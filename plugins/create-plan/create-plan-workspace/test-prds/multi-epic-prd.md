# PRD: User Authentication System

## Document Control

| Field | Value |
|-------|-------|
| Title | User Authentication System |
| Owner | Alex Chen |
| Repository | github.com/acme/saas-platform |
| Classification | Confidential |

## Executive Summary

Add a complete user authentication system to the SaaS platform, including registration, login with JWT tokens, password reset via email, and role-based access control. This replaces the current hardcoded API key approach and enables multi-tenant user management.

## Problem Statement

The platform currently uses a single shared API key for all access. This means there is no user identity, no audit trail, and no way to restrict access by role. Customer contracts now require per-user authentication and admin/member role separation. Without this, the Q3 enterprise deals cannot close.

## Scope

### In Scope
- User registration with email verification
- Login returning JWT access and refresh tokens
- Password reset flow via email
- Role-based access control (admin, member)
- User profile management

### Out of Scope
- OAuth/SSO integration (Phase 2)
- Two-factor authentication (Phase 2)
- User analytics dashboard

### Non-Goals
- Do not remove the API key system yet — it must coexist during migration
- Do not build a custom email service; use SendGrid

## Personas and Scenarios

**New User**: Given they visit the registration page, when they submit valid email and password, then they receive a verification email and can log in after clicking the verification link.

**Existing Member**: Given they are logged in, when their JWT expires, then the client uses the refresh token to obtain a new access token without re-entering credentials.

**Admin**: Given they are logged in as admin, when they view the user management page, then they can see all users and change roles.

## Functional Requirements

| ID | Requirement | Priority | Acceptance Criteria |
|----|------------|----------|-------------------|
| FR-1 | User registration | Must | POST /api/auth/register creates user, sends verification email |
| FR-2 | Email verification | Must | GET /api/auth/verify/:token activates user account |
| FR-3 | Login with JWT | Must | POST /api/auth/login returns access token (15m) and refresh token (7d) |
| FR-4 | Token refresh | Must | POST /api/auth/refresh returns new access token |
| FR-5 | Password reset request | Must | POST /api/auth/forgot-password sends reset email |
| FR-6 | Password reset execution | Must | POST /api/auth/reset-password/:token updates password |
| FR-7 | Role-based middleware | Must | Endpoints can require specific roles; returns 403 if insufficient |
| FR-8 | User profile CRUD | Should | GET/PUT /api/users/me for profile management |
| FR-9 | Admin user listing | Should | GET /api/admin/users lists all users (admin only) |
| FR-10 | Admin role assignment | Should | PUT /api/admin/users/:id/role changes user role (admin only) |

## Non-Functional Requirements

- **Performance**: Auth endpoints respond within 200ms p95
- **Security**: Passwords hashed with bcrypt (cost 12), JWTs signed with RS256, refresh tokens stored hashed in DB
- **Resilience**: Rate limiting on auth endpoints (10 req/min per IP)

## Tech Stack

- **Language**: TypeScript 5.x
- **Runtime**: Node.js 20
- **Framework**: Express.js 4.x with express-validator
- **Database**: PostgreSQL 15 via Prisma ORM
- **Auth**: jsonwebtoken, bcryptjs
- **Email**: @sendgrid/mail
- **Test framework**: Jest with supertest
- **Package manager**: npm

## Architecture

```
src/
├── app.ts
├── config/
│   └── env.ts
├── middleware/
│   ├── auth.ts           # JWT verification middleware
│   └── rbac.ts           # Role-based access control
├── routes/
│   ├── auth.ts           # Registration, login, password reset
│   ├── users.ts          # Profile management
│   └── admin.ts          # Admin endpoints
├── services/
│   ├── auth.service.ts   # Business logic for auth
│   ├── email.service.ts  # SendGrid integration
│   └── token.service.ts  # JWT creation/verification
├── prisma/
│   └── schema.prisma     # User model, refresh tokens
└── __tests__/
    ├── auth.test.ts
    ├── users.test.ts
    └── admin.test.ts
```

## Build / Run / Validate

```bash
npm install
npx prisma generate
npx prisma migrate dev
npm run dev          # starts on port 3000
npm run lint
npm test
npm run build
```

**Environment variables required**:
- `DATABASE_URL` — PostgreSQL connection string
- `JWT_PRIVATE_KEY` — RS256 private key (PEM)
- `JWT_PUBLIC_KEY` — RS256 public key (PEM)
- `SENDGRID_API_KEY` — SendGrid API key
- `APP_URL` — Base URL for verification/reset links

## Security

- Passwords: bcrypt with cost factor 12
- JWTs: RS256, access token 15 min, refresh token 7 days
- Refresh tokens: stored as SHA-256 hash in database
- Rate limiting: 10 requests/minute per IP on auth endpoints
- No secrets in logs or error responses

## Phase Plan

- [ ] E1: Database schema and user model — Set up Prisma schema with User and RefreshToken models
- [ ] E2: Registration and email verification — Implement signup flow with SendGrid verification
- [ ] E3: Login and JWT token management — Implement login, token refresh, and auth middleware
- [ ] E4: Password reset flow — Implement forgot/reset password with email tokens
- [ ] E5: Role-based access control — Add RBAC middleware and admin endpoints

## Epic Cards

### E1: Database Schema and User Model

**Objective**: Create the data layer for users and refresh tokens.

**Acceptance Criteria**:
- [ ] Prisma schema includes User model (id, email, password, role, verified, timestamps)
- [ ] Prisma schema includes RefreshToken model (id, token_hash, user_id, expires_at)
- [ ] Migration runs successfully
- [ ] Seed script creates one admin user

**Validation**: `npx prisma migrate dev && npx prisma db seed`

### E2: Registration and Email Verification

**Objective**: Allow new users to register and verify their email.

**Acceptance Criteria**:
- [ ] POST /api/auth/register validates input, hashes password, creates unverified user
- [ ] Verification email sent via SendGrid with unique token
- [ ] GET /api/auth/verify/:token sets user.verified = true
- [ ] Duplicate email returns 409
- [ ] Tests cover success, duplicate, and invalid token cases

**Validation**: `npm test -- --testPathPattern=auth`

### E3: Login and JWT Token Management

**Objective**: Authenticate users and manage JWT lifecycle.

**Acceptance Criteria**:
- [ ] POST /api/auth/login returns access + refresh tokens for verified users
- [ ] Unverified users get 403
- [ ] Invalid credentials get 401
- [ ] POST /api/auth/refresh issues new access token
- [ ] Auth middleware protects routes, returns 401 for invalid/expired tokens
- [ ] Tests cover all scenarios

**Validation**: `npm test -- --testPathPattern=auth`

### E4: Password Reset Flow

**Objective**: Allow users to reset forgotten passwords securely.

**Acceptance Criteria**:
- [ ] POST /api/auth/forgot-password sends reset email (always returns 200 to prevent enumeration)
- [ ] POST /api/auth/reset-password/:token validates token and updates password
- [ ] Reset tokens expire after 1 hour
- [ ] Tests cover success, expired token, and invalid token

**Validation**: `npm test -- --testPathPattern=auth`

### E5: Role-Based Access Control

**Objective**: Restrict endpoints by user role.

**Acceptance Criteria**:
- [ ] RBAC middleware checks user.role against required roles
- [ ] GET /api/admin/users returns user list (admin only)
- [ ] PUT /api/admin/users/:id/role changes role (admin only)
- [ ] Member accessing admin endpoint gets 403
- [ ] GET/PUT /api/users/me works for any authenticated user
- [ ] Tests cover role enforcement

**Validation**: `npm test`

## Open Questions

1. Should we support multiple sessions per user or single-session only?
2. What is the password complexity policy?

## Definition of Done

- [ ] All acceptance criteria met across all epics
- [ ] All tests pass
- [ ] No lint errors
- [ ] Security review completed
- [ ] API documentation updated
