# Add Health Check Endpoint to Express.js API

This ExecPlan is a living document. The sections `Progress`, `Surprises & Discoveries`, `Decision Log`, and `Outcomes & Retrospective` must be kept up to date as work proceeds.


## Purpose / Big Picture

After this change, operations engineers can programmatically verify that the web-api service is running and that its PostgreSQL database connection is active by sending a single HTTP request. Instead of curling business endpoints and guessing at the meaning of their responses, they will have a dedicated, stable signal: `GET /health` returns HTTP 200 with `{"status": "healthy", "database": "connected"}` when everything is fine, or HTTP 503 with `{"status": "unhealthy", "database": "disconnected"}` when the database is unreachable. To see it working, start the server with `npm run dev` and run `curl http://localhost:3000/health` — you should receive a JSON response indicating the current health of the service.


## Progress

- [ ] Create the health check route handler in `src/routes/health.ts`
- [ ] Wire the health route into the Express application in `src/app.ts`
- [ ] Create unit tests covering healthy and unhealthy scenarios in `src/__tests__/health.test.ts`
- [ ] Run the full test suite with `npm test` and confirm all tests pass (existing and new)
- [ ] Run the linter with `npm run lint` and confirm no errors
- [ ] Start the server with `npm run dev` and manually verify `GET /health` returns expected JSON
- [ ] Build the project with `npm run build` and confirm TypeScript compilation succeeds


## Surprises & Discoveries

No discoveries yet — this section will be populated during implementation.


## Decision Log

- Decision: Use a single ExecPlan for the entire PRD rather than splitting into multiple plans.
  Rationale: The PRD contains one epic (E1) that describes a single cohesive feature — adding one endpoint, one route file, and one test file. The scope is small enough that splitting would add overhead without clarity.
  Date/Author: 2026-03-10 / Plan Author

- Decision: The health route will query the database using the existing `pg` connection pool rather than introducing a new database client or ORM.
  Rationale: The PRD specifies PostgreSQL via the `pg` package, and the project already has a connection pool at `src/db/pool.ts`. Reusing it keeps the health check consistent with how business routes use the database and avoids adding dependencies.
  Source: PRD — Tech Stack and Architecture sections.

- Decision: The health endpoint will not require authentication.
  Rationale: The PRD explicitly states this as a non-functional requirement ("No authentication required") and as a non-goal ("Do not add authentication to the health endpoint"). Load balancers and monitoring systems need unauthenticated access to health checks.
  Source: PRD — Non-Functional Requirements and Non-Goals sections.

- Decision: The health endpoint will not expose internal details beyond status and database connectivity.
  Rationale: The PRD's security requirement says the endpoint "must not expose internal details beyond status." The response body is limited to `status` and `database` fields.
  Source: PRD — Non-Functional Requirements section.

- Decision: Tests will mock the database pool rather than requiring a running PostgreSQL instance for unit tests.
  Rationale: Unit tests should be fast and isolated. The `pg` pool's `query` method will be mocked to simulate both connected and disconnected states. The integration test using `supertest` will also mock the pool to avoid requiring a database server during CI.
  Source: PRD — Test framework is Jest with supertest; standard practice for unit-level isolation.


## Outcomes & Retrospective

To be completed at major milestones and at plan completion.


## Context and Orientation

This plan targets the `acme/web-api` repository, which is a REST API built with Express.js 4.x running on Node.js 20, written in TypeScript 5.x. The project uses npm as its package manager.

The repository has the following structure relevant to this work:

    src/
    ├── app.ts              # The main Express application file. It creates the Express app,
    │                       # registers middleware, mounts route handlers, and exports the app.
    ├── routes/
    │   └── users.ts        # An existing route module for user-related endpoints. Each route
    │                       # module exports an Express Router that is mounted in app.ts.
    ├── db/
    │   └── pool.ts         # Exports a PostgreSQL connection pool created with the `pg` package.
    │                       # The pool is a `pg.Pool` instance that other modules import to run
    │                       # SQL queries. A "pool" here means a reusable set of database connections
    │                       # managed by the `pg` library so that each query does not have to open
    │                       # a new connection from scratch.
    └── __tests__/
        └── (test files)    # Jest test files. Tests use `supertest` to make HTTP requests against
                            # the Express app without starting a real server.

Key terms used in this plan:

- **Express.js**: A Node.js web framework that handles HTTP requests. An Express "app" is created by calling `express()`, and routes are registered on it using methods like `app.get()` or `app.use()`.
- **Router**: An Express construct that groups related route handlers. You create one with `express.Router()`, define routes on it, and then mount it on the main app with `app.use('/prefix', router)`.
- **pg.Pool**: A class from the `pg` (node-postgres) npm package. It manages a pool of connections to a PostgreSQL database. Calling `pool.query('SELECT 1')` borrows a connection, runs the query, and returns it to the pool.
- **supertest**: A library that wraps an Express app and lets you make HTTP requests in tests without binding to a real port. You pass the app to `request(app)` and chain methods like `.get('/health').expect(200)`.
- **Jest**: A JavaScript testing framework. Tests are files matching patterns like `*.test.ts`. You run them with `npm test`. Jest provides `describe`, `it`/`test`, `expect`, and mocking utilities like `jest.mock()`.

The existing route pattern (inferred from the architecture) works like this: each file in `src/routes/` exports a Router, and `src/app.ts` imports that Router and mounts it. For example, `src/app.ts` likely contains a line like `app.use('/users', usersRouter)`. The new health route will follow this same pattern.


## Plan of Work

The work proceeds in three stages: create the route handler, wire it into the app, and add tests.

First, create the file `src/routes/health.ts`. This file will export an Express Router with a single `GET /` handler. When a request arrives, the handler will import the database pool from `src/db/pool.ts` and attempt to run a lightweight query (`SELECT 1`). If the query succeeds, the handler responds with HTTP 200 and the JSON body `{"status": "healthy", "database": "connected"}`. If the query throws an error (meaning the database is unreachable or the connection failed), the handler catches the error and responds with HTTP 503 and the JSON body `{"status": "unhealthy", "database": "disconnected"}`. The handler does not log the full error details in the response body, consistent with the security requirement to avoid exposing internals.

Second, modify `src/app.ts` to import the new health router and mount it at the `/health` path. This involves adding an import statement at the top of the file and a single `app.use('/health', healthRouter)` line in the route registration section, following the same pattern used for the existing users route.

Third, create the file `src/__tests__/health.test.ts` containing both unit-level and integration-level tests. The tests will mock `src/db/pool.ts` so that no real database is needed. There will be two main test cases: one where the pool's `query` method resolves successfully (verifying HTTP 200 and the healthy JSON response), and one where it rejects with an error (verifying HTTP 503 and the unhealthy JSON response). Both tests use `supertest` to make requests against the Express app.


## Concrete Steps

All commands below assume the working directory is the repository root (the directory containing `package.json`).

1. **Create the health route handler.**

   Create the file `src/routes/health.ts` with the following content. The file imports the Express types and the database pool, creates a Router, and defines a single GET handler that checks database connectivity.

       // src/routes/health.ts
       import { Router, Request, Response } from 'express';
       import pool from '../db/pool';

       const router = Router();

       router.get('/', async (_req: Request, res: Response) => {
         try {
           await pool.query('SELECT 1');
           res.status(200).json({ status: 'healthy', database: 'connected' });
         } catch {
           res.status(503).json({ status: 'unhealthy', database: 'disconnected' });
         }
       });

       export default router;

   After creating this file, verify it exists:

       ls src/routes/health.ts

   Expected output:

       src/routes/health.ts

2. **Wire the health route into the Express app.**

   Open `src/app.ts`. Locate the section where existing routers are imported (look for a line like `import usersRouter from './routes/users'`). Add a new import directly below it:

       import healthRouter from './routes/health';

   Then locate the section where routes are mounted (look for a line like `app.use('/users', usersRouter)`). Add a new line in that section:

       app.use('/health', healthRouter);

   The exact line numbers depend on the current content of `app.ts`, but the pattern should be clear from the existing route registrations. Place the health route import alongside other route imports, and the `app.use` call alongside other route mount statements.

3. **Create the test file.**

   Create the file `src/__tests__/health.test.ts` with the following content. The tests mock the database pool module so that no real PostgreSQL server is required.

       // src/__tests__/health.test.ts
       import request from 'supertest';
       import app from '../app';
       import pool from '../db/pool';

       jest.mock('../db/pool', () => ({
         __esModule: true,
         default: {
           query: jest.fn(),
         },
       }));

       const mockedPool = pool as jest.Mocked<typeof pool>;

       describe('GET /health', () => {
         afterEach(() => {
           jest.resetAllMocks();
         });

         it('returns 200 with healthy status when database is connected', async () => {
           (mockedPool.query as jest.Mock).mockResolvedValueOnce({ rows: [{ '?column?': 1 }] });

           const response = await request(app).get('/health');

           expect(response.status).toBe(200);
           expect(response.body).toEqual({
             status: 'healthy',
             database: 'connected',
           });
         });

         it('returns 503 with unhealthy status when database is disconnected', async () => {
           (mockedPool.query as jest.Mock).mockRejectedValueOnce(new Error('Connection refused'));

           const response = await request(app).get('/health');

           expect(response.status).toBe(503);
           expect(response.body).toEqual({
             status: 'unhealthy',
             database: 'disconnected',
           });
         });
       });

   Verify the file was created:

       ls src/__tests__/health.test.ts

   Expected output:

       src/__tests__/health.test.ts

4. **Install dependencies (if not already installed).**

       npm install

   Expected output: a summary of installed packages with no errors. If dependencies are already installed, npm will report that the tree is up to date.

5. **Run the linter.**

       npm run lint

   Expected output: no errors or warnings. If the linter reports issues in the new files, fix them before proceeding (common issues are missing semicolons, trailing whitespace, or import ordering depending on the project's ESLint configuration).

6. **Run the test suite.**

       npm test

   Expected output: all tests pass, including the two new tests in `health.test.ts`. The output should include lines like:

       PASS  src/__tests__/health.test.ts
         GET /health
           ✓ returns 200 with healthy status when database is connected
           ✓ returns 503 with unhealthy status when database is disconnected

       Test Suites: X passed, X total
       Tests:       Y passed, Y total

   The exact counts depend on how many existing tests the project has. The important thing is zero failures.

7. **Build the project.**

       npm run build

   Expected output: TypeScript compiles without errors, and the `dist/` directory is populated with JavaScript output files. There should be no type errors.

8. **Manual smoke test (optional, requires a running database).**

   If a PostgreSQL instance is available and the environment variables for database connection are configured, start the development server and test the endpoint:

       npm run dev

   In a separate terminal:

       curl -s http://localhost:3000/health | python3 -m json.tool

   Expected output when the database is reachable:

       {
           "status": "healthy",
           "database": "connected"
       }

   The HTTP status code should be 200. To verify the status code explicitly:

       curl -s -o /dev/null -w "%{http_code}" http://localhost:3000/health

   Expected output:

       200


## Validation and Acceptance

The implementation is complete when all of the following conditions are met:

1. **GET /health returns 200 when healthy.** With the server running and the database reachable, `curl http://localhost:3000/health` returns HTTP 200 with the body `{"status":"healthy","database":"connected"}`.

2. **GET /health returns 503 when unhealthy.** With the server running and the database unreachable (for example, the PostgreSQL service is stopped or the connection string points to a non-existent host), `curl http://localhost:3000/health` returns HTTP 503 with the body `{"status":"unhealthy","database":"disconnected"}`.

3. **Unit test covers the healthy scenario.** The test `returns 200 with healthy status when database is connected` in `src/__tests__/health.test.ts` passes. This test mocks the pool query to resolve successfully and verifies the 200 status and JSON body.

4. **Unit test covers the unhealthy scenario.** The test `returns 503 with unhealthy status when database is disconnected` in `src/__tests__/health.test.ts` passes. This test mocks the pool query to reject with an error and verifies the 503 status and JSON body.

5. **No existing tests break.** Running `npm test` produces zero failures across all test suites, not just the new one.

6. **No lint errors.** Running `npm run lint` produces zero errors.

7. **Response time.** The health check responds within 500ms under normal conditions. Since the query is `SELECT 1` (a trivial operation that does not touch any table), this should be well within the threshold. If the database is unreachable, the response time depends on the pool's connection timeout setting, which is outside the scope of this plan but should be monitored.

To run the full validation suite:

    npm run lint && npm test && npm run build

All three commands should exit with code 0.


## Idempotence and Recovery

Every step in this plan is safe to re-run.

Creating `src/routes/health.ts` and `src/__tests__/health.test.ts` are file-creation operations. If the files already exist, re-running the creation step will overwrite them with the same content — no harm done.

The edit to `src/app.ts` (adding the import and `app.use` line) must be checked before re-applying. If the lines are already present, do not add them again, as duplicate route mounts would cause Express to call the handler twice for each request. Before adding, search the file for `healthRouter` or `'/health'` — if either is found, the wiring is already in place.

Running `npm install`, `npm run lint`, `npm test`, and `npm run build` are all idempotent by nature. They can be run any number of times without side effects.

If a step fails partway through (for example, the test suite reveals a type error in the new route), fix the issue in the relevant file and re-run the failing command. No rollback is needed because no step in this plan modifies the database schema or performs destructive operations.


## Artifacts and Notes

Expected healthy response:

    $ curl -s http://localhost:3000/health
    {"status":"healthy","database":"connected"}

Expected unhealthy response (database down):

    $ curl -s http://localhost:3000/health
    {"status":"unhealthy","database":"disconnected"}

Expected test output:

    $ npm test

    > web-api@1.0.0 test
    > jest

    PASS  src/__tests__/health.test.ts
      GET /health
        ✓ returns 200 with healthy status when database is connected (25 ms)
        ✓ returns 503 with unhealthy status when database is disconnected (8 ms)

    Test Suites: 1 passed, 1 total
    Tests:       2 passed, 2 total
    Snapshots:   0 total
    Time:        1.234 s

The test suite count shown above reflects only the new test file. The full run will include existing test suites as well, and all must pass.


## Interfaces and Dependencies

**Runtime dependencies** (already present in the project):

- `express` (4.x) — Web framework. Provides `Router`, `Request`, `Response` types.
- `pg` (8.x) — PostgreSQL client for Node.js. Provides the `Pool` class used in `src/db/pool.ts`.

**Development dependencies** (already present in the project):

- `typescript` (5.x) — TypeScript compiler. Compiles `.ts` files to JavaScript in `dist/`.
- `jest` (29.x) — Test runner. Configured to work with TypeScript via `ts-jest` or a similar transformer.
- `supertest` (6.x or 7.x) — HTTP assertion library for testing Express apps without starting a server.
- `@types/express`, `@types/jest`, `@types/supertest` — TypeScript type definitions for the above packages.

**Module interfaces after implementation:**

`src/db/pool.ts` — must export a default `pg.Pool` instance with a `query` method:

    // Existing module, no changes required
    import { Pool } from 'pg';
    const pool = new Pool();
    export default pool;

`src/routes/health.ts` — must export a default Express Router:

    import { Router } from 'express';
    const router: Router;
    export default router;

    // Route: GET /
    // Success response: { status: 'healthy', database: 'connected' } with HTTP 200
    // Failure response: { status: 'unhealthy', database: 'disconnected' } with HTTP 503

`src/app.ts` — must import and mount the health router:

    import healthRouter from './routes/health';
    app.use('/health', healthRouter);

**Services:**

- PostgreSQL database — must be accessible via the connection configuration used by `src/db/pool.ts` (typically via `DATABASE_URL` environment variable or individual `PGHOST`, `PGPORT`, `PGDATABASE`, `PGUSER`, `PGPASSWORD` variables). Required at runtime for health checks but not required for running tests (tests mock the pool).
