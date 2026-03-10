# PRD: Add Health Check Endpoint

## Document Control

| Field | Value |
|-------|-------|
| Title | Health Check Endpoint |
| Owner | Jane Smith |
| Repository | github.com/acme/web-api |
| Classification | Internal |

## Executive Summary

Add a `/health` endpoint to the existing Express.js REST API so that load balancers and monitoring systems can verify the service is running and its database connection is active.

## Problem Statement

The operations team currently has no way to programmatically check if the web-api service is healthy. They rely on manual curl requests to business endpoints, which return false negatives when the endpoint logic changes. A dedicated health check would reduce incident response time by giving a clear, stable signal.

## Scope

### In Scope
- A `GET /health` endpoint returning JSON with service status and database connectivity
- Integration with the existing Express.js app in `src/app.ts`
- Unit and integration tests

### Out of Scope
- Readiness probes (separate concern, future work)
- Detailed dependency health (Redis, external APIs)
- Dashboard or alerting configuration

### Non-Goals
- Do not modify existing business endpoints
- Do not add authentication to the health endpoint

## Personas and Scenarios

**Operations Engineer**: Given the service is deployed, when they send `GET /health`, then they receive HTTP 200 with `{"status": "healthy", "database": "connected"}` if all is well, or HTTP 503 with `{"status": "unhealthy", "database": "disconnected"}` if the DB is down.

## Functional Requirements

| ID | Requirement | Priority | Acceptance Criteria |
|----|------------|----------|-------------------|
| FR-1 | Health endpoint returns 200 when healthy | Must | `GET /health` returns 200 with JSON body |
| FR-2 | Health endpoint checks database connectivity | Must | Response includes `database` field reflecting actual DB state |
| FR-3 | Health endpoint returns 503 when unhealthy | Must | When DB is unreachable, returns 503 |

## Non-Functional Requirements

- **Performance**: Health check must respond within 500ms
- **Security**: No authentication required; endpoint must not expose internal details beyond status

## Tech Stack

- **Language**: TypeScript 5.x
- **Runtime**: Node.js 20
- **Framework**: Express.js 4.x
- **Database**: PostgreSQL via `pg` package
- **Test framework**: Jest with `supertest`
- **Package manager**: npm

## Architecture

```
src/
├── app.ts              # Express app setup, routes
├── routes/
│   ├── users.ts        # Existing user routes
│   └── health.ts       # NEW: health check route
├── db/
│   └── pool.ts         # PostgreSQL connection pool
└── __tests__/
    └── health.test.ts  # NEW: health check tests
```

## Build / Run / Validate

```bash
# Install
npm install

# Run locally
npm run dev    # starts on port 3000

# Lint
npm run lint

# Test
npm test       # Jest, expect all tests to pass

# Build
npm run build  # tsc output to dist/
```

## Phase Plan

- [ ] E1: Add health check endpoint — Create the route, wire it into the app, add tests

## Epic Card: E1 — Health Check Endpoint

**Objective**: Add a `/health` GET endpoint that checks database connectivity.

**Acceptance Criteria**:
- [ ] `GET /health` returns 200 with `{"status": "healthy", "database": "connected"}`
- [ ] When DB pool query fails, returns 503 with `{"status": "unhealthy", "database": "disconnected"}`
- [ ] Unit test covers both healthy and unhealthy scenarios
- [ ] Integration test hits the endpoint via supertest
- [ ] No existing tests break

**Validation**:
```bash
npm test
curl http://localhost:3000/health
```

## Definition of Done

- [ ] All acceptance criteria met
- [ ] All tests pass
- [ ] Code reviewed
- [ ] No lint errors
