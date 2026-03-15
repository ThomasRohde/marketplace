# Cross-Target Reconciliation & Conflict Rules

This document explains how Copilot IDE and Copilot CLI overlap, where they diverge,
and the rules for detecting and resolving conflicts between them.

## Cross-Readability Matrix

These files are automatically read by each target even when they "belong" to a different
agent ecosystem. This only applies to **repository-root** files (not subdirectories or
user-level).

| File | Copilot IDE reads it? | Copilot CLI reads it? | Primary owner |
|------|----------------------|----------------------|---------------|
| `AGENTS.md` | Yes | Yes | Shared |
| `CLAUDE.md` | Yes (cross-read) | Yes (native) | Claude Code |
| `CLAUDE.local.md` | Yes (cross-read) | No | Claude Code |
| `GEMINI.md` | Yes (cross-read) | Yes (native) | Gemini |
| `.github/copilot-instructions.md` | Yes | Yes | Shared |

**Practical meaning:** Both Copilot IDE and CLI read `CLAUDE.md` and `GEMINI.md` at the
repository root. `CLAUDE.local.md` is only read by IDE. This means instructions in
`CLAUDE.md` will affect all three tools (Claude Code, Copilot IDE, and Copilot CLI).

## Conflict Types

When the same logical artifact exists in multiple places or targets, these conflict types
can arise:

### 1. Duplicate (warning)

**What:** The same artifact name exists for both Copilot IDE and Copilot CLI at the same
scope.

**Example:** An agent named `searcher` exists at both `.github/agents/searcher.md`
(shared) AND `~/.copilot/agents/searcher.md` (user-level for CLI). Both targets see
an agent called "searcher" but from different sources.

**Resolution:** Decide which target should own the artifact. Remove the duplicate or
rename one.

### 2. Shadowed (warning)

**What:** The same artifact exists at different scope levels within one target, and the
higher-scope version hides the lower-scope one.

**Example:** `~/.copilot/agents/reviewer.md` (user scope) is shadowed by
`.github/agents/reviewer.md` (repo scope) because repo scope takes precedence.

**Resolution:** Accept the precedence (higher scope wins) or rename one to avoid collision.

**Precedence order** (lower number = lower priority, overridden by higher):
```
user (100) < repository (200) < directory (300) < target (400) < session (500)
```

### 3. Lossy Mapping (info)

**What:** An artifact exists for one target but the other target cannot see it (and no
cross-readability rule covers it).

**Example:** A `.prompt.md` file exists in `.github/prompts/` — Copilot IDE uses it, but
Copilot CLI has no concept of prompt files. The customization is "lost" for CLI users.

**Resolution options:**
- Accept the gap (it's a target-specific feature)
- Create an equivalent in the other target's format (e.g., convert the prompt to a
  command in `.claude/commands/` for CLI)

### 4. Ambiguous (error)

**What:** Two artifacts with the same logical name exist at the same scope within the
same target, from different source locations, and there's no precedence rule to pick
a winner.

**Example:** Both `.github/agents/helper.md` and `.claude/agents/helper.md` exist at
repo scope for Copilot IDE, with no clear winner.

**Resolution:** Remove one, rename one, or move one to a different scope.

## Precedence Rules by Artifact Type

Different artifact types use different resolution strategies when multiple instances exist:

| Rule | Behavior | Used By |
|------|----------|---------|
| **cumulative** | All artifacts apply (content is concatenated) | Guidance, rules |
| **first_found** | Lowest precedence rank wins | Agent discovery |
| **last_loaded** | Highest precedence rank wins | MCP servers |
| **scope** | Higher scope level overrides lower | Default for most |

## Reconciliation Checklist

When auditing a workspace, check for these common issues:

### Shared Artifacts
- [ ] Is `AGENTS.md` present? Both targets read it.
- [ ] Is `.github/copilot-instructions.md` present? Both targets read it.
- [ ] Are the shared files consistent in intent for both IDE and CLI users?

### IDE-Only Gaps
- [ ] Are there `.prompt.md` files with no CLI equivalent?
- [ ] Are there VS Code settings-driven instructions with no CLI equivalent?
- [ ] Are there devcontainer MCP servers with no CLI MCP equivalent?

### CLI-Only Gaps
- [ ] Are there `~/.copilot/` user instructions with no IDE equivalent?
- [ ] Are there `.claude/commands/` with no IDE prompt equivalent?
- [ ] Are environment variables (`COPILOT_CUSTOM_INSTRUCTIONS_DIRS`, etc.) pointing to
  directories that IDE doesn't know about?

### Agent Name Collisions
- [ ] Do any agents share a name across different locations?
- [ ] If so, do the precedence rules produce the intended winner?

### MCP Configuration Drift
- [ ] Does `.vscode/mcp.json` (IDE) match `.github/mcp.json` (CLI)?
- [ ] Does user-level `~/.copilot/mcp-config.json` match VS Code user MCP settings?

### Cross-Read Awareness
- [ ] If `CLAUDE.md` exists, is the author aware both Copilot IDE and CLI read it?
- [ ] If `GEMINI.md` exists, is the author aware both Copilot IDE and CLI read it?
- [ ] If `CLAUDE.local.md` exists, is the author aware Copilot IDE reads it (but CLI does not)?
- [ ] Are there instructions in `CLAUDE.md` that don't make sense for Copilot?

### Agent Precedence Difference
- [ ] For CLI: user-level agents (`~/.copilot/agents/`) override project-level agents
      (opposite of IDE where repo scope overrides user scope)
- [ ] If an agent exists at both levels, are the correct versions winning for each target?
