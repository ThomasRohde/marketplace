# MCP Servers Reference

Model Context Protocol (MCP) servers extend Copilot's capabilities by connecting it to
external services, databases, APIs, and development tools.

## Configuration

### Workspace Level (.vscode/mcp.json)
```json
{
  "servers": {
    "my-server": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@my-org/my-mcp-server"],
      "env": {
        "API_KEY": "${env:MY_API_KEY}"
      }
    }
  }
}
```

### User Settings Level
```jsonc
// VS Code settings.json
{
  "mcp": {
    "servers": {
      "github": {
        "type": "stdio",
        "command": "docker",
        "args": ["run", "-i", "--rm", "ghcr.io/github/github-mcp-server"],
        "env": {
          "GITHUB_TOKEN": "${env:GITHUB_TOKEN}"
        }
      }
    }
  }
}
```

### In Custom Agent Profiles (Org/Enterprise)
```yaml
---
name: my-agent
description: 'Agent with MCP access'
tools: ['custom-mcp/tool-1', 'read', 'edit']
mcp-servers:
  custom-mcp:
    type: 'local'
    command: 'some-command'
    args: ['--arg1']
    tools: ['*']
    env:
      API_KEY: ${{ secrets.API_KEY }}
---
```

## Built-in MCP Servers (Copilot Coding Agent)

These are available out-of-box for Copilot coding agent:
- GitHub MCP Server — Repository operations, issues, PRs
- Reference via `github/tool-name` in agent tool lists

## Using MCP Tools in Prompts and Agents

Reference MCP tools with `server-name/tool-name`:

```yaml
# In an agent or prompt file
tools: ['github/create_issue', 'slack/send_message', 'jira/search_issues']
```

In prompt body text:
```markdown
Use #tool:github/create_issue to file a new issue for any bug found.
```

## Environment Variables and Secrets

MCP configs support variable substitution:

| Syntax | Source |
|--------|--------|
| `${env:VAR_NAME}` | Local environment variable |
| `${{ secrets.SECRET_NAME }}` | GitHub Copilot environment secrets |
| `$COPILOT_MCP_VAR` | Copilot environment variable |

Configure secrets in your repository's Settings → Environments → "copilot" environment.

## Common MCP Server Patterns

### Database Access
```json
{
  "servers": {
    "postgres": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "DATABASE_URL": "${env:DATABASE_URL}"
      }
    }
  }
}
```

### Issue Tracker Integration
```json
{
  "servers": {
    "linear": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@linear/mcp-server"],
      "env": {
        "LINEAR_API_KEY": "${env:LINEAR_API_KEY}"
      }
    }
  }
}
```

### Awesome Copilot MCP Server
Provides a prompt for searching and installing prompts, instructions, agents, and skills
from the awesome-copilot community repository:

```json
{
  "servers": {
    "awesome-copilot": {
      "type": "stdio",
      "command": "docker",
      "args": [
        "run", "-i", "--rm",
        "ghcr.io/microsoft/mcp-dotnet-awesome-copilot:latest"
      ]
    }
  }
}
```

## Tips

- MCP servers at the repo level work with VS Code and Copilot coding agent
- Organization-level MCP can only be configured in custom agent profiles
- Test MCP connections with the MCP inspector before deploying
- Keep MCP servers lightweight — they run alongside the agent
- Use the `tools` field in agents to restrict which MCP tools are available
