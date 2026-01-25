# DrawIO Plugin for Claude Code

Create production-ready `.drawio` diagram files directly from Claude Code.

## Features

- **Comprehensive diagram support**: Flowcharts, architecture diagrams, UML (sequence, class), ER diagrams, network diagrams, org charts, ArchiMate, C4 model
- **Production-ready output**: Proper XML structure, styling, connectors, and layouts
- **Skill-based knowledge**: Automatically activates when you discuss diagrams
- **Quick command**: Use `/drawio` for rapid diagram generation

## Installation

Add this plugin to your Claude Code configuration:

```bash
claude --plugin-dir /path/to/drawio
```

Or copy to your project's `.claude-plugin/` directory.

## Usage

### Automatic Skill Activation

The DrawIO skill activates automatically when you:
- Ask to "create a diagram" or "make a flowchart"
- Mention ".drawio" files or "draw.io"
- Request architecture, sequence, ER, or network diagrams

### Command Usage

```
/drawio <description>
```

**Examples:**
- `/drawio user authentication flow with login, MFA, and session management`
- `/drawio microservices architecture with API gateway, auth service, and database`
- `/drawio ER diagram for e-commerce with users, orders, and products`
- `/drawio ArchiMate diagram for order management system`
- `/drawio C4 container diagram for banking application`

## Components

- **Skill**: `drawio-creation` - Comprehensive DrawIO XML format knowledge
- **Command**: `/drawio` - Quick diagram generation

## Supported Diagram Types

| Type | Description |
|------|-------------|
| Flowchart | Process flows, decision trees, workflows |
| Architecture | System design, microservices, cloud infrastructure |
| Sequence | UML sequence diagrams for interactions |
| Class | UML class diagrams with relationships |
| ER | Entity-relationship database diagrams |
| Network | Network topology and infrastructure |
| Org Chart | Organizational hierarchies |
| ArchiMate | Enterprise architecture (Business/Application/Technology layers) |
| C4 Model | Context, Container, Component diagrams for software architecture |

## License

MIT
