# Normalization Guide

How to transform a raw OpenAPI / Swagger spec into a clean, resource-oriented command model. This is the most important step in the pipeline — it determines whether the generated CLI feels like a thoughtful tool or a thin HTTP wrapper.

## Table of contents

1. [The normalization pipeline](#the-normalization-pipeline)
2. [Resource extraction](#resource-extraction)
3. [Command naming](#command-naming)
4. [Operation classification](#operation-classification)
5. [Flag derivation](#flag-derivation)
6. [Handling messy specs](#handling-messy-specs)
7. [Intermediate representation](#intermediate-representation)

## The normalization pipeline

```
Raw Spec → Parse → Resolve Refs → Extract Resources → Classify Operations
    → Normalize Names → Derive Flags → Build Command Tree → IR
```

Each step produces a defined output. Do not skip steps or combine them. The pipeline prevents the common failure mode of generating ad-hoc code directly from raw path strings.

## Resource extraction

### Step 1: Identify resource families

Group operations by the resource they operate on. Use these signals in priority order:

1. **Tags** — if the spec uses tags consistently, each tag is a resource family
2. **Path prefix** — `/customers`, `/customers/{id}`, `/customers/{id}/orders` → `customer` resource with `order` as a sub-resource
3. **Schema names** — if request/response schemas reference `Customer`, `Order`, etc., use those as resource names
4. **OperationId prefix** — `listCustomers`, `getCustomer`, `createCustomer` → `customer`

### Step 2: Resolve sub-resources

Decide whether nested paths become sub-commands or flags:

| Pattern | CLI mapping | Rationale |
|---------|------------|-----------|
| `/customers/{id}/orders` | `mycli customer orders list --customer-id 123` | Sub-resource with its own CRUD |
| `/customers/{id}/activate` | `mycli customer activate --id 123` | Action on a resource, not a sub-resource |
| `/customers/{id}/orders/{orderId}` | `mycli customer orders get --customer-id 123 --order-id 456` | Nested resource access |
| `/reports/daily` | `mycli report daily` | Fixed sub-command, not parameterized |

### Step 3: Handle singleton resources

Some APIs have singleton paths like `/me`, `/settings`, `/health`:

- `/me` → `mycli me` or `mycli account whoami`
- `/settings` → `mycli settings get`, `mycli settings update`
- `/health` → `mycli health check`

## Command naming

### Naming conventions

| Concept | Convention | Example |
|---------|-----------|---------|
| Resource names | singular noun, kebab-case | `customer`, `api-key`, `billing-account` |
| Action verbs | standard set (see below) | `list`, `get`, `create`, `update`, `delete` |
| Sub-resources | nested commands | `customer orders list` |
| Command separator | space (not colon or dot) | `mycli customer list` |
| Flag names | `--kebab-case` | `--customer-id`, `--dry-run` |

### Standard verb mapping

| HTTP method + path pattern | CLI verb | Example |
|---|---|---|
| `GET /resources` | `list` | `mycli customer list` |
| `GET /resources/{id}` | `get` | `mycli customer get --id 123` |
| `POST /resources` | `create` | `mycli customer create --data '{...}'` |
| `PUT /resources/{id}` | `replace` | `mycli customer replace --id 123 --data '{...}'` |
| `PATCH /resources/{id}` | `update` | `mycli customer update --id 123 --data '{...}'` |
| `DELETE /resources/{id}` | `delete` | `mycli customer delete --id 123` |
| `POST /resources/{id}/action` | `action-name` | `mycli customer activate --id 123` |
| `GET /resources/{id}/sub` | `sub list` | `mycli customer orders list --customer-id 123` |

### When the standard verbs don't fit

Some APIs use non-CRUD patterns:

| API pattern | CLI mapping |
|---|---|
| `POST /search` | `mycli <resource> search --query '...'` |
| `POST /batch` | `mycli <resource> batch --data '[...]'` |
| `POST /export` | `mycli <resource> export --format csv` |
| `POST /import` | `mycli <resource> import --file data.csv` |
| `POST /validate` | `mycli <resource> validate --data '{...}'` |

Use the operation's semantic intent, not its HTTP method, to choose the verb.

## Operation classification

Classify every operation to determine safety behavior:

```
┌─────────────┬──────────────┬───────────┬──────────────┬─────────────┐
│ Class       │ HTTP methods │ Side      │ Retry safe?  │ Safety      │
│             │              │ effects?  │              │ features    │
├─────────────┼──────────────┼───────────┼──────────────┼─────────────┤
│ read        │ GET, HEAD    │ No        │ Yes          │ None needed │
│ create      │ POST         │ Yes       │ With idemp.  │ --dry-run   │
│ update      │ PUT, PATCH   │ Yes       │ With idemp.  │ --dry-run   │
│ delete      │ DELETE       │ Yes       │ No           │ --dry-run,  │
│             │              │           │              │ --force     │
│ bulk-write  │ POST (batch) │ Yes       │ With idemp.  │ --dry-run,  │
│             │              │           │              │ --force     │
│ admin       │ Any on admin │ Yes       │ Depends      │ plan/apply, │
│             │ paths        │           │              │ --force     │
│ long-run    │ POST (async) │ Yes       │ With idemp.  │ --dry-run,  │
│             │              │           │              │ poll status │
└─────────────┴──────────────┴───────────┴──────────────┴─────────────┘
```

### Risk levels

Assign risk levels to write operations:

| Risk | Criteria | Example | Safety requirement |
|------|----------|---------|-------------------|
| low | Creates non-critical resource | Create tag, add label | `--dry-run` |
| medium | Modifies existing resource | Update customer name | `--dry-run` |
| high | Deletes resource or changes access | Delete user, revoke API key | `--dry-run`, `--force`, plan/apply |
| critical | Irreversible with broad impact | Delete org, purge all data | `--dry-run`, `--force`, plan/validate/apply/verify |

## Flag derivation

### Path parameters → required flags

```yaml
# Spec
/customers/{customerId}/orders/{orderId}:
  get: ...

# CLI
mycli customer orders get --customer-id <id> --order-id <id>
```

Convert `camelCase` path params to `--kebab-case` flags. Always make path params required.

### Query parameters → optional flags

```yaml
# Spec
parameters:
  - name: status
    in: query
    schema:
      type: string
      enum: [active, inactive]
  - name: limit
    in: query
    schema:
      type: integer
      default: 20

# CLI
mycli customer list [--status active|inactive] [--limit 20]
```

Preserve defaults. For enum params, document valid values in `--help`.

### Request body → --data flag or stdin

```yaml
# Simple body
mycli customer create --data '{"name": "Acme", "email": "acme@example.com"}'

# From file
mycli customer create --data @customer.json

# From stdin
cat customer.json | mycli customer create --data -

# Individual fields (optional convenience, for simple bodies)
mycli customer create --name "Acme" --email "acme@example.com"
```

For complex bodies, prefer `--data` with JSON. For simple bodies (3-5 scalar fields), optionally generate individual flags as convenience.

### Headers → config-managed, not flags

Headers that are part of auth or environment config should not be flags. Only expose headers as flags if they are genuinely per-operation (e.g., `If-Match` for conditional updates, `Accept-Language` for localization).

## Handling messy specs

Real-world specs are messy. Here's how to handle common problems:

### Missing operationIds

Generate them from the path and method:

```
GET /customers → listCustomers
GET /customers/{id} → getCustomer
POST /customers → createCustomer
DELETE /customers/{id} → deleteCustomer
```

Flag in the ingestion report: "Generated operationIds — spec did not provide them."

### Inconsistent naming

If the spec uses `getCustomers` for one endpoint and `fetch_orders` for another, normalize both:
- `getCustomers` → `customer list`
- `fetch_orders` → `order list`

Document the mapping in the ingestion report.

### Missing response schemas

If an endpoint has no response schema, generate a passthrough:
- Return the raw API response inside the `result` field of the envelope
- Flag in the ingestion report: "No response schema for GET /widgets — passing through raw response."

### Duplicate paths after normalization

If two different paths normalize to the same command name:
- `/api/v1/users` and `/api/v2/users` → add version prefix: `mycli user-v1 list`, `mycli user-v2 list`
- Or prefer the higher version and alias the other

Report the collision and the resolution in the ingestion report.

### Deprecated endpoints

Include deprecated endpoints with a `[DEPRECATED]` tag in help and guide output. Emit a warning to stderr when they are used:

```
[WARN] customer legacy-search is deprecated. Use customer search instead.
```

## Intermediate representation

After normalization, produce a structured IR that drives code generation. The IR is the single source of truth for the command tree.

```json
{
  "cli_name": "mycli",
  "version": "1.0.0",
  "schema_version": "1.0.0",
  "base_url_template": "https://api.example.com",
  "auth_schemes": [...],
  "resources": [
    {
      "name": "customer",
      "description": "Manage customers",
      "commands": [
        {
          "name": "list",
          "description": "List customers with optional filtering",
          "type": "read",
          "risk": "none",
          "http_method": "GET",
          "http_path": "/customers",
          "flags": [
            {
              "name": "--status",
              "type": "string",
              "required": false,
              "enum": ["active", "inactive"],
              "description": "Filter by status",
              "maps_to": "query.status"
            },
            {
              "name": "--limit",
              "type": "integer",
              "required": false,
              "default": 20,
              "description": "Max results per page",
              "maps_to": "query.limit"
            }
          ],
          "response_schema": { "$ref": "Widget[]" },
          "examples": [
            "mycli customer list",
            "mycli customer list --status active --limit 10"
          ]
        },
        {
          "name": "delete",
          "description": "Delete a customer",
          "type": "write",
          "risk": "high",
          "http_method": "DELETE",
          "http_path": "/customers/{customerId}",
          "flags": [
            {
              "name": "--id",
              "type": "string",
              "required": true,
              "description": "Customer ID",
              "maps_to": "path.customerId"
            },
            {
              "name": "--dry-run",
              "type": "boolean",
              "required": false,
              "default": false,
              "description": "Preview without executing"
            },
            {
              "name": "--force",
              "type": "boolean",
              "required": false,
              "default": false,
              "description": "Skip confirmation"
            }
          ],
          "safety": {
            "dry_run": true,
            "force_required": true,
            "plan_apply": true,
            "idempotency_key": false
          },
          "examples": [
            "mycli customer delete --id 123 --dry-run",
            "mycli customer delete --id 123 --force"
          ]
        }
      ]
    }
  ],
  "assumptions": [
    {
      "source": "spec",
      "issue": "No operationId for DELETE /customers/{id}",
      "assumption": "Generated operationId: deleteCustomer",
      "patchable": true
    }
  ]
}
```

This IR is written to `cli-model.json` in the generated project. It serves as:
1. Input to code generation
2. Input to `guide` command rendering
3. A diffable contract for tracking changes across regenerations
4. Documentation for operators
