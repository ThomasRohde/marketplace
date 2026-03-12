---
name: api-anything
description: >
  Generate enterprise-ready, agent-first CLIs from OpenAPI or Swagger specifications.
  Use this skill whenever the user wants to "generate a CLI from an OpenAPI spec",
  "turn a Swagger API into a CLI", "scaffold an enterprise REST CLI", "create a CLI
  wrapper around a REST API", "derive a machine-readable CLI from an API description",
  "generate auth-aware commands from an OAS file", "build a deterministic CLI for this
  service", "create an agent-friendly CLI from this API", or mentions "api-anything",
  "OpenAPI CLI", "Swagger CLI", "REST CLI generator", "OAS to CLI", or "API CLI scaffold"
  in the context of generating CLI code from an API specification. Also triggers when the
  user provides an OpenAPI/Swagger spec file and asks to build a command-line tool from it,
  even if they don't use the exact term "CLI". Does NOT trigger for generic API discussion,
  SDK generation, client library generation, API debugging, or consuming an existing CLI.
---

# api-anything

Transform an OpenAPI / Swagger specification into a production-grade, agent-first CLI.

## Governing contract

Every CLI produced by this skill must conform to the **CLI-MANIFEST** — the normative design contract for agent-first CLIs. The full manifest is embedded in `references/cli-manifest-contract.md`. Read it before generating any CLI code.

The manifest defines 23 principles across 5 parts (Foundations, Read & Discover, Safe Mutation, Transactional Workflows, Multi-Agent Coordination). It covers the output envelope, error taxonomy, exit codes, read/write separation, `guide` command, `LLM=true` handling, mutation safety, and transactional workflow patterns that the generated CLI must implement.

## When to use this skill

- User provides an OpenAPI 3.x or Swagger 2.0 spec and wants a CLI built from it
- User wants an agent-usable CLI wrapper around a REST API
- User needs enterprise auth profiles (OAuth, OIDC, mTLS, API keys) wired into a CLI
- User wants normalized resource commands rather than raw HTTP path mirroring

## When NOT to use this skill

- User wants a client SDK or library (not a CLI)
- User is debugging or consuming an existing API without CLI generation intent
- User wants to document or visualize an API (use a docs tool instead)
- User wants to mock or stub an API server
- User wants a GUI or web frontend for an API

## Workflow

Execute these phases in order. Each phase produces artifacts the next phase consumes. Do not skip phases — the pipeline prevents the common failure mode of generating ad-hoc code directly from a raw spec.

### Phase 1: Ingest the spec

Accept the spec from URL, local file path, or raw pasted content. Support both OpenAPI 3.x and Swagger 2.0.

1. Parse and validate the spec structure
2. Resolve `$ref` references where possible
3. Detect and report:
   - Missing or circular refs
   - Unresolved schemas
   - Incomplete or suspicious auth definitions
   - Naming collisions across paths/operations
   - Unsupported constructs (websockets, callbacks) — surface these explicitly, don't silently ignore
4. Produce an **ingestion report** listing what was found, what's missing, and what assumptions you're making

If the spec is invalid or critically incomplete, stop and present the issues to the user before continuing.

### Phase 2: Normalize the API model

Build a canonical internal representation. Read `references/normalization-guide.md` for detailed guidance on this step.

1. Extract all operations and group them into **resource families** using tags, path structure, and schema relationships
2. Normalize naming: `kebab-case` for commands, `snake_case` for flags, consistent pluralization
3. Classify each operation:
   - **read** (GET, HEAD) — safe, cacheable, retry-safe
   - **write** (POST, PUT, PATCH, DELETE) — requires mutation safety
   - **bulk** — operations on collections
   - **long-running** — async operations with polling
   - **high-risk** — destructive operations (DELETE, bulk writes, admin operations)
4. Map HTTP concepts to CLI concepts:
   - Path params → required positional args or `--id` style flags
   - Query params → optional flags
   - Request body → `--data` flag or stdin JSON
   - Headers → handled by auth/config, not exposed as flags unless genuinely operation-specific

### Phase 3: Model the CLI surface

Derive the command tree from the normalized model. Prefer resource-oriented verbs:

```
mycli customer list [--status active] [--limit 50]
mycli customer get --id 123
mycli customer create --data '{"name": "Acme"}'
mycli customer update --id 123 --data '{"name": "Acme Corp"}'
mycli customer delete --id 123 [--dry-run] [--force]
```

Not raw path mirroring like `mycli get-api-v1-customers-by-id`.

Define these introspection commands for every generated CLI:

- `mycli guide` — machine-readable usage guide for agents (structured JSON explaining all commands, flags, auth, and workflows)
- `mycli spec` — dump the embedded API spec or command metadata
- `mycli --help` / `mycli <command> --help` — human-readable help
- `mycli --version` — version and schema_version

Define the output contract. Read `references/output-contract.md` for the envelope spec. Every command returns:

```json
{
  "schema_version": "1.0.0",
  "request_id": "uuid",
  "ok": true,
  "command": "customer.get",
  "result": { ... },
  "error": null,
  "meta": { "duration_ms": 142 }
}
```

Define the error taxonomy with stable error codes (not just HTTP status codes). Read `references/output-contract.md` for the error code registry pattern.

### Phase 4: Model enterprise auth

Read `references/auth-patterns.md` for the complete auth pattern catalog.

Key principles:

1. **Derive auth from the spec** — extract `securitySchemes` and `security` requirements
2. **Assume the spec is incomplete** — enterprise specs routinely omit auth details, use wrong scheme names, or describe gateway auth inaccurately
3. **Provide a policy overlay** — generate a `config.yaml` or `.myclirc` that lets operators patch auth settings without modifying code
4. **Support environment profiles** — `test`, `syst`, `prod` with different base URLs, scopes, certs, token endpoints. When the user provides multiple endpoints, generate a `--env` flag (accepting `test`, `syst`, `prod`) that selects the target environment at runtime. Always generate the CLI from the production spec's perspective — prod is the canonical source of truth for command shapes, schemas, and contracts. Non-prod environments may have subset functionality or relaxed auth, but the CLI surface should reflect prod.
5. **Separate auth discovery from runtime** — config/setup is distinct from per-request auth injection

Generate auth configuration that handles:
- API keys (header, query, cookie)
- HTTP Basic
- Bearer tokens
- OAuth 2.0 client credentials and authorization code + PKCE
- OpenID Connect discovery
- mTLS
- Custom gateway headers

### Phase 5: Add safety and operability

For every write operation, apply the CLI-MANIFEST mutation safety model:

- **`--dry-run`** — preview what would happen without executing
- **`--force`** — skip confirmation for high-risk operations (require explicit opt-in)
- **Structured change records** — before/after snapshots where the API supports it
- **Idempotency keys** — for operations where retry safety matters (payments, provisioning)
- **Risk classification** — tag operations as `low`, `medium`, `high`, `critical`

For high-risk operations, implement the transactional workflow:
1. `mycli <resource> <action> --plan` — generate an execution plan
2. `mycli <resource> <action> --validate` — validate the plan against current state
3. `mycli <resource> <action> --apply` — execute with confirmation
4. `mycli <resource> <action> --verify` — confirm the mutation took effect

Add operational concerns:
- **Pagination** — consistent `--limit`, `--offset` or `--cursor` flags; handle API pagination transparently
- **Rate limiting** — respect `Retry-After` headers, implement backoff, report limits in stderr
- **Long-running operations** — poll with progress on stderr, return final result on stdout
- **Secret redaction** — never log auth tokens, API keys, or credentials in output or stderr
- **Retries** — only for idempotent reads; never auto-retry writes unless idempotency is confirmed

### Phase 6: Generate implementation artifacts

Produce a complete, buildable project. Typical structure:

```
mycli/
├── README.md                    # Usage, installation, examples
├── ARCHITECTURE.md              # How the CLI is structured internally
├── AGENTS.md                    # Guide for coding agents working on this codebase
├── src/
│   ├── main.{ext}              # Entry point
│   ├── commands/               # One module per resource family
│   ├── auth/                   # Auth provider implementations
│   ├── client/                 # HTTP client with retry, rate-limit, pagination
│   ├── config/                 # Profile and environment management
│   ├── output/                 # Envelope formatting, error codes
│   └── guide/                  # Guide command implementation
├── config/
│   └── default.yaml            # Default configuration template
├── tests/
│   ├── unit/                   # Normalization, config parsing, output formatting
│   ├── integration/            # Mock server tests
│   ├── subprocess/             # CLI invocation tests
│   └── fixtures/               # Test specs, mock responses
├── package.json / pyproject.toml / go.mod
└── .github/
    └── workflows/
        └── ci.yaml
```

Choose the tech stack based on user preference, or default to:
- **Node.js/TypeScript**: Commander.js or oclif
- **Python**: Typer or Click
- **Go**: Cobra
- **Rust**: Clap

### Phase 7: Validate

Read `references/validation-strategy.md` for the complete 7-layer validation framework.

At minimum, generate tests covering:

1. **Static** — spec parses, refs resolve, no naming collisions
2. **Contract** — every command produces the correct envelope, guide works, errors have codes
3. **Behavioral** — representative operations with mock responses behave correctly
4. **Subprocess** — install the CLI and invoke it as a subprocess; verify stdout/stderr separation, exit codes, JSON parsability
5. **Auth** — each auth mode configures and injects correctly
6. **Negative** — malformed input, missing auth, server errors produce correct error envelopes

After validation, produce a **validation report** stating:
- What has been tested and proven
- What remains assumed or untested
- What requires live/sandbox verification the user must do themselves

## Assumptions and limits

- This skill generates the CLI scaffold and implementation code. It does not deploy, publish, or host the CLI.
- Generated CLIs are deterministic wrappers — they translate CLI invocations to API calls. They do not add business logic.
- Specs with websocket, GraphQL, gRPC, or event-streaming endpoints are out of scope. Surface them in the ingestion report and skip them.
- File upload/download operations are supported but may need manual refinement depending on the API's multipart handling.

## Uncertainty disclosure

If the source spec is ambiguous, incomplete, or contradictory:

1. Identify the specific ambiguity in the ingestion report
2. State your assumption explicitly
3. Generate a `spec-patches.yaml` overlay file where operators can correct assumptions without modifying generated code
4. Never hide assumptions in generated code comments — make them visible in the project's top-level documentation

## Quality bar

The generated CLI must be usable by a weak coding agent (Haiku-class) with no improvisation. That means:
- Rigid, predictable command structure
- Explicit examples for every command in the guide
- Deterministic output schemas
- No ambiguous flags or modes
- Predictable side-effect handling with clear risk labels

## Reference files

Read these when you need detailed guidance during specific phases:

| File | When to read |
|------|-------------|
| `references/cli-manifest-contract.md` | Before Phase 3 — understand the full CLI contract |
| `references/normalization-guide.md` | During Phase 2 — how to normalize specs into commands |
| `references/auth-patterns.md` | During Phase 4 — enterprise auth pattern catalog |
| `references/output-contract.md` | During Phase 3 — JSON envelope and error taxonomy |
| `references/validation-strategy.md` | During Phase 7 — multi-layered validation framework |
| `references/examples.md` | When generating examples or guide content |
