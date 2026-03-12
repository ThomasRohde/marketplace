# Examples

Concrete walkthroughs showing `api-anything` in action. Use these as reference when generating guide content, README examples, and test fixtures.

## Table of contents

1. [Example 1: Simple CRUD API (Petstore-class)](#example-1-simple-crud-api)
2. [Example 2: Enterprise API with OAuth2](#example-2-enterprise-api-with-oauth2)
3. [Example 3: Messy spec with missing auth](#example-3-messy-spec-with-missing-auth)
4. [Example 4: Agent workflow — safe delete](#example-4-agent-workflow-safe-delete)

## Example 1: Simple CRUD API

### Input

A minimal Widget API spec with API key auth, 4 CRUD endpoints.

### Generated command tree

```
widget-cli guide
widget-cli spec
widget-cli widget list [--status active|inactive|archived] [--limit 20]
widget-cli widget get --id <id>
widget-cli widget create --data '{"name": "..."}' [--dry-run]
widget-cli widget delete --id <id> [--dry-run] [--force]
```

### Example session

```bash
# Check what the CLI can do
$ widget-cli guide | jq '.result.commands[].name'
"widget.list"
"widget.get"
"widget.create"
"widget.delete"

# List widgets
$ widget-cli widget list --status active --limit 5
{
  "schema_version": "1.0.0",
  "request_id": "a1b2c3d4-...",
  "ok": true,
  "command": "widget.list",
  "result": {
    "items": [
      {"id": "w_001", "name": "Sprocket", "status": "active"},
      {"id": "w_002", "name": "Gear", "status": "active"}
    ],
    "pagination": {"total": 2, "limit": 5, "offset": 0, "has_more": false}
  },
  "error": null,
  "meta": {"duration_ms": 89}
}

# Get a single widget
$ widget-cli widget get --id w_001 | jq '.result.name'
"Sprocket"

# Dry-run a create
$ widget-cli widget create --data '{"name": "Cog"}' --dry-run
{
  "ok": true,
  "command": "widget.create",
  "result": {
    "dry_run": true,
    "planned_changes": [
      {"action": "create", "resource_type": "widget", "data": {"name": "Cog"}}
    ]
  }
}

# Actually create
$ widget-cli widget create --data '{"name": "Cog"}'
{
  "ok": true,
  "command": "widget.create",
  "result": {"id": "w_003", "name": "Cog", "status": "active"}
}

# Delete with force (non-interactive)
$ widget-cli widget delete --id w_003 --force
{
  "ok": true,
  "command": "widget.delete",
  "result": {"deleted": true, "resource_id": "w_003"}
}

# Error case
$ widget-cli widget get --id w_999
{
  "ok": false,
  "command": "widget.get",
  "error": {
    "code": "API_NOT_FOUND",
    "message": "Widget w_999 not found",
    "recoverable": false,
    "suggestion": "Verify the widget ID with: widget-cli widget list"
  }
}
$ echo $?
5
```

## Example 2: Enterprise API with OAuth2

### Input

A customer management API with OAuth2 client credentials, pagination, enum filters, and nested order resources.

### Generated auth config

```yaml
# ~/.customer-cli/config.yaml
version: 1
default_env: test
environments:
  test:
    base_url: https://api-test.example.com/v2
    auth:
      method: oauth2-client-credentials
      token_url: https://auth-test.example.com/oauth/token
      scopes: [read:customers, write:customers, read:orders]
    timeout_ms: 10000

  syst:
    base_url: https://api-syst.example.com/v2
    auth:
      method: oauth2-client-credentials
      token_url: https://auth-syst.example.com/oauth/token
      scopes: [read:customers, write:customers, read:orders]
    timeout_ms: 15000

  prod:
    base_url: https://api.example.com/v2
    auth:
      method: oauth2-client-credentials
      token_url: https://auth.example.com/oauth/token
      scopes: [read:customers, write:customers, read:orders]
      audience: https://api.example.com
    timeout_ms: 30000
```

### Generated command tree

The CLI is generated from the **production** spec — prod defines the canonical command surface. The `--env` flag selects which environment to target at runtime.

```
customer-cli guide
customer-cli spec
customer-cli auth setup --env <name>
customer-cli auth test --env <name>
customer-cli auth refresh --env <name>
customer-cli auth list
customer-cli auth whoami --env <name>

customer-cli customer list [--env test|syst|prod] [--status active|inactive|suspended] [--limit 20] [--cursor <token>]
customer-cli customer get --id <id> [--env test|syst|prod]
customer-cli customer create --data '...' [--dry-run] [--env test|syst|prod]
customer-cli customer update --id <id> --data '...' [--dry-run] [--env test|syst|prod]
customer-cli customer delete --id <id> [--dry-run] [--force] [--env test|syst|prod]
customer-cli customer search --query '...' [--limit 20] [--env test|syst|prod]

customer-cli customer orders list --customer-id <id> [--status pending|shipped|delivered] [--limit 20]
customer-cli customer orders get --customer-id <id> --order-id <id>
```

### Example session

```bash
# Set up auth for test environment
$ export MYCLI_CLIENT_ID=test-client-id
$ export MYCLI_CLIENT_SECRET=test-client-secret
$ customer-cli auth test --env test
{
  "ok": true,
  "command": "auth.test",
  "result": {
    "authenticated": true,
    "identity": "test-client-id",
    "scopes": ["read:customers", "write:customers", "read:orders"],
    "token_expires_in": 3599
  }
}

# List with pagination using cursor (targeting prod)
$ customer-cli customer list --env prod --limit 2
{
  "ok": true,
  "command": "customer.list",
  "result": {
    "items": [
      {"id": "cust_001", "name": "Acme Corp", "status": "active"},
      {"id": "cust_002", "name": "Widgets Inc", "status": "active"}
    ],
    "pagination": {
      "total": 1420,
      "limit": 2,
      "has_more": true,
      "next_cursor": "eyJpZCI6ImN1c3RfMDAyIn0="
    }
  }
}

# Get next page
$ customer-cli customer list --env prod --limit 2 --cursor "eyJpZCI6ImN1c3RfMDAyIn0="

# Nested resource: list orders for a customer
$ customer-cli customer orders list --customer-id cust_001 --status pending
{
  "ok": true,
  "command": "customer.orders.list",
  "result": {
    "items": [
      {"id": "ord_789", "customer_id": "cust_001", "status": "pending", "total": 299.99}
    ],
    "pagination": {"total": 1, "limit": 20, "has_more": false}
  }
}
```

## Example 3: Messy spec with missing auth

### Input

An internal API spec that:
- Has no `securitySchemes` defined
- Uses inconsistent naming (`getUsers`, `fetch_products`, `OrdersList`)
- Has unresolved `$ref` for one schema
- Includes a deprecated endpoint

### Ingestion report (generated)

```json
{
  "ok": true,
  "command": "ingest",
  "result": {
    "spec_version": "openapi 3.0.2",
    "endpoints_found": 12,
    "issues": [
      {
        "severity": "warning",
        "type": "missing_auth",
        "message": "No securitySchemes defined. Auth must be configured via spec-patches.yaml or manual profile setup."
      },
      {
        "severity": "info",
        "type": "naming_normalized",
        "message": "Inconsistent operationIds normalized: getUsers→user.list, fetch_products→product.list, OrdersList→order.list"
      },
      {
        "severity": "error",
        "type": "unresolved_ref",
        "message": "$ref '#/components/schemas/PaymentMethod' not found. Affected endpoint: POST /orders. Using passthrough for this response."
      },
      {
        "severity": "info",
        "type": "deprecated",
        "message": "GET /users/search is deprecated per spec. Included with deprecation warning."
      }
    ],
    "assumptions": [
      "Auth method: custom-headers (default). Override via spec-patches.yaml.",
      "Generated operationIds for 3 endpoints missing them.",
      "PaymentMethod schema responses will be passed through as raw JSON."
    ]
  }
}
```

### Generated spec-patches.yaml (template)

```yaml
# spec-patches.yaml — Operator corrections for the internal API spec
# The spec has no securitySchemes. Configure auth here.
patches:
  - description: "Add API key auth (adjust header name to match your gateway)"
    operation: add
    target: components.securitySchemes
    value:
      GatewayAuth:
        type: apiKey
        in: header
        name: X-Gateway-Token

  - description: "Apply auth to all endpoints"
    operation: add
    target: security
    value:
      - GatewayAuth: []

  - description: "Fix missing PaymentMethod schema"
    operation: add
    target: components.schemas.PaymentMethod
    value:
      type: object
      properties:
        id: { type: string }
        type: { type: string, enum: [credit_card, bank_transfer, crypto] }
        last_four: { type: string }
```

## Example 4: Agent workflow — safe delete

This shows how an agent would use the plan/validate/apply/verify workflow to safely delete a customer.

```bash
# Step 1: Plan the deletion
$ customer-cli customer delete --id cust_123 --plan --env prod
{
  "ok": true,
  "command": "customer.delete",
  "result": {
    "plan_id": "plan_del_abc123",
    "planned_actions": [
      {"step": 1, "action": "verify_exists", "resource": "customer/cust_123", "risk": "none"},
      {"step": 2, "action": "check_dependencies", "resource": "customer/cust_123", "risk": "none"},
      {"step": 3, "action": "delete", "resource": "customer/cust_123", "risk": "high", "reversible": false}
    ],
    "dependencies_found": {
      "orders": 3,
      "invoices": 1
    },
    "warnings": [
      "Customer has 3 active orders and 1 unpaid invoice. Deletion will cascade."
    ],
    "requires_force": true
  }
}

# Step 2: Validate (re-check preconditions)
$ customer-cli customer delete --id cust_123 --validate --plan-id plan_del_abc123 --env prod
{
  "ok": true,
  "command": "customer.delete",
  "result": {
    "plan_id": "plan_del_abc123",
    "valid": true,
    "state_unchanged": true,
    "message": "Preconditions still met. Ready to apply."
  }
}

# Step 3: Apply
$ customer-cli customer delete --id cust_123 --apply --plan-id plan_del_abc123 --force --env prod
{
  "ok": true,
  "command": "customer.delete",
  "result": {
    "plan_id": "plan_del_abc123",
    "applied": true,
    "actions_completed": 3,
    "before": {"id": "cust_123", "name": "Acme Corp", "status": "active", "orders": 3},
    "after": null
  }
}

# Step 4: Verify
$ customer-cli customer delete --id cust_123 --verify --plan-id plan_del_abc123 --env prod
{
  "ok": true,
  "command": "customer.delete",
  "result": {
    "plan_id": "plan_del_abc123",
    "verified": true,
    "assertions": [
      {"check": "resource_deleted", "resource": "customer/cust_123", "passed": true},
      {"check": "api_returns_404", "resource": "customer/cust_123", "passed": true}
    ]
  }
}
```

An agent can follow this workflow mechanically: plan → validate → apply → verify. Each step returns structured JSON, so the agent can parse the result and decide whether to proceed to the next step.

## Example: LLM=true behavior

```bash
# Without LLM=true in a terminal
$ customer-cli customer list --limit 3
┌──────────┬─────────────┬──────────┐
│ ID       │ Name        │ Status   │
├──────────┼─────────────┼──────────┤
│ cust_001 │ Acme Corp   │ active   │
│ cust_002 │ Widgets Inc │ active   │
│ cust_003 │ FooCo       │ inactive │
└──────────┴─────────────┴──────────┘
Showing 3 of 142 customers. Use --cursor for next page.

# With LLM=true
$ LLM=true customer-cli customer list --limit 3
{"schema_version":"1.0.0","request_id":"...","ok":true,"command":"customer.list","result":{"items":[...],"pagination":{...}}}

# Piped (non-TTY) — JSON by default
$ customer-cli customer list --limit 3 | jq '.result.items[0].name'
"Acme Corp"

# Explicit override
$ customer-cli customer list --limit 3 --format json
{"schema_version":"1.0.0",...}
```
