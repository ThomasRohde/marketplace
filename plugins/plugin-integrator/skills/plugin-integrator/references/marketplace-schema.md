# Marketplace JSON Schemas

## marketplace.json

Location: `.claude-plugin/marketplace.json` (repository root)

This is the marketplace registry. It lists all available plugins.

```json
{
  "name": "thomas-rohde-plugins",
  "owner": {
    "name": "Thomas Klok Rohde",
    "email": "thomas@rohde.name"
  },
  "metadata": {
    "description": "A curated collection of Claude Code plugins by Thomas Klok Rohde",
    "version": "1.0.0"
  },
  "plugins": [
    {
      "name": "plugin-name",
      "source": "./plugins/plugin-name",
      "description": "Concise description of the plugin",
      "version": "1.0.0",
      "author": {
        "name": "Thomas Klok Rohde",
        "email": "thomas@rohde.name"
      },
      "repository": "https://github.com/ThomasRohde/marketplace",
      "keywords": ["keyword1", "keyword2", "keyword3"],
      "category": "productivity"
    }
  ]
}
```

### Plugin entry fields

| Field | Required | Description |
|-------|----------|-------------|
| `name` | Yes | Kebab-case plugin identifier, must match directory name |
| `source` | Yes | Relative path to plugin directory, always `./plugins/<name>` |
| `description` | Yes | One-line description, same as plugin.json and README first line |
| `version` | Yes | Semver version string |
| `author.name` | Yes | Author's full name |
| `author.email` | No | Author's email address |
| `repository` | Yes | GitHub repository URL |
| `keywords` | Yes | Array of 3-8 lowercase keywords |
| `category` | Yes | Plugin category (typically `"productivity"`) |

---

## plugin.json

Location: `plugins/<plugin-name>/.claude-plugin/plugin.json`

This is the local plugin metadata, stored within each plugin directory.

```json
{
  "name": "plugin-name",
  "version": "1.0.0",
  "description": "Same description as marketplace.json entry",
  "author": {
    "name": "Thomas Klok Rohde"
  },
  "keywords": ["keyword1", "keyword2", "keyword3"]
}
```

### Fields

| Field | Required | Description |
|-------|----------|-------------|
| `name` | Yes | Must match marketplace.json entry and directory name |
| `version` | Yes | Must match marketplace.json entry |
| `description` | Yes | Must match marketplace.json entry |
| `author.name` | Yes | Author name |
| `keywords` | Yes | Must match marketplace.json entry |

---

## SKILL.md frontmatter

Location: `plugins/<plugin-name>/skills/SKILL.md` or `plugins/<plugin-name>/skills/<skill-name>/SKILL.md`

```yaml
---
name: skill-display-name
description: >
  Description of what the skill does and when to trigger it.
  Include specific trigger phrases like "create a diagram",
  "generate a flowchart", etc. Make descriptions slightly
  "pushy" to ensure triggering — Claude tends to undertrigger.
version: 1.0.0
---
```

### Frontmatter fields

| Field | Required | Description |
|-------|----------|-------------|
| `name` | Yes | Human-readable skill name |
| `description` | Yes | Trigger description with specific phrases (5+ recommended) |
| `version` | No | Skill version (semver) |

### Description best practices

- Include 5+ specific trigger phrases
- Use third-person voice: "when the user asks to..."
- Cover alternative phrasings, abbreviations, synonyms
- Be slightly "pushy" — Claude tends to undertrigger skills
- Keep under 200 words
