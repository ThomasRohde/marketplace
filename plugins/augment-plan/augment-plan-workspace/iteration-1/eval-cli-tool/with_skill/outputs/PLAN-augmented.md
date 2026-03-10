# Build a Database Migration CLI

This ExecPlan is a living document. The sections `Progress`, `Surprises & Discoveries`, `Decision Log`, and `Outcomes & Retrospective` must be kept up to date as work proceeds.

## Purpose / Big Picture

After this change, developers can manage database schema migrations from the command line using `dbmig`. They can create new migration files, apply pending migrations, roll back the last migration, and inspect the current migration status. To see it working, run `dbmig status` to view pending migrations, then `dbmig apply` to execute them, and verify with `dbmig status` again showing all migrations as applied.

## Progress

### Milestone 0 — Scaffold Repository Structure and Guidance Files
- [ ] Initialize the TypeScript project with package.json, tsconfig.json, and directory structure
- [ ] Create `README.md` with project description, quick start, repo structure, and test instructions
- [ ] Create `PROJECT.md` with problem statement, goals, non-goals, constraints, and assumptions
- [ ] Create `ARCHITECTURE.md` with stack rationale, component map, data flows, and trade-offs
- [ ] Create `TESTING.md` with test strategy, test pyramid, coverage expectations, and CI validation
- [ ] Create `CONTRIBUTING.md` with branch workflow, code style, commit conventions, and review checklist
- [ ] Create `CHANGELOG.md` with initial entry
- [ ] Create `DECISIONS/ADR-0001-initial-architecture.md` recording the TypeScript + Commander.js + pg choice
- [ ] Create `AGENTS.md` with project overview, coding rules, invariants, validation steps, and TODO guidance
- [ ] Create `.editorconfig` with consistent formatting rules
- [ ] Create `.gitignore` for Node.js/TypeScript projects
- [ ] Configure Prettier as the formatter (`.prettierrc`)
- [ ] Configure ESLint with TypeScript support (`.eslintrc.cjs` or `eslint.config.mjs`)
- [ ] Create `.github/workflows/ci.yml` with lint, typecheck, and test steps
- [ ] Verify: all guidance files exist and are non-empty
- [ ] Verify: `npx eslint --print-config src/index.ts` runs without configuration errors
- [ ] Verify: the CI workflow is valid YAML

### Milestone 1 — Establish CLI Contract and Foundations
- [ ] Define the `Envelope<T>` response type in `src/envelope.ts`
- [ ] Implement the envelope serializer so every command returns the same shape
- [ ] Define the error code taxonomy in `src/errors.ts`
- [ ] Map error categories to exit code ranges in `src/exit-codes.ts`
- [ ] Implement the `dbmig guide` command that returns the full CLI schema as JSON
- [ ] Add `isatty()` detection and `LLM=true` environment variable support in `src/output.ts`
- [ ] Add `--output` flag (json | text) with json as default when piped
- [ ] Add metrics/observability (duration_ms) to every envelope response
- [ ] Add `--dry-run` flag infrastructure for mutating commands
- [ ] Add concrete examples to every command's `--help` text
- [ ] Validate: run `dbmig guide`, parse the JSON output, verify it lists all commands, flags, and error codes
- [ ] Validate: run a command with `--output json`, verify the envelope shape matches the contract
- [ ] Validate: run a command with piped stdout, verify JSON output is produced by default

### Milestone 2 — Implement `dbmig create <name>`
- [ ] Implement `src/commands/create.ts` — generate timestamped migration directory with up.sql and down.sql
- [ ] Wrap output in the structured envelope with command `migration.create`
- [ ] Return a change record with `before: null` and `after: { name, timestamp, upPath, downPath }`
- [ ] Support `--dry-run` to preview the directory and files that would be created without writing
- [ ] Define error codes: `ERR_VALIDATION_EMPTY_NAME`, `ERR_IO_WRITE_FAILED`
- [ ] Write tests for create command, verifying envelope shape and dry-run behavior

### Milestone 3 — Implement `dbmig status`
- [ ] Implement `src/commands/status.ts` — query `_migrations` table, scan `migrations/` directory
- [ ] Return structured metadata: array of `{ name, timestamp, state: "applied" | "pending", applied_at? }`
- [ ] Use stable ordering by timestamp
- [ ] Return a fingerprint of the current migration state (hash of applied migration names + timestamps)
- [ ] Define error codes: `ERR_IO_CONNECTION`, `ERR_IO_TABLE_MISSING`
- [ ] Write tests for status command, verifying envelope shape and structured metadata

### Milestone 4 — Implement `dbmig apply`
- [ ] Implement `src/commands/apply.ts` — find pending migrations, execute up.sql in transaction, insert into `_migrations`
- [ ] Wrap output in the structured envelope with command `migration.apply`
- [ ] Return change records with before/after state for each applied migration
- [ ] Support `--dry-run` to list migrations that would be applied without executing them
- [ ] Include a change summary: `{ total_operations, migrations_applied, by_name: [...] }`
- [ ] Implement fingerprint-based conflict detection: record state fingerprint before apply, reject if stale
- [ ] Require `--allow-schema-change` flag when applying migrations that contain DROP statements
- [ ] Define error codes: `ERR_IO_CONNECTION`, `ERR_CONFLICT_FINGERPRINT`, `ERR_VALIDATION_NO_PENDING`, `ERR_IO_SQL_FAILED`, `ERR_VALIDATION_DANGEROUS_SQL`
- [ ] Write tests for apply command, verifying envelope shape, dry-run, fingerprint rejection, and safety flag

### Milestone 5 — Implement `dbmig rollback`
- [ ] Implement `src/commands/rollback.ts` — find last applied migration, execute down.sql, delete from `_migrations`
- [ ] Wrap output in the structured envelope with command `migration.rollback`
- [ ] Return a change record with before (applied state) and after (reverted state)
- [ ] Support `--dry-run` to show what would be rolled back without executing
- [ ] Require `--confirm-rollback` safety flag (rollback is destructive)
- [ ] Define error codes: `ERR_IO_CONNECTION`, `ERR_VALIDATION_NONE_APPLIED`, `ERR_IO_SQL_FAILED`
- [ ] Write tests for rollback command, verifying envelope shape, dry-run, and safety flag

### Milestone 6 — Integration Tests and Final Validation
- [ ] Write integration tests exercising the full create -> status -> apply -> status -> rollback -> status workflow
- [ ] Verify every command returns a valid envelope with `ok`, `command`, `result`, `errors`, `warnings`, `metrics`
- [ ] Verify `dbmig guide` output is complete and accurate
- [ ] Run the full test suite and verify all pass
- [ ] Run the linter and verify zero errors

## Surprises & Discoveries

No discoveries yet — this section will be populated during implementation.

## Decision Log

- Decision: Use Commander.js as the CLI framework.
  Rationale: Commander.js is the most widely used Node.js CLI framework with excellent TypeScript support and subcommand handling.
  Date/Author: 2026-03-10 / Plan Author

- Decision: Use raw `pg` for database operations rather than an ORM.
  Rationale: Migration tools should have minimal dependencies and direct SQL control. An ORM adds unnecessary abstraction for what is essentially a SQL runner.
  Date/Author: 2026-03-10 / Plan Author

- Decision: Apply CLI Manifest Parts I (Foundations), II (Read & Discover), III (Safe Mutation), and IV (Transactional Workflows — partial).
  Rationale: `dbmig` is a database migration CLI. It has read commands (`status`), mutation commands (`create`, `apply`, `rollback`), and follows a transactional pattern (create migration files, then apply them). Part IV is applied partially — fingerprint-based conflict detection and the plan/apply pattern are relevant, but full workflow composition (Principle 21) is overkill for a focused migration tool. Part V (Multi-Agent Coordination) is not applied because the plan does not describe concurrent agent usage.
  Date/Author: 2026-03-10 / Augment Plan Skill

- Decision: Skip Part V (Multi-Agent Coordination).
  Rationale: The plan describes a single-user migration tool. Database-level advisory locks could be added later if concurrent agent usage becomes a requirement, but adding locking infrastructure now would be premature.
  Date/Author: 2026-03-10 / Augment Plan Skill

- Decision: Add a full scaffolding milestone (Milestone 0) before any feature work.
  Rationale: The original plan had no scaffolding — no README, no ARCHITECTURE.md, no AGENTS.md, no linter config, no CI workflow. These files establish the project foundation and make the repo navigable for both humans and coding agents.
  Date/Author: 2026-03-10 / Augment Plan Skill

- Decision: Use Prettier + ESLint for code quality, Jest for testing, GitHub Actions for CI.
  Rationale: These are the standard TypeScript quality tools. The plan already specifies Jest. Prettier and ESLint are the community defaults for TypeScript formatting and linting.
  Date/Author: 2026-03-10 / Augment Plan Skill

## Outcomes & Retrospective

To be completed at major milestones and at plan completion.

## Context and Orientation

This plan creates a new CLI tool called `dbmig` from scratch. The project will be a TypeScript Node.js application using Commander.js for CLI argument parsing and the `pg` package for PostgreSQL connectivity.

The project structure will be:

    dbmig/
    ├── src/
    │   ├── index.ts          # CLI entry point, Commander.js program setup
    │   ├── envelope.ts       # Structured JSON response envelope type and serializer
    │   ├── errors.ts         # Error code taxonomy and error builder
    │   ├── exit-codes.ts     # Exit code mapping by error category
    │   ├── output.ts         # Output mode detection (isatty, LLM=true, --output flag)
    │   ├── commands/
    │   │   ├── guide.ts      # `dbmig guide` — machine-readable CLI schema
    │   │   ├── create.ts     # `dbmig create` command handler
    │   │   ├── status.ts     # `dbmig status` command handler
    │   │   ├── apply.ts      # `dbmig apply` command handler
    │   │   └── rollback.ts   # `dbmig rollback` command handler
    │   ├── db.ts             # Database connection pool management
    │   └── migrations.ts     # Migration file discovery and execution logic
    ├── migrations/           # Generated migration files live here
    ├── tests/
    │   └── commands/
    │       ├── guide.test.ts
    │       ├── create.test.ts
    │       ├── status.test.ts
    │       ├── apply.test.ts
    │       └── rollback.test.ts
    ├── DECISIONS/
    │   └── ADR-0001-initial-architecture.md
    ├── .github/
    │   └── workflows/
    │       └── ci.yml
    ├── README.md
    ├── PROJECT.md
    ├── ARCHITECTURE.md
    ├── TESTING.md
    ├── CONTRIBUTING.md
    ├── CHANGELOG.md
    ├── AGENTS.md
    ├── .editorconfig
    ├── .gitignore
    ├── .prettierrc
    ├── .eslintrc.cjs
    ├── package.json
    └── tsconfig.json

Key terms:
- **Migration**: A pair of SQL files (up and down) that describe a schema change. The "up" file applies the change; the "down" file reverts it.
- **Migration table**: A database table (`_migrations`) that records which migrations have been applied, with timestamps.
- **Structured envelope**: The standard JSON response shape that every `dbmig` command returns, regardless of success or failure. Agents parse one schema, not N.
- **Error code**: A machine-readable string (e.g., `ERR_IO_CONNECTION`) that agents branch on. Error codes are stable across versions. Human-readable messages accompany them but are not parsed programmatically.
- **Exit code**: A numeric process exit code mapped to an error category. Agents and shell scripts branch on exit codes without parsing JSON.
- **Guide command**: The `dbmig guide` command returns the full CLI schema as JSON — all commands, flags, error codes, and examples — so an agent can bootstrap its knowledge of the CLI in one call.
- **Dry-run**: A mode where a mutating command executes its full pipeline but writes nothing. It returns the changes that *would* be made as structured data.
- **Fingerprint**: A hash of the current migration state used for conflict detection. If the state changes between planning and applying, the apply is rejected.
- **Change record**: A structured before/after description of what a mutation did, returned in the envelope's `result` field.

### CLI Design Contract

Every `dbmig` command returns a structured JSON envelope on stdout. The envelope shape is:

```typescript
interface Envelope<T> {
  schema_version: "1.0";
  request_id: string;          // Unique per invocation, e.g., "req_20260310_143000_7f3a"
  ok: boolean;                 // true on success, false on error
  command: string;             // Dotted command ID, e.g., "migration.apply"
  result: T | null;            // Command-specific payload; null on failure
  warnings: Warning[];         // Non-fatal issues (always an array, possibly empty)
  errors: CliError[];          // Structured errors (always an array, possibly empty)
  metrics: {
    duration_ms: number;       // Wall-clock milliseconds
  };
}

interface CliError {
  code: string;                // e.g., "ERR_IO_CONNECTION"
  message: string;             // Human-readable description
  retryable: boolean;
  suggested_action: "retry" | "fix_input" | "reauth" | "escalate";
  details?: Record<string, unknown>;
}

interface Warning {
  code: string;
  message: string;
}
```

### Error Code Taxonomy

| Code | Category | Retryable | Suggested Action | Exit Code |
|------|----------|-----------|-----------------|-----------|
| `ERR_VALIDATION_EMPTY_NAME` | Validation | No | fix_input | 10 |
| `ERR_VALIDATION_NO_PENDING` | Validation | No | fix_input | 10 |
| `ERR_VALIDATION_NONE_APPLIED` | Validation | No | fix_input | 10 |
| `ERR_VALIDATION_DANGEROUS_SQL` | Validation | No | fix_input | 10 |
| `ERR_IO_CONNECTION` | I/O | Yes | retry | 50 |
| `ERR_IO_TABLE_MISSING` | I/O | No | fix_input | 50 |
| `ERR_IO_WRITE_FAILED` | I/O | Yes | retry | 50 |
| `ERR_IO_SQL_FAILED` | I/O | No | escalate | 50 |
| `ERR_CONFLICT_FINGERPRINT` | Conflict | No | fix_input | 40 |
| `ERR_INTERNAL_UNEXPECTED` | Internal | No | escalate | 90 |

### Exit Code Ranges

| Range | Category | Meaning |
|-------|----------|---------|
| 0 | Success | Command completed successfully |
| 10 | Validation | Bad input, missing arguments, schema mismatch |
| 20 | Permission | Protected resource (reserved for future use) |
| 40 | Conflict | Stale state, fingerprint mismatch |
| 50 | I/O | Database connection failure, file system error, SQL execution error |
| 90 | Internal | Bug — agent should not retry |

### Command Naming

Commands use the `dbmig <verb>` pattern. The dotted command IDs used in the envelope are:

| Command | Dotted ID | Mutates? |
|---------|-----------|----------|
| `dbmig guide` | `cli.guide` | No |
| `dbmig create <name>` | `migration.create` | Yes (creates files) |
| `dbmig status` | `migration.status` | No |
| `dbmig apply` | `migration.apply` | Yes (modifies database) |
| `dbmig rollback` | `migration.rollback` | Yes (modifies database) |

### Output Mode Rules

Output mode is determined by this precedence (highest to lowest):
1. `--output json` or `--output text` flag (explicit)
2. `LLM=true` environment variable (forces JSON, suppresses banners/progress)
3. `isatty(stdout)` — if stdout is piped, default to JSON; if terminal, default to text

In text mode, the CLI renders a human-readable table or summary. In JSON mode, it emits the raw envelope. Progress information and diagnostics are always written to stderr, never stdout.

## Plan of Work

Start with Milestone 0 to scaffold the repository with guidance files, quality infrastructure, and the basic project skeleton. Then establish the CLI contract in Milestone 1 — the structured envelope, error codes, exit codes, guide command, and output mode handling. This foundation ensures every subsequent command is built on a consistent, agent-friendly contract. Then implement the four commands in order: `create`, `status`, `apply`, `rollback`. Each command will be a separate module exporting a function that Commander.js calls, and each will return its results wrapped in the standard envelope. Finish with integration tests that exercise the full workflow.

The `create` command generates a new migration directory under `migrations/` with a timestamp prefix and two empty SQL files: `up.sql` and `down.sql`. It supports `--dry-run` to preview the files without writing.

The `status` command reads the `migrations/` directory, compares it against the `_migrations` table in the database, and returns each migration's state as structured metadata with stable timestamp ordering and a fingerprint of the current state.

The `apply` command finds all pending migrations (those in the `migrations/` directory but not in `_migrations`), checks the state fingerprint for conflicts, executes their `up.sql` files in order within a transaction, records each in `_migrations`, and returns change records with before/after state. It supports `--dry-run` and requires `--allow-schema-change` for migrations containing DROP statements.

The `rollback` command finds the most recently applied migration from `_migrations`, executes its `down.sql` file, removes the record from `_migrations`, and returns a change record. It requires `--confirm-rollback` because rollback is a destructive operation. It supports `--dry-run`.

## Concrete Steps

### Milestone 0 — Scaffold Repository Structure and Guidance Files

1. Initialize the project:

       mkdir dbmig && cd dbmig
       npm init -y
       npm install commander pg
       npm install -D typescript @types/node @types/pg jest ts-jest @types/jest prettier eslint @typescript-eslint/parser @typescript-eslint/eslint-plugin

2. Create `tsconfig.json` with target ES2022, module NodeNext, and outDir `dist/`.

3. Create `.editorconfig`:

       root = true
       [*]
       indent_style = space
       indent_size = 2
       end_of_line = lf
       charset = utf-8
       trim_trailing_whitespace = true
       insert_final_newline = true

4. Create `.gitignore` for Node.js/TypeScript (node_modules, dist, coverage, .env).

5. Create `.prettierrc` with 2-space indentation, single quotes, trailing commas.

6. Create `.eslintrc.cjs` with TypeScript parser and recommended rules.

7. Create `README.md` with project description ("dbmig is a database migration CLI for PostgreSQL"), quick start instructions, repo structure summary, and test/lint commands.

8. Create `PROJECT.md` with problem statement, goals (manage PostgreSQL schema migrations from CLI), non-goals (not an ORM, not a query builder, not multi-database), constraints (TypeScript, Node.js, PostgreSQL only), and assumptions.

9. Create `ARCHITECTURE.md` with stack rationale (TypeScript + Commander.js + pg), component map (entry point, command handlers, db module, migration module, envelope/error infrastructure), data flows (CLI input -> Commander parse -> command handler -> pg query -> envelope response), and trade-offs.

10. Create `TESTING.md` with strategy (unit tests for command handlers with mocked pg, integration tests with real database), test pyramid (unit > integration), coverage expectations, and CI validation steps.

11. Create `CONTRIBUTING.md` with branch workflow, code style (Prettier + ESLint), commit conventions, and review checklist.

12. Create `CHANGELOG.md` with initial `## [Unreleased]` entry.

13. Create `DECISIONS/ADR-0001-initial-architecture.md` recording: TypeScript chosen for type safety and ecosystem; Commander.js chosen for CLI parsing; raw pg chosen over ORM for minimal abstraction; structured JSON envelope adopted for agent-first CLI design.

14. Create `AGENTS.md` with:
    - Project overview: "dbmig is a TypeScript CLI for PostgreSQL migrations. Every command returns a structured JSON envelope."
    - Where to look first: `src/envelope.ts` for the response contract, `src/errors.ts` for error codes, `src/commands/` for command handlers
    - Coding rules: every command handler must return via the envelope serializer; never print to stdout directly; use stderr for diagnostics
    - Invariants: the envelope shape is the contract — `ok`, `command`, `result`, `errors`, `warnings`, `metrics` are always present
    - How to validate: `npm test`, `npm run lint`, `npm run typecheck`
    - When to stop: if a migration SQL is ambiguous, leave a TODO rather than guessing the intent

15. Create `.github/workflows/ci.yml`:

    ```yaml
    name: CI
    on: [push, pull_request]
    jobs:
      build:
        runs-on: ubuntu-latest
        steps:
          - uses: actions/checkout@v4
          - uses: actions/setup-node@v4
            with:
              node-version: 20
          - run: npm ci
          - run: npm run lint
          - run: npm run typecheck
          - run: npm test
    ```

16. Verify all guidance files exist and are non-empty. Verify `npx eslint --print-config src/index.ts` runs without configuration errors. Verify the CI workflow is valid YAML.

### Milestone 1 — Establish CLI Contract and Foundations

17. Create `src/envelope.ts` — define the `Envelope<T>`, `CliError`, and `Warning` interfaces. Implement a `createEnvelope<T>()` factory and a `serializeEnvelope()` function that writes the JSON to stdout. Generate `request_id` as `req_<YYYYMMDD>_<HHmmss>_<4hex>`.

    ```typescript
    export interface Envelope<T> {
      schema_version: "1.0";
      request_id: string;
      ok: boolean;
      command: string;
      result: T | null;
      warnings: Warning[];
      errors: CliError[];
      metrics: { duration_ms: number };
    }

    export interface CliError {
      code: string;
      message: string;
      retryable: boolean;
      suggested_action: "retry" | "fix_input" | "reauth" | "escalate";
      details?: Record<string, unknown>;
    }

    export interface Warning {
      code: string;
      message: string;
    }
    ```

18. Create `src/errors.ts` — define all error codes as constants with their retry semantics and suggested actions. Export an `errorFor(code, message, details?)` helper that constructs a `CliError`.

19. Create `src/exit-codes.ts` — map error code prefixes to exit code ranges. Export `exitCodeFor(errorCode: string): number`.

    ```typescript
    const EXIT_CODES: Record<string, number> = {
      ERR_VALIDATION: 10,
      ERR_AUTH: 20,
      ERR_CONFLICT: 40,
      ERR_IO: 50,
      ERR_INTERNAL: 90,
    };

    export function exitCodeFor(errorCode: string): number {
      const prefix = Object.keys(EXIT_CODES).find((p) => errorCode.startsWith(p));
      return prefix ? EXIT_CODES[prefix] : 90;
    }
    ```

20. Create `src/output.ts` — detect output mode. Check `--output` flag first, then `LLM=true` env var, then `process.stdout.isTTY`. Export `getOutputMode(): "json" | "text"` and `isLlmMode(): boolean`. When in text mode and stdout is a TTY, render a human-readable summary. When in JSON mode or piped, emit the raw envelope.

21. Update `src/index.ts` — register the global `--output` option on the Commander program. Add a top-level error handler that catches unhandled errors, wraps them in the envelope with `ERR_INTERNAL_UNEXPECTED`, and exits with code 90.

22. Implement `src/commands/guide.ts` — the `dbmig guide` command. Returns JSON listing all commands with their flags, input expectations, dotted IDs, error codes, exit code mapping, and examples. Include `schema_version` and `compatibility` fields.

    ```typescript
    // Abbreviated guide output structure
    {
      schema_version: "1.0",
      compatibility: { additive_changes: "minor", breaking_changes: "major" },
      commands: {
        "migration.create": {
          verb: "create",
          args: [{ name: "name", required: true, description: "Migration name" }],
          flags: ["--dry-run", "--output"],
          mutates: true,
          error_codes: ["ERR_VALIDATION_EMPTY_NAME", "ERR_IO_WRITE_FAILED"]
        },
        // ... other commands
      },
      error_codes: { /* full taxonomy */ },
      exit_codes: { /* full mapping */ }
    }
    ```

23. Add concrete examples to every command's `--help` epilog text in the Commander configuration. For example:

    ```
    Examples:
      $ dbmig create add-users-table
      $ dbmig create add-users-table --dry-run
      $ dbmig status
      $ dbmig apply --dry-run
      $ dbmig apply --allow-schema-change
      $ dbmig rollback --confirm-rollback --dry-run
    ```

24. Validate: run `dbmig guide`, parse the JSON output, and verify it contains entries for all five commands, their flags, and the full error code taxonomy. Run `dbmig guide | node -e "JSON.parse(require('fs').readFileSync('/dev/stdin','utf8'))"` to confirm valid JSON.

### Milestone 2 — Implement `dbmig create <name>`

25. Implement `src/commands/create.ts` — generate a timestamped migration directory under `migrations/` with `up.sql` and `down.sql`. The directory name format is `<YYYYMMDDHHMMSS>-<name>/`.

26. Wrap the command's output in the structured envelope. On success:

    ```jsonc
    {
      "ok": true,
      "command": "migration.create",
      "result": {
        "type": "migration.create",
        "target": "migrations/20260310143000-add-users-table",
        "before": null,
        "after": {
          "name": "add-users-table",
          "timestamp": "20260310143000",
          "up_path": "migrations/20260310143000-add-users-table/up.sql",
          "down_path": "migrations/20260310143000-add-users-table/down.sql"
        }
      },
      "errors": [],
      "warnings": [],
      "metrics": { "duration_ms": 12 }
    }
    ```

27. Support `--dry-run`: execute the full name validation and path generation, return the result with `"dry_run": true` in the result, but do not create the directory or files.

28. Validate empty name input returns `ERR_VALIDATION_EMPTY_NAME` with exit code 10. Validate successful creation returns a well-formed envelope. Validate `--dry-run` creates no files on disk.

29. Write tests for create command in `tests/commands/create.test.ts`, verifying envelope shape, change record content, dry-run behavior, and error handling.

### Milestone 3 — Implement `dbmig status`

30. Implement `src/commands/status.ts` — query `_migrations` table, scan `migrations/` directory, compute state per migration.

31. Return structured metadata in the envelope:

    ```jsonc
    {
      "ok": true,
      "command": "migration.status",
      "result": {
        "migrations": [
          {
            "name": "add-users-table",
            "timestamp": "20260310143000",
            "state": "applied",
            "applied_at": "2026-03-10T14:30:05Z"
          },
          {
            "name": "add-posts-table",
            "timestamp": "20260310150000",
            "state": "pending",
            "applied_at": null
          }
        ],
        "summary": { "total": 2, "applied": 1, "pending": 1 },
        "fingerprint": "sha256:a1b2c3d4e5f6..."
      },
      "errors": [],
      "warnings": [],
      "metrics": { "duration_ms": 35 }
    }
    ```

32. Ensure stable ordering by timestamp (ascending). The fingerprint is a SHA-256 hash of the concatenated applied migration names and their `applied_at` timestamps, so agents can detect state changes between calls.

33. Handle the case where the `_migrations` table does not exist: return all migrations as pending and include a warning `{ "code": "WARN_NO_MIGRATION_TABLE", "message": "_migrations table does not exist; all migrations shown as pending" }`.

34. Write tests for status command in `tests/commands/status.test.ts`, mocking the pg pool. Verify envelope shape, stable ordering, fingerprint computation, and the no-table warning.

### Milestone 4 — Implement `dbmig apply`

35. Implement `src/commands/apply.ts` — find pending migrations, execute up.sql in a database transaction, insert records into `_migrations`.

36. Before applying, compute the state fingerprint (same algorithm as `status`). If a `--fingerprint` value is provided, compare it against the current state. If they differ, reject with `ERR_CONFLICT_FINGERPRINT` and exit code 40.

37. Return change records in the envelope:

    ```jsonc
    {
      "ok": true,
      "command": "migration.apply",
      "result": {
        "changes": [
          {
            "type": "migration.apply",
            "target": "migrations/20260310143000-add-users-table",
            "before": { "state": "pending" },
            "after": { "state": "applied", "applied_at": "2026-03-10T14:31:00Z" }
          }
        ],
        "summary": {
          "total_operations": 1,
          "migrations_applied": 1
        },
        "fingerprint_before": "sha256:...",
        "fingerprint_after": "sha256:..."
      },
      "errors": [],
      "warnings": [],
      "metrics": { "duration_ms": 230 }
    }
    ```

38. Support `--dry-run`: execute the full pending migration discovery and SQL parsing, return the change summary with `"dry_run": true`, but do not execute any SQL or modify `_migrations`.

39. Scan each migration's `up.sql` for DROP statements. If found, require the `--allow-schema-change` flag. Without it, return `ERR_VALIDATION_DANGEROUS_SQL` with a message naming the specific migration and the dangerous statement.

40. If no migrations are pending, return a success envelope with an empty changes array and a warning `WARN_NO_PENDING_MIGRATIONS`.

41. Create the `_migrations` table automatically if it does not exist (idempotent `CREATE TABLE IF NOT EXISTS`).

42. Write tests for apply command in `tests/commands/apply.test.ts`. Test envelope shape, dry-run, fingerprint conflict rejection, dangerous SQL detection, and the no-pending-migrations case.

### Milestone 5 — Implement `dbmig rollback`

43. Implement `src/commands/rollback.ts` — find last applied migration from `_migrations`, execute its `down.sql`, delete the record from `_migrations`.

44. Require the `--confirm-rollback` safety flag. Without it, return `ERR_VALIDATION_NONE_APPLIED` with message "Rollback is destructive. Use --confirm-rollback to proceed." and exit code 10.

45. Return a change record in the envelope:

    ```jsonc
    {
      "ok": true,
      "command": "migration.rollback",
      "result": {
        "change": {
          "type": "migration.rollback",
          "target": "migrations/20260310143000-add-users-table",
          "before": { "state": "applied", "applied_at": "2026-03-10T14:31:00Z" },
          "after": { "state": "pending" }
        },
        "fingerprint_before": "sha256:...",
        "fingerprint_after": "sha256:..."
      },
      "errors": [],
      "warnings": [],
      "metrics": { "duration_ms": 180 }
    }
    ```

46. Support `--dry-run`: return the change record with `"dry_run": true` without executing any SQL.

47. If no migrations are applied, return a success envelope with `result: null` and a warning `WARN_NO_APPLIED_MIGRATIONS`.

48. Write tests for rollback command in `tests/commands/rollback.test.ts`. Test envelope shape, safety flag requirement, dry-run, change record, and the no-applied-migrations case.

### Milestone 6 — Integration Tests and Final Validation

49. Write integration tests in `tests/integration.test.ts` that exercise the full workflow:

        dbmig create add-users-table
        dbmig status                     → shows add-users-table as pending
        dbmig apply --dry-run            → shows what would be applied
        dbmig apply                      → applies the migration
        dbmig status                     → shows add-users-table as applied
        dbmig rollback --confirm-rollback --dry-run → shows what would roll back
        dbmig rollback --confirm-rollback → reverts the migration
        dbmig status                     → shows add-users-table as pending again

50. For each command invocation in the integration test, parse the JSON output and verify:
    - `ok` is the expected boolean
    - `command` matches the expected dotted ID
    - `result` is non-null on success
    - `errors` is empty on success, non-empty on expected failure
    - `warnings` is an array
    - `metrics.duration_ms` is a positive number
    - `schema_version` is `"1.0"`
    - `request_id` is a non-empty string

51. Verify `dbmig guide` output lists all five commands with their flags and error codes.

52. Run the full test suite:

        npm test

    Expected: all tests pass.

53. Run the linter:

        npm run lint

    Expected: zero errors.

## Validation and Acceptance

After building, verify the following end-to-end workflow:

    dbmig create add-users-table
    # Expected: JSON envelope with ok:true, command:"migration.create", result containing file paths

    dbmig status --output json
    # Expected: JSON envelope listing "add-users-table" as pending, with fingerprint

    dbmig apply --dry-run --output json
    # Expected: JSON envelope with dry_run:true, showing add-users-table would be applied

    dbmig apply --output json
    # Expected: JSON envelope with change records showing migration applied

    dbmig status --output json
    # Expected: JSON envelope showing "add-users-table" as applied, fingerprint changed

    dbmig rollback --confirm-rollback --output json
    # Expected: JSON envelope with change record showing migration reverted

    dbmig guide
    # Expected: JSON listing all commands, flags, error codes, and exit codes

Run `npm test` and expect all tests to pass. Run `npm run lint` and expect zero errors.

## Idempotence and Recovery

The `create` command is idempotent — re-running with the same name generates a new timestamped directory (different timestamp). The `apply` command skips already-applied migrations. If `apply` fails mid-transaction, the database transaction rolls back and no partial state is recorded in `_migrations`. The `rollback` command is safe to retry — if no migrations are applied, it reports that in the envelope warnings and exits cleanly with code 0. The `_migrations` table is created idempotently with `CREATE TABLE IF NOT EXISTS`.

All commands return structured error information on failure. Agents can branch on `errors[0].code` and `suggested_action` to decide whether to retry, fix input, or escalate. Transient I/O errors (e.g., `ERR_IO_CONNECTION`) are marked `retryable: true`.

## Artifacts and Notes

None yet.

## Interfaces and Dependencies

- **commander** (^12.x) — CLI framework
- **pg** (^8.x) — PostgreSQL client
- **jest** + **ts-jest** — Test framework
- **typescript** (^5.x) — Language
- **prettier** — Code formatter
- **eslint** + **@typescript-eslint** — Linter with TypeScript support

Key interfaces:
- `Envelope<T> { schema_version, request_id, ok, command, result, errors, warnings, metrics }`
- `CliError { code, message, retryable, suggested_action, details? }`
- `Warning { code, message }`
- `Migration { name: string; timestamp: string; upPath: string; downPath: string }`
- `MigrationRecord { name: string; applied_at: Date }`
- `ChangeRecord { type: string; target: string; before: unknown; after: unknown }`
- `getPool(): pg.Pool`
- `getPendingMigrations(): Promise<Migration[]>`
- `getAppliedMigrations(): Promise<MigrationRecord[]>`
- `computeFingerprint(applied: MigrationRecord[]): string`
- `createEnvelope<T>(command: string, result: T, opts?): Envelope<T>`
- `exitCodeFor(errorCode: string): number`
- `getOutputMode(): "json" | "text"`
