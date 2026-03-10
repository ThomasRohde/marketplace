# Add User Dashboard to React Web App

This ExecPlan is a living document. The sections `Progress`, `Surprises & Discoveries`, `Decision Log`, and `Outcomes & Retrospective` must be kept up to date as work proceeds.

## Purpose / Big Picture

After this change, authenticated users see a personalized dashboard when they log in, showing their recent activity, account summary, and quick-action buttons. To see it working, log in as a test user, navigate to `/dashboard`, and observe the activity feed loading with the user's recent actions and the account summary card displaying their current plan and usage stats.

## Progress

### Milestone 0: Scaffold Repository Structure and Guidance Files
- [ ] Create `README.md` with project overview, quick start, repo structure, and test instructions
- [ ] Create `PROJECT.md` with problem statement, goals, non-goals, constraints, and assumptions
- [ ] Create `ARCHITECTURE.md` with stack rationale, component map, data flows, and trade-offs
- [ ] Create `TESTING.md` with testing strategy, test pyramid, coverage expectations, and CI validation
- [ ] Create `CONTRIBUTING.md` with branch workflow, code style, commit conventions, and review checklist
- [ ] Create `CHANGELOG.md` with initial entry
- [ ] Create `DECISIONS/ADR-0001-initial-architecture.md` recording the foundational architecture decision
- [ ] Create `AGENTS.md` with project overview for coding agents, authoritative files, coding rules, invariants, validation instructions, and ambiguity handling
- [ ] Create `.github/copilot-instructions.md` with repo-wide implementation guidance
- [ ] Create `.github/instructions/backend.instructions.md` with Express/Prisma conventions
- [ ] Create `.github/instructions/frontend.instructions.md` with React/TypeScript conventions
- [ ] Create `.github/instructions/testing.instructions.md` with testing conventions
- [ ] Create `.github/PULL_REQUEST_TEMPLATE.md`
- [ ] Configure Prettier (`.prettierrc`) for consistent formatting
- [ ] Configure ESLint (`eslint.config.js`) for TypeScript and React linting
- [ ] Create `.editorconfig` for cross-editor consistency
- [ ] Review `.gitignore` and ensure it covers `node_modules/`, `dist/`, `.env`, and IDE files
- [ ] Create `.github/workflows/ci.yml` with lint, type-check, and test jobs
- [ ] Validate: all guidance files exist and are non-empty
- [ ] Validate: `npm run lint` runs without configuration errors
- [ ] Validate: CI workflow is syntactically valid (`actionlint` or manual review)

### Milestone 1: Dashboard Feature Implementation
- [ ] Create the Dashboard page component at `src/pages/Dashboard.tsx`
- [ ] Create the ActivityFeed component at `src/components/dashboard/ActivityFeed.tsx`
- [ ] Create the AccountSummary component at `src/components/dashboard/AccountSummary.tsx`
- [ ] Create the QuickActions component at `src/components/dashboard/QuickActions.tsx`
- [ ] Add the `/dashboard` route to `src/App.tsx` with auth guard
- [ ] Create API hooks in `src/hooks/useDashboardData.ts` using React Query
- [ ] Add backend endpoint `GET /api/dashboard` in `src/api/routes/dashboard.ts`
- [ ] Write component tests with React Testing Library
- [ ] Write API route tests with supertest
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

- Decision: CLI augmentation not applied — this is a web application, not a CLI tool.
  Rationale: The project is a React + Express.js web app with no command-line interface component. CLI manifest principles (structured envelope, error codes, exit codes, guide command) do not apply.
  Date/Author: 2026-03-10 / Plan Augmentation

- Decision: Add a full scaffolding milestone (Milestone 0) before feature work.
  Rationale: The original plan jumps directly to feature implementation without establishing the repository foundation. Adding README, ARCHITECTURE.md, AGENTS.md, testing strategy, CI workflows, linter/formatter configs, and PR templates makes the project navigable for both humans and future coding agents. Scaffolding goes first because feature code should land in a repo that already has quality infrastructure in place.
  Date/Author: 2026-03-10 / Plan Augmentation

- Decision: Include path-specific `.instructions.md` files for backend, frontend, and testing.
  Rationale: The project has distinct backend (Express/Prisma) and frontend (React/TypeScript) conventions. Path-specific agent guidance prevents coding agents from applying frontend patterns in backend code or vice versa.
  Date/Author: 2026-03-10 / Plan Augmentation

- Decision: Use Prettier for formatting and ESLint for linting.
  Rationale: These are the standard tools for TypeScript/React projects. The existing stack (React 18, TypeScript, React Router, React Query) aligns with the Prettier + ESLint ecosystem. No reason to deviate.
  Date/Author: 2026-03-10 / Plan Augmentation

## Outcomes & Retrospective

To be completed at major milestones and at plan completion.

## Context and Orientation

This plan targets an existing React + Express.js application. The frontend uses React 18 with TypeScript, React Router v6 for navigation, and React Query for server state management. The backend is Express.js with TypeScript, using Prisma as the ORM connected to PostgreSQL.

### Project Scaffolding Context

The plan now includes a scaffolding milestone (Milestone 0) that must be completed before feature work begins. The scaffolding establishes:

- **Foundation documents** — README.md, PROJECT.md, ARCHITECTURE.md, TESTING.md, CONTRIBUTING.md, CHANGELOG.md, and an initial architecture decision record. These make the project self-documenting and reduce onboarding friction.
- **Agent guidance files** — AGENTS.md and path-specific `.instructions.md` files under `.github/instructions/`. These give coding agents (Copilot, Claude, etc.) the context they need to generate correct code without human intervention. AGENTS.md is the single entry point an agent reads first.
- **Quality infrastructure** — Prettier for formatting, ESLint for linting, `.editorconfig` for cross-editor consistency, and a GitHub Actions CI workflow that runs lint, type-check, and test on every push and PR. This catches issues before they reach code review.
- **PR template** — A standardized pull request template that prompts contributors to describe their changes, link related issues, and confirm testing.

Relevant project structure:

    .github/
    ├── workflows/
    │   └── ci.yml                # CI pipeline: lint, type-check, test
    ├── instructions/
    │   ├── backend.instructions.md
    │   ├── frontend.instructions.md
    │   └── testing.instructions.md
    ├── copilot-instructions.md
    └── PULL_REQUEST_TEMPLATE.md
    AGENTS.md
    ARCHITECTURE.md
    CHANGELOG.md
    CONTRIBUTING.md
    DECISIONS/
    └── ADR-0001-initial-architecture.md
    PROJECT.md
    README.md
    TESTING.md
    src/
    ├── pages/              # Page-level React components (one per route)
    │   ├── Home.tsx
    │   ├── Dashboard.tsx   # New — added by this plan
    │   └── Profile.tsx
    ├── components/         # Reusable UI components
    │   ├── common/
    │   └── dashboard/      # New — added by this plan
    │       ├── ActivityFeed.tsx
    │       ├── AccountSummary.tsx
    │       └── QuickActions.tsx
    ├── hooks/              # Custom React hooks
    │   ├── useAuth.ts      # Authentication hook (already exists)
    │   └── useDashboardData.ts  # New — added by this plan
    ├── api/
    │   └── routes/         # Express route handlers
    │       ├── auth.ts
    │       ├── dashboard.ts  # New — added by this plan
    │       └── users.ts
    ├── App.tsx             # Root component with React Router setup
    └── tests/
        ├── components/
        └── api/

## Plan of Work

### Phase 1: Scaffolding (Milestone 0)

Establish the repository foundation before writing any feature code. Create all documentation files, agent guidance files, and quality infrastructure. This is a prerequisite for feature work — it ensures that every subsequent commit lands in a repo with linting, formatting, CI, and documentation already in place.

The scaffolding phase follows a specific order: foundation documents first (README, PROJECT, ARCHITECTURE), then agent guidance files (AGENTS.md, .instructions.md), then quality tooling (Prettier, ESLint, .editorconfig, CI), then the PR template. Each layer builds on the previous one.

### Phase 2: Feature Implementation (Milestone 1)

Create the backend endpoint that aggregates dashboard data — recent activity, account summary, and available quick actions — into a single JSON response. Then build the frontend components: a container Dashboard page that fetches data via React Query, and three presentational components for each dashboard section.

The Dashboard page will be protected by the existing `AuthGuard` wrapper, which redirects unauthenticated users to `/login`.

## Concrete Steps

### Milestone 0: Scaffold Repository Structure and Guidance Files

0.1. Create `README.md` at the project root with:
  - One-paragraph project description (React + Express dashboard application)
  - Quick start section: `npm install`, `npx prisma migrate dev`, `npm run dev`
  - Repository structure summary (matching the tree in Context and Orientation)
  - How to run tests: `npm test`
  - How to lint: `npm run lint`
  - How to format: `npm run format`
  - Link to CONTRIBUTING.md for contribution guidelines

0.2. Create `PROJECT.md` at the project root with:
  - Problem statement: authenticated users need a personalized landing page
  - Target users: authenticated application users
  - Goals: activity feed, account summary, quick actions
  - Non-goals: real-time updates (polling/WebSocket), admin dashboard, analytics
  - Constraints: single API call for all dashboard data, existing auth system
  - Assumptions: React Query is the data-fetching standard, Prisma manages all DB access
  - Success criteria: dashboard loads within 2 seconds, all tests pass, accessible markup

0.3. Create `ARCHITECTURE.md` at the project root with:
  - Stack: React 18 + TypeScript (frontend), Express.js + TypeScript (backend), Prisma + PostgreSQL (data)
  - Rationale: existing stack, no changes introduced by this plan
  - Component map: pages (route-level), components (reusable UI), hooks (data fetching), api/routes (Express handlers)
  - Data flow: Browser -> React Query hook -> GET /api/dashboard -> Express handler -> Prisma -> PostgreSQL -> JSON response -> React component tree
  - Trade-offs: single API call simplifies loading states but couples all dashboard data into one endpoint
  - Known unknowns: pagination strategy if activity feed grows large, caching policy for dashboard data

0.4. Create `TESTING.md` at the project root with:
  - Strategy: React Testing Library for component tests, supertest for API route tests
  - Test pyramid: unit tests for utility functions, integration tests for components with mocked API, integration tests for API routes with test database
  - Required commands: `npm test` runs all tests, `npm test -- --coverage` for coverage report
  - Coverage expectations: new code should have at least 80% line coverage
  - PR testing rule: every PR that adds or changes a component must include corresponding tests
  - Agent validation: before completing work, run `npm test` and confirm zero failures; run `npm run lint` and confirm zero errors

0.5. Create `CONTRIBUTING.md` at the project root with:
  - Branch workflow: create feature branches from `main`, open PR when ready, require at least one approval
  - Code style: Prettier for formatting (run `npm run format`), ESLint for linting (run `npm run lint`), TypeScript strict mode
  - Commit conventions: conventional commits (`feat:`, `fix:`, `docs:`, `test:`, `chore:`)
  - Review checklist: tests pass, no lint errors, no type errors, documentation updated if applicable, PR template filled out
  - Architectural changes: propose in a new ADR under `DECISIONS/` before implementation

0.6. Create `CHANGELOG.md` at the project root with an initial entry:
  ```
  # Changelog

  ## [Unreleased]

  ### Added
  - Project scaffolding: README, ARCHITECTURE, TESTING, CONTRIBUTING, AGENTS guidance files
  - CI workflow for lint, type-check, and test
  - Prettier and ESLint configuration
  ```

0.7. Create `DECISIONS/ADR-0001-initial-architecture.md` with:
  - Title: "Initial Architecture — React + Express + Prisma"
  - Status: Accepted
  - Context: building a user dashboard feature in an existing React + Express application
  - Decision: retain the existing stack (React 18, Express.js, Prisma, PostgreSQL, React Query, React Router v6) without introducing new frameworks or patterns
  - Consequences: consistency with existing code, lower onboarding cost, no migration risk; trade-off is that any limitations of the current stack persist

0.8. Create `AGENTS.md` at the project root with:
  - Project overview: React + Express.js web application with TypeScript, using Prisma for database access and React Query for server state
  - Where to look first: `src/App.tsx` for routing, `src/pages/` for page components, `src/api/routes/` for backend endpoints, `src/hooks/` for data fetching
  - Authoritative files: `ARCHITECTURE.md` for system design, `TESTING.md` for test strategy, `CONTRIBUTING.md` for code style
  - Coding rules:
    - All React components are functional components with TypeScript
    - All API routes return JSON
    - Use React Query hooks for data fetching, never `fetch()` directly in components
    - Use Prisma for all database queries, never raw SQL
    - All new files must have corresponding tests
  - Architectural invariants:
    - Protected routes use the `AuthGuard` wrapper
    - API routes are registered in `src/api/index.ts`
    - Page components live in `src/pages/`, reusable components in `src/components/`
  - How to validate: run `npm run lint`, `npm run typecheck`, and `npm test` — all must pass with zero errors
  - Ambiguity handling: if a requirement is unclear, leave a `TODO:` comment with a description of what is uncertain and what information is needed; do not guess at business logic
  - When to stop: if a change would require modifying the authentication system, the database schema beyond the `activity_log` and `users` tables, or the build configuration, stop and request human review

0.9. Create `.github/copilot-instructions.md` with:
  - Follow existing patterns before introducing new abstractions
  - Use TypeScript strict mode — no `any` types unless absolutely necessary
  - Naming conventions: PascalCase for components and types, camelCase for functions and variables, SCREAMING_SNAKE_CASE for constants
  - Every React component must be a named export (not default export) for better refactoring support
  - Prefer React Query's `useQuery` and `useMutation` over manual `useEffect` + `useState` for server state
  - Tests use React Testing Library — test behavior, not implementation details
  - Documentation: update README if adding new scripts or changing project structure

0.10. Create `.github/instructions/backend.instructions.md` with:
  - Express route handlers go in `src/api/routes/`
  - Register every new route in `src/api/index.ts`
  - Use Prisma client for all database access — import from the shared instance
  - Return JSON responses with appropriate HTTP status codes (200 for success, 400 for validation errors, 401 for unauthenticated, 403 for unauthorized, 500 for server errors)
  - Validate request inputs at the route handler level before calling Prisma
  - Route tests use supertest — see existing tests in `src/tests/api/` for patterns

0.11. Create `.github/instructions/frontend.instructions.md` with:
  - Page-level components go in `src/pages/`, one per route
  - Reusable UI components go in `src/components/`, grouped by feature (e.g., `src/components/dashboard/`)
  - Data-fetching hooks go in `src/hooks/`
  - Use React Query for all server state — create custom hooks that wrap `useQuery`/`useMutation`
  - Handle loading, error, and empty states in every component that fetches data
  - Use TypeScript interfaces for all props — define them in the same file as the component or in a shared types file
  - Protect authenticated routes with the `AuthGuard` wrapper in `src/App.tsx`

0.12. Create `.github/instructions/testing.instructions.md` with:
  - Component tests: use React Testing Library, render the component, interact with it, assert on visible output
  - API route tests: use supertest, make HTTP requests to the route, assert on status code and response body
  - Mock external dependencies (API calls in component tests, database in route tests) — never hit real services in tests
  - Test file naming: `ComponentName.test.tsx` for component tests, `routename.test.ts` for API tests
  - Test file location: `src/tests/components/` for component tests, `src/tests/api/` for API tests
  - Every test file should have at least: a happy-path test, an error-state test, and an edge-case test

0.13. Create `.github/PULL_REQUEST_TEMPLATE.md` with sections:
  - **What does this PR do?** (brief description)
  - **Related issue** (link to issue or "N/A")
  - **How to test** (steps for reviewer to verify)
  - **Checklist**: tests pass, no lint errors, no type errors, documentation updated if needed, screenshots for UI changes

0.14. Create or update `.prettierrc` at the project root:
  ```json
  {
    "semi": true,
    "singleQuote": true,
    "trailingComma": "all",
    "printWidth": 100,
    "tabWidth": 2
  }
  ```
  Add `format` and `format:check` scripts to `package.json`:
  - `"format": "prettier --write \"src/**/*.{ts,tsx,json,css}\""`
  - `"format:check": "prettier --check \"src/**/*.{ts,tsx,json,css}\""`

0.15. Create or update ESLint config (`eslint.config.js`) for TypeScript and React:
  - Extend `@typescript-eslint/recommended` and `plugin:react/recommended`
  - Enable `react-hooks/rules-of-hooks` and `react-hooks/exhaustive-deps`
  - Disallow `any` as a warning (not error) to avoid blocking on legacy code
  - Add `lint` script to `package.json`: `"lint": "eslint src/"`

0.16. Create `.editorconfig` at the project root:
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

0.17. Review `.gitignore` and ensure it includes at minimum:
  - `node_modules/`
  - `dist/`
  - `.env`
  - `.env.local`
  - `coverage/`
  - `.DS_Store`
  - `*.log`

0.18. Create `.github/workflows/ci.yml`:
  ```yaml
  name: CI
  on:
    push:
      branches: [main]
    pull_request:
      branches: [main]
  jobs:
    quality:
      runs-on: ubuntu-latest
      steps:
        - uses: actions/checkout@v4
        - uses: actions/setup-node@v4
          with:
            node-version: 20
            cache: npm
        - run: npm ci
        - run: npm run lint
        - run: npm run typecheck
        - run: npm test -- --coverage
        - run: npm run format:check
  ```
  Add `typecheck` script to `package.json` if not already present: `"typecheck": "tsc --noEmit"`

0.19. Validate the scaffolding milestone:
  - Verify all guidance files exist and are non-empty: README.md, PROJECT.md, ARCHITECTURE.md, TESTING.md, CONTRIBUTING.md, CHANGELOG.md, AGENTS.md, DECISIONS/ADR-0001-initial-architecture.md
  - Verify agent guidance files exist: `.github/copilot-instructions.md`, `.github/instructions/backend.instructions.md`, `.github/instructions/frontend.instructions.md`, `.github/instructions/testing.instructions.md`, `.github/PULL_REQUEST_TEMPLATE.md`
  - Run `npm run lint` — expect zero configuration errors (code warnings are acceptable at this stage)
  - Run `npm run format:check` — expect no formatting violations in new files
  - Review `.github/workflows/ci.yml` for syntactic correctness

### Milestone 1: Dashboard Feature Implementation

1. Create `src/api/routes/dashboard.ts` with a `GET /api/dashboard` handler that queries Prisma for the authenticated user's recent activity (last 10 actions from the `activity_log` table), account info (from the `users` table), and returns them as JSON.

2. Register the route in `src/api/index.ts`.

3. Create `src/hooks/useDashboardData.ts` with a React Query hook that calls `GET /api/dashboard`.

4. Create `src/components/dashboard/ActivityFeed.tsx` — renders a list of recent activity items with timestamps.

5. Create `src/components/dashboard/AccountSummary.tsx` — renders the user's plan name, usage percentage, and renewal date.

6. Create `src/components/dashboard/QuickActions.tsx` — renders action buttons (Create Project, Invite Team Member, View Reports).

7. Create `src/pages/Dashboard.tsx` — composes the three components, handles loading/error states.

8. Add route to `src/App.tsx`:

       <Route path="/dashboard" element={<AuthGuard><Dashboard /></AuthGuard>} />

9. Write tests and run:

       npm test

   Expected: all tests pass.

## Validation and Acceptance

After scaffolding (Milestone 0):
- All documentation and guidance files exist and contain meaningful content (not just headers)
- `npm run lint` runs without configuration errors
- `npm run format:check` passes on all new files
- `.github/workflows/ci.yml` is syntactically valid
- The README contains a working quick-start section with correct commands

After feature implementation (Milestone 1):
- Navigate to `http://localhost:3000/dashboard` while authenticated
- Expected: see the activity feed with recent items, account summary card, and quick action buttons
- Navigate to `/dashboard` while not authenticated
- Expected: redirect to `/login`
- Run `npm test` — all tests pass including new dashboard tests
- Run `npm run lint` — no errors in new code
- Run `npm run format:check` — no formatting violations

## Idempotence and Recovery

All steps are additive — creating new files and adding a new route. Re-running any step overwrites the file with the same content.

For the scaffolding milestone, all file creations are idempotent. If a file already exists with different content, the implementing agent should compare against the existing content and only add what is missing rather than overwriting. Configuration files (`.prettierrc`, `.editorconfig`, ESLint config) should be created only if they do not already exist; if they exist, the agent should verify they meet the minimum requirements documented in the steps and augment if needed.

## Artifacts and Notes

### Placeholder Pattern

For any scaffolding file where the plan does not specify enough detail, the implementing agent should use this pattern:

```
TODO: <what is missing>
Why it matters: <one sentence>
How to fill this in: <one or two concrete instructions>
Example: <optional short example>
```

This ensures that incomplete sections are explicitly flagged and actionable, rather than silently omitted or filled with speculative content.

## Interfaces and Dependencies

- **react-query** (^5.x) — Data fetching (already installed)
- **prisma** (^5.x) — ORM (already installed)
- **react-router-dom** (^6.x) — Routing (already installed)
- **prettier** (^3.x) — Code formatting (install as devDependency if not present)
- **eslint** (^9.x) — Linting (install as devDependency if not present)
- **@typescript-eslint/parser** + **@typescript-eslint/eslint-plugin** — TypeScript ESLint support (install as devDependencies if not present)
- **eslint-plugin-react** + **eslint-plugin-react-hooks** — React linting rules (install as devDependencies if not present)

Key types:
- `DashboardData { activity: ActivityItem[]; account: AccountSummary; quickActions: QuickAction[] }`
- `ActivityItem { id: string; action: string; target: string; timestamp: string }`
- `AccountSummary { plan: string; usagePercent: number; renewalDate: string }`
