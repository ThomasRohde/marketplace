# Add User Dashboard to React Web App

This ExecPlan is a living document. The sections `Progress`, `Surprises & Discoveries`, `Decision Log`, and `Outcomes & Retrospective` must be kept up to date as work proceeds.

## Purpose / Big Picture

After this change, authenticated users see a personalized dashboard when they log in, showing their recent activity, account summary, and quick-action buttons. To see it working, log in as a test user, navigate to `/dashboard`, and observe the activity feed loading with the user's recent actions and the account summary card displaying their current plan and usage stats.

## Progress

### Milestone 0 — Scaffold Repository Structure and Guidance Files
- [ ] Create `README.md` with project overview, quick start, repo structure, and test instructions
- [ ] Create `PROJECT.md` with problem statement, goals, non-goals, constraints, and assumptions
- [ ] Create `ARCHITECTURE.md` with stack rationale, component map, data flows, and trade-offs
- [ ] Create `TESTING.md` with test strategy, test pyramid, coverage expectations, and CI validation
- [ ] Create `CONTRIBUTING.md` with branch workflow, code style, commit conventions, and review checklist
- [ ] Create `CHANGELOG.md` with initial entry
- [ ] Create `DECISIONS/ADR-0001-initial-architecture.md` recording the React + Express + Prisma + PostgreSQL stack decision
- [ ] Create `AGENTS.md` with project overview for agents, authoritative files, coding rules, invariants, and validation instructions
- [ ] Create `.github/instructions/frontend.instructions.md` with React/TypeScript conventions
- [ ] Create `.github/instructions/backend.instructions.md` with Express/Prisma conventions
- [ ] Create `.github/instructions/testing.instructions.md` with React Testing Library and supertest conventions
- [ ] Add `.editorconfig` with consistent indentation and line-ending settings
- [ ] Verify `.gitignore` covers `node_modules/`, `dist/`, `.env`, and Prisma artifacts
- [ ] Add or verify Prettier config (`.prettierrc`) for consistent formatting
- [ ] Add or verify ESLint config (`.eslintrc` or `eslint.config.js`) with TypeScript and React plugins
- [ ] Create `.github/workflows/ci.yml` with lint, type-check, and test steps
- [ ] Validate: all guidance files exist and are non-empty
- [ ] Validate: `npm run lint` runs without configuration errors
- [ ] Validate: CI workflow is syntactically valid YAML

### Milestone 1 — Backend Dashboard Endpoint
- [ ] Create `src/api/routes/dashboard.ts` with `GET /api/dashboard` handler
- [ ] Register the route in `src/api/index.ts`
- [ ] Write API route tests with supertest

### Milestone 2 — Frontend Dashboard Components and Integration
- [ ] Create `src/hooks/useDashboardData.ts` using React Query
- [ ] Create `src/components/dashboard/ActivityFeed.tsx`
- [ ] Create `src/components/dashboard/AccountSummary.tsx`
- [ ] Create `src/components/dashboard/QuickActions.tsx`
- [ ] Create `src/pages/Dashboard.tsx`
- [ ] Add the `/dashboard` route to `src/App.tsx` with auth guard
- [ ] Write component tests with React Testing Library
- [ ] Run full test suite and verify all pass

## Surprises & Discoveries

No discoveries yet — this section will be populated during implementation.

## Decision Log

- Decision: Use React Query for data fetching on the dashboard.
  Rationale: The app already uses React Query for other data fetching. Consistency matters more than switching to SWR or a custom solution.
  Date/Author: 2026-03-10 / Plan Author

- Decision: The dashboard loads all data in a single API call rather than multiple parallel requests.
  Rationale: Simplifies loading states and error handling. The data volume is small enough that a single round-trip is acceptable.
  Date/Author: 2026-03-10 / Plan Author

- Decision: Skip CLI augmentation entirely.
  Rationale: This project is a React + Express.js web application, not a CLI tool. No command-line interface is exposed to users or agents. The CLI manifest does not apply.
  Date/Author: 2026-03-10 / Augment Plan

- Decision: Add a full scaffolding milestone (Milestone 0) before feature work.
  Rationale: The original plan has no scaffolding steps — no README, no ARCHITECTURE.md, no AGENTS.md, no linter/formatter config, and no CI workflow. Without these, the repo is difficult to navigate for both humans and coding agents. Scaffolding before feature work ensures the foundation is in place when implementation begins.
  Date/Author: 2026-03-10 / Augment Plan

- Decision: Include `AGENTS.md` and path-specific `.instructions.md` files for frontend, backend, and testing.
  Rationale: The project has distinct frontend (React/TypeScript) and backend (Express/Prisma) conventions. Path-specific agent guidance ensures coding agents follow the right patterns in each area without polluting one domain with the other's rules.
  Date/Author: 2026-03-10 / Augment Plan

- Decision: Use Prettier for formatting and ESLint with TypeScript and React plugins for linting.
  Rationale: The project uses TypeScript across both frontend and backend. Prettier + ESLint is the standard pairing for TypeScript/React projects and integrates well with the existing stack.
  Date/Author: 2026-03-10 / Augment Plan

## Outcomes & Retrospective

To be completed at major milestones and at plan completion.

## Context and Orientation

This plan targets an existing React + Express.js application. The frontend uses React 18 with TypeScript, React Router v6 for navigation, and React Query for server state management. The backend is Express.js with TypeScript, using Prisma as the ORM connected to PostgreSQL.

Relevant project structure:

    src/
    ├── pages/              # Page-level React components (one per route)
    │   ├── Home.tsx
    │   └── Profile.tsx
    ├── components/         # Reusable UI components
    │   └── common/
    ├── hooks/              # Custom React hooks
    │   └── useAuth.ts      # Authentication hook (already exists)
    ├── api/
    │   └── routes/         # Express route handlers
    │       ├── auth.ts
    │       └── users.ts
    ├── App.tsx             # Root component with React Router setup
    └── tests/
        ├── components/
        └── api/

### Scaffolding Files

Milestone 0 adds the following project guidance and quality infrastructure files. These are not application code — they establish the repository foundation that makes the project navigable for humans and coding agents alike.

- **`README.md`** — What the project is, quick start instructions, repo structure overview, how to run tests, and how to contribute. This is the entry point for any new contributor or agent.
- **`PROJECT.md`** — Problem statement, target users, goals, non-goals, scope boundaries, constraints, and assumptions. Captures the "why" behind the project so implementation decisions can be evaluated against intent.
- **`ARCHITECTURE.md`** — Stack rationale (React 18 + Express + Prisma + PostgreSQL), component map, data flow between frontend and backend, and trade-offs. Labels inferred choices as provisional where the PRD does not specify.
- **`TESTING.md`** — Test strategy (unit tests with React Testing Library for components, supertest for API routes), test pyramid, coverage expectations, and CI validation steps. Defines what must be tested for each PR.
- **`CONTRIBUTING.md`** — Branch and PR workflow, code style expectations (enforced by Prettier and ESLint), commit message conventions, and review checklist.
- **`CHANGELOG.md`** — Initial entry documenting the project's starting state.
- **`DECISIONS/ADR-0001-initial-architecture.md`** — Records the foundational architecture decision: why React 18, Express, Prisma, and PostgreSQL were chosen, what remains provisional, and the criteria for revisiting.
- **`AGENTS.md`** — Project overview in agent-friendly terms, authoritative files, coding rules, architectural invariants (e.g., all data fetching through React Query, all routes behind `AuthGuard`), validation commands (`npm test`, `npm run lint`), and instructions for when to stop and leave a `TODO` instead of guessing.
- **Path-specific `.instructions.md` files** — Separate guidance for frontend (React component patterns, hook conventions, TypeScript strictness), backend (Express route structure, Prisma query patterns, error handling), and testing (React Testing Library queries, supertest patterns, what to assert).
- **`.editorconfig`** — Consistent indentation (2 spaces for TypeScript/JSON), line endings, and trailing whitespace rules.
- **`.prettierrc`** — Formatting rules: single quotes, trailing commas, print width, consistent with existing code style.
- **ESLint config** — TypeScript parser, React plugin, React Hooks plugin, import ordering. Extends recommended configs for TypeScript and React.
- **`.github/workflows/ci.yml`** — GitHub Actions workflow that runs on push and PR: install dependencies, lint (`eslint`), type-check (`tsc --noEmit`), run tests (`npm test`), and report results.

### Placeholder Pattern

For any guidance file where the PRD or existing codebase does not provide enough information to fill a section completely, use this pattern:

```
TODO: <what is missing>
Why it matters: <one sentence>
How to fill this in: <one or two concrete instructions>
Example: <optional short example>
```

This keeps the files useful immediately while making gaps visible and actionable.

## Plan of Work

**Milestone 0 — Scaffold Repository Structure and Guidance Files.** Before writing any feature code, establish the repo foundation: guidance documents (README, ARCHITECTURE, AGENTS, etc.), quality tooling (Prettier, ESLint, editorconfig), and CI. This milestone produces no application behavior but ensures every subsequent milestone is built on a navigable, lint-clean, continuously-tested base.

**Milestone 1 — Backend Dashboard Endpoint.** Create the backend endpoint that aggregates dashboard data — recent activity, account summary, and available quick actions — into a single JSON response. Write API route tests with supertest.

**Milestone 2 — Frontend Dashboard Components and Integration.** Build the frontend components: a container Dashboard page that fetches data via React Query, and three presentational components for each dashboard section. Add the route with auth guard. Write component tests. Run the full suite.

The Dashboard page will be protected by the existing `AuthGuard` wrapper, which redirects unauthenticated users to `/login`.

## Concrete Steps

### Milestone 0 — Scaffold Repository Structure and Guidance Files

0.1. Create `README.md` at the repo root. Include:
   - Project name and one-line description
   - Current status (in development)
   - Quick start: `npm install`, `npx prisma migrate dev`, `npm run dev`
   - Repo structure summary (reference the tree in Context and Orientation)
   - How to run tests: `npm test`
   - How to lint: `npm run lint`
   - How to contribute: link to `CONTRIBUTING.md`

   If any quick-start details are uncertain (e.g., exact database setup), use the placeholder pattern.

0.2. Create `PROJECT.md` at the repo root. Include:
   - Problem statement: authenticated users need a personalized landing page after login
   - Target users: registered users of the web application
   - Goals: display recent activity, account summary, quick actions
   - Non-goals: real-time updates, dashboard customization, admin analytics
   - Constraints: must use existing React Query and Prisma stack
   - Assumptions: `activity_log` table exists with the required schema

   Use `TODO:` markers for any scope boundaries not covered by the plan.

0.3. Create `ARCHITECTURE.md` at the repo root. Include:
   - Stack: React 18 + TypeScript (frontend), Express.js + TypeScript (backend), Prisma + PostgreSQL (data)
   - Rationale: these are the existing project choices; consistency is the priority
   - Component map: pages -> components -> hooks -> API routes -> Prisma models
   - Data flow for the dashboard: `Dashboard.tsx` -> `useDashboardData` hook -> `GET /api/dashboard` -> Prisma query -> PostgreSQL
   - Trade-offs: single API call simplifies loading states but couples the three data sections
   - Label all choices as "established" (not provisional) since this is an existing project

0.4. Create `TESTING.md` at the repo root. Include:
   - Strategy: unit tests for components (React Testing Library), integration tests for API routes (supertest), no E2E in this plan
   - Test commands: `npm test`, `npm test -- --coverage`
   - Coverage expectation: all new components and routes must have tests
   - What to test per PR: every new component gets render tests and interaction tests; every new route gets request/response tests
   - Agent validation: run `npm test` before considering any milestone complete

0.5. Create `CONTRIBUTING.md` at the repo root. Include:
   - Branch from `main`, use feature branches named `feat/<description>`
   - Code style: enforced by Prettier and ESLint — run `npm run lint` before committing
   - Commit messages: imperative mood, reference issue numbers where applicable
   - Review checklist: tests pass, lint passes, types check, no `any` types unless justified
   - Architectural changes: propose in a new ADR in `DECISIONS/` before implementing

0.6. Create `CHANGELOG.md` with an initial entry:
   ```
   # Changelog

   ## [Unreleased]
   - Add user dashboard with activity feed, account summary, and quick actions
   ```

0.7. Create `DECISIONS/ADR-0001-initial-architecture.md`. Record:
   - Title: Initial Architecture — React + Express + Prisma + PostgreSQL
   - Status: Accepted
   - Context: the project was started with this stack; the dashboard feature continues within it
   - Decision: use the existing stack without introducing new frameworks or libraries
   - Consequences: constrained to React Query for data fetching, Prisma for ORM, Express for routing

0.8. Create `AGENTS.md` at the repo root. Include:
   - Project overview: a React + Express web app with Prisma/PostgreSQL; currently adding a user dashboard
   - Where to look first: `src/App.tsx` for routes, `src/api/routes/` for backend endpoints, `src/hooks/` for data fetching
   - Authoritative files: `ARCHITECTURE.md` for stack decisions, `TESTING.md` for test expectations
   - Coding rules:
     - All data fetching through React Query hooks in `src/hooks/`
     - All routes wrapped in `AuthGuard` if they require authentication
     - No `any` types — use explicit TypeScript interfaces
     - Components in `src/components/` are presentational; page-level logic lives in `src/pages/`
   - Architectural invariants:
     - Single API call per page for initial data load
     - Prisma is the only database access layer
     - React Router v6 is the only routing mechanism
   - Validation: run `npm test` and `npm run lint` — both must pass with zero errors
   - When to stop: if a Prisma schema change is needed that is not described in the plan, leave a `TODO` and stop

0.9. Create `.github/instructions/frontend.instructions.md`. Include:
   - Use functional components with TypeScript (`React.FC` or plain function with typed props)
   - Use React Query's `useQuery` for all data fetching — never `fetch` directly in components
   - Place shared types in a `types/` directory or co-locate with the module that defines them
   - Use `React.Suspense` boundaries where appropriate for loading states
   - Follow existing component naming: PascalCase files matching the default export name

0.10. Create `.github/instructions/backend.instructions.md`. Include:
   - Express route handlers go in `src/api/routes/`, one file per resource
   - Register routes in `src/api/index.ts`
   - Use Prisma Client for all database access — never raw SQL
   - Return JSON responses with consistent shape: `{ data: T }` on success, `{ error: string }` on failure
   - Authenticate requests using the existing auth middleware before accessing user-specific data

0.11. Create `.github/instructions/testing.instructions.md`. Include:
   - Component tests use React Testing Library — query by role, label, or text, not by class or test ID unless necessary
   - API tests use supertest against the Express app instance
   - Each test file lives alongside its source file in the `tests/` mirror directory (e.g., `tests/components/dashboard/ActivityFeed.test.tsx`)
   - Mock Prisma Client in API tests using a shared mock setup
   - Assert on visible behavior and API response shape, not internal implementation details

0.12. Add `.editorconfig` at the repo root:
   ```ini
   root = true

   [*]
   indent_style = space
   indent_size = 2
   end_of_line = lf
   charset = utf-8
   trim_trailing_whitespace = true
   insert_final_newline = true

   [*.md]
   trim_trailing_whitespace = false
   ```

0.13. Verify `.gitignore` includes at minimum: `node_modules/`, `dist/`, `.env`, `.env.local`, `prisma/*.db`, `coverage/`. If it exists, check for gaps. If it does not exist, create it.

0.14. Add or verify `.prettierrc` at the repo root:
   ```json
   {
     "semi": true,
     "singleQuote": true,
     "trailingComma": "all",
     "printWidth": 100,
     "tabWidth": 2
   }
   ```
   Match existing code style if it differs from these defaults.

0.15. Add or verify ESLint config. Use `eslint.config.js` (flat config) or `.eslintrc.json` depending on what the project already uses. Ensure it includes:
   - `@typescript-eslint/parser`
   - `@typescript-eslint/eslint-plugin`
   - `eslint-plugin-react`
   - `eslint-plugin-react-hooks`
   - Extends: `eslint:recommended`, `plugin:@typescript-eslint/recommended`, `plugin:react/recommended`, `plugin:react-hooks/recommended`

   Add a `lint` script to `package.json` if not already present: `"lint": "eslint src/ --ext .ts,.tsx"`

0.16. Create `.github/workflows/ci.yml`:
   ```yaml
   name: CI
   on:
     push:
       branches: [main]
     pull_request:
       branches: [main]
   jobs:
     build-and-test:
       runs-on: ubuntu-latest
       steps:
         - uses: actions/checkout@v4
         - uses: actions/setup-node@v4
           with:
             node-version: 20
             cache: npm
         - run: npm ci
         - run: npm run lint
         - run: npx tsc --noEmit
         - run: npm test -- --coverage
   ```

0.17. Validate the scaffolding milestone:
   - Confirm all guidance files (`README.md`, `PROJECT.md`, `ARCHITECTURE.md`, `TESTING.md`, `CONTRIBUTING.md`, `CHANGELOG.md`, `AGENTS.md`) exist and are non-empty
   - Confirm `DECISIONS/ADR-0001-initial-architecture.md` exists and is non-empty
   - Confirm `.editorconfig`, `.prettierrc`, and ESLint config exist
   - Confirm `.github/workflows/ci.yml` exists and is valid YAML
   - Run `npm run lint` and confirm it executes without configuration errors (code warnings are acceptable at this stage)
   - Run `npx tsc --noEmit` and confirm it completes

### Milestone 1 — Backend Dashboard Endpoint

1.1. Create `src/api/routes/dashboard.ts` with a `GET /api/dashboard` handler that queries Prisma for the authenticated user's recent activity (last 10 actions from the `activity_log` table), account info (from the `users` table), and returns them as JSON.

1.2. Register the route in `src/api/index.ts`.

1.3. Write API route tests in `src/tests/api/dashboard.test.ts` using supertest. Test:
   - Authenticated request returns 200 with the expected `DashboardData` shape
   - Unauthenticated request returns 401
   - Response includes `activity`, `account`, and `quickActions` fields

### Milestone 2 — Frontend Dashboard Components and Integration

2.1. Create `src/hooks/useDashboardData.ts` with a React Query hook that calls `GET /api/dashboard`.

2.2. Create `src/components/dashboard/ActivityFeed.tsx` — renders a list of recent activity items with timestamps.

2.3. Create `src/components/dashboard/AccountSummary.tsx` — renders the user's plan name, usage percentage, and renewal date.

2.4. Create `src/components/dashboard/QuickActions.tsx` — renders action buttons (Create Project, Invite Team Member, View Reports).

2.5. Create `src/pages/Dashboard.tsx` — composes the three components, handles loading/error states.

2.6. Add route to `src/App.tsx`:

       <Route path="/dashboard" element={<AuthGuard><Dashboard /></AuthGuard>} />

2.7. Write component tests in `src/tests/components/dashboard/`:
   - `ActivityFeed.test.tsx` — renders activity items, displays timestamps
   - `AccountSummary.test.tsx` — renders plan name, usage bar, renewal date
   - `QuickActions.test.tsx` — renders action buttons, fires click handlers
   - `Dashboard.test.tsx` — renders loading state, renders error state, renders composed dashboard with data

2.8. Run full test suite:

       npm test

   Expected: all tests pass including new dashboard tests.

## Validation and Acceptance

After implementation:
- Navigate to `http://localhost:3000/dashboard` while authenticated
- Expected: see the activity feed with recent items, account summary card, and quick action buttons
- Navigate to `/dashboard` while not authenticated
- Expected: redirect to `/login`
- Run `npm test` — all tests pass including new dashboard tests
- Run `npm run lint` — no lint errors
- Run `npx tsc --noEmit` — no type errors
- Confirm all scaffolding guidance files exist and are non-empty

## Idempotence and Recovery

All steps are additive — creating new files and adding a new route. Re-running any step overwrites the file with the same content. Scaffolding files (Milestone 0) are standalone and do not depend on feature code, so they can be created or regenerated independently.

## Artifacts and Notes

None yet.

## Interfaces and Dependencies

- **react-query** (^5.x) — Data fetching (already installed)
- **prisma** (^5.x) — ORM (already installed)
- **react-router-dom** (^6.x) — Routing (already installed)
- **eslint** — Linting (verify installed, add TypeScript and React plugins if missing)
- **prettier** — Formatting (verify installed)
- **@typescript-eslint/parser** + **@typescript-eslint/eslint-plugin** — TypeScript linting
- **eslint-plugin-react** + **eslint-plugin-react-hooks** — React linting

Key types:
- `DashboardData { activity: ActivityItem[]; account: AccountSummary; quickActions: QuickAction[] }`
- `ActivityItem { id: string; action: string; target: string; timestamp: string }`
- `AccountSummary { plan: string; usagePercent: number; renewalDate: string }`
