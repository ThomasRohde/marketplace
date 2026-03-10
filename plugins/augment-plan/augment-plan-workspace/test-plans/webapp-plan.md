# Add User Dashboard to React Web App

This ExecPlan is a living document. The sections `Progress`, `Surprises & Discoveries`, `Decision Log`, and `Outcomes & Retrospective` must be kept up to date as work proceeds.

## Purpose / Big Picture

After this change, authenticated users see a personalized dashboard when they log in, showing their recent activity, account summary, and quick-action buttons. To see it working, log in as a test user, navigate to `/dashboard`, and observe the activity feed loading with the user's recent actions and the account summary card displaying their current plan and usage stats.

## Progress

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

## Plan of Work

First, create the backend endpoint that aggregates dashboard data — recent activity, account summary, and available quick actions — into a single JSON response. Then build the frontend components: a container Dashboard page that fetches data via React Query, and three presentational components for each dashboard section.

The Dashboard page will be protected by the existing `AuthGuard` wrapper, which redirects unauthenticated users to `/login`.

## Concrete Steps

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

After implementation:
- Navigate to `http://localhost:3000/dashboard` while authenticated
- Expected: see the activity feed with recent items, account summary card, and quick action buttons
- Navigate to `/dashboard` while not authenticated
- Expected: redirect to `/login`
- Run `npm test` — all tests pass including new dashboard tests

## Idempotence and Recovery

All steps are additive — creating new files and adding a new route. Re-running any step overwrites the file with the same content.

## Artifacts and Notes

None yet.

## Interfaces and Dependencies

- **react-query** (^5.x) — Data fetching (already installed)
- **prisma** (^5.x) — ORM (already installed)
- **react-router-dom** (^6.x) — Routing (already installed)

Key types:
- `DashboardData { activity: ActivityItem[]; account: AccountSummary; quickActions: QuickAction[] }`
- `ActivityItem { id: string; action: string; target: string; timestamp: string }`
- `AccountSummary { plan: string; usagePercent: number; renewalDate: string }`
