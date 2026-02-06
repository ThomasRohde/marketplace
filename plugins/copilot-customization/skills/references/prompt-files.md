# Prompt Files Reference

Prompt files (`.prompt.md`) are reusable, parameterized prompts that appear as `/` slash
commands in Copilot Chat. They encode common tasks with specific context and instructions.

## File Structure

```yaml
---
description: 'Short description shown when browsing / commands'
agent: 'agent'                    # Optional: target agent
model: 'Claude Sonnet 4'          # Optional: model override
tools: ['search/codebase', 'read', 'edit', 'githubRepo']  # Optional: available tools
---

# Prompt body in Markdown

Your detailed instructions here. Use imperative mood — address Copilot directly.

Reference workspace files with relative Markdown links:
[coding standards](../copilot-instructions.md)

Reference tools inline: Use #tool:search to find relevant code.
```

## Frontmatter Fields

| Field | Required | Description |
|-------|----------|-------------|
| `description` | Yes | Shown in the `/` command picker. Keep under 100 chars. |
| `agent` | No | `'agent'`, `'ask'`, `'edit'`, or a custom agent name. If tools are specified and current agent is ask/edit, defaults to `'agent'`. |
| `model` | No | Override the model. E.g., `'Claude Sonnet 4'`, `'GPT-4o'`, `'o3-mini'` |
| `tools` | No | Array of tool names/aliases available during execution |

## Available Tools

### Built-in Tool Aliases
| Alias | Description |
|-------|-------------|
| `search` or `search/codebase` | Search across workspace files |
| `read` | Read file contents |
| `edit` | Edit files |
| `fetch` | Fetch web URLs |
| `githubRepo` | Access GitHub repository context |
| `usages` | Find symbol usages |
| `vscode/askQuestions` | Prompt the user for input |
| `vscode/vscodeAPI` | Access VS Code API information |
| `agent` | Invoke a sub-agent |
| `web` | Web search |

### MCP Server Tools
Reference MCP tools with `server-name/tool-name` syntax:
```yaml
tools: ['github/create_issue', 'slack/send_message']
```

## Storage Locations

| Type | Location | Scope |
|------|----------|-------|
| Workspace | `.github/prompts/*.prompt.md` | Current workspace only |
| User profile | VS Code profile folder | All workspaces |
| Additional folders | Configure via `chat.promptFiles.sourceFolder` setting | Custom |

## Creating a Prompt File

1. Run Command Palette → "Chat: New Prompt File"
2. Choose workspace or user profile location
3. Name the file (becomes the `/` command name)
4. Write frontmatter + body

## Invoking Prompts

- Type `/` in the chat input → select from picker
- Type `/prompt-name` directly
- Prompts can reference other prompts or agents

## Body Writing Guidelines

1. **Use imperative mood**: "Generate a component" not "You should generate"
2. **Be specific**: Include exact file paths, naming conventions, patterns
3. **Reference files**: `[style guide](../docs/style-guide.md)` pulls file content into context
4. **Reference tools**: `#tool:search` to hint at tool usage
5. **Structure with sections**: Use headings to organize complex prompts
6. **Ask for missing info**: "Ask for the component name if not provided"

## Examples

### Component Generator
```markdown
---
description: 'Generate a new React component with tests and stories'
agent: 'agent'
tools: ['search/codebase', 'read', 'edit']
---

Generate a new React component following project conventions.

Ask for the component name and purpose if not provided.

## Requirements
- Create the component in `src/components/<ComponentName>/`
- Include: `index.tsx`, `<ComponentName>.test.tsx`, `<ComponentName>.stories.tsx`
- Follow patterns from [component guidelines](../instructions/react.instructions.md)
- Use TypeScript interfaces for all props
- Include JSDoc documentation on the exported component
- Add barrel export in the component's `index.tsx`
```

### Code Review Prompt
```markdown
---
description: 'Review staged changes for quality and best practices'
agent: 'ask'
tools: ['search/codebase', 'read']
---

Review the currently staged git changes. Analyze for:

1. **Correctness**: Logic errors, edge cases, null handling
2. **Standards**: Adherence to [project standards](../copilot-instructions.md)
3. **Security**: Input validation, auth checks, data exposure
4. **Performance**: Unnecessary re-renders, N+1 queries, memory leaks
5. **Testing**: Whether changes need new or updated tests

Present findings organized by severity: Critical → Warning → Suggestion.
Do NOT suggest code changes — explain what should change and why.
```

### PR Description Generator
```markdown
---
description: 'Generate a PR description from staged changes'
agent: 'ask'
tools: ['search/codebase']
---

Generate a pull request description for the current staged changes.

## Format
- **Title**: Conventional commit format (`type(scope): description`)
- **Summary**: 2-3 sentences explaining the change
- **Changes**: Bullet list of what changed and why
- **Testing**: How to verify the changes
- **Screenshots**: Note if UI changes need screenshots

Reference: [PR template](../PULL_REQUEST_TEMPLATE.md) if it exists.
```

## Tips

- Prompt file names become the `/command` — use short, descriptive names
- The `/init` command itself is a prompt file you can customize
- Prompts can reference custom agents via `agent: my-custom-agent`
- Use `model:` to select fast models for simple tasks, reasoning models for complex ones
- Combine with instructions: prompts can link to `.instructions.md` files for context
