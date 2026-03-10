---
name: augment-plan
description: >
  Augment an existing Execution Plan (ExecPlan) with CLI design requirements and project
  scaffolding guidance. Use this skill whenever the user wants to "augment a plan",
  "add CLI requirements to a plan", "add scaffolding to a plan", "enrich a plan with CLI
  design", "make my plan CLI-ready", "add agent-first CLI patterns to my plan", or mentions
  "augment plan", "plan augmentation", "CLI plan", or "scaffold plan" in the context of
  enhancing an existing ExecPlan. Also triggers when the user has an existing PLAN.md and
  wants to add CLI interface design, structured output patterns, error handling contracts,
  or project scaffolding milestones. Covers both adding CLI-specific milestones (structured
  envelopes, error codes, exit codes, guide commands, dry-run, safety flags) and scaffolding
  milestones (repo layout, documentation, agent guidance files, quality infrastructure).
  Even if the user only mentions one aspect (e.g., "add CLI stuff to my plan" or "add
  scaffolding steps"), use this skill — it handles both independently.
---

# Augment Plan

Take an existing Execution Plan (ExecPlan) and enrich it with two complementary layers of guidance: **CLI design requirements** for agent-first command-line interfaces, and **project scaffolding** for repository structure and guidance files.

## Why this skill exists

ExecPlans created from PRDs describe *what to build* at the code level — milestones, file edits, validation steps. But two things consistently fall through the cracks:

1. **CLI design** — When the project includes a CLI, plans tend to describe commands at the feature level ("add a `deploy` command") without specifying the structured envelope, error taxonomy, exit codes, guide command, dry-run support, or safety flags that make the CLI usable by agents. The result is a CLI that works for humans but breaks agent automation.

2. **Project scaffolding** — Plans jump straight to feature code without establishing the repository foundation: the README, ARCHITECTURE.md, AGENTS.md, testing strategy, CI workflows, and other guidance files that make the project navigable for both humans and future coding agents.

This skill closes both gaps by reading the existing plan and inserting well-placed milestones, steps, and context that address CLI design and scaffolding — without disrupting the plan's existing structure or narrative flow.

## How to run this skill

### Step 1: Locate and read the existing plan

Ask the user for the ExecPlan file path if not provided. Read it thoroughly. Pay attention to:

- **The project type** — Is this a CLI tool? A library with a CLI interface? An API with a companion CLI? Understanding this determines how much of the CLI manifest applies.
- **Existing milestones** — Where does feature work begin? Scaffolding milestones should come before feature milestones. CLI design milestones should be woven into or placed before the milestones that implement commands.
- **Tech stack** — The plan's language and framework choices constrain the implementation hints you'll provide (Python/Typer, TypeScript/Commander, Go/Cobra, etc.).
- **The plan's voice and level of detail** — Match it. If the plan is terse and concrete, your additions should be too. If it's narrative and explanatory, write in that style.

### Step 2: Read the PRD (if available)

If the PRD that generated this plan exists in the repo, read it too. It provides context about:
- Whether the project is a CLI at all (if not, skip CLI augmentation)
- The intended user base (agents vs. humans vs. both)
- Non-goals that might affect scaffolding scope

If no PRD is available, work from the plan alone and ask the user to confirm your inferences.

### Step 3: Decide what to augment

Not every plan needs both layers. Ask yourself:

**Does the project include a CLI?**
- Yes → Apply CLI augmentation (read `references/cli-manifest.md` for the full contract)
- No → Skip CLI augmentation entirely

**Does the plan already include scaffolding steps?**
- No scaffolding at all → Add a full scaffolding milestone
- Some scaffolding but gaps → Fill the gaps
- Comprehensive scaffolding → Skip or lightly supplement

Tell the user what you plan to add before modifying the file:
- "This plan describes a CLI tool but doesn't specify structured output, error codes, or a guide command. I'll add a CLI foundations milestone."
- "There's no scaffolding in this plan — no README, ARCHITECTURE.md, or AGENTS.md setup. I'll add a scaffolding milestone before the first feature milestone."
- "The CLI already has structured output planned, but it's missing dry-run support and safety flags. I'll augment the relevant milestones."

### Step 4: Determine applicable CLI parts

The CLI manifest has five parts. Not all apply to every CLI. Use this decision tree based on what the CLI does:

| CLI type | Parts to apply |
|----------|---------------|
| Read-only query/inspection tool | I (Foundations) + II (Read & Discover) |
| Tool that modifies files/state | I + II + III (Safe Mutation) |
| Plan-review-apply workflow tool | I + II + III + IV (Transactional Workflows) |
| Multi-agent/shared-resource tool | I + II + III + IV + V (Multi-Agent Coordination) |

Part I (Foundations) applies to every CLI. It covers:
- Structured JSON envelope for every command response
- Machine-readable error codes with retry semantics
- Distinct exit codes per error category
- Built-in `guide` command for progressive discovery
- Consistent command groups and verb naming
- Examples in `--help`
- TOON (Terse Output or None) — stdout is for data only
- `LLM=true` environment variable support
- Observability metrics in every response
- Schema versioning

Read `references/cli-manifest.md` for the full specification of each part before writing your augmentation. The reference contains implementation hints for Python, TypeScript, and Go — use the ones matching the plan's tech stack.

### Step 5: Write the CLI augmentation

Add CLI requirements to the plan in a way that respects its existing structure. You have three strategies depending on the plan's current state:

**Strategy A: Insert a new milestone** — When the plan has no CLI design at all, add a dedicated milestone (typically "Milestone 0" or inserted before the first feature milestone) titled something like "Establish CLI Contract and Foundations." This milestone should cover:

1. Define the response envelope type/schema (the exact struct/interface/model for the project's language)
2. Implement the envelope serializer so every command returns the same shape
3. Define the error code taxonomy (with `ERR_` prefixed codes organized by category)
4. Map error categories to exit code ranges
5. Implement the `guide` command that returns the full CLI schema as JSON
6. Add `isatty()` detection and `LLM=true` support
7. Add `--output` flag (json/text) with json as default when piped
8. Add metrics/observability to the envelope
9. Validate with concrete test: run a command, parse the JSON output, verify envelope shape

For mutation CLIs, add additional steps:
10. Add `--dry-run` to every mutating command
11. Implement change records with before/after state
12. Add explicit safety flags for dangerous operations
13. Add `--backup` support for destructive operations
14. Implement atomic writes (temp file + fsync + rename)

For transactional CLIs, add:
15. Implement fingerprint-based conflict detection
16. Create plan/validate/apply/verify workflow commands
17. Add structured assertion support for verification
18. Support workflow composition format

**Strategy B: Augment existing milestones** — When the plan already describes CLI commands but lacks the contract details, weave requirements into existing milestones. For each milestone that implements a command:
- Add a step to wrap the command's output in the structured envelope
- Add a step to define error codes for that command's failure modes
- Add validation steps that verify the envelope shape
- Add dry-run support if the command mutates state

**Strategy C: Add a Context section addendum** — When the plan's CLI design is mostly complete but missing some principles, add a "CLI Design Contract" subsection to the Context and Orientation section that documents the principles the implementing agent must follow, without restructuring existing milestones.

In all cases, be concrete. Don't say "add structured output" — show the exact envelope type definition for the project's language. Don't say "add error codes" — list the specific error codes the CLI will need based on its commands.

### Step 6: Write the scaffolding augmentation

Read `references/scaffold-from-prd.md` for the full scaffolding specification. Add a scaffolding milestone to the plan — this should be the very first milestone (before any feature work), titled something like "Scaffold Repository Structure and Guidance Files."

The milestone should include concrete steps to create:

**Foundation documents** (only those the project doesn't already have):
- `README.md` — what the project is, quick start, repo structure, how to test
- `PROJECT.md` — problem statement, goals, non-goals, constraints, assumptions
- `ARCHITECTURE.md` — stack rationale, component map, data flows, trade-offs
- `TESTING.md` — strategy, test pyramid, coverage expectations, CI validation
- `CONTRIBUTING.md` — branch workflow, code style, commit conventions, review checklist
- `CHANGELOG.md` — initial entry
- `DECISIONS/ADR-0001-initial-architecture.md` — record the foundational architecture decision

**Agent guidance files**:
- `AGENTS.md` — project overview for agents, where to look first, coding rules, invariants, how to validate, when to stop and leave a TODO
- Path-specific `.instructions.md` files where appropriate (backend, frontend, testing conventions)

**Quality infrastructure** (appropriate to the plan's tech stack):
- Formatter config (Prettier, Black, gofmt, etc.)
- Linter config (ESLint, Ruff, golangci-lint, etc.)
- `.editorconfig`
- `.gitignore`
- CI workflow (`.github/workflows/ci.yml` or equivalent)

**Placeholder pattern** — For anything the PRD doesn't specify, instruct the implementing agent to use this format:
```
TODO: <what is missing>
Why it matters: <one sentence>
How to fill this in: <one or two concrete instructions>
Example: <optional short example>
```

The scaffolding milestone's validation step should verify:
- All guidance files exist and are non-empty
- The README contains a working quick-start section
- The CI workflow is syntactically valid
- The linter runs without configuration errors

### Step 7: Update living sections

After adding milestones and steps, update the plan's living sections:

**Progress** — Add unchecked items for every new step you introduced, grouped under the new milestone headings.

**Decision Log** — Add entries for:
- Which CLI manifest parts you applied and why
- Which scaffolding files you included/excluded and why
- Any assumptions you made about the project type

**Context and Orientation** — If you added new concepts (structured envelope, error taxonomy, guide command), define them here so the plan remains self-contained.

### Step 8: Self-review

Before presenting to the user, verify:

- **Self-contained**: The plan still makes complete sense without reading the CLI manifest or scaffolding guide. All concepts are defined inline.
- **Proportionate**: The augmentation is proportional to the plan's scope. A small plan for a simple CLI shouldn't get a 200-line CLI contract section.
- **Stack-specific**: Implementation hints match the plan's tech stack. Don't give Python examples in a Go project.
- **Non-destructive**: Existing milestones, steps, and validation criteria are preserved. Nothing was removed or contradicted.
- **Ordered correctly**: Scaffolding comes first, then CLI foundations, then feature milestones.
- **Concrete**: Every new step names specific files, types, functions, or commands — not vague directives.

### Step 9: Write the augmented plan

Save the augmented plan back to the same file (or a new file if the user prefers). Tell the user:
- What was added (CLI augmentation, scaffolding, or both)
- Which CLI manifest parts were applied
- How many new milestones/steps were introduced
- Any assumptions that need verification

## Matching CLI manifest parts to the plan

When reading `references/cli-manifest.md`, here's what to extract for each part:

### Part I — Foundations (always apply for CLIs)
Focus on principles 1 (envelope), 2 (error codes), 3 (exit codes), 4 (guide command), 5 (naming), 7 (TOON), and 8 (LLM=true). These are the non-negotiable baseline. Principles 6 (help examples), 9 (observability), and 10 (schema versioning) are important but lighter-weight.

### Part II — Read & Discover (query/inspection CLIs)
Focus on principle 11 (read/write separation) and 12 (structured metadata). If the CLI has any `list`, `inspect`, `show`, or `get` commands, add steps to ensure they return rich structured metadata with stable ordering and cursor pagination.

### Part III — Safe Mutation (state-changing CLIs)
Focus on principles 13 (dry-run), 14 (change records), and 15 (safety flags). These three transform a "hope it works" CLI into a recoverable one. Add 16 (backup) and 17 (atomic writes) if the CLI modifies files on disk.

### Part IV — Transactional Workflows (plan-review-apply CLIs)
Only apply if the CLI has a plan/apply pattern (like Terraform, Alembic, or Helm). Focus on 18 (fingerprinting) and 19 (plan/validate/apply/verify). Principles 20 and 21 are for more sophisticated CLIs.

### Part V — Multi-Agent Coordination
Only apply if multiple agents or agents + humans will use the CLI concurrently on shared resources. Focus on 22 (locking) and 23 (concurrency docs).

## Reference files

- `references/cli-manifest.md` — The complete CLI-MANIFEST specification. Read this before writing CLI augmentation. It contains the full contract, implementation hints for Python/TypeScript/Go, and do/don't examples for every principle.
- `references/scaffold-from-prd.md` — The complete project scaffolding guide. Read this before writing scaffolding augmentation. It contains the full list of deliverables, content guidance per file, and the placeholder pattern.
