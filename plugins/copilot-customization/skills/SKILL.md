---
name: copilot-customization
description: >
  Create, scaffold, and configure GitHub Copilot customizations for VS Code projects.
  Covers custom instructions (.instructions.md), prompt files (.prompt.md), custom agents
  (.agent.md), agent skills (SKILL.md folders), hooks (.github/hooks/), and MCP server
  integration. Use when asked to "set up copilot", "create an agent", "add instructions",
  "create a prompt", "scaffold a skill", "configure hooks", "customize copilot", or when
  building any GitHub Copilot customization for VS Code or GitHub.com.
---

# GitHub Copilot Customization Skill

Create and manage the full spectrum of GitHub Copilot customizations for VS Code (1.109+),
GitHub Copilot CLI, and Copilot coding agent.

## Decision Tree — Which Primitive to Use

Before creating anything, determine the right customization type:

```
User request
│
├─ "Set up Copilot for this project" or "/init"
│   → Generate .github/copilot-instructions.md  (always-on instructions)
│   → See: references/instructions.md
│
├─ "Rules for specific file types" (e.g., "all .tsx files should...")
│   → Create .instructions.md with applyTo glob pattern
│   → See: references/instructions.md
│
├─ "Reusable task" (e.g., "scaffold a component", "generate tests")
│   → Create .prompt.md in .github/prompts/
│   → See: references/prompt-files.md
│
├─ "Specialized persona" (e.g., "code reviewer", "security auditor", "planner")
│   → Create .agent.md in .github/agents/
│   → See: references/custom-agents.md
│
├─ "Teach Copilot a complex capability with scripts/resources"
│   → Create skill folder in .github/skills/<name>/SKILL.md
│   → See: references/agent-skills.md
│
├─ "Run checks before/after agent actions" (lint, security, logging)
│   → Create hooks.json in .github/hooks/
│   → See: references/hooks.md
│
├─ "Connect external services" (databases, APIs, issue trackers)
│   → Configure MCP servers in .vscode/mcp.json or settings
│   → See: references/mcp-servers.md
│
└─ "Full project setup" or "enterprise customization"
    → Combine multiple primitives (see examples/enterprise-setup.md)
```

## Quick Reference: File Locations

| Primitive       | Workspace Location                       | User/Profile Location         |
|----------------|------------------------------------------|-------------------------------|
| Instructions   | `.github/copilot-instructions.md`        | VS Code profile folder        |
|                | `.github/instructions/*.instructions.md` |                               |
| Prompts        | `.github/prompts/*.prompt.md`            | VS Code profile folder        |
| Agents         | `.github/agents/*.agent.md`              | VS Code profile folder        |
| Skills         | `.github/skills/<name>/SKILL.md`         | `~/.copilot/skills/<name>/`   |
| Hooks          | `.github/hooks/*.json`                   | N/A (repo-level only)         |
| MCP Servers    | `.vscode/mcp.json`                       | VS Code settings              |

## Quick Reference: Frontmatter Fields

### Instructions (.instructions.md)
```yaml
---
applyTo: '**/*.ts'        # Glob pattern — when to apply (omit for always-on)
---
```

### Prompt Files (.prompt.md)
```yaml
---
description: 'Short description shown in / menu'
agent: 'agent'            # Target agent: 'agent', 'ask', 'edit', or custom name
model: 'Claude Sonnet 4'  # Optional model override
tools: ['search/codebase', 'githubRepo', 'read', 'edit']  # Available tools
---
```

### Custom Agents (.agent.md)
```yaml
---
name: my-agent             # Display name
description: 'What this agent does and when to use it'
tools: ['search', 'read', 'edit', 'fetch', 'usages']
model: 'Claude Sonnet 4'  # Optional model
handoffs:                  # Optional workflow transitions
  - label: 'Next Step'
    agent: other-agent
    prompt: 'Continue with...'
    send: false            # true = auto-submit
---
```

### Agent Skills (SKILL.md)
```yaml
---
name: my-skill-name        # Lowercase, hyphens for spaces
description: >
  What the skill does and when Copilot should load it.
  Be specific about trigger phrases and use cases.
---
```

### Hooks (hooks.json)
```json
{
  "hooks": [
    {
      "type": "command",
      "event": "pre-tool-execution",
      "bash": "./scripts/my-hook.sh",
      "powershell": "./scripts/my-hook.ps1",
      "timeoutSec": 30
    }
  ]
}
```

## Workflow: Creating Customizations

1. **Identify the need** — Use the decision tree above
2. **Read the reference** — Open the relevant file from `references/`
3. **Copy the template** — Start from the matching file in `templates/`
4. **Customize** — Follow the guidelines in the reference document
5. **Test** — Use the Chat Debug View (Ctrl+Shift+P → "Chat: Open Debug View")
6. **Iterate** — Refine based on actual agent behavior

## Progressive Discovery

This skill uses **progressive discovery** — only load what you need:

- **This file (SKILL.md)**: Decision tree + quick reference (always loaded first)
- **references/**: Deep-dive documentation per primitive (load on demand)
- **templates/**: Copy-paste starting points (load when scaffolding)
- **examples/**: Real-world configurations (load for inspiration)

When Copilot loads this skill, start here. Only read reference files when you need
detailed guidance on a specific primitive. Only read templates when you need to
generate files. Only read examples when the user wants a comprehensive setup.

## Important Notes

- Agent Skills require the `chat.useAgentSkills` setting enabled (preview feature)
- Hooks work with Copilot coding agent and Copilot CLI (not local chat)
- Custom agents were previously called "chat modes" — `.chatmode.md` files still work
- Skills in `.claude/skills/` directories are also recognized by Copilot
- The `/init` command auto-generates initial instructions from your project
- Use the Chat Debug View to verify which instructions/skills are loaded
