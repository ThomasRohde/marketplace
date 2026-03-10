# Create Plan Plugin for Claude Code

Generate self-contained, agent-executable Execution Plans (ExecPlans) from PRD files that any coding agent or human novice can follow end-to-end.

## Features

- **PRD-to-Plan transformation**: Converts epics, acceptance criteria, and tech stack decisions into concrete, step-by-step execution plans
- **Self-contained output**: Every ExecPlan embeds all context needed — no external references, no assumed knowledge
- **Living document structure**: Built-in Progress, Decision Log, Surprises & Discoveries, and Outcomes sections that stay current during implementation
- **Observable outcomes**: Every milestone ends with verifiable behavior, not just code changes
- **Multi-plan support**: Splits large PRDs into independent per-epic ExecPlans when appropriate

## Installation

Add this plugin to your Claude Code configuration:

```bash
claude --plugin-dir /path/to/create-plan
```

Or copy to your project's `.claude-plugin/` directory.

## Usage

### Automatic Skill Activation

The `create-plan` skill activates automatically when you ask to:
- Create a plan or execution plan from a PRD
- Turn requirements into implementation steps
- Break down a PRD into milestones
- Generate an ExecPlan for a feature

### Example Requests

- "Create an execution plan from PRD.md"
- "Turn this PRD into a step-by-step implementation plan"
- "Break down the epics in my PRD into ExecPlans"
- "Generate a plan I can hand to a coding agent for this feature"
- "How do I implement this PRD? Create a plan."

## Components

- **Skill**: `create-plan` — Transforms PRDs into self-contained ExecPlans
- **References**: `exec-plan-guidelines.md` — Complete ExecPlan specification and skeleton template

## License

MIT
