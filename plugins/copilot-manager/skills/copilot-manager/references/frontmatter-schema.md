# Frontmatter Schema Reference

All Copilot customization files use YAML frontmatter delimited by `---`. This document
covers every recognized field by artifact type.

## Instruction Files (`.instructions.md`)

```yaml
---
applyTo: '**/*.ts'              # Glob pattern — restrict when this instruction applies
                                 # Omit for always-on. Supports: '*.py', 'src/**/*.tsx', etc.
---
```

Only one field is recognized. The body is free-form markdown guidance.

## Custom Agents (`.md` in agents directories)

```yaml
---
name: my-agent                   # Display name (shown in @-mentions)
id: my-agent                     # Identifier (used in handoff references)
description: >                   # What this agent does (shown in agent picker)
  A security-focused code reviewer
  that checks for OWASP top 10.
tools:                           # Tools the agent can use
  - search/codebase
  - read
  - edit
  - fetch
  - usages
  - githubRepo
model: Claude Sonnet 4           # Optional model override
user-invocable: true             # Whether user can invoke directly (default: true)
mode: edit                       # Operation mode: 'agent', 'edit', 'ask'
target:                          # Target runtimes (filter which Copilot reads this)
  - github-copilot
  - vscode
agents:                          # Sub-agents this agent can call
  - searcher
  - reviewer
argument-hint: >                 # Hint shown for argument input
  Describe the code to review
disable-model-invocation: false  # If true, agent can only be invoked by name
infer: true                      # Whether to infer capabilities
mcp-servers:                     # MCP servers this agent requires
  - filesystem
  - github
handoffs:                        # Workflow transitions to other agents
  - label: 'Continue Review'
    agent: reviewer
    prompt: 'Review the changes from the previous step'
    send: false                  # true = auto-submit, false = user confirms
hooks:                           # Inline hooks for this agent
  onFileCreated:
    type: command
    bash: ./scripts/lint.sh
excludeAgent:                    # Exclude from certain agents
  - coding-agent
---
```

## Skills (`SKILL.md`)

```yaml
---
name: my-skill-name              # Lowercase with hyphens
description: >                   # When Copilot should load this skill
  What the skill does.
  Include trigger phrases and use cases.
compatibility:                   # Optional: required tools/deps
  tools:
    - read
    - edit
---
```

The body contains the skill's instructions — loaded into context when triggered.

## Prompt Files (`.prompt.md`) — IDE Only

```yaml
---
description: 'Generate a React component with tests'  # Shown in / menu
agent: agent                     # Target agent: 'agent', 'ask', 'edit', or custom name
model: Claude Sonnet 4           # Optional model override
tools:                           # Available tools for this prompt
  - search/codebase
  - githubRepo
  - read
  - edit
---
```

The body is the prompt template. Can include `${variableName}` placeholders and
`#file:path` references.

## Hooks (`hooks.json`)

Not frontmatter-based. Uses JSON:

```json
{
  "hooks": [
    {
      "type": "command",
      "event": "pre-tool-execution",
      "bash": "./scripts/my-hook.sh",
      "powershell": "./scripts/my-hook.ps1",
      "timeoutSec": 30,
      "description": "Lint before saving"
    }
  ]
}
```

Events: `pre-tool-execution`, `post-tool-execution`, `onFileCreated`, `onFileEdited`,
`onFileDeleted`, `onTerminalCommand`.

## MCP Server Configuration

### `.vscode/mcp.json` (IDE)

```json
{
  "servers": {
    "my-server": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@my/mcp-server"],
      "env": {
        "API_KEY": "${input:api-key}"
      }
    }
  },
  "inputs": [
    {
      "id": "api-key",
      "type": "promptString",
      "description": "API key for my-server"
    }
  ]
}
```

### `.github/mcp.json` (CLI)

Same structure, but the `inputs` mechanism may behave differently in CLI context.

### `~/.copilot/mcp-config.json` (CLI user-level)

```json
{
  "servers": {
    "my-server": {
      "type": "stdio",
      "command": "my-server-binary",
      "args": ["--config", "~/.my-server.json"]
    }
  }
}
```

## Common Frontmatter Parsing Notes

- Frontmatter is delimited by `---` on its own line
- YAML is parsed case-sensitively for field names
- Unknown fields are ignored (forward compatibility)
- Boolean fields default to their type-appropriate default if omitted
- List fields accept both single strings and arrays: `tools: read` and `tools: [read]`
- The `description` field supports multi-line YAML strings (use `>` or `|`)
