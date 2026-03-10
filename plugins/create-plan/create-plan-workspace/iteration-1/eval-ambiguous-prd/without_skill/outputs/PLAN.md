# Implementation Plan: Real-Time Notification System

## 1. Overview

This plan covers the implementation of a real-time notification system for the Acme dashboard application (`github.com/acme/dashboard`). The system will deliver in-app notifications via WebSocket, including a notification bell with unread count, toast messages for high-priority events, user-configurable notification preferences, and a notification history page.

---

## 2. Assumptions (Resolving PRD Ambiguities)

The PRD contains several unresolved ambiguities. The following assumptions are made to unblock planning. Each should be validated with the product owner (Sam Patel) before implementation begins.

| # | Ambiguity | Assumption | Rationale |
|---|-----------|------------|-----------|
| 1 | Frontend framework unspecified | **React** (with TypeScript) | React is the most widely adopted SPA framework, likely already in use for "the existing dashboard." If the dashboard uses a different framework, this plan's component structure adapts easily. |
| 2 | Database TBD | **PostgreSQL** for notification storage, **Redis** for pub/sub and transient state (unread counts, connection tracking) | PostgreSQL provides durable, queryable storage for notification history. Redis provides fast pub/sub for real-time fan-out and ephemeral caching. |
| 3 | WebSocket library unspecified | **Socket.IO** (server and client) | Socket.IO provides automatic reconnection with exponential backoff, room-based routing, and fallback to long-polling. This also resolves ambiguity #7 (reconnection strategy). |
| 4 | Architecture integration points unclear | Notification service runs as a **separate module within the existing Node.js/Express server**, with a dedicated `/ws` endpoint. A new `NotificationService` class encapsulates all notification logic. | Keeps deployment simple (single process) while maintaining separation of concerns. |
| 5 | Build/run commands reference external README | Standard commands assumed: `npm install`, `npm run dev`, `npm run build`, `npm test` | Standard Node.js/React project conventions. |
| 6 | Vague acceptance criteria for E2/E3 | Specific, testable criteria defined below in each task. | Enables clear verification of implementation completeness. |
| 7 | No reconnection/backoff strategy defined | **Exponential backoff**: initial delay 1s, factor 2x, max delay 30s, max attempts unlimited (Socket.IO defaults). Connection status indicator shown to the user. | Prevents reconnection storms while ensuring eventual reconnection. |

---

## 3. Architecture Overview

```
+------------------+       WebSocket (Socket.IO)       +-------------------+
|                  | <-------------------------------> |                   |
|   React Client   |                                   |   Express Server  |
|                  |         REST API (HTTP)            |                   |
|  - NotifBell     | <-------------------------------> |  - NotifService   |
|  - ToastManager  |                                   |  - NotifRouter    |
|  - PrefsPage     |                                   |  - WebSocket Hub  |
|  - HistoryPage   |                                   |                   |
+------------------+                                   +--------+----------+
                                                                |
                                                    +-----------+-----------+
                                                    |                       |
                                              +-----+------+        +------+-----+
                                              | PostgreSQL  |        |   Redis    |
                                              | (storage)   |        | (pub/sub)  |
                                              +-------------+        +------------+
```

### Data Flow

1. An event occurs in the system (e.g., new comment, status change, assignment change).
2. The originating service calls `NotificationService.emit(event)`.
3. `NotificationService` persists the notification to PostgreSQL.
4. `NotificationService` publishes the event to Redis pub/sub.
5. The WebSocket Hub picks up the Redis message and delivers it to the target user's Socket.IO room.
6. The React client receives the event, updates the bell count, and optionally shows a toast.

---

## 4. Database Schema

### PostgreSQL

```sql
-- notifications table
CREATE TABLE notifications (
    id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id       UUID NOT NULL REFERENCES users(id),
    type          VARCHAR(50) NOT NULL,          -- e.g., 'comment', 'status_change', 'assignment'
    title         VARCHAR(255) NOT NULL,
    body          TEXT,
    priority      VARCHAR(10) NOT NULL DEFAULT 'normal',  -- 'normal' | 'high'
    resource_type VARCHAR(50),                   -- e.g., 'task', 'project'
    resource_id   UUID,
    is_read       BOOLEAN NOT NULL DEFAULT FALSE,
    created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_notifications_user_unread ON notifications(user_id, is_read, created_at DESC);
CREATE INDEX idx_notifications_user_created ON notifications(user_id, created_at DESC);

-- notification_preferences table
CREATE TABLE notification_preferences (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID NOT NULL REFERENCES users(id),
    notification_type VARCHAR(50) NOT NULL,
    enabled         BOOLEAN NOT NULL DEFAULT TRUE,
    UNIQUE(user_id, notification_type)
);
```

### Redis Keys

- `notif:unread:{userId}` -- integer counter for unread badge (INCR/DECR)
- `notif:channel` -- pub/sub channel for real-time fan-out

---

## 5. Phased Implementation Plan

### Phase 1 / Epic 1: WebSocket Infrastructure

**Objective**: Establish a reliable real-time communication channel between server and client.

#### Task 1.1: Server-Side WebSocket Setup

**Description**: Integrate Socket.IO with the existing Express server. Create a WebSocket hub that authenticates connections and manages user rooms.

**Files to create/modify**:
- `server/src/websocket/socketHub.ts` (new) -- Socket.IO server initialization, auth middleware, room management
- `server/src/websocket/index.ts` (new) -- exports
- `server/src/app.ts` (modify) -- attach Socket.IO to the HTTP server

**Implementation details**:
- Attach Socket.IO to the existing HTTP server instance on the `/ws` path.
- Implement authentication middleware that validates the user's JWT/session token on connection.
- On successful auth, join the socket to a room named `user:{userId}`.
- Handle `disconnect` events and log connection lifecycle.
- Implement heartbeat/ping-pong (Socket.IO handles this by default; configure `pingTimeout: 20000`, `pingInterval: 25000`).

**Acceptance criteria**:
- [ ] Socket.IO server starts alongside Express without errors.
- [ ] Only authenticated users can establish a WebSocket connection; unauthenticated attempts receive a 401 error.
- [ ] Each connected user is placed in their own room (`user:{userId}`).
- [ ] Server logs connection and disconnection events.

**Estimated effort**: 4 hours

---

#### Task 1.2: Client-Side WebSocket Connection

**Description**: Create a React context/provider that manages the Socket.IO client connection lifecycle.

**Files to create/modify**:
- `client/src/contexts/WebSocketContext.tsx` (new) -- React context providing socket instance
- `client/src/hooks/useWebSocket.ts` (new) -- hook for consuming socket events
- `client/src/App.tsx` (modify) -- wrap app in WebSocketProvider

**Implementation details**:
- `WebSocketProvider` creates a Socket.IO client connection on mount (after user login).
- Pass auth token in the `auth` handshake option.
- Expose connection status (`connected`, `disconnected`, `reconnecting`) via context.
- Socket.IO client handles reconnection automatically with exponential backoff (configure: `reconnectionDelay: 1000`, `reconnectionDelayMax: 30000`, `reconnectionAttempts: Infinity`).
- Clean up connection on unmount / logout.

**Acceptance criteria**:
- [ ] Client connects to WebSocket server automatically upon login.
- [ ] Client disconnects cleanly on logout.
- [ ] Connection status is accessible throughout the app via `useWebSocket()`.
- [ ] Client reconnects automatically after network interruption with exponential backoff (1s initial, 30s max).
- [ ] A small connection status indicator appears in the UI when disconnected/reconnecting.

**Estimated effort**: 4 hours

---

#### Task 1.3: Redis Pub/Sub Integration

**Description**: Set up Redis as a pub/sub backbone so the notification system can scale across multiple server instances if needed.

**Files to create/modify**:
- `server/src/websocket/redisPubSub.ts` (new) -- Redis publisher and subscriber setup
- `server/src/websocket/socketHub.ts` (modify) -- subscribe to Redis channel and relay to Socket.IO rooms

**Implementation details**:
- Use `ioredis` library for Redis connections.
- On notification publish: serialize notification payload and publish to `notif:channel`.
- On message receive: deserialize, look up target user's Socket.IO room, emit event.
- Configure Socket.IO Redis adapter (`@socket.io/redis-adapter`) for multi-instance support.

**Acceptance criteria**:
- [ ] Notifications published to Redis are delivered to the correct user's WebSocket connection.
- [ ] System works correctly with a single server instance.
- [ ] Redis connection failures are logged and retried gracefully.

**Estimated effort**: 3 hours

---

#### Task 1.4: Notification Service (Core Logic)

**Description**: Create the central `NotificationService` class that other parts of the application call to emit notifications.

**Files to create/modify**:
- `server/src/services/notificationService.ts` (new) -- core notification creation, storage, and dispatch logic
- `server/src/models/notification.ts` (new) -- TypeScript interfaces/types for notification data

**Implementation details**:
- `NotificationService.create({ userId, type, title, body, priority, resourceType, resourceId })`:
  1. Check user's notification preferences; skip if this type is disabled.
  2. Insert notification row into PostgreSQL.
  3. Increment Redis unread counter (`notif:unread:{userId}`).
  4. Publish to Redis pub/sub channel for real-time delivery.
- `NotificationService.markAsRead(notificationId, userId)`:
  1. Update `is_read = true` in PostgreSQL.
  2. Decrement Redis unread counter.
- `NotificationService.markAllAsRead(userId)`:
  1. Bulk update in PostgreSQL.
  2. Reset Redis unread counter to 0.
- `NotificationService.getUnreadCount(userId)`: Read from Redis counter (fast path).

**Acceptance criteria**:
- [ ] Calling `NotificationService.create()` persists a notification to PostgreSQL.
- [ ] User preferences are respected: disabled notification types are not stored or delivered.
- [ ] Unread count in Redis stays in sync with PostgreSQL.
- [ ] Notifications are delivered within 2 seconds of event trigger (NFR target).

**Estimated effort**: 5 hours

---

#### Task 1.5: Database Migration

**Description**: Create database migration scripts for the notifications and notification_preferences tables.

**Files to create/modify**:
- `server/src/migrations/YYYYMMDD_create_notifications.ts` (new)
- `server/src/migrations/YYYYMMDD_create_notification_preferences.ts` (new)

**Implementation details**:
- Use the project's existing migration tool (assumed: Knex, TypeORM, or Prisma).
- Create both tables as defined in the schema section above.
- Include rollback/down migrations.
- Seed default notification types: `comment`, `status_change`, `assignment`, `mention`, `due_date`.

**Acceptance criteria**:
- [ ] Migrations run successfully against a clean database.
- [ ] Migrations are reversible (down migration drops tables).
- [ ] Indexes are created for query performance.

**Estimated effort**: 2 hours

---

#### Task 1.6: Unit and Integration Tests for Phase 1

**Description**: Write tests for the WebSocket infrastructure and notification service.

**Files to create/modify**:
- `server/src/__tests__/websocket/socketHub.test.ts` (new)
- `server/src/__tests__/services/notificationService.test.ts` (new)
- `client/src/__tests__/contexts/WebSocketContext.test.tsx` (new)

**Test coverage**:
- Socket.IO connection auth (accept valid token, reject invalid).
- Room assignment on connection.
- `NotificationService.create()` stores notification and publishes event.
- `NotificationService.markAsRead()` updates read status and counter.
- Preference checking logic (disabled type skips delivery).
- Client reconnection behavior (mock disconnect/reconnect).

**Acceptance criteria**:
- [ ] All tests pass in CI.
- [ ] Core notification service logic has >80% branch coverage.

**Estimated effort**: 4 hours

---

### Phase 1 Total: ~22 hours

---

### Phase 2 / Epic 2: Notification UI Components

**Objective**: Build user-facing notification components -- bell icon with dropdown and toast messages.

#### Task 2.1: Notification Bell Component

**Description**: Create a notification bell icon in the app header that displays the unread count and opens a dropdown with recent notifications.

**Files to create/modify**:
- `client/src/components/notifications/NotificationBell.tsx` (new)
- `client/src/components/notifications/NotificationDropdown.tsx` (new)
- `client/src/components/notifications/NotificationItem.tsx` (new)
- `client/src/hooks/useNotifications.ts` (new) -- state management for notifications
- `client/src/components/Header.tsx` (modify) -- add NotificationBell to header
- `client/src/styles/notifications.css` (new)

**Implementation details**:
- Bell icon with badge showing unread count (fetched from Redis via REST on initial load, updated via WebSocket).
- Badge hidden when count is 0. Display "99+" if count exceeds 99.
- Clicking bell opens a dropdown panel showing the 20 most recent notifications.
- Each notification item shows: icon (by type), title, body preview (truncated to 80 chars), relative timestamp ("2 min ago"), and read/unread state (bold for unread).
- Clicking a notification marks it as read and navigates to the relevant resource.
- "Mark all as read" button at the top of the dropdown.
- "View all" link at the bottom, navigating to the history page.
- Dropdown closes on outside click or Escape key.

**REST endpoints needed**:
- `GET /api/notifications?limit=20&offset=0` -- fetch recent notifications
- `GET /api/notifications/unread-count` -- get unread count
- `PATCH /api/notifications/:id/read` -- mark one as read
- `PATCH /api/notifications/read-all` -- mark all as read

**Acceptance criteria**:
- [ ] Bell icon is visible in the header on all pages.
- [ ] Unread count badge displays correctly and updates in real time (within 2 seconds of a new notification).
- [ ] Badge shows "99+" for counts above 99 and is hidden when count is 0.
- [ ] Dropdown displays up to 20 recent notifications with type icon, title, body preview, and relative timestamp.
- [ ] Unread notifications are visually distinct (bold text, subtle background).
- [ ] Clicking a notification marks it as read, closes the dropdown, and navigates to the associated resource.
- [ ] "Mark all as read" button resets unread count to 0 and updates all items visually.
- [ ] Dropdown closes on outside click or Escape key press.
- [ ] Component is accessible: keyboard navigable, ARIA labels on bell button and badge.

**Estimated effort**: 8 hours

---

#### Task 2.2: REST API Endpoints for Notifications

**Description**: Create REST endpoints for fetching notifications, marking as read, and getting unread count.

**Files to create/modify**:
- `server/src/routes/notificationRoutes.ts` (new)
- `server/src/controllers/notificationController.ts` (new)
- `server/src/app.ts` (modify) -- register notification routes

**Endpoints**:
| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/notifications` | Paginated list. Query params: `limit` (default 20, max 100), `offset` (default 0). Returns `{ data: Notification[], total: number }` |
| GET | `/api/notifications/unread-count` | Returns `{ count: number }` |
| PATCH | `/api/notifications/:id/read` | Mark single notification as read. Returns 204. |
| PATCH | `/api/notifications/read-all` | Mark all user's notifications as read. Returns 204. |

**Acceptance criteria**:
- [ ] All endpoints require authentication (401 for unauthenticated requests).
- [ ] Users can only access their own notifications (authorization enforced).
- [ ] Pagination works correctly with `limit` and `offset`.
- [ ] Endpoints return proper HTTP status codes (200, 204, 400, 401, 404).

**Estimated effort**: 4 hours

---

#### Task 2.3: Toast Notification System

**Description**: Build a toast notification manager that displays dismissible toast messages for high-priority events.

**Files to create/modify**:
- `client/src/components/notifications/ToastManager.tsx` (new) -- container that renders active toasts
- `client/src/components/notifications/Toast.tsx` (new) -- individual toast component
- `client/src/contexts/ToastContext.tsx` (new) -- context for managing toast state
- `client/src/App.tsx` (modify) -- add ToastManager and ToastProvider
- `client/src/styles/toast.css` (new)

**Implementation details**:
- Toasts appear in the bottom-right corner of the viewport.
- Show toasts only for notifications with `priority: 'high'`.
- Toast displays notification title and a brief body (truncated to 100 chars).
- Each toast auto-dismisses after 5 seconds.
- User can dismiss a toast early by clicking the close button.
- Maximum 3 toasts visible at once; additional toasts queue and appear as earlier ones dismiss.
- Toasts stack vertically with newest at the bottom.
- Clicking toast body navigates to the relevant resource and marks the notification as read.
- Toast entrance animation: slide in from right (300ms). Exit animation: fade out (200ms).

**Acceptance criteria**:
- [ ] High-priority notifications trigger a toast within 2 seconds of the event.
- [ ] Normal-priority notifications do NOT trigger a toast.
- [ ] Toast displays title and truncated body text.
- [ ] Toast auto-dismisses after 5 seconds.
- [ ] User can manually dismiss a toast via close button.
- [ ] Maximum 3 toasts are visible simultaneously; extras are queued.
- [ ] Clicking a toast navigates to the relevant resource.
- [ ] Toasts have smooth entrance and exit animations.
- [ ] Toasts are accessible: proper ARIA role (`alert`), close button is keyboard-accessible.

**Estimated effort**: 6 hours

---

#### Task 2.4: Integration Between WebSocket Events and UI Components

**Description**: Wire WebSocket events to the notification bell and toast system so the UI updates in real time.

**Files to create/modify**:
- `client/src/hooks/useNotifications.ts` (modify) -- subscribe to WebSocket events
- `client/src/components/notifications/NotificationBell.tsx` (modify) -- react to real-time updates

**Implementation details**:
- Listen for `notification:new` WebSocket event.
- On receiving event:
  1. Increment unread count in bell badge.
  2. Prepend notification to dropdown list (if open).
  3. If priority is high, push to toast queue.
- Listen for `notification:read` event (for cross-tab sync if user has multiple tabs open).

**Acceptance criteria**:
- [ ] New notifications appear in the bell dropdown without page refresh.
- [ ] Unread count updates in real time.
- [ ] High-priority events trigger toasts.
- [ ] Marking a notification as read in one tab reflects in other tabs within 2 seconds.

**Estimated effort**: 3 hours

---

#### Task 2.5: Unit and Integration Tests for Phase 2

**Description**: Write tests for notification UI components and REST endpoints.

**Files to create/modify**:
- `client/src/__tests__/components/NotificationBell.test.tsx` (new)
- `client/src/__tests__/components/Toast.test.tsx` (new)
- `server/src/__tests__/routes/notificationRoutes.test.ts` (new)

**Test coverage**:
- Bell renders with correct unread count.
- Dropdown opens/closes correctly.
- Mark as read updates UI state.
- Toast appears for high-priority notifications.
- Toast auto-dismisses after 5 seconds.
- Toast queue respects max visible limit.
- REST endpoints return correct data and status codes.
- Authorization is enforced on all endpoints.

**Acceptance criteria**:
- [ ] All tests pass.
- [ ] UI components have tests for key user interactions.
- [ ] REST endpoints have tests for success, auth failure, and invalid input cases.

**Estimated effort**: 5 hours

---

### Phase 2 Total: ~26 hours

---

### Phase 3 / Epic 3: Notification Preferences and History

**Objective**: Allow users to control which notification types they receive and review past notifications.

#### Task 3.1: Notification Preferences API

**Description**: Create REST endpoints for managing user notification preferences.

**Files to create/modify**:
- `server/src/routes/preferenceRoutes.ts` (new)
- `server/src/controllers/preferenceController.ts` (new)
- `server/src/services/notificationService.ts` (modify) -- check preferences before delivering
- `server/src/app.ts` (modify) -- register preference routes

**Endpoints**:
| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/notification-preferences` | Returns all preferences for the current user. Each entry: `{ type, label, description, enabled }` |
| PUT | `/api/notification-preferences` | Accepts array of `{ type, enabled }` to bulk update preferences. Returns 200. |

**Implementation details**:
- Define notification types as a server-side registry:
  - `comment` -- "Comments" -- "Someone comments on an item you follow"
  - `status_change` -- "Status Changes" -- "An item's status is updated"
  - `assignment` -- "Assignments" -- "You are assigned to an item"
  - `mention` -- "Mentions" -- "Someone mentions you"
  - `due_date` -- "Due Dates" -- "A due date is approaching or passed"
- On first access, if a user has no preferences rows, create defaults (all enabled).
- The `NotificationService.create()` method (from Task 1.4) already checks preferences before persisting/delivering.

**Acceptance criteria**:
- [ ] GET returns all notification types with their enabled/disabled state.
- [ ] PUT updates preferences correctly and returns the updated state.
- [ ] Default preferences (all enabled) are created for users who have never set preferences.
- [ ] After disabling a type, notifications of that type are no longer stored or delivered to the user.
- [ ] Endpoints require authentication.

**Estimated effort**: 3 hours

---

#### Task 3.2: Notification Preferences UI Page

**Description**: Build a preferences page where users can toggle notification types on/off.

**Files to create/modify**:
- `client/src/pages/NotificationPreferences.tsx` (new)
- `client/src/components/notifications/PreferenceToggle.tsx` (new)
- `client/src/routes.tsx` (modify) -- add route `/settings/notifications`
- `client/src/components/SettingsNav.tsx` (modify) -- add link to notification preferences

**Implementation details**:
- Page title: "Notification Preferences"
- Display each notification type as a row with: label, description, and toggle switch.
- Changes save automatically on toggle (debounced 500ms, or explicit "Save" button -- use explicit Save button for clarity).
- Show success feedback on save ("Preferences saved").
- Show loading state while fetching initial preferences.
- Show error state if save fails, with retry option.

**Acceptance criteria**:
- [ ] Page loads and displays all notification types with their current enabled/disabled state.
- [ ] Toggling a switch and clicking Save updates the preference on the server.
- [ ] Success message is shown after saving.
- [ ] Error message with retry option is shown if save fails.
- [ ] Page is accessible: toggles have labels, save button has clear text.
- [ ] Page is linked from the settings navigation.

**Estimated effort**: 4 hours

---

#### Task 3.3: Notification History Page

**Description**: Build a paginated page displaying all past notifications.

**Files to create/modify**:
- `client/src/pages/NotificationHistory.tsx` (new)
- `client/src/components/notifications/NotificationList.tsx` (new)
- `client/src/routes.tsx` (modify) -- add route `/notifications`

**Implementation details**:
- Displays notifications in reverse chronological order.
- Each item shows: type icon, title, body, timestamp (absolute for items >24h old, relative for recent), read/unread state.
- Pagination: 25 items per page, with "Load more" button (or infinite scroll -- use "Load more" for simplicity).
- Filter controls: filter by type (multi-select dropdown), filter by read/unread status.
- Clicking a notification marks it as read and navigates to the relevant resource.
- "Mark all as read" button at the top.
- Empty state: friendly message when user has no notifications ("No notifications yet. You're all caught up!").

**REST endpoint update**:
- Extend `GET /api/notifications` to support query params: `type` (comma-separated), `is_read` (boolean).

**Acceptance criteria**:
- [ ] Page displays notifications in reverse chronological order.
- [ ] Pagination works: initial load shows 25 items, "Load more" fetches the next 25.
- [ ] Filter by notification type works correctly.
- [ ] Filter by read/unread status works correctly.
- [ ] Clicking a notification marks it as read and navigates to the associated resource.
- [ ] "Mark all as read" button works and updates all visible items.
- [ ] Empty state is displayed when there are no notifications.
- [ ] Page is accessible and keyboard navigable.

**Estimated effort**: 6 hours

---

#### Task 3.4: Unit and Integration Tests for Phase 3

**Description**: Write tests for preferences and history features.

**Files to create/modify**:
- `client/src/__tests__/pages/NotificationPreferences.test.tsx` (new)
- `client/src/__tests__/pages/NotificationHistory.test.tsx` (new)
- `server/src/__tests__/routes/preferenceRoutes.test.ts` (new)

**Test coverage**:
- Preferences page loads and displays all types.
- Toggling and saving updates server state.
- History page renders notifications in correct order.
- Pagination loads additional items.
- Filters work correctly.
- Mark all as read updates UI and server.

**Acceptance criteria**:
- [ ] All tests pass.
- [ ] Key user flows are covered.

**Estimated effort**: 4 hours

---

### Phase 3 Total: ~17 hours

---

## 6. Implementation Order and Dependencies

```
Phase 1 (WebSocket Infrastructure) -- ~22 hours
  Task 1.5 (DB Migration)            [no dependencies]
  Task 1.1 (Server WebSocket)        [no dependencies]
  Task 1.3 (Redis Pub/Sub)           [depends on 1.1]
  Task 1.4 (Notification Service)    [depends on 1.3, 1.5]
  Task 1.2 (Client WebSocket)        [depends on 1.1]
  Task 1.6 (Tests)                   [depends on 1.1-1.5]

Phase 2 (Notification UI) -- ~26 hours
  Task 2.2 (REST API)                [depends on 1.4]
  Task 2.1 (Notification Bell)       [depends on 2.2]
  Task 2.3 (Toast System)            [no dependencies on other Phase 2 tasks]
  Task 2.4 (WebSocket-UI wiring)     [depends on 1.2, 2.1, 2.3]
  Task 2.5 (Tests)                   [depends on 2.1-2.4]

Phase 3 (Preferences & History) -- ~17 hours
  Task 3.1 (Preferences API)         [depends on 1.4]
  Task 3.2 (Preferences UI)          [depends on 3.1]
  Task 3.3 (History Page)            [depends on 2.2]
  Task 3.4 (Tests)                   [depends on 3.1-3.3]
```

**Total estimated effort: ~65 hours (~8-9 working days for a single developer)**

---

## 7. Parallelization Opportunities

With two developers, the following tasks can be done in parallel:

- **Developer A (Backend)**: Tasks 1.1, 1.3, 1.4, 1.5, 2.2, 3.1
- **Developer B (Frontend)**: Tasks 1.2, 2.1, 2.3, 2.4, 3.2, 3.3

This could reduce calendar time to approximately 5-6 working days.

---

## 8. Risk Register

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| Assumed tech stack (React/Node) does not match actual codebase | Medium | High -- significant rework | Validate assumptions with team before starting; plan adapts to any SPA framework |
| WebSocket connections at scale cause memory pressure | Low (for internal app) | Medium | Monitor connection count; Socket.IO supports sticky sessions with Redis adapter for horizontal scaling |
| Redis becomes a single point of failure | Low | High | Deploy Redis with replication; application degrades gracefully (falls back to polling REST endpoints) |
| Notification volume overwhelms PostgreSQL write throughput | Low | Medium | Use batch inserts for high-throughput scenarios; consider partitioning by date if table grows large |
| Cross-tab synchronization causes race conditions on unread count | Medium | Low | Redis counter is the source of truth; periodic reconciliation job corrects drift |

---

## 9. Definition of Done

A feature is considered done when:

- [ ] Code is implemented according to the task specification.
- [ ] Unit tests are written and passing.
- [ ] Integration tests cover key user flows.
- [ ] Code has been reviewed by at least one other developer.
- [ ] No regressions in existing functionality.
- [ ] Notifications are delivered within 2 seconds of the triggering event (performance NFR).
- [ ] WebSocket reconnects automatically with exponential backoff after disconnection (resilience NFR).
- [ ] Feature is accessible (keyboard navigation, ARIA attributes, screen reader compatible).
- [ ] Feature works in the latest versions of Chrome, Firefox, Safari, and Edge.

---

## 10. Open Questions for Stakeholder Review

Before implementation begins, the following should be confirmed:

1. **Tech stack confirmation**: Is the dashboard built with React? What is the existing backend runtime (Node.js/Express assumed)?
2. **Existing database**: Is PostgreSQL already in use, or is there a different primary database?
3. **Redis availability**: Is Redis already part of the infrastructure, or does it need to be provisioned?
4. **Notification types**: Are the five assumed types (`comment`, `status_change`, `assignment`, `mention`, `due_date`) correct and complete?
5. **Priority rules**: What criteria determine whether a notification is "high priority" (triggering a toast)? Currently assumed: all `assignment` and `due_date` notifications are high priority.
6. **Retention policy**: How long should notifications be retained in the database? (No policy defined in PRD; suggest 90 days with automatic cleanup.)
7. **Rate limiting**: Should there be a limit on how many notifications a user can receive per minute to prevent notification fatigue?
