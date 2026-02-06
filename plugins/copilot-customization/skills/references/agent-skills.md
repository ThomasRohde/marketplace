# Agent Skills Reference

Agent Skills are folders containing instructions, scripts, and resources that Copilot
loads on-demand when relevant to a task. Skills are an **open standard** that works across
VS Code, GitHub Copilot CLI, and Copilot coding agent.

## Key Difference from Other Primitives

| Feature | Instructions | Skills |
|---------|-------------|--------|
| Loaded | Always or by file pattern | On-demand, when relevant |
| Content | Guidelines only | Guidelines + scripts + resources |
| Complexity | Simple rules | Complex workflows with assets |
| Portability | VS Code focused | Cross-agent (VS Code, CLI, coding agent) |

**Use instructions** for simple, always-needed coding standards.
**Use skills** for detailed, specialized capabilities with bundled resources.

## Prerequisite

Enable the preview setting:
```jsonc
// .vscode/settings.json
{
  "chat.useAgentSkills": true
}
```

## Directory Structure

```
.github/skills/
└── my-skill-name/
    ├── SKILL.md              # Required — metadata + instructions
    ├── scripts/              # Optional — executable scripts
    │   ├── setup.sh
    │   └── validate.py
    ├── examples/             # Optional — code examples
    │   ├── good-example.ts
    │   └── bad-example.ts
    ├── references/           # Optional — documentation
    │   └── api-spec.md
    └── assets/               # Optional — templates, configs
        └── template.json
```

## SKILL.md Format

```yaml
---
name: my-skill-name           # Required. Lowercase, hyphens for spaces.
description: >                # Required. When Copilot should use this skill.
  Describe what the skill does and when to activate it.
  Include trigger phrases users might say.
  Be specific about use cases.
license: MIT                  # Optional. License for shared skills.
---

# Skill Name

## Overview
Brief description of what this skill enables.

## Instructions
Step-by-step instructions for Copilot to follow when this skill is activated.

## Scripts
Reference scripts in this directory that Copilot can execute:
- `scripts/setup.sh` — Initial setup
- `scripts/validate.py` — Validate output

## Examples
Show Copilot what good output looks like by referencing example files.

## Guidelines
Any constraints, patterns, or anti-patterns to follow.
```

## How Skills Load (Progressive Discovery)

1. **User sends a prompt** (e.g., "Set up a Python project with uv")
2. **Copilot reads skill descriptions** from all `SKILL.md` frontmatter
3. **Matching skill found** → SKILL.md body is injected into context
4. **Copilot references additional files** (scripts, examples) only as needed
5. **Files load lazily** — bundled assets don't consume context until referenced

This means you can install many skills without bloating context — only relevant
skills and their referenced files are loaded per task.

## Storage Locations

| Level | Location | Scope |
|-------|----------|-------|
| Project | `.github/skills/<skill>/SKILL.md` | Single repository |
| Project (legacy) | `.claude/skills/<skill>/SKILL.md` | Also recognized |
| Personal | `~/.copilot/skills/<skill>/SKILL.md` | All projects |
| Personal (legacy) | `~/.claude/skills/<skill>/SKILL.md` | Also recognized |

## Writing Effective Skills

### 1. Description is Critical
The `description` field determines whether your skill gets activated. Write it like
a search query match — include the phrases users would say:

```yaml
description: >
  Set up Python projects on Windows using uv package manager.
  Use when asked to "create python project", "set up uv",
  "initialize python environment", or "scaffold python app".
```

### 2. Include Executable Scripts
Skills are most powerful when they include scripts Copilot can run:

```bash
#!/bin/bash
# scripts/setup.sh — Project scaffolding

set -e

PROJECT_NAME="${1:-my-project}"
mkdir -p "$PROJECT_NAME/src" "$PROJECT_NAME/tests"

# Create pyproject.toml
cat > "$PROJECT_NAME/pyproject.toml" << EOF
[project]
name = "$PROJECT_NAME"
version = "0.1.0"
requires-python = ">=3.11"
EOF

echo "Project $PROJECT_NAME created successfully"
```

### 3. Show Good vs Bad Examples
```markdown
## Examples

### Good: Error handling with proper types
See [examples/good-error-handling.ts](examples/good-error-handling.ts)

### Bad: Swallowing errors silently  
See [examples/bad-error-handling.ts](examples/bad-error-handling.ts)

Copilot should follow the good pattern and avoid the bad pattern.
```

### 4. Reference External Docs
```markdown
## References
- [API specification](references/api-spec.md) — Full API contract
- [Database schema](references/schema.sql) — Current DB schema
- [Architecture decision records](references/adr/) — Why we made certain choices
```

## Example: Complete Skill

```
.github/skills/react-component/
├── SKILL.md
├── templates/
│   ├── component.tsx.template
│   ├── component.test.tsx.template
│   └── component.stories.tsx.template
└── examples/
    └── Button.tsx
```

**SKILL.md:**
```yaml
---
name: react-component
description: >
  Scaffold React components with tests, stories, and proper TypeScript types.
  Use when asked to "create component", "new component", "scaffold component",
  or "generate react component".
---

# React Component Scaffolding

Create new React components following project conventions.

## Steps
1. Ask for component name and purpose if not provided
2. Create component directory: `src/components/<ComponentName>/`
3. Generate files from templates in this skill's `templates/` directory
4. Adapt the template to the specific component requirements
5. Add barrel export in the component's index.tsx

## File Structure
Each component directory contains:
- `<ComponentName>.tsx` — Component implementation
- `<ComponentName>.test.tsx` — Unit tests
- `<ComponentName>.stories.tsx` — Storybook stories
- `index.tsx` — Barrel export

## Templates
- [Component template](templates/component.tsx.template)
- [Test template](templates/component.test.tsx.template)
- [Stories template](templates/component.stories.tsx.template)

## Example
See [Button example](examples/Button.tsx) for reference implementation.

## Conventions
- Use `React.FC<Props>` with explicit interface
- Props interface named `<ComponentName>Props`
- Use `forwardRef` for components accepting `ref`
- Include `data-testid` attributes for testing
```

## Community Skills

- **github/awesome-copilot** — Community collection of skills
- **anthropics/skills** — Reference skills from Anthropic

Always review shared skills before using them in your project.

## Tips

- Skill directory names: lowercase, hyphens, match the `name` field
- Skills may take 5-10 minutes to index after creation
- Test by asking Copilot something that matches your skill's description
- Use the Chat Debug View to verify skill loading
- Combine skills with custom agents — agents can leverage skills automatically
