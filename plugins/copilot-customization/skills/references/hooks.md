# Hooks Reference

Hooks extend Copilot agent behavior by executing custom shell commands at key points
during agent execution. They work with **Copilot coding agent** and **Copilot CLI** only
(not local VS Code chat).

## Overview

Hooks let you:
- Run linters/formatters before code changes are applied
- Enforce security policies on tool usage
- Log agent activity for auditing
- Block dangerous operations
- Set up environment at session start
- Clean up resources at session end

## Configuration

**Location:** `.github/hooks/<name>.json`

The hooks config file must be on the repository's **default branch** to be used by
Copilot coding agent. For Copilot CLI, hooks are loaded from the current working directory.

## Hook Types (Events)

| Event | When it Fires | Common Uses |
|-------|--------------|-------------|
| `session-start` | New session begins or existing session resumes | Environment setup, logging |
| `pre-tool-execution` | Before any tool runs | Security enforcement, linting, approval |
| `post-tool-execution` | After a tool completes | Logging, validation, cleanup |
| `session-end` | Session finishes | Cleanup, reporting, notifications |

## Configuration Template

```json
{
  "hooks": [
    {
      "type": "command",
      "event": "session-start",
      "bash": "./scripts/session-start.sh",
      "powershell": "./scripts/session-start.ps1",
      "cwd": "scripts",
      "timeoutSec": 30
    },
    {
      "type": "command",
      "event": "pre-tool-execution",
      "bash": "./scripts/pre-tool.sh",
      "powershell": "./scripts/pre-tool.ps1",
      "timeoutSec": 15
    },
    {
      "type": "command",
      "event": "post-tool-execution",
      "bash": "./scripts/post-tool.sh",
      "powershell": "./scripts/post-tool.ps1",
      "timeoutSec": 15
    },
    {
      "type": "command",
      "event": "session-end",
      "bash": "./scripts/session-end.sh",
      "powershell": "./scripts/session-end.ps1",
      "timeoutSec": 30
    }
  ]
}
```

## Hook Properties

| Property | Required | Description |
|----------|----------|-------------|
| `type` | Yes | Always `"command"` |
| `event` | Yes | One of the event types above |
| `bash` | Yes* | Path to bash script (*at least one of bash/powershell required) |
| `powershell` | Yes* | Path to PowerShell script |
| `cwd` | No | Working directory for script execution |
| `timeoutSec` | No | Timeout in seconds (default varies by event) |

## Input JSON

Hook scripts receive a JSON payload on **stdin**. The format depends on the event type.

### session-start Input
```json
{
  "timestamp": 1704614400000,
  "cwd": "/path/to/project",
  "source": "new",
  "initialPrompt": "Create a new feature"
}
```

### pre-tool-execution Input
```json
{
  "timestamp": 1704614400000,
  "cwd": "/path/to/project",
  "toolName": "edit",
  "toolArgs": "{\"file\":\"src/app.ts\",\"content\":\"...\"}"
}
```

### post-tool-execution Input
```json
{
  "timestamp": 1704614400000,
  "cwd": "/path/to/project",
  "toolName": "bash",
  "toolArgs": "{\"command\":\"npm test\"}",
  "toolResult": "All tests passed"
}
```

## Output JSON (pre-tool-execution only)

Pre-tool hooks can control whether the tool runs by outputting JSON:

### Allow (default — no output needed)
```json
{}
```

### Deny with reason
```json
{
  "permissionDecision": "deny",
  "permissionDecisionReason": "Code does not pass linting"
}
```

## Example Scripts

### Security Enforcement Hook
```bash
#!/bin/bash
# scripts/pre-tool.sh — Block dangerous operations

INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.toolName')
TOOL_ARGS=$(echo "$INPUT" | jq -r '.toolArgs')

# Block modifications to protected paths
if [ "$TOOL_NAME" = "edit" ] || [ "$TOOL_NAME" = "create" ]; then
  FILE_PATH=$(echo "$TOOL_ARGS" | jq -r '.file // .path // empty')
  
  # Protect sensitive directories
  case "$FILE_PATH" in
    .github/workflows/*|.env*|*secret*|*credential*)
      echo '{"permissionDecision":"deny","permissionDecisionReason":"Protected file — manual changes only"}'
      exit 0
      ;;
  esac
fi

# Block destructive bash commands
if [ "$TOOL_NAME" = "bash" ]; then
  COMMAND=$(echo "$TOOL_ARGS" | jq -r '.command')
  
  if echo "$COMMAND" | grep -qE '(rm -rf|drop table|delete from|force push)'; then
    echo '{"permissionDecision":"deny","permissionDecisionReason":"Destructive command blocked"}'
    exit 0
  fi
fi
```

### Lint-on-Edit Hook
```bash
#!/bin/bash
# scripts/lint-check.sh — Run linter before allowing edits

INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.toolName')

if [ "$TOOL_NAME" = "edit" ] || [ "$TOOL_NAME" = "create" ]; then
  npm run lint-staged 2>/dev/null
  if [ $? -ne 0 ]; then
    echo '{"permissionDecision":"deny","permissionDecisionReason":"Code does not pass linting"}'
  fi
fi
```

### Activity Logging Hook
```bash
#!/bin/bash
# scripts/log-activity.sh — Audit trail for agent actions

INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.toolName')
TIMESTAMP=$(echo "$INPUT" | jq -r '.timestamp')
USER=${USER:-unknown}

LOG_DIR="/var/log/copilot"
mkdir -p "$LOG_DIR"

echo "$TIMESTAMP,$USER,$TOOL_NAME" >> "$LOG_DIR/usage.csv"
```

### Session Setup Hook
```bash
#!/bin/bash
# scripts/session-start.sh — Environment preparation

INPUT=$(cat)
CWD=$(echo "$INPUT" | jq -r '.cwd')

cd "$CWD"

# Install dependencies if needed
if [ -f "package.json" ] && [ ! -d "node_modules" ]; then
  npm ci --silent
fi

# Run initial checks
npm run typecheck --silent 2>/dev/null || true
```

## Testing Hooks Locally

Pipe test input into your hook script:

```bash
# Test pre-tool hook
echo '{"timestamp":1704614400000,"cwd":"/tmp","toolName":"bash","toolArgs":"{\"command\":\"ls\"}"}' \
  | ./scripts/pre-tool.sh

# Check exit code
echo $?

# Validate output is valid JSON
./scripts/pre-tool.sh <<< '{"toolName":"edit"}' | jq .
```

## Troubleshooting

| Problem | Solution |
|---------|----------|
| Hook not running | Ensure file is on default branch |
| Script permission denied | Run `chmod +x scripts/*.sh` |
| Invalid JSON output | Validate with `jq` before deploying |
| Timeout errors | Increase `timeoutSec` or optimize script |
| Hook blocks everything | Add debug logging with `set -x` and `>&2` |

### Debug Mode
```bash
#!/bin/bash
set -x  # Enable bash debug mode
INPUT=$(cat)
echo "DEBUG: Received input" >&2
echo "$INPUT" >&2
# ... rest of script
```

## Important Notes

- Hooks run in the **agent's environment**, not your local machine
- Hooks on Copilot coding agent run in GitHub Actions infrastructure
- Hook scripts must output valid JSON or no output (empty = allow)
- Non-zero exit codes from hooks may cause the agent to fail
- Keep hooks fast — long-running hooks slow down the agent significantly
