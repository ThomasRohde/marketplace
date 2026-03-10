# Add Real-Time Notifications to the Dashboard

This ExecPlan is a living document. The sections Progress, Surprises & Discoveries, Decision Log, and Outcomes & Retrospective must be kept up to date as work proceeds.

## Ambiguity Notice

The source PRD contains seven unresolved ambiguities that would normally require stakeholder clarification before proceeding. Because this plan must be actionable, each ambiguity has been resolved with a reasonable default choice. Every resolution is documented in the Decision Log below with the tag "Ambiguity Resolution" so reviewers can locate, challenge, and override any assumption. The seven ambiguities are:

1. **Frontend framework unspecified** ("use whatever works best"). Resolved: React with TypeScript.
2. **Database marked TBD**. Resolved: PostgreSQL.
3. **WebSocket library unspecified** ("some WebSocket library"). Resolved: Socket.IO (server and client).
4. **Architecture integration points undefined** ("details to be determined"). Resolved: assumed Express.js backend with a standard `src/` layout described in Context and Orientation.
5. **Build/run/validate commands missing** ("refer to existing README"). Resolved: assumed npm-based project with `npm run dev`, `npm test`, and `npm run build`.
6. **Acceptance criteria for E2 and E3 are vague** ("works", "appear"). Resolved: concrete observable behaviors defined in Validation and Acceptance.
7. **Reconnection strategy unspecified**. Resolved: exponential backoff starting at 1 second, doubling up to 30 seconds, with jitter.

If any of these assumptions are wrong, update this plan and the Decision Log before starting implementation.

## Purpose / Big Picture

After this change, users of the Acme dashboard will receive instant in-app notifications whenever events occur that affect them — new comments, status updates, and assignment changes — without refreshing the page. A notification bell in the header will display an unread count, high-priority events will surface as dismissible toast messages, and users will be able to control which notification types they receive and review their full notification history. To see it working, start the development server, log in, trigger a notification event from a second browser tab or via a test script, and observe the bell count increment and a toast appear within two seconds.

## Progress

- [ ] Milestone 1: WebSocket Infrastructure
  - [ ] Install Socket.IO server and client dependencies
  - [ ] Create the notification events database table via migration
  - [ ] Implement the WebSocket gateway module on the backend
  - [ ] Implement the WebSocket client hook on the frontend
  - [ ] Add automatic reconnection with exponential backoff
  - [ ] Write integration test: client connects, server emits test event, client receives it
  - [ ] Validate: run test suite and confirm WebSocket round-trip under 2 seconds

- [ ] Milestone 2: Notification UI Components
  - [ ] Create the NotificationBell component (bell icon with unread badge)
  - [ ] Create the NotificationDropdown component (list of recent notifications, mark-as-read)
  - [ ] Create the Toast component and toast manager
  - [ ] Integrate NotificationBell into the existing header/layout
  - [ ] Wire WebSocket events to bell count and toast display
  - [ ] Write unit tests for NotificationBell, NotificationDropdown, and Toast
  - [ ] Validate: log in, trigger event, observe bell count increment and toast appearance

- [ ] Milestone 3: Preferences and History
  - [ ] Create the notification_preferences database table via migration
  - [ ] Implement backend API endpoints for preferences CRUD
  - [ ] Implement backend API endpoint for paginated notification history
  - [ ] Create the NotificationPreferences page component
  - [ ] Create the NotificationHistory page component
  - [ ] Add routes for /settings/notifications and /notifications/history
  - [ ] Wire preference toggles to filter incoming WebSocket events
  - [ ] Write tests for preferences API and history API
  - [ ] Validate: toggle a preference off, trigger that event type, confirm no notification appears

## Surprises & Discoveries

No discoveries yet — this section will be populated during implementation.

## Decision Log

- Decision: Use React with TypeScript as the frontend framework.
  Rationale: The PRD says "use whatever framework works best" without specifying one. React is the most widely adopted frontend framework with the largest ecosystem of component libraries, and TypeScript adds type safety that reduces bugs in event-driven systems. This is an **Ambiguity Resolution** for PRD Ambiguity #1.
  Date/Author: Plan creation.

- Decision: Use PostgreSQL as the database for notification storage.
  Rationale: The PRD marks the database as "TBD — need to evaluate options." PostgreSQL provides ACID transactions, mature JSON column support for flexible notification payloads, and is a safe default for relational data. If the existing project already uses a different relational database, substitute accordingly. This is an **Ambiguity Resolution** for PRD Ambiguity #2.
  Date/Author: Plan creation.

- Decision: Use Socket.IO for WebSocket communication (both server and client libraries).
  Rationale: The PRD says "some WebSocket library." Socket.IO was chosen because it provides automatic reconnection, room-based broadcasting (useful for per-user notification channels), fallback to long-polling when WebSockets are blocked, and a mature ecosystem. The built-in reconnection support directly addresses NFR resilience requirements. This is an **Ambiguity Resolution** for PRD Ambiguity #3.
  Date/Author: Plan creation.

- Decision: Assume the backend is an Express.js server with a standard `src/` directory layout.
  Rationale: The PRD says "the existing server" and "details to be determined during implementation" without describing the architecture. Express.js is the most common Node.js server framework and pairs naturally with Socket.IO. If the actual server uses a different framework (Fastify, Koa, NestJS), the Socket.IO integration approach will differ but the notification logic remains the same. This is an **Ambiguity Resolution** for PRD Ambiguity #4.
  Date/Author: Plan creation.

- Decision: Assume npm-based tooling with `npm run dev` for development, `npm test` for testing, and `npm run build` for production builds.
  Rationale: The PRD says "refer to the existing project README for build commands," violating self-containment. These are the most common npm scripts for a Node.js/React project. Before starting, verify by reading `package.json` in the repository root and adjust commands if they differ. This is an **Ambiguity Resolution** for PRD Ambiguity #5.
  Date/Author: Plan creation.

- Decision: Define concrete acceptance criteria for E2 and E3 to replace the PRD's vague wording.
  Rationale: The PRD's acceptance criteria for E2 say "notification bell shows count" and "toast messages appear for important events" without specifying observable behaviors. The PRD's E3 criteria say "preferences page works" and "history page shows past notifications." These have been replaced with specific, testable behaviors in the Validation and Acceptance section. This is an **Ambiguity Resolution** for PRD Ambiguity #6.
  Date/Author: Plan creation.

- Decision: Implement exponential backoff reconnection: initial delay 1 second, multiplier 2x, maximum delay 30 seconds, with random jitter of 0-500ms.
  Rationale: The PRD requires "reconnect automatically on connection drop" but specifies no retry policy. Unbounded immediate retries could cause reconnection storms that overload the server. Exponential backoff with jitter is the industry standard for this problem. Socket.IO supports this configuration natively. This is an **Ambiguity Resolution** for PRD Ambiguity #7.
  Date/Author: Plan creation.

- Decision: Notifications are not a replacement for existing polling-based data refresh.
  Rationale: The PRD explicitly states this as a non-goal. The notification system is supplementary — it alerts users to changes but does not update the underlying data views. Existing data refresh mechanisms must remain intact.
  Date/Author: Plan creation. Source: PRD Non-Goals section.

- Decision: Push notifications, email digests, and notification grouping/batching are out of scope.
  Rationale: The PRD explicitly lists these as out of scope. Do not implement them even if they seem like natural extensions.
  Date/Author: Plan creation. Source: PRD Out of Scope section.

## Outcomes & Retrospective

To be completed at major milestones and at plan completion.

## Context and Orientation

This plan targets the repository at `github.com/acme/dashboard`. The project is assumed to be a full-stack JavaScript/TypeScript application with the following structure (verify and adjust after reading the actual repo):

    <repo-root>/
      package.json              — project manifest with scripts and dependencies
      src/
        server/
          index.ts              — Express.js application entry point
          routes/               — API route handlers
          middleware/            — Express middleware (auth, error handling)
          models/               — database models or ORM definitions
        client/
          App.tsx               — React application root
          components/           — reusable UI components
            Header.tsx          — top navigation bar (where the bell will go)
          pages/                — page-level components
          hooks/                — custom React hooks
          styles/               — CSS or styled-component files
        shared/                 — types and constants shared between client and server
      migrations/               — database migration files
      tests/                    — test files
      public/                   — static assets

Key terms used in this plan:

- **WebSocket**: A protocol that provides full-duplex (two-way) communication between a browser and a server over a single persistent TCP connection. Unlike HTTP, where the client must ask for data, WebSockets let the server push data to the client at any time.

- **Socket.IO**: A JavaScript library that wraps WebSockets with additional features: automatic reconnection, room-based message routing (so the server can send a message to just one user), and fallback to HTTP long-polling when WebSockets are blocked by firewalls or proxies. It has two parts: a server library (`socket.io`) and a client library (`socket.io-client`).

- **Toast notification**: A small, temporary message that slides into view (typically in a corner of the screen), stays visible for a few seconds, and then disappears. Users can usually dismiss it early by clicking a close button.

- **Notification bell**: An icon (typically a bell shape) in the application header that displays a badge with the count of unread notifications. Clicking it opens a dropdown listing recent notifications.

- **Exponential backoff**: A reconnection strategy where the wait time between retry attempts doubles each time (1s, 2s, 4s, 8s, ...) up to a maximum. This prevents a flood of reconnection attempts when the server is down. Jitter adds a small random delay to prevent many clients from reconnecting at the exact same instant.

- **Migration**: A versioned script that modifies the database schema (creating tables, adding columns). Migrations run in order and can be rolled back. In this plan, migrations are SQL files executed by a migration tool.

The notification system adds three new areas to the codebase: (1) a WebSocket gateway on the server that listens for client connections and pushes notification events, (2) a set of React components on the client for displaying notifications, and (3) database tables for persisting notifications and user preferences. These three areas connect as follows: when a backend event occurs (e.g., a comment is created), the server writes a row to the notifications table and then emits a Socket.IO event to the affected user's room. The client, connected via Socket.IO, receives the event, updates the bell count, and optionally shows a toast. The preferences table controls which event types reach the user.

## Plan of Work

The work is divided into three milestones matching the PRD's epics. Each milestone is independently verifiable.

**Milestone 1 — WebSocket Infrastructure.** This milestone establishes the real-time communication channel. First, install the Socket.IO server and client packages. Then create a database migration that adds a `notifications` table with columns for id, user_id, type, title, body, payload (JSONB), read status, and timestamps. Next, create a WebSocket gateway module at `src/server/websocket.ts` that initializes a Socket.IO server instance attached to the existing Express HTTP server. This module will authenticate incoming connections (using the same session or JWT token the app already uses for HTTP requests), join each authenticated user to a private room named `user:<userId>`, and expose a `sendNotification(userId, notification)` function that other server modules can call to push events. On the client side, create a custom React hook at `src/client/hooks/useSocket.ts` that establishes a Socket.IO connection on mount, handles reconnection with exponential backoff (1s initial, 2x multiplier, 30s max, 0-500ms jitter), and provides the connection status and an event listener interface to consuming components. Finally, write an integration test that starts the server, connects a Socket.IO test client, emits a test notification, and asserts the client receives it within 2 seconds.

**Milestone 2 — Notification UI Components.** This milestone builds the user-facing notification display. Create a `NotificationBell` component at `src/client/components/NotificationBell.tsx` that renders a bell icon with a red badge showing the unread count. When clicked, it toggles a `NotificationDropdown` component that lists the most recent notifications, each showing the title, a truncated body, the timestamp, and a read/unread indicator. Clicking a notification in the dropdown marks it as read (via an API call and optimistic UI update) and the unread count decrements. Create a `Toast` component at `src/client/components/Toast.tsx` and a toast manager at `src/client/components/ToastManager.tsx` that renders a stack of toasts in the bottom-right corner. Toasts auto-dismiss after 5 seconds or can be closed manually. Integrate the `NotificationBell` into the existing `Header.tsx` component. Wire the `useSocket` hook so that incoming notification events update the bell count (by incrementing a React state counter) and, if the notification is high-priority, trigger a toast.

**Milestone 3 — Preferences and History.** This milestone adds user control. Create a migration for a `notification_preferences` table with columns for user_id, notification_type, and enabled (boolean), with a composite unique constraint on (user_id, notification_type). Add three API endpoints: `GET /api/notifications/preferences` (returns the current user's preferences), `PUT /api/notifications/preferences` (updates a single preference toggle), and `GET /api/notifications/history?page=N&limit=M` (returns paginated notification history for the current user). Create a `NotificationPreferences` page component at `src/client/pages/NotificationPreferences.tsx` that displays a list of notification types with toggle switches. Create a `NotificationHistory` page component at `src/client/pages/NotificationHistory.tsx` that displays a paginated, reverse-chronological list of notifications with infinite scroll or page buttons. Add frontend routes: `/settings/notifications` for preferences and `/notifications/history` for history. On the server side, modify the `sendNotification` function in the WebSocket gateway to check the user's preferences before emitting the event — if the user has disabled that notification type, the notification is still stored in the database but not pushed via WebSocket.

## Concrete Steps

### Milestone 1: WebSocket Infrastructure

1. **Install dependencies.** From the repository root:

       npm install socket.io@^4.7 socket.io-client@^4.7
       npm install --save-dev @types/socket.io @types/socket.io-client

   Expected output: packages added to `package.json` under `dependencies` and `devDependencies`, `node_modules` updated. If the project uses yarn or pnpm, substitute the equivalent commands.

2. **Create the notifications table migration.** Create a new file at `migrations/<timestamp>_create_notifications.sql` (or use the project's migration tool to generate it). The migration should contain:

       CREATE TABLE IF NOT EXISTS notifications (
         id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
         user_id       UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
         type          VARCHAR(50) NOT NULL,
         title         VARCHAR(255) NOT NULL,
         body          TEXT,
         payload       JSONB DEFAULT '{}',
         is_read       BOOLEAN DEFAULT FALSE,
         created_at    TIMESTAMPTZ DEFAULT NOW(),
         updated_at    TIMESTAMPTZ DEFAULT NOW()
       );

       CREATE INDEX idx_notifications_user_id ON notifications(user_id);
       CREATE INDEX idx_notifications_user_unread ON notifications(user_id) WHERE is_read = FALSE;

   Run the migration:

       npm run migrate

   Expected: migration completes without errors. Verify by connecting to the database and confirming the `notifications` table exists. If the project does not have a `migrate` script, check `package.json` for the appropriate command (e.g., `npx knex migrate:latest` or `npx prisma migrate dev`).

3. **Create the WebSocket gateway module.** Create `src/server/websocket.ts`. This module exports an `initializeWebSocket(httpServer)` function that:
   - Creates a new Socket.IO server instance attached to the provided HTTP server, with CORS configured to match the existing Express CORS settings.
   - Registers a `connection` event handler that authenticates the connecting client (by reading the auth token from `socket.handshake.auth.token`), looks up the user, and joins the socket to room `user:<userId>`.
   - Exports a `sendNotification(userId, notification)` function that emits a `notification:new` event to the `user:<userId>` room.
   - Logs connections and disconnections for debugging.

   Then, in `src/server/index.ts`, import `initializeWebSocket` and call it with the HTTP server instance after the Express app is set up. The HTTP server must be the raw Node.js `http.Server`, not the Express app itself. If the current code does `app.listen(port)`, refactor to:

       import { createServer } from 'http';
       const httpServer = createServer(app);
       initializeWebSocket(httpServer);
       httpServer.listen(port);

4. **Create the client-side socket hook.** Create `src/client/hooks/useSocket.ts`. This custom React hook:
   - Establishes a Socket.IO connection to the server on component mount.
   - Passes the user's auth token via `socket.handshake.auth.token`.
   - Configures reconnection: `reconnection: true`, `reconnectionDelay: 1000`, `reconnectionDelayMax: 30000`, `randomizationFactor: 0.5`.
   - Exposes: `isConnected` (boolean), `lastNotification` (the most recent notification event), and `onNotification(callback)` (registers a listener for `notification:new` events).
   - Cleans up the connection on unmount.

5. **Write an integration test.** Create `tests/websocket.test.ts` (or use the project's test directory convention). The test should:
   - Start the server programmatically.
   - Connect a Socket.IO test client with valid auth credentials.
   - Call `sendNotification` on the server side with a test payload.
   - Assert the client receives the `notification:new` event within 2 seconds.
   - Disconnect and shut down.

   Run:

       npm test -- --grep "websocket"

   Expected: test passes, confirming round-trip notification delivery.

### Milestone 2: Notification UI Components

6. **Create NotificationBell component.** Create `src/client/components/NotificationBell.tsx`. The component renders a bell icon (use an SVG or icon library already in the project; if none exists, use a simple SVG bell). It accepts an `unreadCount` prop and displays a red circular badge with the count when `unreadCount > 0`. The badge is hidden when the count is 0. Clicking the bell toggles the dropdown visibility.

7. **Create NotificationDropdown component.** Create `src/client/components/NotificationDropdown.tsx`. The component renders a positioned panel below the bell (absolute positioning relative to the bell's container). It displays a list of notifications (title, truncated body up to 80 characters, relative timestamp like "2 minutes ago"). Each notification row has a visual indicator for read/unread state (e.g., a blue dot for unread). Clicking a notification calls a `markAsRead` API endpoint (`PATCH /api/notifications/:id/read`) and visually updates the row. Include a "Mark all as read" link at the top and a "View all" link at the bottom that navigates to `/notifications/history`.

8. **Create Toast and ToastManager components.** Create `src/client/components/Toast.tsx` (a single toast with title, body, close button, and a 5-second auto-dismiss timer) and `src/client/components/ToastManager.tsx` (manages a stack of up to 3 visible toasts, positioned fixed in the bottom-right corner, newest on top). Use a React context or a simple module-level store so that any part of the app can call `showToast(notification)`.

9. **Integrate into the layout.** In `src/client/components/Header.tsx` (or the project's equivalent top navigation component), import and render `NotificationBell`. Place the `ToastManager` in `src/client/App.tsx` so it renders at the app root level.

10. **Wire WebSocket events to UI.** In a top-level component (e.g., `App.tsx` or a dedicated `NotificationProvider`), use the `useSocket` hook. When a `notification:new` event arrives: increment the unread count state, prepend the notification to the dropdown list, and if the notification's `type` field is in the set of high-priority types (initially: `assignment`, `deadline`, `mention`), call `showToast`.

11. **Write unit tests.** Create tests for NotificationBell (renders count, hides badge at zero, toggles dropdown on click), NotificationDropdown (renders notifications, calls markAsRead on click), and Toast (renders content, auto-dismisses after 5 seconds, dismisses on close click). Run:

        npm test

    Expected: all new tests pass alongside existing tests.

### Milestone 3: Preferences and History

12. **Create the notification_preferences table migration.** Create `migrations/<timestamp>_create_notification_preferences.sql`:

        CREATE TABLE IF NOT EXISTS notification_preferences (
          id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
          user_id           UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
          notification_type VARCHAR(50) NOT NULL,
          enabled           BOOLEAN DEFAULT TRUE,
          created_at        TIMESTAMPTZ DEFAULT NOW(),
          updated_at        TIMESTAMPTZ DEFAULT NOW(),
          UNIQUE(user_id, notification_type)
        );

    Run:

        npm run migrate

    Expected: migration completes, `notification_preferences` table exists.

13. **Implement preferences API endpoints.** In `src/server/routes/notifications.ts` (create this file if it does not exist), add:
    - `GET /api/notifications/preferences` — returns all preference rows for the authenticated user. If a notification type has no row, it defaults to enabled. Returns a JSON array of objects with `type` and `enabled` fields.
    - `PUT /api/notifications/preferences` — accepts `{ type: string, enabled: boolean }` in the request body. Upserts the preference row. Returns the updated preference.

14. **Implement notification history API endpoint.** In the same routes file, add:
    - `GET /api/notifications/history?page=1&limit=20` — returns paginated notifications for the authenticated user, ordered by `created_at` descending. Returns `{ notifications: [...], total: N, page: N, limit: N }`.
    - `PATCH /api/notifications/:id/read` — marks a single notification as read. Returns 204.
    - `POST /api/notifications/read-all` — marks all unread notifications for the authenticated user as read. Returns 204.

15. **Create NotificationPreferences page.** Create `src/client/pages/NotificationPreferences.tsx`. The page fetches preferences on mount, displays a list of notification types (comment, status_change, assignment, deadline, mention) with a toggle switch for each. Toggling calls the PUT endpoint and updates the local state optimistically. Add a route at `/settings/notifications`.

16. **Create NotificationHistory page.** Create `src/client/pages/NotificationHistory.tsx`. The page fetches the first page of notification history on mount and displays it as a list. Each row shows the notification title, body, type badge, and timestamp. Include a "Load more" button or infinite scroll that fetches the next page. Add a route at `/notifications/history`.

17. **Filter notifications by preferences.** In the `sendNotification` function in `src/server/websocket.ts`, before emitting the event, query the `notification_preferences` table. If the user has a row for that notification type with `enabled = false`, skip the WebSocket emit (the notification is still stored in the database for history). This ensures the preference is enforced server-side, not just client-side.

18. **Write tests for preferences and history.** Create tests that:
    - Verify GET /api/notifications/preferences returns defaults for a new user.
    - Verify PUT /api/notifications/preferences creates and updates preferences.
    - Verify GET /api/notifications/history returns paginated results.
    - Verify that a disabled notification type is not emitted via WebSocket.

    Run:

        npm test

    Expected: all tests pass.

## Validation and Acceptance

The following are the concrete, observable acceptance criteria for the entire plan. Each maps to a PRD functional requirement.

**FR-1: WebSocket connection.** Start the development server with `npm run dev`. Open the browser to `http://localhost:3000` (or the project's configured port) and log in with a valid user account. Open the browser developer tools, go to the Network tab, and filter by "WS" (WebSocket). You should see an active WebSocket connection to the server. If you kill the server and restart it, the client should automatically reconnect within a few seconds without a page refresh.

**FR-2: Notification bell.** After logging in, the header should display a bell icon. If there are unread notifications, a red badge shows the count. Click the bell to open a dropdown listing recent notifications with titles and timestamps. Click a notification in the dropdown — it should visually change to "read" state and the badge count should decrement by one.

**FR-3: Toast messages.** Trigger a high-priority notification (e.g., assign a task to the logged-in user from another account or via a test script). A toast should slide into view in the bottom-right corner showing the notification title and body. The toast should auto-dismiss after 5 seconds. Clicking the X button on the toast should dismiss it immediately.

**FR-4: Preferences.** Navigate to `/settings/notifications`. You should see a list of notification types with toggle switches. Turn off "assignment" notifications. Trigger an assignment notification. The notification should NOT appear as a toast or update the bell count. Navigate to `/notifications/history` — the notification should still appear there (it was stored, just not pushed in real time). Turn the preference back on and trigger another assignment notification — this time it should appear.

**FR-5: History page.** Navigate to `/notifications/history`. You should see a paginated list of past notifications in reverse chronological order. If there are more than 20 notifications, a "Load more" button or infinite scroll should load the next page.

**NFR: Performance.** The time between a server-side event and the notification appearing in the UI should be under 2 seconds. Measure by logging timestamps on both sides.

**NFR: Resilience.** Stop the server while a client is connected. The client should show a brief disconnection state. Restart the server. The client should reconnect automatically within the backoff window (1-30 seconds) without user intervention and without a page refresh.

Test commands:

    npm test

Expected: all tests pass (both existing and new). The exact count will depend on the number of existing tests in the project.

    npm run build

Expected: production build completes with no TypeScript errors and no warnings.

## Idempotence and Recovery

All database migrations use `CREATE TABLE IF NOT EXISTS`, making them safe to re-run. If a migration fails partway, check the migration tool's status command (e.g., `npx knex migrate:status`) to see which migrations have been applied, then re-run.

npm dependency installation is idempotent — running `npm install` again has no adverse effect.

File creation steps are idempotent: if a file already exists, the content will be overwritten with the correct implementation. No step deletes files or drops tables.

If the WebSocket gateway initialization fails (e.g., port conflict), the error will be logged at server startup. Fix the root cause (usually another process using the same port) and restart.

If a test fails, read the test output carefully. The most common issues are: (1) database not running or not migrated — run `npm run migrate`; (2) auth token not configured in test setup — ensure the test creates a valid user and generates a token; (3) port conflict — ensure no other instance of the dev server is running.

## Artifacts and Notes

Expected WebSocket connection handshake in browser developer tools (Network tab, WS filter):

    Request URL: ws://localhost:3000/socket.io/?EIO=4&transport=websocket
    Status: 101 Switching Protocols

Expected notification event payload received by the client:

    {
      "id": "a1b2c3d4-...",
      "type": "assignment",
      "title": "Task assigned to you",
      "body": "John assigned 'Fix login bug' to you",
      "payload": { "taskId": "xyz-123" },
      "isRead": false,
      "createdAt": "2026-03-10T12:00:00Z"
    }

Expected preferences API response:

    GET /api/notifications/preferences
    200 OK
    [
      { "type": "comment", "enabled": true },
      { "type": "status_change", "enabled": true },
      { "type": "assignment", "enabled": false },
      { "type": "deadline", "enabled": true },
      { "type": "mention", "enabled": true }
    ]

Expected history API response:

    GET /api/notifications/history?page=1&limit=2
    200 OK
    {
      "notifications": [
        { "id": "...", "type": "comment", "title": "New comment", "body": "...", "isRead": true, "createdAt": "..." },
        { "id": "...", "type": "assignment", "title": "Task assigned", "body": "...", "isRead": false, "createdAt": "..." }
      ],
      "total": 47,
      "page": 1,
      "limit": 2
    }

## Interfaces and Dependencies

**Server dependencies:**
- `socket.io` ^4.7 — WebSocket server library. Provides the `Server` class, `Socket` type, and room-based broadcasting via `io.to(room).emit(event, data)`.
- `express` (existing) — HTTP server framework. The Socket.IO server attaches to the underlying `http.Server` created from the Express app.
- `pg` or equivalent PostgreSQL driver (existing or to be added) — database access for notifications and preferences tables.
- `uuid` or database-native `gen_random_uuid()` — for generating notification IDs.

**Client dependencies:**
- `socket.io-client` ^4.7 — WebSocket client library. Provides the `io(url, options)` function that returns a `Socket` instance.
- `react` and `react-dom` (existing) — UI framework.

**Key interfaces that must exist after implementation:**

Server-side (`src/server/websocket.ts`):

    function initializeWebSocket(httpServer: HttpServer): void
    function sendNotification(userId: string, notification: NotificationPayload): Promise<void>

    interface NotificationPayload {
      type: string;         // e.g., "comment", "assignment", "deadline"
      title: string;
      body: string;
      payload?: Record<string, unknown>;
    }

Server-side API routes (`src/server/routes/notifications.ts`):

    GET    /api/notifications/preferences        -> PreferenceItem[]
    PUT    /api/notifications/preferences        -> PreferenceItem
    GET    /api/notifications/history?page&limit  -> PaginatedNotifications
    PATCH  /api/notifications/:id/read           -> 204
    POST   /api/notifications/read-all           -> 204

    interface PreferenceItem {
      type: string;
      enabled: boolean;
    }

    interface PaginatedNotifications {
      notifications: Notification[];
      total: number;
      page: number;
      limit: number;
    }

Client-side hook (`src/client/hooks/useSocket.ts`):

    function useSocket(): {
      isConnected: boolean;
      lastNotification: Notification | null;
      onNotification: (callback: (notification: Notification) => void) => void;
    }

Client-side components:

    NotificationBell     — src/client/components/NotificationBell.tsx
    NotificationDropdown — src/client/components/NotificationDropdown.tsx
    Toast                — src/client/components/Toast.tsx
    ToastManager         — src/client/components/ToastManager.tsx

Client-side pages:

    NotificationPreferences — src/client/pages/NotificationPreferences.tsx
    NotificationHistory     — src/client/pages/NotificationHistory.tsx

Database tables:

    notifications              — stores all notification events
    notification_preferences   — stores per-user, per-type opt-in/opt-out settings
