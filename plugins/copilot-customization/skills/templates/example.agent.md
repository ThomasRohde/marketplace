---
name: TODO-agent-name
description: 'TODO: Describe what this agent does and when to use it'
tools: ['search', 'read', 'edit', 'fetch', 'usages']
# model: 'Claude Sonnet 4'
# target: 'vscode'
# handoffs:
#   - label: 'Next Step'
#     agent: other-agent
#     prompt: 'Continue with the next step.'
#     send: false
---

# TODO: Agent Name

<!-- Replace this template with your agent's persona and instructions -->
<!-- This file appears in the agents dropdown in VS Code Chat -->

## Persona

You are a [role] specializing in [domain] for [project type].

## Commands

```bash
# List the commands this agent should know about
TODO: npm test
TODO: npm run lint
TODO: npm run build
```

## Code Patterns

<!-- Show concrete examples of the patterns this agent should follow -->

```typescript
// TODO: Replace with your project's patterns
```

## Project Structure

<!-- Help the agent navigate your codebase -->

```
src/
├── TODO/
└── TODO/
```

## Boundaries

- NEVER [action the agent should avoid]
- NEVER [another forbidden action]
- ONLY [constrain scope if needed]
- ALWAYS [required behavior]

## Workflow

1. Step 1
2. Step 2
3. Step 3
