# README.md Template for Marketplace Plugins

Use this template when creating a README.md for a new plugin. Replace all `<placeholder>` values.

---

```markdown
# <Plugin Display Name> Plugin for Claude Code

<One sentence describing what the plugin does and its primary value.>

## Features

- **<Feature 1>**: <Description of capability>
- **<Feature 2>**: <Description of capability>
- **<Feature 3>**: <Description of capability>

## Installation

Add this plugin to your Claude Code configuration:

\`\`\`bash
claude --plugin-dir /path/to/<plugin-name>
\`\`\`

Or copy to your project's `.claude-plugin/` directory.

## Usage

### Automatic Skill Activation

The `<skill-name>` skill activates automatically when you ask to:
- <Trigger phrase 1>
- <Trigger phrase 2>
- <Trigger phrase 3>

### Command Usage (if applicable)

\`\`\`
/<command-name> <arguments>
\`\`\`

**Examples:**
- `/<command-name> <example 1>`
- `/<command-name> <example 2>`

### Example Requests

- "<Natural language request 1>"
- "<Natural language request 2>"
- "<Natural language request 3>"
- "<Natural language request 4>"

## Components

- **Skill**: `<skill-name>` — <brief description>
- **Command**: `/<command-name>` — <brief description> (if applicable)
- **References**: `<reference-file.md>` — <brief description> (if applicable)

## License

<License type or "See LICENSE.txt">
```

---

## Guidelines

- Keep the README under 70 lines for simple plugins, up to 100 for complex ones
- The description should match what's in marketplace.json and plugin.json
- Features should highlight what makes the plugin useful, not list every file
- Installation section is always the same two options (plugin-dir or .claude-plugin/)
- Trigger phrases should match the SKILL.md description frontmatter
- Example requests should be realistic — things a user would actually type
- Components section is a quick inventory, not full documentation
- Only include Command Usage subsection if the plugin has commands/
