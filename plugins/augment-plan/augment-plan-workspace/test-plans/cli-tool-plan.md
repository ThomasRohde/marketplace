# Build a Database Migration CLI

This ExecPlan is a living document. The sections `Progress`, `Surprises & Discoveries`, `Decision Log`, and `Outcomes & Retrospective` must be kept up to date as work proceeds.

## Purpose / Big Picture

After this change, developers can manage database schema migrations from the command line using `dbmig`. They can create new migration files, apply pending migrations, roll back the last migration, and inspect the current migration status. To see it working, run `dbmig status` to view pending migrations, then `dbmig apply` to execute them, and verify with `dbmig status` again showing all migrations as applied.

## Progress

- [ ] Set up the TypeScript project with Commander.js and pg dependencies
- [ ] Implement the `dbmig create <name>` command to generate timestamped migration files
- [ ] Implement the `dbmig status` command to list migrations and their applied/pending state
- [ ] Implement the `dbmig apply` command to run pending migrations in order
- [ ] Implement the `dbmig rollback` command to revert the last applied migration
- [ ] Write tests for all commands using Jest
- [ ] Run the full test suite and verify all pass

## Surprises & Discoveries

No discoveries yet — this section will be populated during implementation.

## Decision Log

- Decision: Use Commander.js as the CLI framework.
  Rationale: Commander.js is the most widely used Node.js CLI framework with excellent TypeScript support and subcommand handling.
  Date/Author: 2026-03-10 / Plan Author

- Decision: Use raw `pg` for database operations rather than an ORM.
  Rationale: Migration tools should have minimal dependencies and direct SQL control. An ORM adds unnecessary abstraction for what is essentially a SQL runner.
  Date/Author: 2026-03-10 / Plan Author

## Outcomes & Retrospective

To be completed at major milestones and at plan completion.

## Context and Orientation

This plan creates a new CLI tool called `dbmig` from scratch. The project will be a TypeScript Node.js application using Commander.js for CLI argument parsing and the `pg` package for PostgreSQL connectivity.

The project structure will be:

    dbmig/
    ├── src/
    │   ├── index.ts          # CLI entry point, Commander.js program setup
    │   ├── commands/
    │   │   ├── create.ts     # `dbmig create` command handler
    │   │   ├── status.ts     # `dbmig status` command handler
    │   │   ├── apply.ts      # `dbmig apply` command handler
    │   │   └── rollback.ts   # `dbmig rollback` command handler
    │   ├── db.ts             # Database connection pool management
    │   └── migrations.ts     # Migration file discovery and execution logic
    ├── migrations/           # Generated migration files live here
    ├── tests/
    │   └── commands/
    │       ├── create.test.ts
    │       ├── status.test.ts
    │       ├── apply.test.ts
    │       └── rollback.test.ts
    ├── package.json
    └── tsconfig.json

Key terms:
- **Migration**: A pair of SQL files (up and down) that describe a schema change. The "up" file applies the change; the "down" file reverts it.
- **Migration table**: A database table (`_migrations`) that records which migrations have been applied, with timestamps.

## Plan of Work

Start by initializing the TypeScript project with the necessary dependencies. Then implement the four commands in order: `create`, `status`, `apply`, `rollback`. Each command will be a separate module exporting a function that Commander.js calls.

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

2. Create `tsconfig.json` with target ES2022, module NodeNext, and outDir `dist/`.

3. Implement `src/index.ts` — create the Commander program with four subcommands.

4. Implement `src/db.ts` — export a `pg.Pool` configured from environment variables (DATABASE_URL).

5. Implement `src/commands/create.ts` — generate timestamped migration directory with up.sql and down.sql.

6. Implement `src/commands/status.ts` — query `_migrations` table, scan `migrations/` directory, print status.

7. Implement `src/commands/apply.ts` — find pending migrations, execute up.sql in transaction, insert into `_migrations`.

8. Implement `src/commands/rollback.ts` — find last applied migration, execute down.sql, delete from `_migrations`.

9. Write tests for each command, mocking the pg pool.

10. Run tests:

        npm test

    Expected: all tests pass.

## Validation and Acceptance

After building, verify the following:

    npx ts-node src/index.ts create add-users-table
    # Expected: creates migrations/<timestamp>-add-users-table/ with up.sql and down.sql

    npx ts-node src/index.ts status
    # Expected: shows "add-users-table" as pending

    npx ts-node src/index.ts apply
    # Expected: applies the migration, creates _migrations table if needed

    npx ts-node src/index.ts status
    # Expected: shows "add-users-table" as applied

    npx ts-node src/index.ts rollback
    # Expected: reverts the migration

Run `npm test` and expect all tests to pass.

## Idempotence and Recovery

The `create` command is idempotent — re-running with the same name generates a new timestamped directory (different timestamp). The `apply` command skips already-applied migrations. The `rollback` command is safe to retry — if no migrations are applied, it reports that and exits cleanly.

## Artifacts and Notes

None yet.

## Interfaces and Dependencies

- **commander** (^12.x) — CLI framework
- **pg** (^8.x) — PostgreSQL client
- **jest** + **ts-jest** — Test framework
- **typescript** (^5.x) — Language

Key interfaces:
- `Migration { name: string; timestamp: string; upPath: string; downPath: string }`
- `MigrationRecord { name: string; applied_at: Date }`
- `getPool(): pg.Pool`
- `getPendingMigrations(): Promise<Migration[]>`
- `getAppliedMigrations(): Promise<MigrationRecord[]>`
