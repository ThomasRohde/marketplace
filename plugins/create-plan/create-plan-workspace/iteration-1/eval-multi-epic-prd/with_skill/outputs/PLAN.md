# Add User Authentication System to the SaaS Platform

This ExecPlan is a living document. The sections `Progress`, `Surprises & Discoveries`, `Decision Log`, and `Outcomes & Retrospective` must be kept up to date as work proceeds.


## Purpose / Big Picture

After this change, the SaaS platform supports individual user accounts instead of a single shared API key. Users can register with an email address, verify their account, log in to receive short-lived JWT access tokens and longer-lived refresh tokens, and reset forgotten passwords via email. Administrators can list all users and assign roles, and every API endpoint can enforce role-based access so that only authorized users reach protected resources. The existing API key system continues to function during migration.

To see it working, start the server with `npm run dev`, register a new user by POSTing to `http://localhost:3000/api/auth/register`, verify the account via the emailed link, log in at `/api/auth/login` to receive a JWT, and then access protected endpoints by passing that JWT in the `Authorization: Bearer <token>` header. Admin users can manage other users at `/api/admin/users`. Running `npm test` executes the full test suite and confirms all authentication flows pass.


## Progress

### Milestone 1 — Database Schema and User Model
- [ ] Create Prisma schema with User and RefreshToken models
- [ ] Create environment configuration module at `src/config/env.ts`
- [ ] Run initial Prisma migration
- [ ] Create seed script with one admin user
- [ ] Verify migration and seed execute successfully

### Milestone 2 — Registration and Email Verification
- [ ] Create SendGrid email service at `src/services/email.service.ts`
- [ ] Create auth service at `src/services/auth.service.ts` with registration logic
- [ ] Create auth routes at `src/routes/auth.ts` with POST `/api/auth/register`
- [ ] Implement GET `/api/auth/verify/:token` endpoint
- [ ] Wire auth routes into `src/app.ts`
- [ ] Write tests for registration and verification in `src/__tests__/auth.test.ts`
- [ ] Run tests and confirm they pass

### Milestone 3 — Login and JWT Token Management
- [ ] Create token service at `src/services/token.service.ts` for JWT signing and verification
- [ ] Add login logic to auth service (credential validation, token issuance)
- [ ] Add POST `/api/auth/login` and POST `/api/auth/refresh` routes
- [ ] Create auth middleware at `src/middleware/auth.ts` for JWT verification
- [ ] Extend tests for login, refresh, and middleware scenarios
- [ ] Run tests and confirm they pass

### Milestone 4 — Password Reset Flow
- [ ] Add forgot-password logic to auth service (token generation, email sending)
- [ ] Add reset-password logic to auth service (token validation, password update)
- [ ] Add POST `/api/auth/forgot-password` and POST `/api/auth/reset-password/:token` routes
- [ ] Extend tests for password reset scenarios (success, expired, invalid)
- [ ] Run tests and confirm they pass

### Milestone 5 — Role-Based Access Control and Admin Endpoints
- [ ] Create RBAC middleware at `src/middleware/rbac.ts`
- [ ] Create admin routes at `src/routes/admin.ts` with GET `/api/admin/users` and PUT `/api/admin/users/:id/role`
- [ ] Create user profile routes at `src/routes/users.ts` with GET/PUT `/api/users/me`
- [ ] Wire admin and user routes into `src/app.ts`
- [ ] Write tests in `src/__tests__/admin.test.ts` and `src/__tests__/users.test.ts`
- [ ] Run full test suite and confirm all tests pass
- [ ] Run linter and confirm no errors


## Surprises & Discoveries

No discoveries yet — this section will be populated during implementation.


## Decision Log

- Decision: Use a single comprehensive ExecPlan rather than one per epic.
  Rationale: The five epics (schema, registration, login, password reset, RBAC) are tightly coupled. They share the same database models, the same auth service module, and the same test files. Splitting into five separate plans would force heavy duplication of context and create coordination overhead between plans.
  Date/Author: Plan creation.

- Decision: Use RS256 (asymmetric) JWT signing instead of HS256 (symmetric).
  Rationale: The PRD explicitly specifies RS256. This means the server signs tokens with a private key and verifies them with a public key. This allows other services to verify tokens without possessing the signing secret.
  Source: PRD, Tech Stack and Security sections.

- Decision: Store refresh tokens as SHA-256 hashes in the database rather than storing the raw token.
  Rationale: The PRD requires this for security. If the database is compromised, the attacker cannot use the hashed tokens to impersonate users because they cannot reverse the hash to obtain the original token value.
  Source: PRD, Security section.

- Decision: Support multiple concurrent sessions per user (multiple refresh tokens allowed).
  Rationale: The PRD lists "Should we support multiple sessions per user or single-session only?" as an open question. Multiple sessions is the more common and user-friendly default — users expect to be logged in on their phone and laptop simultaneously. This can be tightened later.
  Source: PRD, Open Questions #1.

- Decision: Password complexity policy requires minimum 8 characters, at least one uppercase letter, one lowercase letter, and one digit.
  Rationale: The PRD lists password complexity as an open question. This policy is a reasonable baseline that balances security with usability. It can be adjusted via configuration later.
  Source: PRD, Open Questions #2.

- Decision: Use SendGrid for all transactional email (verification and password reset).
  Rationale: The PRD explicitly lists SendGrid as the email service and `@sendgrid/mail` as the library. The PRD non-goals state "do not build a custom email service; use SendGrid."
  Source: PRD, Non-Goals and Tech Stack sections.

- Decision: The existing API key authentication system remains untouched.
  Rationale: The PRD non-goals explicitly state "Do not remove the API key system yet — it must coexist during migration." The new JWT auth middleware will be additive — applied only to new auth-protected routes.
  Source: PRD, Non-Goals section.


## Outcomes & Retrospective

To be completed at major milestones and at plan completion.


## Context and Orientation

The repository at `github.com/acme/saas-platform` is a TypeScript application running on Node.js 20 with Express.js 4.x as the HTTP framework. The codebase uses Prisma ORM to communicate with a PostgreSQL 15 database. The entry point is `src/app.ts`, which creates and configures the Express application, mounts route handlers, and starts the HTTP server on port 3000.

The project uses npm as its package manager. TypeScript source files live under `src/`. The build output goes to a `dist/` directory (produced by `npm run build`). Tests use Jest as the test runner and Supertest for making HTTP assertions against the Express app without starting a real server.

Currently, the application authenticates all API requests with a single shared API key. There is no concept of individual users, sessions, or roles. This plan adds all of those concepts while leaving the existing API key mechanism in place so that current integrations continue to work during migration.

The file structure this plan creates and modifies is as follows. Paths are relative to the repository root.

`prisma/schema.prisma` — The Prisma schema file defines the database models. This plan adds a `User` model and a `RefreshToken` model here. Prisma is an ORM (Object-Relational Mapping) tool: you define your database tables as models in this file, then run `npx prisma migrate dev` to create the corresponding database tables and `npx prisma generate` to create a TypeScript client that can query those tables.

`src/config/env.ts` — A module that reads environment variables and exports them as typed constants. Environment variables are configuration values set outside the code (in the shell or a `.env` file) so that secrets like database credentials and API keys are not hardcoded in source files.

`src/middleware/auth.ts` — Express middleware for JWT verification. Middleware in Express is a function that runs before a route handler. It receives the incoming HTTP request, can modify it (for example, by attaching the authenticated user's information), and either passes control to the next handler or rejects the request with an error. This middleware extracts the JWT from the `Authorization` header, verifies its signature using the RS256 public key, and attaches the decoded user information to the request object.

`src/middleware/rbac.ts` — Express middleware for role-based access control. RBAC (Role-Based Access Control) means restricting access to certain endpoints based on the user's role (for example, "admin" or "member"). This middleware checks whether the authenticated user's role matches one of the roles required by the endpoint and returns HTTP 403 Forbidden if it does not.

`src/routes/auth.ts` — Express router defining the authentication endpoints: registration, email verification, login, token refresh, forgot password, and reset password.

`src/routes/users.ts` — Express router for user profile endpoints. Authenticated users can view and update their own profile.

`src/routes/admin.ts` — Express router for admin-only endpoints: listing all users and changing a user's role.

`src/services/auth.service.ts` — The business logic layer for authentication operations. This module contains functions for registering a user (hashing the password, creating the database record, generating a verification token, triggering the verification email), logging in (validating credentials, issuing tokens), and resetting passwords. It is called by the route handlers and calls the token service and email service.

`src/services/token.service.ts` — Handles JWT creation and verification. A JWT (JSON Web Token) is a signed string that encodes a payload (such as the user's ID and role) and an expiration time. The server signs the token with a private key (RS256 algorithm), and any party with the corresponding public key can verify the token's authenticity without contacting the server. This service creates access tokens (short-lived, 15 minutes) and refresh tokens (longer-lived, 7 days). Refresh tokens are also stored as SHA-256 hashes in the database so they can be revoked.

`src/services/email.service.ts` — Wraps the `@sendgrid/mail` library to send transactional emails (verification and password reset). SendGrid is a third-party email delivery service; the `@sendgrid/mail` npm package provides a simple API: you call `sgMail.send({ to, from, subject, html })` and it delivers the email through SendGrid's infrastructure.

`src/__tests__/auth.test.ts` — Jest tests for all authentication endpoints (register, verify, login, refresh, forgot-password, reset-password).

`src/__tests__/users.test.ts` — Jest tests for user profile endpoints.

`src/__tests__/admin.test.ts` — Jest tests for admin endpoints, including role enforcement.

How these parts connect: A client sends an HTTP request to the Express server (`src/app.ts`). Express matches the URL to a route in `src/routes/`. If the route is protected, the request first passes through `src/middleware/auth.ts` (which verifies the JWT) and possibly `src/middleware/rbac.ts` (which checks the user's role). The route handler then calls functions in `src/services/` to perform business logic, which in turn use the Prisma client to read from or write to the PostgreSQL database. Responses flow back through the middleware chain to the client.


## Plan of Work

The work proceeds in five milestones, each building on the previous one. Every milestone ends with running tests that validate the new behavior.

### Milestone 1: Database Schema and User Model

Begin by defining the data models that the entire authentication system depends on. In `prisma/schema.prisma`, add a `User` model with the following fields: `id` (UUID, primary key, auto-generated), `email` (unique string), `password` (string, stores the bcrypt hash), `role` (enum with values ADMIN and MEMBER, defaults to MEMBER), `verified` (boolean, defaults to false), `verificationToken` (optional string for email verification), `resetToken` (optional string for password reset), `resetTokenExpiry` (optional DateTime), `createdAt` (DateTime, auto-set), and `updatedAt` (DateTime, auto-updated). Add a `RefreshToken` model with: `id` (UUID), `tokenHash` (string, stores the SHA-256 hash of the refresh token), `userId` (string, foreign key to User), `expiresAt` (DateTime), and `createdAt` (DateTime). Define a `Role` enum with values `ADMIN` and `MEMBER`. Create a relation so that a User has many RefreshTokens and deleting a User cascades to delete their tokens.

Create `src/config/env.ts` to centralize environment variable access. This module reads `DATABASE_URL`, `JWT_PRIVATE_KEY`, `JWT_PUBLIC_KEY`, `SENDGRID_API_KEY`, and `APP_URL` from `process.env`, validates that they are present, and exports them as typed constants.

Create a seed script at `prisma/seed.ts` that uses the Prisma client and bcryptjs to create a single admin user with email `admin@acme.com`, a bcrypt-hashed password `Admin123!`, role `ADMIN`, and `verified: true`. Configure the seed command in `package.json` under the `prisma.seed` key so that `npx prisma db seed` executes it.

Run the migration and seed to validate that the schema is correct and the admin user is created.

### Milestone 2: Registration and Email Verification

Create the email service first since registration depends on it. In `src/services/email.service.ts`, import `@sendgrid/mail`, configure it with the SendGrid API key from `src/config/env.ts`, and export two functions: `sendVerificationEmail(to: string, token: string)` which sends an HTML email containing a clickable link to `${APP_URL}/api/auth/verify/${token}`, and `sendPasswordResetEmail(to: string, token: string)` which sends a link to `${APP_URL}/api/auth/reset-password/${token}`.

Create `src/services/auth.service.ts` with a `register` function that: validates the email is not already taken (query the User table; if found, throw a conflict error), hashes the password using `bcryptjs.hash` with cost factor 12, generates a random verification token using `crypto.randomUUID()`, creates the User record in the database with `verified: false` and the verification token stored, and calls `sendVerificationEmail`. Add a `verifyEmail` function that: looks up the User by `verificationToken`, returns an error if not found, sets `verified = true` and clears the `verificationToken`.

Create `src/routes/auth.ts` as an Express Router. Add a POST `/register` handler that uses `express-validator` to validate the request body (email must be a valid email, password must be at least 8 characters with one uppercase, one lowercase, and one digit), calls `auth.service.register`, and returns HTTP 201 with `{ message: "Registration successful. Please check your email to verify your account." }`. Add a GET `/verify/:token` handler that calls `auth.service.verifyEmail` and returns HTTP 200 with `{ message: "Email verified successfully." }`. Mount this router in `src/app.ts` at the `/api/auth` prefix.

Write tests in `src/__tests__/auth.test.ts` covering: successful registration returns 201, duplicate email returns 409, invalid email format returns 400, weak password returns 400, successful verification returns 200, invalid verification token returns 400.

### Milestone 3: Login and JWT Token Management

Create `src/services/token.service.ts` with functions to create and verify JWTs. The `generateAccessToken(userId: string, role: string)` function signs a JWT payload `{ sub: userId, role }` with the RS256 private key and a 15-minute expiration. The `generateRefreshToken(userId: string)` function creates a random token string using `crypto.randomBytes(64).toString('hex')`, hashes it with SHA-256, stores the hash in the `RefreshToken` table with a 7-day expiration, and returns the raw token to the caller. The `verifyAccessToken(token: string)` function verifies the JWT signature against the RS256 public key and returns the decoded payload. The `verifyRefreshToken(rawToken: string)` function hashes the provided token, looks it up in the `RefreshToken` table, checks that it has not expired, and returns the associated user ID.

Add a `login` function to `src/services/auth.service.ts` that: looks up the User by email, returns 401 if not found, compares the provided password against the stored bcrypt hash using `bcryptjs.compare`, returns 401 if mismatched, checks `verified` and returns 403 if false, then calls `tokenService.generateAccessToken` and `tokenService.generateRefreshToken` and returns both tokens. Add a `refreshToken` function that: calls `tokenService.verifyRefreshToken` to validate the refresh token, loads the associated User, generates a new access token, and returns it.

Add POST `/login` and POST `/refresh` routes in `src/routes/auth.ts`. The login route validates email and password inputs, calls `auth.service.login`, and returns HTTP 200 with `{ accessToken, refreshToken }`. The refresh route accepts `{ refreshToken }` in the body, calls `auth.service.refreshToken`, and returns HTTP 200 with `{ accessToken }`.

Create `src/middleware/auth.ts`. This middleware reads the `Authorization` header, expects the format `Bearer <token>`, extracts the token, calls `tokenService.verifyAccessToken`, and if valid, attaches `{ userId, role }` to `req.user`. If the header is missing or the token is invalid/expired, it returns HTTP 401 with `{ error: "Unauthorized" }`.

Extend `src/__tests__/auth.test.ts` with tests for: successful login returns 200 with tokens, login with wrong password returns 401, login with unverified user returns 403, login with non-existent email returns 401, successful token refresh returns 200 with new access token, refresh with invalid token returns 401, protected route without token returns 401, protected route with expired token returns 401, protected route with valid token succeeds.

### Milestone 4: Password Reset Flow

Add a `forgotPassword` function to `src/services/auth.service.ts` that: receives an email address, looks up the User, and if found generates a random reset token using `crypto.randomUUID()`, stores it in `User.resetToken` with a `resetTokenExpiry` set to one hour from now, and calls `sendPasswordResetEmail`. If the user is not found, the function does nothing (no error) to prevent email enumeration. The endpoint always returns HTTP 200 with a generic message regardless of whether the email exists. Add a `resetPassword` function that: receives the token and new password, looks up the User by `resetToken`, verifies `resetTokenExpiry` is in the future (returns error if expired), hashes the new password with bcrypt cost 12, updates the User's password, and clears the `resetToken` and `resetTokenExpiry` fields.

Add POST `/forgot-password` and POST `/reset-password/:token` routes in `src/routes/auth.ts`. The forgot-password route validates the email input and always returns HTTP 200 with `{ message: "If an account with that email exists, a password reset link has been sent." }`. The reset-password route validates the new password (same rules as registration), calls `auth.service.resetPassword`, and returns HTTP 200 with `{ message: "Password reset successful." }`.

Extend `src/__tests__/auth.test.ts` with tests for: forgot-password with valid email returns 200 and sends email, forgot-password with unknown email returns 200 (no email sent, no error), reset-password with valid token updates password and returns 200, reset-password with expired token returns 400, reset-password with invalid token returns 400, user can log in with new password after reset.

### Milestone 5: Role-Based Access Control and Admin Endpoints

Create `src/middleware/rbac.ts`. This module exports a function `requireRole(...roles: string[])` that returns Express middleware. The middleware checks `req.user.role` (set by the auth middleware in the previous milestone) against the provided list of allowed roles. If the role is included, it calls `next()`. If not, it returns HTTP 403 with `{ error: "Forbidden: insufficient role" }`. This middleware must always be used after the auth middleware in the middleware chain.

Create `src/routes/admin.ts` as an Express Router. Add GET `/users` (protected by auth middleware and `requireRole('ADMIN')`) that queries all Users from the database and returns them with `id`, `email`, `role`, `verified`, and `createdAt` (password hash excluded). Add PUT `/users/:id/role` (protected by auth middleware and `requireRole('ADMIN')`) that validates the `role` field in the request body (must be `ADMIN` or `MEMBER`), updates the User record, and returns the updated user.

Create `src/routes/users.ts` as an Express Router. Add GET `/me` (protected by auth middleware) that returns the authenticated user's profile (id, email, role, verified, createdAt). Add PUT `/me` (protected by auth middleware) that allows updating the user's email (with re-verification if changed) and returns the updated profile.

Mount the admin router at `/api/admin` and the users router at `/api/users` in `src/app.ts`.

Write tests in `src/__tests__/admin.test.ts` covering: admin can list users (200), member cannot list users (403), admin can change user role (200), member cannot change role (403), changing to invalid role returns 400. Write tests in `src/__tests__/users.test.ts` covering: authenticated user can GET their profile (200), authenticated user can PUT to update profile (200), unauthenticated request returns 401.

After all tests pass, run `npm run lint` and confirm zero lint errors. Run `npm run build` to confirm the TypeScript compiles without errors.


## Concrete Steps

All commands are run from the repository root directory unless otherwise noted.

### Milestone 1: Database Schema and User Model

1. Install the required npm packages.

        npm install bcryptjs jsonwebtoken @sendgrid/mail express-validator
        npm install -D @types/bcryptjs @types/jsonwebtoken

    Expected output: packages added to `node_modules/` and `package.json` updated. No errors.

2. Add the User model, RefreshToken model, and Role enum to the Prisma schema file at `prisma/schema.prisma`. The models should include all fields described in the Plan of Work section under Milestone 1. Below the existing content in the schema file, add the Role enum, the User model, and the RefreshToken model with the appropriate relations and field attributes.

3. Generate the Prisma client and run the migration.

        npx prisma generate
        npx prisma migrate dev --name add-user-auth-models

    Expected output from `prisma generate`: "Generated Prisma Client". Expected output from `prisma migrate dev`: "The following migration has been created and applied" followed by the migration name. The database now has `User` and `RefreshToken` tables.

4. Create the environment configuration module at `src/config/env.ts`. This file reads environment variables from `process.env` and exports them. For each required variable (`DATABASE_URL`, `JWT_PRIVATE_KEY`, `JWT_PUBLIC_KEY`, `SENDGRID_API_KEY`, `APP_URL`), throw an error at startup if the variable is not set.

5. Create the seed script at `prisma/seed.ts`. This script imports the Prisma client and bcryptjs, hashes the password `Admin123!` with bcrypt cost 12, and upserts a User with email `admin@acme.com`, role `ADMIN`, `verified: true`, and the hashed password. Use upsert so the script is idempotent.

6. Add the seed configuration to `package.json`.

        // In package.json, add:
        "prisma": {
          "seed": "ts-node prisma/seed.ts"
        }

7. Run the seed script.

        npx prisma db seed

    Expected output: "Running seed command" followed by confirmation that the admin user was created or already exists. Verify by querying:

        npx prisma studio

    Open the browser, navigate to the User table, and confirm one row exists with email `admin@acme.com`, role `ADMIN`, verified `true`.

### Milestone 2: Registration and Email Verification

8. Create `src/services/email.service.ts` with functions `sendVerificationEmail` and `sendPasswordResetEmail` as described in the Plan of Work.

9. Create `src/services/auth.service.ts` with the `register` and `verifyEmail` functions as described in the Plan of Work.

10. Create `src/routes/auth.ts` with POST `/register` and GET `/verify/:token` routes. Use `express-validator` to validate inputs. Mount the router in `src/app.ts` at `/api/auth`.

11. Write tests in `src/__tests__/auth.test.ts` for registration and verification scenarios. Mock the email service to prevent actual emails from being sent during tests. Use Supertest to make HTTP requests against the Express app.

12. Run the tests.

        npm test -- --testPathPattern=auth

    Expected output: all registration and verification tests pass. Example:

        PASS src/__tests__/auth.test.ts
          Registration
            ✓ registers a new user and returns 201
            ✓ returns 409 for duplicate email
            ✓ returns 400 for invalid email
            ✓ returns 400 for weak password
          Email Verification
            ✓ verifies email with valid token and returns 200
            ✓ returns 400 for invalid verification token

### Milestone 3: Login and JWT Token Management

13. Create `src/services/token.service.ts` with `generateAccessToken`, `generateRefreshToken`, `verifyAccessToken`, and `verifyRefreshToken` functions as described in the Plan of Work. For RS256 signing, use `jwt.sign(payload, privateKey, { algorithm: 'RS256', expiresIn: '15m' })`.

14. Add `login` and `refreshToken` functions to `src/services/auth.service.ts`.

15. Add POST `/login` and POST `/refresh` routes to `src/routes/auth.ts`.

16. Create `src/middleware/auth.ts` with the JWT verification middleware.

17. Extend tests in `src/__tests__/auth.test.ts` for login, refresh, and middleware scenarios.

18. Run the tests.

        npm test -- --testPathPattern=auth

    Expected output: all auth tests pass, including the new login and refresh tests. Example additions:

        Login
          ✓ returns 200 with access and refresh tokens for valid credentials
          ✓ returns 401 for wrong password
          ✓ returns 403 for unverified user
          ✓ returns 401 for non-existent email
        Token Refresh
          ✓ returns 200 with new access token for valid refresh token
          ✓ returns 401 for invalid refresh token
        Auth Middleware
          ✓ returns 401 when no Authorization header
          ✓ returns 401 for expired token
          ✓ passes through for valid token

### Milestone 4: Password Reset Flow

19. Add `forgotPassword` and `resetPassword` functions to `src/services/auth.service.ts` as described in the Plan of Work.

20. Add POST `/forgot-password` and POST `/reset-password/:token` routes to `src/routes/auth.ts`.

21. Extend tests in `src/__tests__/auth.test.ts` for password reset scenarios.

22. Run the tests.

        npm test -- --testPathPattern=auth

    Expected output: all auth tests pass, including the new password reset tests. Example additions:

        Password Reset
          ✓ forgot-password returns 200 for valid email
          ✓ forgot-password returns 200 for unknown email (no enumeration)
          ✓ reset-password with valid token returns 200 and updates password
          ✓ reset-password with expired token returns 400
          ✓ reset-password with invalid token returns 400
          ✓ user can log in with new password after reset

### Milestone 5: Role-Based Access Control and Admin Endpoints

23. Create `src/middleware/rbac.ts` with the `requireRole` factory function as described in the Plan of Work.

24. Create `src/routes/admin.ts` with GET `/users` and PUT `/users/:id/role`, both protected by auth middleware and `requireRole('ADMIN')`.

25. Create `src/routes/users.ts` with GET `/me` and PUT `/me`, both protected by auth middleware (any role).

26. Mount the new routers in `src/app.ts`: admin routes at `/api/admin`, user routes at `/api/users`.

27. Write tests in `src/__tests__/admin.test.ts` and `src/__tests__/users.test.ts` as described in the Plan of Work.

28. Run the full test suite.

        npm test

    Expected output: all tests across all test files pass. Example:

        Test Suites: 3 passed, 3 total
        Tests:       ~25 passed, ~25 total

29. Run the linter.

        npm run lint

    Expected output: no errors or warnings.

30. Run the build.

        npm run build

    Expected output: TypeScript compiles to `dist/` without errors.


## Validation and Acceptance

After completing all milestones, the following manual acceptance checks can be performed by starting the server and issuing requests. Start the server with the required environment variables set (via a `.env` file or shell exports):

    DATABASE_URL=postgresql://user:pass@localhost:5432/saas_platform
    JWT_PRIVATE_KEY="-----BEGIN RSA PRIVATE KEY-----\n...\n-----END RSA PRIVATE KEY-----"
    JWT_PUBLIC_KEY="-----BEGIN PUBLIC KEY-----\n...\n-----END PUBLIC KEY-----"
    SENDGRID_API_KEY=SG.test_key
    APP_URL=http://localhost:3000

    npm run dev

1. Register a user:

        curl -X POST http://localhost:3000/api/auth/register \
          -H "Content-Type: application/json" \
          -d '{"email": "newuser@example.com", "password": "SecurePass1"}'

    Expected: HTTP 201 with `{ "message": "Registration successful. Please check your email to verify your account." }`

2. Verify the user (using the token from the verification email or by querying the database):

        curl http://localhost:3000/api/auth/verify/<verification-token>

    Expected: HTTP 200 with `{ "message": "Email verified successfully." }`

3. Log in:

        curl -X POST http://localhost:3000/api/auth/login \
          -H "Content-Type: application/json" \
          -d '{"email": "newuser@example.com", "password": "SecurePass1"}'

    Expected: HTTP 200 with `{ "accessToken": "eyJ...", "refreshToken": "a3f..." }`

4. Access a protected endpoint:

        curl http://localhost:3000/api/users/me \
          -H "Authorization: Bearer <accessToken>"

    Expected: HTTP 200 with user profile JSON (id, email, role, verified, createdAt).

5. Refresh the token:

        curl -X POST http://localhost:3000/api/auth/refresh \
          -H "Content-Type: application/json" \
          -d '{"refreshToken": "<refreshToken>"}'

    Expected: HTTP 200 with `{ "accessToken": "eyJ..." }` (a new access token).

6. Access without token:

        curl http://localhost:3000/api/users/me

    Expected: HTTP 401 with `{ "error": "Unauthorized" }`

7. Request password reset:

        curl -X POST http://localhost:3000/api/auth/forgot-password \
          -H "Content-Type: application/json" \
          -d '{"email": "newuser@example.com"}'

    Expected: HTTP 200 with `{ "message": "If an account with that email exists, a password reset link has been sent." }`

8. Admin lists users (log in as admin@acme.com first):

        curl http://localhost:3000/api/admin/users \
          -H "Authorization: Bearer <admin-access-token>"

    Expected: HTTP 200 with JSON array of user objects.

9. Member tries admin endpoint:

        curl http://localhost:3000/api/admin/users \
          -H "Authorization: Bearer <member-access-token>"

    Expected: HTTP 403 with `{ "error": "Forbidden: insufficient role" }`

10. Run the full automated test suite:

        npm test

    Expected: all tests pass with zero failures.

11. Run the linter:

        npm run lint

    Expected: zero errors.


## Idempotence and Recovery

All Prisma migrations are tracked in the `prisma/migrations/` directory. Running `npx prisma migrate dev` is idempotent — it applies only migrations that have not yet been applied. If a migration fails partway, run `npx prisma migrate reset` to reset the database and re-apply all migrations from scratch (this destroys data, so use only in development).

The seed script uses `upsert` so it can be run repeatedly without creating duplicate admin users.

`npm install` is idempotent — re-running it installs only missing packages.

File creation steps are idempotent — re-running them overwrites the previous version. Since all files are tracked in git, any mistake can be reverted with `git checkout -- <file>`.

If the SendGrid API key is invalid or the email service is unreachable, registration will fail. In tests, the email service should be mocked. In development, you can set `SENDGRID_API_KEY` to a test key and check the SendGrid activity dashboard, or temporarily replace the email service with a console logger.

If RS256 key generation is needed for local development, generate a key pair with:

    openssl genrsa -out private.pem 2048
    openssl rsa -in private.pem -pubout -out public.pem

Then set `JWT_PRIVATE_KEY` and `JWT_PUBLIC_KEY` to the contents of these files (with `\n` for newlines when setting as environment variables).


## Artifacts and Notes

Example of a successful registration and login flow (terminal transcript):

    $ curl -s -X POST http://localhost:3000/api/auth/register \
        -H "Content-Type: application/json" \
        -d '{"email": "test@example.com", "password": "Test1234"}' | jq .
    {
      "message": "Registration successful. Please check your email to verify your account."
    }

    $ curl -s http://localhost:3000/api/auth/verify/abc123-uuid-token | jq .
    {
      "message": "Email verified successfully."
    }

    $ curl -s -X POST http://localhost:3000/api/auth/login \
        -H "Content-Type: application/json" \
        -d '{"email": "test@example.com", "password": "Test1234"}' | jq .
    {
      "accessToken": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...",
      "refreshToken": "a3f8c2d1e4b5..."
    }

Example of RBAC enforcement:

    $ curl -s http://localhost:3000/api/admin/users \
        -H "Authorization: Bearer <member-token>" | jq .
    {
      "error": "Forbidden: insufficient role"
    }

    $ curl -s http://localhost:3000/api/admin/users \
        -H "Authorization: Bearer <admin-token>" | jq .
    [
      {
        "id": "uuid-1",
        "email": "admin@acme.com",
        "role": "ADMIN",
        "verified": true,
        "createdAt": "2026-03-10T00:00:00.000Z"
      }
    ]

Example of test output:

    $ npm test
    PASS src/__tests__/auth.test.ts
    PASS src/__tests__/users.test.ts
    PASS src/__tests__/admin.test.ts

    Test Suites: 3 passed, 3 total
    Tests:       25 passed, 25 total
    Snapshots:   0 total
    Time:        4.2 s


## Interfaces and Dependencies

### External Dependencies (npm packages)

- `express` ^4.x — HTTP framework. Already present in the project.
- `express-validator` ^7.x — Request body/param validation middleware for Express. Provides `body()`, `param()`, and `validationResult()` functions used in route handlers to validate input.
- `@prisma/client` ^5.x — Auto-generated database client. Already present (via Prisma). Used to query the User and RefreshToken tables.
- `prisma` ^5.x — CLI tool and schema engine. Already present. Used for migrations and code generation.
- `bcryptjs` ^2.x — Pure JavaScript bcrypt implementation. Provides `bcryptjs.hash(password, saltRounds)` and `bcryptjs.compare(password, hash)` for password hashing and verification.
- `jsonwebtoken` ^9.x — JWT signing and verification. Provides `jwt.sign(payload, key, options)` and `jwt.verify(token, key, options)`.
- `@sendgrid/mail` ^8.x — SendGrid email client. Provides `sgMail.setApiKey(key)` and `sgMail.send(msg)`.
- `jest` ^29.x — Test runner. Already present.
- `supertest` ^6.x — HTTP assertion library for testing Express apps. Already present.
- `@types/bcryptjs` — TypeScript type definitions for bcryptjs. Dev dependency.
- `@types/jsonwebtoken` — TypeScript type definitions for jsonwebtoken. Dev dependency.

### Key Interfaces and Type Signatures

After implementation, the following types and function signatures must exist:

`prisma/schema.prisma`:

    enum Role {
      ADMIN
      MEMBER
    }

    model User {
      id                String         @id @default(uuid())
      email             String         @unique
      password          String
      role              Role           @default(MEMBER)
      verified          Boolean        @default(false)
      verificationToken String?
      resetToken        String?
      resetTokenExpiry  DateTime?
      createdAt         DateTime       @default(now())
      updatedAt         DateTime       @updatedAt
      refreshTokens     RefreshToken[]
    }

    model RefreshToken {
      id        String   @id @default(uuid())
      tokenHash String
      userId    String
      user      User     @relation(fields: [userId], references: [id], onDelete: Cascade)
      expiresAt DateTime
      createdAt DateTime @default(now())
    }

`src/services/token.service.ts`:

    generateAccessToken(userId: string, role: string): string
    generateRefreshToken(userId: string): Promise<string>
    verifyAccessToken(token: string): { sub: string; role: string }
    verifyRefreshToken(rawToken: string): Promise<string>  // returns userId

`src/services/auth.service.ts`:

    register(email: string, password: string): Promise<void>
    verifyEmail(token: string): Promise<void>
    login(email: string, password: string): Promise<{ accessToken: string; refreshToken: string }>
    refreshToken(rawRefreshToken: string): Promise<{ accessToken: string }>
    forgotPassword(email: string): Promise<void>
    resetPassword(token: string, newPassword: string): Promise<void>

`src/services/email.service.ts`:

    sendVerificationEmail(to: string, token: string): Promise<void>
    sendPasswordResetEmail(to: string, token: string): Promise<void>

`src/middleware/auth.ts`:

    authMiddleware(req: Request, res: Response, next: NextFunction): void
    // Attaches req.user = { userId: string, role: string } on success

`src/middleware/rbac.ts`:

    requireRole(...roles: string[]): (req: Request, res: Response, next: NextFunction) => void

### API Endpoints Summary

| Method | Path | Auth | Roles | Description |
|--------|------|------|-------|-------------|
| POST | /api/auth/register | None | Any | Register new user |
| GET | /api/auth/verify/:token | None | Any | Verify email |
| POST | /api/auth/login | None | Any | Log in, get tokens |
| POST | /api/auth/refresh | None | Any | Refresh access token |
| POST | /api/auth/forgot-password | None | Any | Request password reset |
| POST | /api/auth/reset-password/:token | None | Any | Reset password |
| GET | /api/users/me | JWT | Any | Get own profile |
| PUT | /api/users/me | JWT | Any | Update own profile |
| GET | /api/admin/users | JWT | ADMIN | List all users |
| PUT | /api/admin/users/:id/role | JWT | ADMIN | Change user role |
