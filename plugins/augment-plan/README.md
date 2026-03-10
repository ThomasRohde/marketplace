# Augment Plan Plugin for Claude Code

Augment existing Execution Plans with agent-first CLI design requirements and project scaffolding guidance.

## Features

- **CLI Design Augmentation** — Adds structured JSON envelopes, error code taxonomies, exit code ranges, guide commands, dry-run support, safety flags, and LLM=true support based on the CLI-MANIFEST specification
- **Project Scaffolding** — Adds milestones for README, ARCHITECTURE.md, AGENTS.md, TESTING.md, CI workflows, linting, and formatting configuration
- **Smart Detection** — Automatically determines whether a plan describes a CLI tool (applies CLI augmentation) or a non-CLI project (scaffolding only)
- **Progressive CLI Parts** — Applies only the relevant parts of the CLI manifest: Part I (Foundations) for all CLIs, Part II (Read & Discover) for query tools, Part III (Safe Mutation) for state-changing CLIs, Part IV (Transactional Workflows) for plan/apply tools
- **Stack-Aware** — Provides implementation hints specific to the plan's tech stack (Python/Pydantic, TypeScript/Zod, Go/structs)

## Installation

```shell
/plugin install augment-plan@thomas-rohde-plugins
```

## Usage

### Automatic Skill Activation

The skill triggers automatically when you mention:
- "augment a plan", "augment this plan"
- "add CLI requirements to a plan"
- "add scaffolding to a plan"
- "make my plan CLI-ready"
- "add agent-first CLI patterns"
- "enrich a plan with CLI design"

### Example Requests

- "I have a PLAN.md for a database migration CLI. Please augment it with CLI design and scaffolding."
- "Augment my execution plan with proper structured output and error handling."
- "Add scaffolding milestones to my React app plan."
- "My CLI plan is missing agent-first patterns — can you augment it?"
- "Add CLI manifest requirements and project scaffolding to this plan."

## Components

### Skills

- **augment-plan** — Main skill that reads an existing ExecPlan, determines applicable CLI manifest parts, and inserts scaffolding and CLI design milestones

### References

- **cli-manifest.md** — The complete CLI-MANIFEST specification (5 parts, 23 principles) for building agent-first CLIs
- **scaffold-from-prd.md** — The complete project scaffolding guide for repository structure and guidance files

## License

See the main marketplace repository for licensing information.
