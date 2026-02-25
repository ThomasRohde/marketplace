# Plugin Integrator for Claude Code

Package standalone skills into properly structured plugins and register them in the marketplace.

## Features

- **Full scaffolding**: Creates the complete plugin directory structure (plugin.json, README.md, skills/)
- **Marketplace registration**: Adds entries to marketplace.json and the root README.md
- **Convention enforcement**: Follows established patterns from existing plugins for consistency
- **Validation checklist**: Verifies all required files, valid JSON, and correct cross-references

## Installation

Add this plugin to your Claude Code configuration:

```bash
claude --plugin-dir /path/to/plugin-integrator
```

Or copy to your project's `.claude-plugin/` directory.

## Usage

### Automatic Skill Activation

The `plugin-integrator` skill activates automatically when you ask to:
- Add a skill to the marketplace
- Create or scaffold a new plugin
- Package a skill as a plugin
- Register a plugin in marketplace.json
- Convert a skill directory into a plugin

### Example Requests

- "Add this skill to the marketplace as a plugin"
- "Create a new plugin called X from this SKILL.md"
- "Register the new plugin in marketplace.json and the README"
- "Scaffold an empty plugin directory for my new skill"

## Components

- **Skill**: `plugin-integrator` — full integration workflow from skill to registered plugin
- **References**: `readme-template.md` — README template with all required sections
- **References**: `marketplace-schema.md` — JSON schemas for marketplace.json and plugin.json

## License

MIT
