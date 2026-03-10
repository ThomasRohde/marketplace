# Implementation Plan: Health Check Endpoint

## Overview

This plan implements a `GET /health` endpoint for the existing Express.js REST API (TypeScript, Node.js 20, PostgreSQL). The endpoint allows load balancers and monitoring systems to verify that the service is running and its database connection is active.

**Source PRD**: Health Check Endpoint (Owner: Jane Smith)
**Repository**: github.com/acme/web-api

---

## Assumptions

Since no existing codebase is available, the following assumptions are made:

1. `src/app.ts` exports an Express application instance and registers route modules via `app.use()`.
2. `src/db/pool.ts` exports a `pg.Pool` instance (from the `pg` package) used for all database operations.
3. The project already has Jest and supertest configured in `package.json` and a working `tsconfig.json`.
4. Existing routes follow the pattern of exporting an Express `Router` that is mounted in `app.ts`.

---

## Epic E1: Health Check Endpoint

### Task 1: Create the health check route module

**File**: `src/routes/health.ts` (NEW)

**What to do**:

1. Create `src/routes/health.ts`.
2. Import the Express `Router` and the database pool from `src/db/pool.ts`.
3. Define a `GET /` handler on the router that:
   - Attempts a lightweight query against the database (e.g., `SELECT 1`).
   - On success: responds with HTTP 200 and JSON body `{"status": "healthy", "database": "connected"}`.
   - On failure (query throws): responds with HTTP 503 and JSON body `{"status": "unhealthy", "database": "disconnected"}`.
4. Export the router as the default export.

**Implementation details**:

```typescript
// src/routes/health.ts
import { Router, Request, Response } from "express";
import pool from "../db/pool";

const router = Router();

router.get("/", async (_req: Request, res: Response) => {
  try {
    await pool.query("SELECT 1");
    res.status(200).json({ status: "healthy", database: "connected" });
  } catch {
    res.status(503).json({ status: "unhealthy", database: "disconnected" });
  }
});

export default router;
```

**Key decisions**:
- Use `SELECT 1` as the probe query; it is fast, read-only, and requires no tables.
- Catch all errors from the pool query and treat any failure as "unhealthy."
- Do not expose error messages or stack traces in the response (NFR: security).

**Acceptance criteria addressed**: FR-1, FR-2, FR-3.

---

### Task 2: Register the health route in the Express app

**File**: `src/app.ts` (MODIFY)

**What to do**:

1. Import the health router from `./routes/health`.
2. Mount it at the `/health` path: `app.use("/health", healthRouter);`.
3. Place it alongside the existing route registrations (e.g., near the `users` route).

**Implementation details**:

Add two lines to `src/app.ts`:

```typescript
import healthRouter from "./routes/health";
// ... after other app.use() calls:
app.use("/health", healthRouter);
```

**Key decisions**:
- Mount before any error-handling middleware so the health route is reachable.
- No authentication middleware applied to this route (per non-goal in PRD).

**Acceptance criteria addressed**: The endpoint is now reachable at `GET /health`.

---

### Task 3: Write unit tests for the health route handler

**File**: `src/__tests__/health.test.ts` (NEW)

**What to do**:

1. Create `src/__tests__/health.test.ts`.
2. Mock the database pool (`src/db/pool.ts`) using Jest's module mocking.
3. Write two unit-level test cases:
   - **Healthy scenario**: Mock `pool.query` to resolve successfully. Assert response status is 200 and body is `{"status": "healthy", "database": "connected"}`.
   - **Unhealthy scenario**: Mock `pool.query` to reject with an error. Assert response status is 503 and body is `{"status": "unhealthy", "database": "disconnected"}`.

**Implementation details**:

```typescript
// src/__tests__/health.test.ts
import request from "supertest";
import app from "../app";
import pool from "../db/pool";

jest.mock("../db/pool", () => ({
  query: jest.fn(),
}));

describe("GET /health", () => {
  afterEach(() => {
    jest.resetAllMocks();
  });

  it("returns 200 with healthy status when DB is reachable", async () => {
    (pool.query as jest.Mock).mockResolvedValueOnce({ rows: [{ "?column?": 1 }] });

    const res = await request(app).get("/health");

    expect(res.status).toBe(200);
    expect(res.body).toEqual({
      status: "healthy",
      database: "connected",
    });
  });

  it("returns 503 with unhealthy status when DB is unreachable", async () => {
    (pool.query as jest.Mock).mockRejectedValueOnce(new Error("Connection refused"));

    const res = await request(app).get("/health");

    expect(res.status).toBe(503);
    expect(res.body).toEqual({
      status: "unhealthy",
      database: "disconnected",
    });
  });
});
```

**Key decisions**:
- Mock at the module level so we do not need a running database for unit tests.
- Use `supertest` to test through the Express stack (middleware, routing, response).
- Reset mocks between tests to avoid cross-contamination.

**Acceptance criteria addressed**: Unit tests covering both healthy and unhealthy scenarios.

---

### Task 4: Write an integration test

**File**: `src/__tests__/health.test.ts` (MODIFY -- add a describe block) or a separate file if the team prefers separation.

**What to do**:

1. Add an integration test that hits the `/health` endpoint via `supertest` against the real app (with mock or test database).
2. If a test database is available in CI, run the real pool query. Otherwise, the supertest-based tests from Task 3 already serve as integration tests through the Express stack.

**Implementation details**:

The tests written in Task 3 already exercise the full Express request/response lifecycle via `supertest`. If the team requires a true end-to-end integration test against a live test database:

```typescript
describe("GET /health (integration)", () => {
  it("returns 200 against a live test database", async () => {
    // Requires TEST_DATABASE_URL to be set
    const res = await request(app).get("/health");
    expect(res.status).toBe(200);
    expect(res.body.status).toBe("healthy");
  });
});
```

This can be conditionally run based on environment (e.g., skip if no `TEST_DATABASE_URL`).

**Acceptance criteria addressed**: Integration test hits the endpoint via supertest.

---

### Task 5: Validate that no existing tests break

**What to do**:

1. Run the full test suite: `npm test`.
2. Confirm all pre-existing tests in `src/__tests__/` still pass.
3. Run the linter: `npm run lint`.
4. Build the project: `npm run build`.

**Validation commands**:

```bash
npm run lint
npm test
npm run build
curl http://localhost:3000/health   # manual smoke test after npm run dev
```

**Acceptance criteria addressed**: No existing tests break; no lint errors.

---

## Task Dependency Graph

```
Task 1 (Create health route)
    |
    v
Task 2 (Register route in app.ts)
    |
    v
Task 3 (Unit tests)
    |
    v
Task 4 (Integration test)
    |
    v
Task 5 (Full validation)
```

Tasks 1 and 2 must be completed first. Tasks 3 and 4 can technically be written in parallel but logically follow from the route being in place. Task 5 is the final gate.

---

## Non-Functional Considerations

| Concern | Approach |
|---------|----------|
| **Performance (< 500ms)** | `SELECT 1` is sub-millisecond on any healthy PostgreSQL instance. No additional latency sources. |
| **Security** | No authentication on the endpoint (per PRD). Response body contains only `status` and `database` fields -- no internal details leaked. |
| **Reliability** | The handler catches all exceptions from the pool query; it will never crash the process. |
| **Observability** | The endpoint itself serves as the observability surface. No additional logging is required, but standard request logging middleware will capture it. |

---

## Definition of Done Checklist

- [ ] `GET /health` returns 200 with `{"status": "healthy", "database": "connected"}` when DB is up
- [ ] `GET /health` returns 503 with `{"status": "unhealthy", "database": "disconnected"}` when DB is down
- [ ] Unit tests cover both healthy and unhealthy scenarios
- [ ] Integration test hits the endpoint via supertest
- [ ] All existing tests continue to pass (`npm test`)
- [ ] No lint errors (`npm run lint`)
- [ ] Code reviewed and merged

---

## Files Changed Summary

| File | Action | Description |
|------|--------|-------------|
| `src/routes/health.ts` | CREATE | Health check route handler |
| `src/app.ts` | MODIFY | Register the `/health` route |
| `src/__tests__/health.test.ts` | CREATE | Unit and integration tests |
