# ArchiMate Plugin for Claude Code

Enterprise architecture modeling assistance using ArchiMate - The Open Group's standard for describing, analyzing, and communicating enterprise architectures.

## Features

- **Element Selection**: Guidance on choosing the right ArchiMate elements across 6 layers
- **Relationship Modeling**: Proper usage of 11 relationship types with cross-layer patterns
- **Architecture Patterns**: Modern patterns for microservices, cloud, APIs, security, and more
- **Model Quality**: Naming conventions, anti-patterns detection, and quality checks

## Components

### Skills

| Skill | Purpose |
|-------|---------|
| `archimate-modeling` | Core fundamentals: layers, elements, aspects |
| `archimate-relationships` | Relationship types, directions, cross-layer usage |
| `archimate-patterns` | Modern architecture modeling patterns |
| `archimate-quality` | Naming conventions, anti-patterns, quality |

### Commands

| Command | Purpose |
|---------|---------|
| `/archimate:element` | Interactive help choosing the right element type |
| `/archimate:pattern` | Look up specific architecture patterns |

### Agents

| Agent | Purpose |
|-------|---------|
| `archimate-modeler` | Proactively assists with ArchiMate model creation |

## Installation

```bash
# Test locally
claude --plugin-dir /path/to/archimate

# Or copy to project
cp -r archimate/ your-project/.claude-plugin/
```

## Usage Examples

**Get element guidance:**
```
"What ArchiMate element should I use for a REST API?"
"Help me choose between Business Process and Business Function"
```

**Model an architecture:**
```
"Help me model our microservices architecture in ArchiMate"
"Create an ArchiMate model for our customer onboarding process"
```

**Look up patterns:**
```
/archimate:pattern microservices
/archimate:pattern cloud infrastructure
```

## Future: Archi MCP Integration

This plugin is designed for future integration with an Archi MCP server, enabling direct model manipulation in Archi from Claude Code.

## License

MIT
