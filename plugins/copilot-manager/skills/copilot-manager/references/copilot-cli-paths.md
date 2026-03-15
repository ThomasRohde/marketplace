# Copilot CLI (Terminal Agent) — Complete File Path Reference

Copilot CLI is the terminal-based agent (GA February 2026). It has a different discovery
model than Copilot IDE — it walks parent directories, honors environment variables, and
has its own user-level config tree at `~/.copilot/`.

## Repository-Level Paths

Relative to the workspace/repository root.

### Guidance

| Path | Surface | Precedence Rank |
|------|---------|-----------------|
| `AGENTS.md` | agents_md | 10 |
| `CLAUDE.md` | claude_md | — |
| `GEMINI.md` | gemini_md | — |
| `.github/copilot-instructions.md` | copilot_instructions | 20 |
| `.github/instructions/*.instructions.md` | instruction_files | 30 |

> **Note:** Copilot CLI natively reads `CLAUDE.md` and `GEMINI.md` at the repository root
> (not cross-read — they are part of CLI's own instruction discovery).

### Custom Agents

| Path | Surface | Precedence Rank |
|------|---------|-----------------|
| `.github/agents/*.md` | custom_agent | 1 |
| `.claude/agents/*.md` | custom_agent | 201 (lower priority) |

### Skills

| Path | Surface |
|------|---------|
| `.github/skills/*/SKILL.md` | skill |
| `.claude/skills/*/SKILL.md` | skill |
| `.agents/skills/*/SKILL.md` | skill |

### Commands

| Path | Surface |
|------|---------|
| `.claude/commands/*.md` | command |

### Hooks & MCP

| Path | Surface |
|------|---------|
| `.github/hooks/*.json` | hooks |

## User-Level Paths (`~/.copilot/`)

The Copilot CLI user tree lives at `~/.copilot/`, separate from the IDE's user
settings.

| Path | Artifact Type | Precedence Rank |
|------|--------------|-----------------|
| `~/.copilot/config.json` | target_setting | — |
| `~/.copilot/copilot-instructions.md` | guidance | 0 |
| `~/.copilot/instructions/*.instructions.md` | guidance | 1 |
| `~/.copilot/agents/*.md` | custom_agent | 0 |
| `~/.copilot/skills/*/SKILL.md` | skill | — |
| `~/.copilot/mcp-config.json` | mcp | 0 |

### Claude User Artifacts (cross-read by Copilot CLI)

| Path | Artifact Type | Precedence Rank |
|------|--------------|-----------------|
| `~/.claude/agents/*.md` | custom_agent | 200 |
| `~/.claude/skills/*/SKILL.md` | skill | — |
| `~/.claude/commands/*.md` | command | — |

## Parent Directory Chain

Copilot CLI walks from the current directory up to the filesystem root, discovering
artifacts in each parent. This means a monorepo can have per-package customizations
that are inherited by subdirectories.

For each parent directory, it checks:

| Path (relative to parent) | Artifact Type |
|---------------------------|--------------|
| `.github/agents/*.md` | custom_agent |
| `.github/skills/*/SKILL.md` | skill |
| `.github/instructions/*.instructions.md` | guidance |
| `.claude/agents/*.md` | custom_agent |
| `.claude/skills/*/SKILL.md` | skill |
| `.claude/commands/*.md` | command |

## Environment Variables

Copilot CLI respects these environment variables for additional discovery:

| Variable | What It Points To | Separator | Status |
|----------|-------------------|-----------|--------|
| `COPILOT_CUSTOM_INSTRUCTIONS_DIRS` | Extra instruction directories (searches for `AGENTS.md` and `.github/instructions/**/*.instructions.md`) | Comma-separated | Documented |
| `COPILOT_HOME` | Override `~/.copilot/` config location | Single path | Documented |

## Plugins

Same plugin system as Copilot IDE:

| Path | Source |
|------|--------|
| `~/.copilot/installed-plugins/<name>/` | Installed plugins |
| `~/.copilot/state/marketplace-cache/<name>/` | Cached marketplace plugins |

## Key Differences from Copilot IDE

| Feature | Copilot IDE | Copilot CLI |
|---------|-------------|-------------|
| User config root | VS Code settings | `~/.copilot/` |
| Prompt files (`.prompt.md`) | Yes | No |
| Language model overrides | Yes (settings) | No |
| DevContainer MCP | Yes | No |
| VS Code settings-driven paths | Yes | No |
| Parent directory chain | No | Yes |
| Environment variable paths | No | Yes |
| Commands (`.claude/commands/`) | No | Yes |
| Reads CLAUDE.md | Yes (cross-read) | Yes (native) |
| Reads GEMINI.md | Yes (cross-read) | Yes (native) |
| Agent precedence | Repo overrides user | User overrides repo |

## Glob Patterns for Discovery

```
# Repository-level
AGENTS.md
CLAUDE.md
GEMINI.md
.github/copilot-instructions.md
.github/instructions/*.instructions.md
.github/agents/*.md
.github/skills/*/SKILL.md
.github/hooks/*.json
.claude/agents/*.md
.claude/skills/*/SKILL.md
.claude/commands/*.md
.agents/skills/*/SKILL.md

# User-level (~/.copilot/)
~/.copilot/config.json
~/.copilot/copilot-instructions.md
~/.copilot/instructions/*.instructions.md
~/.copilot/agents/*.md
~/.copilot/skills/*/SKILL.md
~/.copilot/mcp-config.json

# User-level (~/.claude/, cross-read)
~/.claude/agents/*.md
~/.claude/skills/*/SKILL.md
~/.claude/commands/*.md
```
