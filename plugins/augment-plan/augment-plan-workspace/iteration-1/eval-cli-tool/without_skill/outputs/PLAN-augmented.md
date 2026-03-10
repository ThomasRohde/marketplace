# Build a Database Migration CLI

This ExecPlan is a living document. The sections `Progress`, `Surprises & Discoveries`, `Decision Log`, and `Outcomes & Retrospective` must be kept up to date as work proceeds.

## Purpose / Big Picture

After this change, developers can manage database schema migrations from the command line using `dbmig`. They can create new migration files, apply pending migrations, roll back the last migration, and inspect the current migration status. To see it working, run `dbmig status` to view pending migrations, then `dbmig apply` to execute them, and verify with `dbmig status` again showing all migrations as applied.

## Progress

- [ ] Set up the TypeScript project with Commander.js and pg dependencies
- [ ] Configure project scaffolding (linting, formatting, CI, git hooks)
- [ ] Implement the `dbmig create <name>` command to generate timestamped migration files
- [ ] Implement the `dbmig status` command to list migrations and their applied/pending state
- [ ] Implement the `dbmig apply` command to run pending migrations in order
- [ ] Implement the `dbmig rollback` command to revert the last applied migration
- [ ] Implement structured output and error handling across all commands
- [ ] Write unit tests for all commands using Jest
- [ ] Write integration tests against a real PostgreSQL instance
- [ ] Run the full test suite and verify all pass
- [ ] Write README and architecture documentation
- [ ] Verify CI pipeline passes end-to-end

## Surprises & Discoveries

No discoveries yet -- this section will be populated during implementation.

## Decision Log

- Decision: Use Commander.js as the CLI framework.
  Rationale: Commander.js is the most widely used Node.js CLI framework with excellent TypeScript support and subcommand handling.
  Date/Author: 2026-03-10 / Plan Author

- Decision: Use raw `pg` for database operations rather than an ORM.
  Rationale: Migration tools should have minimal dependencies and direct SQL control. An ORM adds unnecessary abstraction for what is essentially a SQL runner.
  Date/Author: 2026-03-10 / Plan Author

- Decision: Support both human-readable and JSON structured output via a `--format` flag.
  Rationale: CLI tools are frequently scripted. JSON output enables composability with `jq`, CI pipelines, and other tooling. Human-readable output remains the default for interactive use.
  Date/Author: 2026-03-10 / Augmented Plan

- Decision: Use ESLint with `@typescript-eslint` and Prettier for code quality.
  Rationale: Industry-standard tooling for TypeScript projects. Catches bugs at lint time and enforces consistent formatting without manual effort.
  Date/Author: 2026-03-10 / Augmented Plan

- Decision: Use GitHub Actions for CI.
  Rationale: Widely adopted, free for open-source and personal repos, and has first-class support for Node.js and PostgreSQL service containers.
  Date/Author: 2026-03-10 / Augmented Plan

- Decision: Use distinct exit codes for different failure categories.
  Rationale: Nonzero exit codes allow scripts and CI to detect failures programmatically. Distinct codes (e.g., 1 for general error, 2 for connection failure, 3 for migration conflict) let callers react appropriately.
  Date/Author: 2026-03-10 / Augmented Plan

## Outcomes & Retrospective

To be completed at major milestones and at plan completion.

## Context and Orientation

This plan creates a new CLI tool called `dbmig` from scratch. The project will be a TypeScript Node.js application using Commander.js for CLI argument parsing and the `pg` package for PostgreSQL connectivity.

The project structure will be:

    dbmig/
    ├── .github/
    │   └── workflows/
    │       └── ci.yml              # GitHub Actions CI pipeline
    ├── src/
    │   ├── index.ts                # CLI entry point, Commander.js program setup
    │   ├── commands/
    │   │   ├── create.ts           # `dbmig create` command handler
    │   │   ├── status.ts           # `dbmig status` command handler
    │   │   ├── apply.ts            # `dbmig apply` command handler
    │   │   └── rollback.ts         # `dbmig rollback` command handler
    │   ├── db.ts                   # Database connection pool management
    │   ├── migrations.ts           # Migration file discovery and execution logic
    │   ├── errors.ts               # Custom error classes and exit code mapping
    │   └── output.ts               # Structured output formatter (text / JSON)
    ├── migrations/                 # Generated migration files live here
    ├── tests/
    │   ├── unit/
    │   │   └── commands/
    │   │       ├── create.test.ts
    │   │       ├── status.test.ts
    │   │       ├── apply.test.ts
    │   │       └── rollback.test.ts
    │   ├── integration/
    │   │   ├── apply-rollback.integration.test.ts
    │   │   └── helpers/
    │   │       └── test-db.ts      # Helpers to spin up / tear down a test database
    │   └── jest.setup.ts           # Global test setup (env vars, timeouts)
    ├── docs/
    │   └── ARCHITECTURE.md         # Architecture and design decisions
    ├── .eslintrc.cjs               # ESLint configuration
    ├── .prettierrc                 # Prettier configuration
    ├── .gitignore
    ├── package.json
    ├── tsconfig.json
    └── README.md                   # Usage, installation, and contributing guide

Key terms:
- **Migration**: A pair of SQL files (up and down) that describe a schema change. The "up" file applies the change; the "down" file reverts it.
- **Migration table**: A database table (`_migrations`) that records which migrations have been applied, with timestamps.

## CLI Design Best Practices

### Structured Output

All commands must support a `--format` option accepting `text` (default) and `json`.

- **Text mode** (default): Human-readable, colorized output using ANSI codes. Colors must be automatically suppressed when stdout is not a TTY (i.e., when piped or redirected), or when the `NO_COLOR` environment variable is set, following the https://no-color.org convention.
- **JSON mode** (`--format json`): Every command prints a single JSON object to stdout with a consistent envelope:

      {
        "success": true,
        "command": "status",
        "data": { ... },
        "errors": []
      }

  On failure the `success` field is `false` and `errors` contains an array of `{ "code": "...", "message": "..." }` objects.

Diagnostic and progress messages (e.g., "Applying migration...") must always go to **stderr**, so that stdout contains only the structured result and can be safely piped into `jq` or consumed by scripts.

### Exit Codes

| Code | Meaning                            |
|------|------------------------------------|
| 0    | Success                            |
| 1    | General / unexpected error         |
| 2    | Database connection failure        |
| 3    | Migration conflict or inconsistency|
| 4    | Invalid arguments / usage error    |

A dedicated `src/errors.ts` module defines custom error classes (`DatabaseConnectionError`, `MigrationConflictError`, etc.) that each carry their exit code. The top-level error handler in `src/index.ts` catches all errors, maps them to the appropriate code, and calls `process.exit()`.

### Error Handling

1. **Wrap all database calls** in try/catch. On connection failure, emit a clear message: "Could not connect to the database. Verify DATABASE_URL is set and the server is reachable." Exit with code 2.
2. **Validate inputs early.** The `create` command must reject names that are empty, contain path separators, or collide with reserved words. Exit with code 4.
3. **Transaction safety.** The `apply` command must run each migration inside a database transaction. If any migration fails, the transaction for that migration is rolled back and the command exits with code 1. Already-applied migrations earlier in the batch remain applied.
4. **Graceful shutdown.** Register a `SIGINT` / `SIGTERM` handler that waits for any in-flight transaction to finish (or rolls it back) before closing the pool and exiting.
5. **Stderr for diagnostics.** All log/progress output goes to stderr. Only final results go to stdout.

### Global Flags

The following flags apply to every subcommand:

| Flag                  | Description                                              |
|-----------------------|----------------------------------------------------------|
| `--format <text|json>`| Output format (default: `text`)                          |
| `--migrations-dir`    | Path to migrations directory (default: `./migrations`)   |
| `--database-url`      | Database connection string (overrides `DATABASE_URL` env)|
| `--verbose`           | Print debug-level information to stderr                  |
| `--dry-run`           | Show what would be done without making changes (apply/rollback only) |

### Help and Discoverability

- Every command and option must have a description string in Commander.js so that `dbmig --help` and `dbmig <command> --help` are self-documenting.
- Add usage examples in each command's `addHelpText('after', ...)` block. For example, `dbmig create --help` should show: `Example: dbmig create add-users-table`.

## Project Scaffolding

### README.md

The README must include the following sections:

1. **Overview** -- one-paragraph description of `dbmig` and its purpose.
2. **Installation** -- `npm install -g dbmig` and local dev setup (`git clone`, `npm install`, `npm run build`).
3. **Quick Start** -- a copy-paste-ready block showing `create`, `apply`, `status`, and `rollback` in sequence.
4. **Configuration** -- table of environment variables and CLI flags.
5. **Commands Reference** -- one subsection per command with arguments, flags, and examples.
6. **Contributing** -- how to run tests, lint, and submit PRs.
7. **License** -- MIT or chosen license.

### Architecture Documentation (docs/ARCHITECTURE.md)

This document describes:

- The layered design: CLI layer (Commander.js) -> Command handlers -> Migration service -> Database layer.
- How the migration discovery algorithm works (scan directory, parse timestamps, compare with `_migrations` table).
- Transaction semantics for `apply` and `rollback`.
- The structured output envelope contract.
- Error classification and exit code mapping.

### Testing Strategy

#### Unit Tests (tests/unit/)

- Mock the `pg.Pool` using Jest manual mocks or a lightweight helper.
- Each command handler is tested in isolation:
  - `create`: Verify file/directory creation, timestamp format, name sanitization, and error on invalid names.
  - `status`: Given a set of filesystem migrations and a mocked `_migrations` table, verify correct applied/pending classification and output.
  - `apply`: Verify correct ordering, transaction wrapping (BEGIN/COMMIT and BEGIN/ROLLBACK on failure), and insertion into `_migrations`.
  - `rollback`: Verify it picks the most recent migration, executes `down.sql`, and deletes the record.
- Test both text and JSON output modes for each command.

#### Integration Tests (tests/integration/)

- Use a real PostgreSQL instance (via Docker or a GitHub Actions service container).
- A `test-db.ts` helper creates a temporary database before each test suite and drops it afterward.
- Run the full `create -> apply -> status -> rollback -> status` lifecycle against the real database.
- Verify that concurrent `apply` calls are handled safely (advisory locks or serialized transactions).

#### Test Configuration

In `package.json`, define two test scripts:

    "scripts": {
      "test": "jest --testPathPattern=unit",
      "test:integration": "jest --testPathPattern=integration",
      "test:all": "jest"
    }

Jest configuration (`jest.config.ts` or in `package.json`):

- Preset: `ts-jest`
- Test environment: `node`
- Setup file: `tests/jest.setup.ts` (loads `.env.test` if present, sets default `DATABASE_URL` for integration tests)
- Coverage thresholds: 80% line coverage minimum, enforced in CI.

### Continuous Integration (GitHub Actions)

Create `.github/workflows/ci.yml`:

```yaml
name: CI
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  lint-and-test:
    runs-on: ubuntu-latest

    services:
      postgres:
        image: postgres:16
        env:
          POSTGRES_USER: test
          POSTGRES_PASSWORD: test
          POSTGRES_DB: dbmig_test
        ports:
          - 5432:5432
        options: >-
          --health-cmd "pg_isready -U test"
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5

    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: npm
      - run: npm ci
      - run: npm run lint
      - run: npm run format:check
      - run: npm run build
      - run: npm test -- --coverage
        env:
          DATABASE_URL: postgres://test:test@localhost:5432/dbmig_test
      - run: npm run test:integration
        env:
          DATABASE_URL: postgres://test:test@localhost:5432/dbmig_test
```

### Linting and Formatting

#### ESLint (`.eslintrc.cjs`)

```js
module.exports = {
  root: true,
  parser: '@typescript-eslint/parser',
  plugins: ['@typescript-eslint'],
  extends: [
    'eslint:recommended',
    'plugin:@typescript-eslint/recommended',
    'plugin:@typescript-eslint/recommended-type-checked',
    'prettier',
  ],
  parserOptions: {
    project: './tsconfig.json',
  },
  rules: {
    '@typescript-eslint/no-floating-promises': 'error',
    '@typescript-eslint/no-misused-promises': 'error',
    'no-console': ['warn', { allow: ['error', 'warn'] }],
  },
};
```

The `no-console` rule warns on bare `console.log` calls so that all output is channeled through the structured output module (`src/output.ts`), which writes to the correct stream (stdout for results, stderr for diagnostics).

#### Prettier (`.prettierrc`)

```json
{
  "semi": true,
  "singleQuote": true,
  "trailingComma": "all",
  "printWidth": 100
}
```

#### Scripts in `package.json`

    "scripts": {
      "build": "tsc",
      "lint": "eslint src/ tests/",
      "lint:fix": "eslint src/ tests/ --fix",
      "format": "prettier --write 'src/**/*.ts' 'tests/**/*.ts'",
      "format:check": "prettier --check 'src/**/*.ts' 'tests/**/*.ts'",
      "test": "jest --testPathPattern=unit",
      "test:integration": "jest --testPathPattern=integration",
      "test:all": "jest",
      "start": "node dist/index.js"
    }

### Git Hooks (via Husky + lint-staged)

Install as dev dependencies:

    npm install -D husky lint-staged

Configure in `package.json`:

    "lint-staged": {
      "*.ts": ["eslint --fix", "prettier --write"]
    }

Set up Husky:

    npx husky init
    echo "npx lint-staged" > .husky/pre-commit

This ensures every commit is linted and formatted before it lands.

### .gitignore

    node_modules/
    dist/
    coverage/
    .env
    .env.*
    *.tsbuildinfo

## Plan of Work

Start by initializing the TypeScript project with the necessary dependencies and scaffolding. Then implement the four commands in order: `create`, `status`, `apply`, `rollback`. Each command will be a separate module exporting a function that Commander.js calls. After the commands work, layer in structured output, error handling, and global flags. Finally, write documentation and verify the CI pipeline.

The `create` command generates a new migration directory under `migrations/` with a timestamp prefix and two empty SQL files: `up.sql` and `down.sql`.

The `status` command reads the `migrations/` directory, compares it against the `_migrations` table in the database, and prints each migration's state (applied or pending).

The `apply` command finds all pending migrations (those in the `migrations/` directory but not in `_migrations`), executes their `up.sql` files in order within a transaction, and records each in `_migrations`.

The `rollback` command finds the most recently applied migration from `_migrations`, executes its `down.sql` file, and removes the record from `_migrations`.

## Concrete Steps

1. Initialize the project:

       mkdir dbmig && cd dbmig
       npm init -y
       npm install commander pg
       npm install -D typescript @types/node @types/pg jest ts-jest @types/jest
       npm install -D eslint @typescript-eslint/parser @typescript-eslint/eslint-plugin eslint-config-prettier prettier
       npm install -D husky lint-staged

2. Create `tsconfig.json` with target ES2022, module NodeNext, outDir `dist/`, strict mode enabled, and `sourceMap: true` for debuggability.

3. Create `.eslintrc.cjs`, `.prettierrc`, and `.gitignore` as specified in the Project Scaffolding section.

4. Initialize Husky and configure the pre-commit hook for lint-staged.

5. Implement `src/errors.ts` -- define custom error classes (`DatabaseConnectionError`, `MigrationConflictError`, `InvalidArgumentError`) each carrying an exit code.

6. Implement `src/output.ts` -- a formatter module that accepts data and an output format (`text` | `json`), writes results to stdout, and diagnostics to stderr. Respects `NO_COLOR` for text mode.

7. Implement `src/index.ts` -- create the Commander program with global flags (`--format`, `--migrations-dir`, `--database-url`, `--verbose`, `--dry-run`), four subcommands, and a top-level error handler that catches exceptions, writes structured error output, and exits with the mapped exit code.

8. Implement `src/db.ts` -- export a `getPool()` function returning a `pg.Pool` configured from the `--database-url` flag or `DATABASE_URL` environment variable. Include a `testConnection()` function that runs `SELECT 1` and throws `DatabaseConnectionError` on failure.

9. Implement `src/commands/create.ts` -- generate timestamped migration directory with up.sql and down.sql. Validate the migration name (no empty strings, no path separators, no reserved characters). Output the created file paths.

10. Implement `src/commands/status.ts` -- query `_migrations` table, scan `migrations/` directory, print status. Support both text (table format) and JSON output.

11. Implement `src/commands/apply.ts` -- find pending migrations, execute up.sql in transaction, insert into `_migrations`. Support `--dry-run` to list what would be applied without executing. Register SIGINT/SIGTERM handlers for graceful shutdown.

12. Implement `src/commands/rollback.ts` -- find last applied migration, execute down.sql, delete from `_migrations`. Support `--dry-run`. Handle the case where no migrations are applied gracefully.

13. Write unit tests for each command, mocking the pg pool. Test both output formats. Test error paths (connection failure, invalid name, no pending migrations, failed SQL).

14. Write integration tests that exercise the full lifecycle against a real PostgreSQL instance.

15. Configure Jest with coverage thresholds (80% minimum line coverage).

16. Create `.github/workflows/ci.yml` as specified in the CI section.

17. Write `README.md` with overview, installation, quick start, configuration, commands reference, contributing guide, and license.

18. Write `docs/ARCHITECTURE.md` covering layered design, migration discovery, transaction semantics, output contract, and error classification.

19. Run the full test and lint suite:

        npm run lint
        npm run format:check
        npm run build
        npm run test:all

    Expected: all checks pass.

## Validation and Acceptance

After building, verify the following:

    npx ts-node src/index.ts create add-users-table
    # Expected: creates migrations/<timestamp>-add-users-table/ with up.sql and down.sql

    npx ts-node src/index.ts status
    # Expected: shows "add-users-table" as pending

    npx ts-node src/index.ts status --format json
    # Expected: JSON envelope with migration list, each marked pending

    npx ts-node src/index.ts apply
    # Expected: applies the migration, creates _migrations table if needed

    npx ts-node src/index.ts status
    # Expected: shows "add-users-table" as applied

    npx ts-node src/index.ts rollback
    # Expected: reverts the migration

    npx ts-node src/index.ts apply --dry-run
    # Expected: lists the migration as "would apply" without executing

    npx ts-node src/index.ts create ""
    # Expected: error message, exit code 4

    npx ts-node src/index.ts apply --database-url postgres://bad:bad@localhost/nope
    # Expected: connection error message, exit code 2

Run `npm run lint && npm run format:check && npm run build && npm run test:all` and expect all checks to pass.

Verify that `dbmig --help` and `dbmig <command> --help` display useful descriptions and examples.

Verify that JSON output piped through `jq` parses cleanly:

    npx ts-node src/index.ts status --format json | jq .

## Idempotence and Recovery

The `create` command is idempotent -- re-running with the same name generates a new timestamped directory (different timestamp). The `apply` command skips already-applied migrations. The `rollback` command is safe to retry -- if no migrations are applied, it reports that and exits cleanly with code 0. The `_migrations` table is created automatically on first use if it does not exist (in `apply` and `status`).

If `apply` fails mid-batch, the failing migration's transaction is rolled back. Previously applied migrations in the same batch remain applied. Re-running `apply` picks up where it left off because it only processes pending migrations.

## Artifacts and Notes

- The `src/output.ts` module is the single source of truth for all CLI output. No command should write directly to `process.stdout` or `process.stderr` -- always go through the formatter.
- The `src/errors.ts` module centralizes error classification. Every error that can reach the user must extend a base `CliError` class that carries an exit code and a machine-readable error code string.

## Interfaces and Dependencies

- **commander** (^12.x) -- CLI framework
- **pg** (^8.x) -- PostgreSQL client
- **jest** + **ts-jest** -- Test framework
- **typescript** (^5.x) -- Language
- **eslint** + **@typescript-eslint** -- Linting
- **prettier** -- Formatting
- **husky** + **lint-staged** -- Git hooks
- **eslint-config-prettier** -- Disables ESLint rules that conflict with Prettier

Key interfaces:

- `Migration { name: string; timestamp: string; upPath: string; downPath: string }`
- `MigrationRecord { name: string; applied_at: Date }`
- `CliError { message: string; exitCode: number; errorCode: string }`
- `OutputEnvelope<T> { success: boolean; command: string; data: T; errors: ErrorDetail[] }`
- `ErrorDetail { code: string; message: string }`
- `OutputFormat = 'text' | 'json'`
- `getPool(): pg.Pool`
- `testConnection(pool: pg.Pool): Promise<void>`
- `getPendingMigrations(): Promise<Migration[]>`
- `getAppliedMigrations(): Promise<MigrationRecord[]>`
- `formatOutput<T>(envelope: OutputEnvelope<T>, format: OutputFormat): void`
