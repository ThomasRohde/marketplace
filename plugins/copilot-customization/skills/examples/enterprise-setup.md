# Enterprise Project Setup Example

A complete Copilot customization setup for a team building a TypeScript microservice.
This example shows how all primitives work together.

## Directory Structure

```
my-project/
├── .github/
│   ├── copilot-instructions.md          # Always-on project context
│   ├── instructions/
│   │   ├── typescript.instructions.md   # TS-specific rules
│   │   ├── testing.instructions.md      # Test file rules
│   │   └── api.instructions.md          # API route rules
│   ├── prompts/
│   │   ├── new-endpoint.prompt.md       # Scaffold API endpoint
│   │   ├── review-changes.prompt.md     # Code review prompt
│   │   └── pr-description.prompt.md     # Generate PR description
│   ├── agents/
│   │   ├── planner.agent.md             # Read-only planning
│   │   ├── reviewer.agent.md            # Code review specialist
│   │   └── test-writer.agent.md         # Test generation
│   ├── skills/
│   │   └── api-endpoint/               # Complex API scaffolding
│   │       ├── SKILL.md
│   │       ├── templates/
│   │       │   ├── route.ts.template
│   │       │   ├── schema.ts.template
│   │       │   └── route.test.ts.template
│   │       └── examples/
│   │           └── users-endpoint.ts
│   └── hooks/
│       └── security.json                # Security enforcement
├── .vscode/
│   ├── settings.json                    # Copilot settings
│   └── mcp.json                         # MCP server configs
└── scripts/
    └── hooks/
        ├── pre-tool.sh                  # Security hook script
        └── session-start.sh             # Setup hook script
```

## How They Interact

```
User opens VS Code with this project
│
├─ copilot-instructions.md loads automatically (project context)
│
├─ User works on a .ts file
│   └─ typescript.instructions.md also loads (applyTo: **/*.ts)
│
├─ User types "/new-endpoint"
│   └─ new-endpoint.prompt.md runs, agent mode scaffolds the endpoint
│       └─ api-endpoint skill activates (matches "create endpoint")
│           └─ Templates from the skill directory are used
│
├─ User selects @reviewer agent
│   └─ reviewer.agent.md persona loads (read-only code review)
│       └─ testing.instructions.md informs test coverage review
│
├─ User delegates to Copilot coding agent
│   └─ security.json hooks activate
│       └─ pre-tool.sh blocks changes to .env and workflow files
│
└─ Agent commits changes
    └─ post-tool.sh logs the activity
```

## Key Files

### .github/copilot-instructions.md
```markdown
# Payments Service

A TypeScript microservice handling payment processing via Stripe.
Built with Express.js, PostgreSQL (Drizzle ORM), and deployed on AWS ECS.

## Architecture
- Clean Architecture: routes → controllers → services → repositories
- Event-driven: Domain events published to SQS for async processing
- All monetary values stored as integers (cents)

## Commands
- `pnpm dev` — Start dev server with hot reload
- `pnpm test` — Run Vitest test suite
- `pnpm lint` — ESLint + Prettier check
- `pnpm typecheck` — TypeScript strict mode check
- `pnpm db:migrate` — Run Drizzle migrations
- `pnpm db:generate` — Generate migration from schema changes

## Security Requirements
- All endpoints require JWT authentication
- PCI-sensitive data must never be logged
- Input validation with Zod on every route
- Rate limiting on all public endpoints
```

### .github/instructions/api.instructions.md
```yaml
---
applyTo: 'src/routes/**'
---
# API Route Standards

Every API route must follow this pattern:

1. Define Zod schema for request validation
2. Create route handler in controller layer
3. Business logic lives in service layer only
4. Database access only through repository layer
5. Return consistent response format: `{ data, error, meta }`
6. Include OpenAPI JSDoc annotations
7. Write integration tests covering happy path + error cases
```

### .github/prompts/new-endpoint.prompt.md
```yaml
---
description: 'Scaffold a new API endpoint with full Clean Architecture layers'
agent: 'agent'
tools: ['search/codebase', 'read', 'edit']
---
Scaffold a new API endpoint following Clean Architecture.

Ask for: endpoint path, HTTP method, and purpose.

Create these files:
1. `src/routes/<resource>.routes.ts` — Express route definition
2. `src/controllers/<resource>.controller.ts` — Request handling
3. `src/services/<resource>.service.ts` — Business logic
4. `src/repositories/<resource>.repository.ts` — Data access
5. `src/schemas/<resource>.schema.ts` — Zod validation schemas
6. `src/routes/__tests__/<resource>.routes.test.ts` — Integration tests

Follow patterns in [API instructions](../instructions/api.instructions.md)
and [project standards](../copilot-instructions.md).
```

### .github/agents/planner.agent.md
```yaml
---
name: Planner
description: 'Create implementation plans without changing code'
tools: ['search', 'read', 'fetch', 'usages', 'githubRepo']
model: 'Claude Sonnet 4'
handoffs:
  - label: 'Implement Plan'
    agent: agent
    prompt: 'Implement the plan outlined above.'
    send: false
  - label: 'Write Tests First'
    agent: test-writer
    prompt: 'Write tests based on the plan above before implementation.'
    send: false
---
# Planner

You create detailed implementation plans. NEVER modify code.

Output format:
1. **Summary**: What and why
2. **Files to Change**: Create / Modify / Delete
3. **Steps**: Ordered implementation steps with code snippets
4. **Tests**: What to test and test strategy
5. **Risks**: Potential issues and mitigations
6. **Estimates**: Rough complexity (S/M/L)
```

### .github/hooks/security.json
```json
{
  "hooks": [
    {
      "type": "command",
      "event": "pre-tool-execution",
      "bash": "./scripts/hooks/pre-tool.sh",
      "timeoutSec": 10
    }
  ]
}
```

### .vscode/settings.json (Copilot-relevant settings)
```jsonc
{
  "chat.useAgentSkills": true,
  "github.copilot.chat.commitMessageGeneration.instructions": [
    { "text": "Use conventional commits: type(scope): description" },
    { "text": "Scopes: api, db, auth, payments, infra, tests" },
    { "text": "Reference Jira ticket: PAYS-XXX" }
  ],
  "github.copilot.chat.codeGeneration.useInstructionFiles": true
}
```

## Rollout Strategy

1. **Week 1**: Start with `copilot-instructions.md` only — establish project context
2. **Week 2**: Add file-scoped `.instructions.md` for your main technologies
3. **Week 3**: Create 2-3 prompt files for your most repetitive tasks
4. **Week 4**: Add a planner and reviewer agent for workflow structure
5. **Ongoing**: Build skills for complex, repeatable scaffolding tasks
6. **When using coding agent**: Add hooks for security and quality enforcement

## Tips for Teams

- Store all customizations in `.github/` so they're version controlled and shared
- Review and iterate on instructions based on actual Copilot output quality
- Keep the main `copilot-instructions.md` under ~500 words for best results
- Use file-scoped instructions to avoid overloading the global context
- Create a `/init`-style prompt that generates onboarding docs for new team members
- Document your custom agents in the project README
