# CLI-MANIFEST Contract Reference

This document summarizes the normative contract from the [CLI-MANIFEST](https://gist.githubusercontent.com/ThomasRohde/d4e99da015786674dbfd0233efb4f809/raw/42bf9031c89e79e3a5780e53ccf520234a74a4bd/CLI-MANIFEST.md). Fetch the full manifest for authoritative details. This reference exists to keep the key requirements accessible during CLI generation without re-fetching every time.

## Core principles

### 1. Single structured JSON envelope

Every command returns exactly one JSON object to stdout. No mixed formats, no partial output, no decorative text on stdout.

```json
{
  "schema_version": "1.0.0",
  "request_id": "550e8400-e29b-41d4-a716-446655440000",
  "ok": true,
  "command": "resource.action",
  "result": {},
  "error": null,
  "meta": {}
}
```

### 2. Terse stdout, verbose stderr

- **stdout**: structured data only — the JSON envelope
- **stderr**: progress indicators, debug logs, warnings, timing info, human-readable context

Agents pay token costs for stdout. Keep it minimal and machine-parsable.

### 3. Output mode precedence

Determine output mode in this order:
1. Explicit flag: `--format json` or `--format table`
2. Environment variable: `LLM=true` forces JSON
3. TTY detection: `isatty(stdout)` — if piped, default to JSON; if terminal, allow human-friendly
4. Default: JSON (agent-safe default)

Implement this precedence in the output formatter. Never guess.

### 4. Read/write separation

Classify every command as either a **read** or a **write**:

| Type | HTTP methods | Safety | Retry | Side effects |
|------|-------------|--------|-------|-------------|
| Read | GET, HEAD, OPTIONS | Safe | Yes | None |
| Write | POST, PUT, PATCH, DELETE | Unsafe | Only with idempotency key | Yes |

Never mix reads and writes in a single command. A command that "gets and then updates" should be two separate commands.

### 5. Guide command

Every CLI must implement `mycli guide` that returns:

```json
{
  "schema_version": "1.0.0",
  "ok": true,
  "command": "guide",
  "result": {
    "name": "mycli",
    "version": "1.0.0",
    "description": "...",
    "auth": {
      "methods": ["api-key", "oauth2-client-credentials"],
      "setup": "mycli auth setup --profile dev"
    },
    "commands": [
      {
        "name": "customer.list",
        "description": "List customers with optional filtering",
        "type": "read",
        "flags": [...],
        "examples": [...]
      }
    ],
    "workflows": [
      {
        "name": "safe-delete",
        "steps": ["plan", "validate", "apply", "verify"]
      }
    ]
  }
}
```

The guide must be machine-parsable and contain enough information for an agent to use the CLI without human assistance.

### 6. Stable error codes

Define a fixed error code registry. Error codes are strings, not HTTP status codes:

```json
{
  "ok": false,
  "error": {
    "code": "AUTH_TOKEN_EXPIRED",
    "message": "Bearer token expired at 2024-01-15T10:30:00Z",
    "details": {
      "token_expiry": "2024-01-15T10:30:00Z",
      "profile": "prod"
    },
    "recoverable": true,
    "suggestion": "Run: mycli auth refresh --profile prod"
  }
}
```

Error code categories:
- `AUTH_*` — authentication/authorization failures
- `INPUT_*` — invalid input, missing required fields
- `API_*` — upstream API errors
- `CONFIG_*` — configuration errors
- `RATE_*` — rate limiting
- `NET_*` — network failures
- `INTERNAL_*` — CLI internal errors

### 7. Exit codes

| Code | Meaning |
|------|---------|
| 0 | Success |
| 1 | General error |
| 2 | Usage/input error |
| 3 | Authentication error |
| 4 | Authorization error |
| 5 | Resource not found |
| 6 | Conflict / precondition failed |
| 7 | Rate limited |
| 8 | Upstream API error |
| 9 | Network error |
| 10 | Timeout |
| 11 | Internal CLI error |

### 8. Mutation safety

For write operations:

- **`--dry-run`**: show what would happen without executing. Return the same envelope with `result.dry_run: true` and `result.planned_changes: [...]`
- **`--force`**: skip confirmation prompts. Must be explicitly provided — never default to force.
- **Before/after records**: where the API supports it, include `result.before` and `result.after` snapshots
- **Idempotency keys**: for high-risk mutations, generate and include an idempotency key. Support `--idempotency-key <key>` for user-provided keys.

### 9. Transactional workflows

For high-risk or complex mutations, implement:

```
mycli resource action --plan        # generate execution plan
mycli resource action --validate    # validate plan against current state
mycli resource action --apply       # execute with confirmation
mycli resource action --verify      # confirm mutation took effect
```

Each step returns a structured envelope. The plan step produces a plan ID. Subsequent steps reference that plan ID.

### 10. Observability metadata

Include in the `meta` field:
- `duration_ms` — request duration
- `api_calls` — number of upstream API calls made
- `rate_limit_remaining` — if available from response headers
- `retry_count` — how many retries were needed
- `cache_hit` — if response was cached

### 11. Schema versioning

Include `schema_version` in every response. Bump the version when:
- Fields are added to the envelope
- Error codes are added
- Command signatures change

This lets agents detect breaking changes and adapt.

## Checklist for generated CLIs

- [ ] Every command returns a single JSON envelope to stdout
- [ ] stderr is used for progress, logs, and human-readable messages
- [ ] `LLM=true` environment variable forces JSON output
- [ ] `isatty()` detection falls back to JSON when piped
- [ ] `--format` flag overrides all other output mode signals
- [ ] `guide` command returns machine-readable command metadata
- [ ] `spec` command returns the embedded API specification
- [ ] `--help` works on every command and subcommand
- [ ] `--version` returns version and schema_version
- [ ] All errors use stable string error codes from a fixed registry
- [ ] Exit codes follow the defined table
- [ ] Write operations support `--dry-run`
- [ ] Destructive operations require `--force` for non-interactive use
- [ ] High-risk operations support plan/validate/apply/verify
- [ ] Idempotency keys are supported where retry safety matters
- [ ] Secrets are never printed to stdout or stderr
- [ ] Pagination is handled transparently with `--limit`/`--cursor` flags
- [ ] Rate limiting is handled with backoff and `Retry-After` respect
- [ ] `schema_version` is present in every response envelope
- [ ] `request_id` is a UUID generated per invocation
