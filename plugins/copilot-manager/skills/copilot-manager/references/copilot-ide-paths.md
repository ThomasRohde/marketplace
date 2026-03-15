# Copilot IDE (VS Code / JetBrains) — Complete File Path Reference

This document lists every file and directory that the Copilot IDE extension discovers as
customization artifacts. Use these paths when scanning a workspace or user home for existing
customizations.

## Workspace-Level Paths

These are relative to the repository/workspace root.

### Guidance (always-on instructions)

| Path | Surface | Notes |
|------|---------|-------|
| `.github/copilot-instructions.md` | copilot_instructions | Primary project-level guidance |
| `.github/instructions/*.instructions.md` | instruction_files | Scoped instruction files |
| `AGENTS.md` | agents_md | Root-level agent definitions. Requires `chat.useAgentsMdFile` enabled (default: true in VS Code 1.109+) |
| `**/AGENTS.md` (subdirs) | agents_md | Nested agent files. Requires `chat.useNestedAgentsMdFiles` enabled |
| `CLAUDE.md` | claude_md | Claude-specific guidance. Requires `chat.useClaudeMdFile` enabled (default: true) |
| `CLAUDE.local.md` | claude_md | Local-only Claude guidance (gitignored) |
| `.claude/CLAUDE.md` | claude_md | Nested Claude guidance |
| `.claude/rules/*.md` | claude_rules | Applying-instructions-style rules |
| `GEMINI.md` | gemini_md | Gemini-specific guidance (cross-read by Copilot IDE) |

### Custom Agents

| Path | Surface | Notes |
|------|---------|-------|
| `.github/agents/*.md` | custom_agent | Primary agent location |
| `.github/chatmodes/*.chatmode.md` | legacy_chatmode | Legacy format, still supported |
| `.claude/agents/*.md` | custom_agent | Claude agents cross-read by Copilot |
| `.agents/skills/*/SKILL.md` | skill | Agent skills in `.agents/` convention |

### Skills

| Path | Surface | Notes |
|------|---------|-------|
| `.github/skills/*/SKILL.md` | skill | Primary skill location (subfolder with SKILL.md) |
| `.claude/skills/*/SKILL.md` | skill | Claude skills cross-read by Copilot |
| `.agents/skills/*/SKILL.md` | skill | Shared agent skills |

### Prompt Files

| Path | Surface | Notes |
|------|---------|-------|
| `.github/prompts/*.prompt.md` | prompt_file | Reusable prompt templates |

### Hooks

| Path | Surface | Notes |
|------|---------|-------|
| `.github/hooks/*.json` | hooks | Event handlers (pre/post tool execution) |
| `.vscode/hooks/*.json` | hooks | VS Code-level hooks |

### Settings & MCP

| Path | Surface | Notes |
|------|---------|-------|
| `.vscode/settings.json` | setting_entry | VS Code workspace settings |
| `.vscode/mcp.json` | mcp | MCP server configuration |
| `.devcontainer.json` | devcontainer_mcp | Dev container MCP servers |
| `.devcontainer/devcontainer.json` | devcontainer_mcp | Alt dev container location |
| `.devcontainer/*.json` | devcontainer_mcp | Multiple dev container files |
| `.claude/settings.json` | setting_entry | Claude settings (hook source) |
| `.claude/settings.local.json` | setting_entry | Local Claude settings (hook source) |

## User-Level Paths

These are relative to the user's home directory (`~` / `$HOME`).

### Settings

| Path | Platform | Notes |
|------|----------|-------|
| `~/.config/Code/User/settings.json` | Linux/macOS | VS Code user settings |
| `~/AppData/Roaming/Code/User/settings.json` | Windows | VS Code user settings |

### Copilot User Artifacts

| Path | Artifact Type |
|------|--------------|
| `~/.copilot/agents/*.md` | custom_agent |
| `~/.copilot/instructions/*.instructions.md` | guidance |
| `~/.copilot/skills/*/SKILL.md` | skill |
| `~/.copilot/mcp-config.json` | mcp |

### Claude User Artifacts (cross-read by Copilot)

| Path | Artifact Type |
|------|--------------|
| `~/.claude/CLAUDE.md` | guidance |
| `~/.claude/rules/*.md` | guidance |
| `~/.claude/agents/*.md` | custom_agent |
| `~/.claude/skills/*/SKILL.md` | skill |
| `~/.agents/skills/*/SKILL.md` | skill |

### VS Code Profile Artifacts

| Path | Artifact Type |
|------|--------------|
| `~/.config/Code/User/agents/*.md` | custom_agent |
| `~/.config/Code/User/prompts/*.prompt.md` | prompt_file |
| `~/.config/Code/User/skills/*/SKILL.md` | skill |
| `~/.config/Code/User/hooks/*.json` | hooks |
| `~/.config/Code/User/mcp.json` | mcp |

## Settings-Driven Locations

VS Code settings can configure additional discovery paths. Check these keys in
`.vscode/settings.json` or user `settings.json`:

| Setting Key | What It Points To |
|-------------|-------------------|
| `chat.instructionsFilesLocations` | Additional instruction file paths |
| `chat.agentFilesLocations` | Additional agent paths |
| `chat.agentSkillsLocations` | Additional skill paths |
| `chat.promptFilesLocations` | Additional prompt paths |
| `chat.hookFilesLocations` | Additional hook paths |
| `chat.plugins.paths` | Explicit plugin paths |
| `github.copilot.chat.modeFilesLocations` | Legacy chatmode paths |

## Plugins

Copilot IDE discovers plugins from:

| Path | Source |
|------|--------|
| `~/.copilot/installed-plugins/<name>/` | Installed plugins |
| `~/.copilot/state/marketplace-cache/<name>/` | Cached marketplace plugins |
| Paths listed in `chat.plugins.paths` setting | Explicit plugins |

Each plugin contains a `plugin.json` manifest (looked up in priority order):
1. `.github/plugin/plugin.json`
2. `.claude-plugin/plugin.json`
3. `plugin.json` (root)

Plugins can declare their own `agents/`, `skills/`, `commands/`, `hooks/`, `mcpServers/`, `lspServers/` directories.

## Glob Patterns for Discovery

Use these patterns with the Glob tool:

```
# Guidance
.github/copilot-instructions.md
.github/instructions/*.instructions.md
AGENTS.md
CLAUDE.md
CLAUDE.local.md
.claude/CLAUDE.md
.claude/rules/*.md
GEMINI.md

# Agents
.github/agents/*.md
.github/chatmodes/*.chatmode.md
.claude/agents/*.md

# Skills
.github/skills/*/SKILL.md
.claude/skills/*/SKILL.md
.agents/skills/*/SKILL.md

# Prompts
.github/prompts/*.prompt.md

# Hooks
.github/hooks/*.json
.vscode/hooks/*.json

# Settings & MCP
.vscode/settings.json
.vscode/mcp.json
.devcontainer.json
.devcontainer/devcontainer.json
.devcontainer/*.json
```
