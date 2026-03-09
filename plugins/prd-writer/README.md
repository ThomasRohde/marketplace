# PRD Writer Plugin for Claude Code

Write enterprise-ready, agent-executable Product Requirements Documents through interactive guided sessions that systematically eliminate ambiguity.

## Features

- **Interactive Drafting**: Guides you through every PRD section with targeted questions to capture precise requirements
- **Ambiguity Tracking**: Logs every unresolved question, vague answer, or deferred decision and reports them at the end
- **Agent-Executable Output**: Produces PRDs with exact validation commands, session-sized epics, and stack guardrails that coding agents can execute directly
- **Anti-Pattern Detection**: Pushes back on vague scope, missing non-goals, subjective acceptance criteria, and other common PRD smells
- **Companion File Scaffolding**: Optionally generates AGENTS.md, PLAN.md, IMPLEMENT.md, DECISIONS.md, and STATUS.md

## Installation

Add this plugin to your Claude Code configuration:

```bash
claude --plugin-dir /path/to/prd-writer
```

Or copy to your project's `.claude-plugin/` directory.

## Usage

### Automatic Skill Activation

The `prd-writer` skill activates automatically when you ask to:
- Write, create, or draft a PRD
- Create product requirements or a product spec
- Plan or scope a new feature or project
- Define requirements for a coding agent

### Example Requests

- "Write a PRD for a user authentication service"
- "Help me create product requirements for our new dashboard feature"
- "I need to scope out a project for migrating our payment service to a new provider"
- "Draft an agentic PRD for a CLI tool that validates JSON schemas"
- "Create a product spec for an internal employee onboarding portal"

## Components

- **Skill**: `prd-writer` — Interactive PRD drafting with ambiguity tracking
- **References**: `template.md` — Full PRD template structure
- **References**: `epic-sizing.md` — Epic sizing rubric for agentic coding sessions

## License

MIT
