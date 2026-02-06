# Custom Agents Reference

Custom agents (`.agent.md`) define specialized AI personas with specific tools,
instructions, and behaviors. They appear in the agents dropdown in VS Code Chat.

Previously called "chat modes" (`.chatmode.md`), which are still recognized.

## File Structure

```yaml
---
name: my-agent                    # Display name (optional, defaults to filename)
description: 'What this agent does and when to use it'
tools: ['search', 'read', 'edit', 'fetch', 'usages']  # Available tools
model: 'Claude Sonnet 4'         # Optional model override
target: 'vscode'                 # Optional: 'vscode' or 'github-copilot'
handoffs:                        # Optional workflow transitions
  - label: 'Implement Plan'
    agent: agent                  # Target agent name or 'agent' for default
    prompt: 'Implement the plan outlined above.'
    send: false                   # true = auto-submit the prompt
---

# Agent Instructions

Detailed persona, behavior rules, and guidelines in Markdown.
Reference tools with #tool:<tool-name> syntax.
Reference workspace files with [relative links](../path/to/file.md).
```

## Frontmatter Fields

| Field | Required | Description |
|-------|----------|-------------|
| `name` | No | Display name. Defaults to filename without extension. |
| `description` | Yes | Shown in agent picker. Describes purpose and trigger. |
| `tools` | No | Array of tool names. Omit to enable ALL tools. |
| `model` | No | AI model override for this agent. |
| `target` | No | `'vscode'` or `'github-copilot'`. Omit for both. |
| `handoffs` | No | Array of workflow transition buttons. |

## Handoffs

Handoffs create workflow buttons that transition to another agent:

```yaml
handoffs:
  - label: 'Start Implementation'    # Button text
    agent: implementation             # Target agent name
    prompt: 'Implement the plan.'     # Pre-filled prompt text
    send: false                       # false = user reviews before sending
  - label: 'Run Tests'
    agent: test-specialist
    prompt: 'Run tests for the changes above.'
    send: true                        # true = auto-submits immediately
```

## Storage Locations

| Type | Location | Scope |
|------|----------|-------|
| Workspace | `.github/agents/*.agent.md` | Current workspace |
| User profile | VS Code profile folder | All workspaces |
| Organization | `.github-private/agents/*.agent.md` | All org repos |
| Enterprise | `.github-private/agents/*.agent.md` | All enterprise repos |

## Available Tool Aliases

When specifying `tools:`, use these aliases:

| Alias | Description |
|-------|-------------|
| `read` | Read file contents |
| `edit` | Create and edit files |
| `search` | Search workspace files |
| `fetch` | Fetch web URLs |
| `usages` | Find references and usages |
| `githubRepo` | GitHub repository context |
| `web` | Web search |
| `agent` | Run sub-agents |
| `vscode/askQuestions` | Prompt user for input |
| `vscode/vscodeAPI` | VS Code API knowledge |

For MCP tools: `mcp-server-name/tool-name`

## Writing Effective Agent Instructions

Based on analysis of 2,500+ agent files, successful agents have:

### 1. Specific Persona
```markdown
You are a security auditor specializing in OWASP Top 10 vulnerabilities
for Node.js applications using Express and PostgreSQL.
```
NOT: "You are a helpful coding assistant."

### 2. Executable Commands Early
```markdown
## Commands
- Lint: `npm run lint`
- Test: `npm test`  
- Type check: `npx tsc --noEmit`
- Security audit: `npm audit`
```

### 3. Code Examples Over Explanations
```markdown
## Error Handling Pattern
Use this pattern for API routes:

\`\`\`typescript
export async function handler(req: Request) {
  try {
    const data = schema.parse(await req.json());
    const result = await service.process(data);
    return Response.json(result);
  } catch (error) {
    if (error instanceof ZodError) {
      return Response.json({ errors: error.issues }, { status: 400 });
    }
    logger.error('Unhandled error', { error });
    return Response.json({ error: 'Internal error' }, { status: 500 });
  }
}
\`\`\`
```

### 4. Clear Boundaries
```markdown
## Boundaries
- NEVER modify files in `src/core/` without explicit user approval
- NEVER remove or skip existing tests
- NEVER commit directly — always stage changes for review
- ONLY write to the `tests/` directory when generating tests
```

### 5. Project Structure Context
```markdown
## Project Structure
- `src/app/` — Next.js pages and layouts
- `src/components/` — Shared UI (do not duplicate)
- `src/lib/` — Business logic (pure functions, testable)
- `src/db/` — Drizzle ORM schema and migrations
```

### 6. Git Workflow
```markdown
## Git Workflow
- Branch naming: `type/description` (e.g., `feat/user-auth`)
- Commit format: conventional commits
- Always run `npm run lint && npm test` before committing
```

## Example Agents

### Planner Agent (Read-Only)
```yaml
---
name: Planner
description: 'Generate implementation plans without making code changes'
tools: ['search', 'read', 'fetch', 'usages', 'githubRepo']
model: 'Claude Sonnet 4'
handoffs:
  - label: 'Implement Plan'
    agent: agent
    prompt: 'Implement the plan outlined above.'
    send: false
---
# Planning Mode

You are in planning mode. Generate implementation plans only.
DO NOT make any code edits. Output a structured Markdown plan with:

1. **Overview**: What we're building and why
2. **Affected Files**: List files to create/modify/delete
3. **Implementation Steps**: Ordered, detailed steps
4. **Testing Strategy**: What tests to write
5. **Risks**: Potential issues and mitigations
```

### Test Specialist Agent
```yaml
---
name: test-specialist
description: 'Write and improve tests without modifying production code'
tools: ['search', 'read', 'edit', 'usages']
---
# Test Specialist

You focus exclusively on testing. Write, improve, and fix tests.

## Rules
- NEVER modify source code — only test files
- Use Vitest with React Testing Library
- Follow AAA pattern (Arrange, Act, Assert)
- Include edge cases and error scenarios
- Run `npm test -- --run` after writing tests to verify

## Test File Conventions
- Location: `__tests__/` next to source, or `*.test.ts(x)`
- Naming: `describe('ComponentName')` → `it('should behavior')`
```

### Code Reviewer Agent
```yaml
---
name: reviewer
description: 'Review code for quality, security, and best practices'
tools: ['search', 'read', 'usages', 'vscode/askQuestions']
---
# Code Reviewer

You are a senior developer conducting thorough code reviews.
Review for quality and adherence to [project standards](../copilot-instructions.md).

## DO NOT
- Write or suggest specific code changes
- Make any file modifications

## Review Checklist
1. **Correctness**: Logic errors, race conditions, null safety
2. **Security**: Input validation, auth, data exposure, injection
3. **Performance**: Complexity, unnecessary work, memory leaks
4. **Readability**: Naming, structure, documentation
5. **Testing**: Coverage gaps, missing edge cases

Present findings by severity: 🔴 Critical → 🟡 Warning → 🔵 Suggestion
```

## Tips

- Start with 2-3 agents, add more as needed
- Use handoffs to create multi-step workflows (plan → implement → test)
- The `target` field lets you create VS Code-only or GitHub.com-only agents
- Organization-level agents in `.github-private` apply to all repos
- Use the Configure Tools dialog in VS Code to visually select available tools
