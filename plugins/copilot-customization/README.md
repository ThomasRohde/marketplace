# GitHub Copilot Customization Plugin for Claude Code

Create and manage GitHub Copilot customizations for VS Code projects.

## Features

- **Full customization coverage**: Instructions, prompts, custom agents, agent skills, hooks, and MCP server integration
- **Scaffolding support**: Templates for `.instructions.md`, `.prompt.md`, `.agent.md`, `SKILL.md`, and `hooks.json`
- **Decision-tree guidance**: Picks the right Copilot primitive based on user intent
- **Progressive discovery**: References and examples for both quick setup and enterprise workflows

## Installation

Add this plugin to your Claude Code configuration:

```bash
claude --plugin-dir /path/to/copilot-customization
```

Or copy to your project's `.claude-plugin/` directory.

## Usage

### Automatic Skill Activation

The `copilot-customization` skill activates automatically when you ask to:
- Set up Copilot customization for a project
- Create or refine custom instructions
- Add prompt files or custom agents
- Scaffold agent skills
- Configure hooks or MCP server integration

### Example Requests

- "Set up Copilot customization for this repository"
- "Create instructions for all TypeScript files"
- "Add a reusable prompt to scaffold React components"
- "Create a custom code-review agent"
- "Configure hooks for pre-tool lint checks"
- "Set up MCP server configuration for local development"

## Components

- **Skill**: `copilot-customization`
- **References**: Deep-dive docs for instructions, prompts, agents, skills, hooks, and MCP
- **Templates**: Starter files for each customization primitive
- **Examples**: Team workflow and enterprise setup examples

## Requirements

- GitHub Copilot in VS Code
- For agent skills: enable `chat.useAgentSkills` (preview feature)
- For hooks: use Copilot coding agent or Copilot CLI

## License

MIT
