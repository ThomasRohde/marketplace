# checkpointflow Plugin for Claude Code

Author, run, and build with deterministic, resumable agent workflows using [checkpointflow](https://github.com/ThomasRohde/checkpointflow). Three skills that give Claude Code full control over the `cpf` CLI — from writing workflows, to running them interactively with pause/resume, to creating new skills through structured iteration.

## Prerequisites

Install checkpointflow:

```bash
uv tool install checkpointflow
```

Verify it works:

```bash
cpf --version
cpf guide
```

## Skills

### cpf-workflow-author

Creates and validates checkpointflow workflow YAML files. Activates when you ask to create a workflow, automate a process as a pipeline, define steps with human or agent checkpoints, or turn a conversation into a reusable runbook.

**Example requests:**
- "Create a workflow for deploying to staging with approval"
- "Turn this runbook into a checkpointflow YAML"
- "Write a workflow that runs tests, waits for review, then deploys"

### cpf-workflow-runner

Runs workflows interactively, handling the full pause/resume cycle. Activates when you ask to run a workflow, resume a paused run, check status, or cancel a run.

**Example requests:**
- "Run the deploy workflow"
- "What's the status of my last run?"
- "Resume the workflow and approve it"

The runner collects input through structured prompts — when a workflow pauses at an `await_event` step, it presents the required choices as a form rather than asking for free-text.

### cpf-skill-creator

Creates and improves Claude Code skills through a structured, workflow-driven process. Wraps the full skill creation lifecycle — capture intent, draft, test, grade, iterate, optimize, package — in a cpf workflow with audience-driven dispatch.

**Example requests:**
- "Create a skill for generating API docs"
- "Improve my deploy skill with better test coverage"
- "Build a skill that converts markdown to PDF"

Requires the `skill-creator` plugin for eval scripts and the review viewer.

## Installation

```bash
/plugin install cpf@thomas-rohde-plugins
```

## What checkpointflow does

checkpointflow is a CLI toolchain for workflows that mix:
- Deterministic CLI commands
- Explicit pause/resume for human or agent input
- Durable execution across restarts and handoffs

Workflows are YAML files with `cli`, `await_event`, and `end` steps. The CLI returns structured JSON envelopes on stdout with semantic exit codes, making it easy for agents to drive.

## License

MIT
