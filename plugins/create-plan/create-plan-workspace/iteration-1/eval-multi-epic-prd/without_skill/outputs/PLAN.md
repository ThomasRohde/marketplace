# Implementation Plan: User Authentication System

## Overview

This plan implements a complete user authentication system for the SaaS platform, replacing the hardcoded API key approach with per-user authentication, JWT-based sessions, and role-based access control. The system is built with TypeScript/Express.js, PostgreSQL via Prisma, and SendGrid for transactional email.

The plan is organized into 5 sequential epics. Each epic builds on the previous one, and every epic ends with passing tests and lint checks before moving on.

---

## Assumptions

- The Express.js application shell (`src/app.ts`) either exists or will be created as part of E1.
- PostgreSQL 15 is available in the development environment.
- SendGrid account and API key are provisioned.
- RS256 key pair has been generated for JWT signing.
- The existing API key system remains untouched; new auth routes are additive.
- Multiple sessions per user are supported (multiple refresh tokens allowed) unless stakeholders decide otherwise.
- Password complexity: minimum 8 characters, at least one uppercase letter, one lowercase letter, one digit, and one special character (reasonable default pending answer to open question).

---

## Epic 1: Database Schema and User Model

**Goal**: Establish the data layer, project scaffolding, and environment configuration.

**Dependencies**: None (starting point).

### Task 1.1: Initialize project and install dependencies

- **File**: `package.json`
- **Action**: Install production and dev dependencies.
  - Production: `express`, `express-validator`, `@prisma/client`, `jsonwebtoken`, `bcryptjs`, `@sendgrid/mail`, `dotenv`, `express-rate-limit`, `helmet`
  - Dev: `typescript`, `ts-node`, `@types/express`, `@types/jsonwebtoken`, `@types/bcryptjs`, `prisma`, `jest`, `ts-jest`, `supertest`, `@types/supertest`, `@types/jest`, `eslint`, `@typescript-eslint/parser`, `@typescript-eslint/eslint-plugin`
- **Validation**: `npm install` completes without errors.

### Task 1.2: Configure TypeScript and project tooling

- **Files**: `tsconfig.json`, `.eslintrc.json`, `jest.config.ts`
- **Action**:
  - Create `tsconfig.json` targeting ES2022 with strict mode, output to `dist/`.
  - Create ESLint config with TypeScript plugin.
  - Create Jest config using `ts-jest` preset.
  - Add npm scripts: `dev`, `build`, `lint`, `test`.
- **Validation**: `npx tsc --noEmit` succeeds; `npm run lint` succeeds.

### Task 1.3: Create environment configuration module

- **File**: `src/config/env.ts`
- **Action**:
  - Load and validate required environment variables: `DATABASE_URL`, `JWT_PRIVATE_KEY`, `JWT_PUBLIC_KEY`, `SENDGRID_API_KEY`, `APP_URL`.
  - Export typed config object.
  - Throw descriptive error on missing variables at startup.
- **File**: `.env.example`
- **Action**: Create template with all required variables documented.
- **Validation**: Importing `env.ts` without env vars throws a clear error; with valid `.env` it exports the config.

### Task 1.4: Define Prisma schema

- **File**: `src/prisma/schema.prisma`
- **Action**: Define the following models:
  - **User**: `id` (UUID, default), `email` (String, unique), `password` (String), `role` (Enum: ADMIN, MEMBER, default MEMBER), `verified` (Boolean, default false), `verificationToken` (String, optional), `resetToken` (String, optional), `resetTokenExpiry` (DateTime, optional), `createdAt` (DateTime), `updatedAt` (DateTime).
  - **RefreshToken**: `id` (UUID, default), `tokenHash` (String, unique), `userId` (UUID, foreign key to User), `expiresAt` (DateTime), `createdAt` (DateTime). Relation: User has many RefreshTokens with cascade delete.
  - Datasource: PostgreSQL from `DATABASE_URL`.
- **Validation**: `npx prisma validate` passes.

### Task 1.5: Create and run initial migration

- **Action**: Run `npx prisma migrate dev --name init` to create the initial migration.
- **Validation**: Migration applies successfully; `npx prisma generate` creates the client.

### Task 1.6: Create seed script

- **File**: `src/prisma/seed.ts`
- **Action**:
  - Hash a default admin password with bcrypt (cost 12).
  - Insert one admin user: `admin@example.com`, role ADMIN, verified true.
  - Configure seed command in `package.json` under `prisma.seed`.
- **Validation**: `npx prisma db seed` creates the admin user; re-running is idempotent (upsert).

### Task 1.7: Create Express application shell

- **File**: `src/app.ts`
- **Action**:
  - Initialize Express app with JSON body parser, helmet, CORS.
  - Mount placeholder route groups: `/api/auth`, `/api/users`, `/api/admin`.
  - Add global error handler middleware.
  - Export the app (separate from server listen for testing).
- **File**: `src/server.ts`
- **Action**: Import app and listen on `PORT` (default 3000).
- **Validation**: `npm run dev` starts without errors; `GET /` returns a health check response.

**Epic 1 exit criteria**: `npx prisma migrate dev && npx prisma db seed` succeeds. App starts. Lint passes.

---

## Epic 2: Registration and Email Verification

**Goal**: Users can register with email/password and verify their email address.

**Dependencies**: Epic 1 complete (schema, app shell, config).

### Task 2.1: Implement email service

- **File**: `src/services/email.service.ts`
- **Action**:
  - Create `EmailService` class wrapping `@sendgrid/mail`.
  - Method `sendVerificationEmail(to: string, token: string)`: sends email with verification link `${APP_URL}/api/auth/verify/${token}`.
  - Method `sendPasswordResetEmail(to: string, token: string)`: sends email with reset link (used later in E4, but define interface now).
  - In test/dev mode, log emails to console instead of sending.
- **Validation**: Unit test mocking SendGrid confirms correct payload is constructed.

### Task 2.2: Implement registration endpoint

- **File**: `src/services/auth.service.ts`
- **Action**:
  - Method `register(email: string, password: string)`:
    - Validate email format and password complexity using express-validator schemas.
    - Check for existing user; if found, throw 409 conflict error.
    - Hash password with bcrypt (cost 12).
    - Generate cryptographically random verification token (`crypto.randomBytes(32).toString('hex')`).
    - Create user record with `verified: false` and store verification token.
    - Call `EmailService.sendVerificationEmail`.
    - Return sanitized user object (no password hash).
- **File**: `src/routes/auth.ts`
- **Action**:
  - `POST /api/auth/register` route with input validation middleware (express-validator).
  - Request body: `{ email: string, password: string }`.
  - Response: 201 with user object on success; 409 on duplicate; 422 on validation failure.
- **Validation**: Manual test with curl/Postman.

### Task 2.3: Implement email verification endpoint

- **File**: `src/services/auth.service.ts`
- **Action**:
  - Method `verifyEmail(token: string)`:
    - Find user by verification token.
    - If not found, throw 400 error (invalid token).
    - Set `verified = true`, clear `verificationToken`.
    - Return success.
- **File**: `src/routes/auth.ts`
- **Action**:
  - `GET /api/auth/verify/:token` route.
  - Response: 200 on success; 400 on invalid/expired token.
- **Validation**: Manual test with token from registration.

### Task 2.4: Write tests for registration and verification

- **File**: `src/__tests__/auth.test.ts` (begin this file)
- **Action**: Write integration tests using supertest:
  - **Registration success**: POST valid data, expect 201, user in DB with `verified: false`.
  - **Duplicate email**: Register same email twice, expect 409 on second attempt.
  - **Invalid input**: Missing email, weak password, expect 422.
  - **Verification success**: Register, extract token from DB, GET verify endpoint, expect 200, user now verified.
  - **Invalid verification token**: GET with bogus token, expect 400.
- **Setup**: Use a test database (separate `DATABASE_URL` for test env). Use `beforeEach` to clean DB state.
- **Validation**: `npm test -- --testPathPattern=auth` passes all tests.

**Epic 2 exit criteria**: Registration creates users; verification activates them; all tests pass; lint clean.

---

## Epic 3: Login and JWT Token Management

**Goal**: Authenticated users can log in, receive JWTs, refresh tokens, and protected routes reject unauthorized access.

**Dependencies**: Epic 2 complete (users can register and verify).

### Task 3.1: Implement token service

- **File**: `src/services/token.service.ts`
- **Action**:
  - Method `generateAccessToken(user: { id: string, email: string, role: string })`: Create JWT signed with RS256 private key, 15-minute expiry, payload includes `sub` (user id), `email`, `role`.
  - Method `generateRefreshToken(userId: string)`: Generate random token (`crypto.randomBytes(64).toString('hex')`), hash with SHA-256, store hash in RefreshToken table with 7-day expiry, return the raw token.
  - Method `verifyAccessToken(token: string)`: Verify JWT with RS256 public key, return decoded payload or throw.
  - Method `verifyRefreshToken(rawToken: string)`: Hash the raw token, look up in DB, check expiry, return associated user or throw.
  - Method `revokeRefreshToken(rawToken: string)`: Delete the hashed token from DB.
- **Validation**: Unit tests for each method.

### Task 3.2: Implement login endpoint

- **File**: `src/services/auth.service.ts`
- **Action**:
  - Method `login(email: string, password: string)`:
    - Find user by email; if not found, throw 401.
    - Compare password with bcrypt; if mismatch, throw 401.
    - If user not verified, throw 403 with message "Please verify your email."
    - Generate access token and refresh token.
    - Return `{ accessToken, refreshToken, user }`.
- **File**: `src/routes/auth.ts`
- **Action**:
  - `POST /api/auth/login` route with input validation.
  - Request body: `{ email: string, password: string }`.
  - Response: 200 with tokens and user on success; 401 on bad credentials; 403 on unverified.
- **Validation**: Manual test.

### Task 3.3: Implement token refresh endpoint

- **File**: `src/services/auth.service.ts`
- **Action**:
  - Method `refreshAccessToken(refreshToken: string)`:
    - Verify refresh token via TokenService.
    - Generate new access token for the associated user.
    - Return `{ accessToken }`.
- **File**: `src/routes/auth.ts`
- **Action**:
  - `POST /api/auth/refresh` route.
  - Request body: `{ refreshToken: string }`.
  - Response: 200 with new access token; 401 on invalid/expired refresh token.
- **Validation**: Manual test.

### Task 3.4: Implement auth middleware

- **File**: `src/middleware/auth.ts`
- **Action**:
  - Extract `Authorization: Bearer <token>` header.
  - Verify the access token using `TokenService.verifyAccessToken`.
  - Attach decoded user to `req.user`.
  - If missing or invalid, return 401 with `{ error: "Unauthorized" }`.
- **Validation**: Unit test with mocked tokens.

### Task 3.5: Implement rate limiting on auth endpoints

- **File**: `src/middleware/rateLimiter.ts`
- **Action**:
  - Use `express-rate-limit` to create a limiter: 10 requests per minute per IP.
  - Apply to all `/api/auth/*` routes.
- **File**: `src/routes/auth.ts`
- **Action**: Mount rate limiter middleware on the auth router.
- **Validation**: Test that 11th request within a minute returns 429.

### Task 3.6: Write tests for login and token management

- **File**: `src/__tests__/auth.test.ts` (extend)
- **Action**: Add integration tests:
  - **Login success**: Register, verify, login, expect 200 with valid JWT and refresh token.
  - **Login unverified**: Register (no verify), login, expect 403.
  - **Login wrong password**: Expect 401.
  - **Login nonexistent user**: Expect 401.
  - **Token refresh success**: Login, use refresh token, expect new access token.
  - **Token refresh expired/invalid**: Expect 401.
  - **Auth middleware**: Request protected route without token (401), with invalid token (401), with valid token (200).
- **Validation**: `npm test -- --testPathPattern=auth` passes all tests.

**Epic 3 exit criteria**: Login returns JWTs; refresh works; auth middleware protects routes; rate limiting active; all tests pass; lint clean.

---

## Epic 4: Password Reset Flow

**Goal**: Users can securely reset forgotten passwords via email.

**Dependencies**: Epic 3 complete (login, email service, token infrastructure).

### Task 4.1: Implement forgot-password endpoint

- **File**: `src/services/auth.service.ts`
- **Action**:
  - Method `forgotPassword(email: string)`:
    - Look up user by email.
    - If user exists, generate a random reset token, hash it, store hash and expiry (1 hour) on user record.
    - Call `EmailService.sendPasswordResetEmail`.
    - Always return success (200) regardless of whether user exists (prevents email enumeration).
- **File**: `src/routes/auth.ts`
- **Action**:
  - `POST /api/auth/forgot-password` route.
  - Request body: `{ email: string }`.
  - Response: Always 200 with generic message.
- **Validation**: Manual test; confirm no information leakage.

### Task 4.2: Implement reset-password endpoint

- **File**: `src/services/auth.service.ts`
- **Action**:
  - Method `resetPassword(token: string, newPassword: string)`:
    - Hash the provided token, find user with matching `resetToken` and `resetTokenExpiry > now`.
    - If not found or expired, throw 400.
    - Hash new password with bcrypt (cost 12).
    - Update user's password; clear `resetToken` and `resetTokenExpiry`.
    - Revoke all existing refresh tokens for this user (force re-login).
    - Return success.
- **File**: `src/routes/auth.ts`
- **Action**:
  - `POST /api/auth/reset-password/:token` route with password validation.
  - Request body: `{ password: string }`.
  - Response: 200 on success; 400 on invalid/expired token.
- **Validation**: Manual test full flow.

### Task 4.3: Write tests for password reset flow

- **File**: `src/__tests__/auth.test.ts` (extend)
- **Action**: Add integration tests:
  - **Forgot password success**: Request reset for existing user, expect 200, confirm token stored in DB.
  - **Forgot password nonexistent email**: Expect 200 (no enumeration).
  - **Reset password success**: Forgot password, extract token from DB, reset with new password, expect 200, confirm old password no longer works, new password works.
  - **Reset password expired token**: Set `resetTokenExpiry` to past, attempt reset, expect 400.
  - **Reset password invalid token**: Use bogus token, expect 400.
  - **Reset password revokes sessions**: After reset, old refresh tokens should be invalid.
- **Validation**: `npm test -- --testPathPattern=auth` passes all tests.

**Epic 4 exit criteria**: Forgot/reset password flow works end-to-end; tokens expire properly; sessions revoked on reset; all tests pass; lint clean.

---

## Epic 5: Role-Based Access Control

**Goal**: Restrict endpoints by user role; build admin endpoints and user profile management.

**Dependencies**: Epic 3 complete (auth middleware), Epic 4 recommended (full auth suite in place).

### Task 5.1: Implement RBAC middleware

- **File**: `src/middleware/rbac.ts`
- **Action**:
  - Export factory function `requireRole(...roles: string[])` that returns Express middleware.
  - Middleware reads `req.user.role` (set by auth middleware from Task 3.4).
  - If user's role is in the allowed list, call `next()`.
  - If not, return 403 with `{ error: "Forbidden: insufficient permissions" }`.
- **Validation**: Unit test with mocked `req.user`.

### Task 5.2: Implement user profile endpoints

- **File**: `src/services/user.service.ts`
- **Action**:
  - Method `getProfile(userId: string)`: Fetch user by ID, return sanitized object (no password).
  - Method `updateProfile(userId: string, data: { email?: string })`: Update allowed fields. If email changes, re-trigger verification flow.
- **File**: `src/routes/users.ts`
- **Action**:
  - `GET /api/users/me`: Returns current user's profile. Protected by auth middleware.
  - `PUT /api/users/me`: Updates current user's profile. Protected by auth middleware. Validates input.
- **Validation**: Manual test.

### Task 5.3: Implement admin user listing endpoint

- **File**: `src/services/admin.service.ts`
- **Action**:
  - Method `listUsers(page: number, limit: number)`: Paginated query for all users, returning sanitized user objects with total count.
- **File**: `src/routes/admin.ts`
- **Action**:
  - `GET /api/admin/users`: Returns paginated user list. Protected by auth middleware + `requireRole('ADMIN')`.
  - Query params: `page` (default 1), `limit` (default 20).
  - Response: `{ users: [...], total: number, page: number, limit: number }`.
- **Validation**: Manual test with admin token.

### Task 5.4: Implement admin role assignment endpoint

- **File**: `src/services/admin.service.ts`
- **Action**:
  - Method `changeUserRole(userId: string, newRole: string)`:
    - Validate role is a valid enum value.
    - Prevent admin from changing their own role (safety guard).
    - Update user's role.
    - Return updated user.
- **File**: `src/routes/admin.ts`
- **Action**:
  - `PUT /api/admin/users/:id/role`: Changes a user's role. Protected by auth middleware + `requireRole('ADMIN')`.
  - Request body: `{ role: "ADMIN" | "MEMBER" }`.
  - Response: 200 with updated user; 400 on invalid role; 404 if user not found; 403 if non-admin.
- **Validation**: Manual test.

### Task 5.5: Write tests for RBAC and admin endpoints

- **File**: `src/__tests__/admin.test.ts`
- **Action**: Integration tests:
  - **Admin list users**: Login as admin, GET /api/admin/users, expect 200 with user list.
  - **Member list users**: Login as member, GET /api/admin/users, expect 403.
  - **Admin change role**: Login as admin, PUT role on member, expect 200, confirm role changed.
  - **Admin self-role-change**: Admin tries to change own role, expect 400.
  - **Invalid role value**: Expect 400.
  - **Unauthenticated access**: No token, expect 401.
- **File**: `src/__tests__/users.test.ts`
- **Action**: Integration tests:
  - **Get profile**: Login, GET /api/users/me, expect 200 with user data (no password hash).
  - **Update profile**: Login, PUT /api/users/me with new data, expect 200.
  - **Unauthenticated profile access**: No token, expect 401.
- **Validation**: `npm test` passes all tests.

### Task 5.6: Mount all routes and finalize app

- **File**: `src/app.ts`
- **Action**:
  - Ensure all route groups are mounted: auth, users, admin.
  - Verify middleware ordering: rate limiter, helmet, auth, RBAC.
  - Add a catch-all 404 handler for undefined routes.
- **Validation**: Full test suite passes; lint clean.

**Epic 5 exit criteria**: RBAC middleware works; admin endpoints restricted to admins; profile endpoints work for all authenticated users; all tests pass; lint clean.

---

## Execution Order and Dependencies

```
E1: Database Schema and User Model
 |
 v
E2: Registration and Email Verification
 |
 v
E3: Login and JWT Token Management
 |
 v
E4: Password Reset Flow
 |
 v
E5: Role-Based Access Control
```

All epics are strictly sequential. Each epic builds on primitives established in the previous one.

---

## File Manifest

| File | Created/Modified In | Purpose |
|------|-------------------|---------|
| `package.json` | E1 (Task 1.1) | Dependencies and scripts |
| `tsconfig.json` | E1 (Task 1.2) | TypeScript configuration |
| `.eslintrc.json` | E1 (Task 1.2) | Lint rules |
| `jest.config.ts` | E1 (Task 1.2) | Test configuration |
| `.env.example` | E1 (Task 1.3) | Environment variable template |
| `src/config/env.ts` | E1 (Task 1.3) | Environment config loader |
| `src/prisma/schema.prisma` | E1 (Task 1.4) | Database schema |
| `src/prisma/seed.ts` | E1 (Task 1.6) | Database seed script |
| `src/app.ts` | E1 (Task 1.7), E5 (Task 5.6) | Express application |
| `src/server.ts` | E1 (Task 1.7) | Server entry point |
| `src/services/email.service.ts` | E2 (Task 2.1) | SendGrid email wrapper |
| `src/services/auth.service.ts` | E2 (Task 2.2), E3 (Task 3.2), E4 (Task 4.1) | Auth business logic |
| `src/routes/auth.ts` | E2 (Task 2.2), E3 (Task 3.2), E4 (Task 4.1) | Auth route handlers |
| `src/services/token.service.ts` | E3 (Task 3.1) | JWT and refresh token logic |
| `src/middleware/auth.ts` | E3 (Task 3.4) | JWT verification middleware |
| `src/middleware/rateLimiter.ts` | E3 (Task 3.5) | Rate limiting middleware |
| `src/middleware/rbac.ts` | E5 (Task 5.1) | Role-based access middleware |
| `src/services/user.service.ts` | E5 (Task 5.2) | User profile logic |
| `src/services/admin.service.ts` | E5 (Task 5.3) | Admin operations logic |
| `src/routes/users.ts` | E5 (Task 5.2) | User profile routes |
| `src/routes/admin.ts` | E5 (Task 5.3) | Admin routes |
| `src/__tests__/auth.test.ts` | E2 (Task 2.4), E3 (Task 3.6), E4 (Task 4.3) | Auth integration tests |
| `src/__tests__/users.test.ts` | E5 (Task 5.5) | User profile tests |
| `src/__tests__/admin.test.ts` | E5 (Task 5.5) | Admin endpoint tests |

---

## Validation Checkpoints

| Checkpoint | Command | When |
|-----------|---------|------|
| Schema valid | `npx prisma validate` | After Task 1.4 |
| Migration runs | `npx prisma migrate dev` | After Task 1.5 |
| Seed works | `npx prisma db seed` | After Task 1.6 |
| App starts | `npm run dev` | After Task 1.7 |
| Auth tests pass | `npm test -- --testPathPattern=auth` | After Tasks 2.4, 3.6, 4.3 |
| Lint clean | `npm run lint` | After each epic |
| Full test suite | `npm test` | After Task 5.5 |
| Build succeeds | `npm run build` | After Task 5.6 |

---

## Risk Mitigation

| Risk | Mitigation |
|------|-----------|
| SendGrid sandbox limits during dev | Use console logging fallback in dev/test mode (Task 2.1) |
| RS256 key management | Document key generation in `.env.example`; use `crypto.generateKeyPairSync` for dev keys |
| Test database pollution | Use separate `DATABASE_URL` for tests; truncate tables in `beforeEach` |
| Rate limiter interfering with tests | Disable or increase limits in test environment |
| Refresh token accumulation | Add cleanup of expired tokens in the seed/migration or as a scheduled task (post-MVP) |

---

## Definition of Done

All of the following must be true before the system is considered complete:

- [ ] All 10 functional requirements (FR-1 through FR-10) are implemented
- [ ] All acceptance criteria across all 5 epics are met
- [ ] `npm test` passes with all tests green
- [ ] `npm run lint` reports zero errors
- [ ] `npm run build` produces a clean build
- [ ] Auth endpoints respond within 200ms at p95
- [ ] Rate limiting is active on auth endpoints (10 req/min per IP)
- [ ] Passwords are hashed with bcrypt cost 12
- [ ] JWTs are signed with RS256
- [ ] Refresh tokens are stored as SHA-256 hashes
- [ ] No secrets appear in logs or error responses
- [ ] API key system still functions (coexistence verified)
- [ ] Security review completed
- [ ] API documentation updated
