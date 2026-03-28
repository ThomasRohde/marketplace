# checkpointflow Plugin for Claude Code

Author and run deterministic, resumable agent workflows with [checkpointflow](https://github.com/ThomasRohde/checkpointflow). Two skills that give Claude Code full control over the `cpf` CLI — from writing workflows to running them interactively with pause/resume.

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
