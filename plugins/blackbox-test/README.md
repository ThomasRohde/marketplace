# Blackbox Test Plugin for Claude Code

Run isolated blackbox tests of any CLI tool. A subagent with zero source code access explores, stress-tests, and documents bugs — catching the issues that unit tests miss because they reflect the author's assumptions.

## Features

- **Tech-stack independent**: Works with Python, Node, Rust, Go, or any CLI
- **Zero-knowledge testing**: Subagent cannot read source code, build configs, or tests
- **Structured 5-phase protocol**: Discovery, happy path, error handling, edge cases, consistency
- **Severity-rated bug reports**: Each bug includes reproduction steps, expected vs actual behavior
- **Automatic cleanup**: Isolated directory created and removed after testing

## Installation

```bash
/plugin install blackbox-test@thomas-rohde-plugins
```

## Usage

### Automatic Skill Activation

The `blackbox-test` skill activates when you ask to:
- Blackbox test or blind test the CLI
- QA test or smoke test the tool
- Do exploratory testing
- Test as an outsider / without reading source

### Example Requests

- "Blackbox test the CLI"
- "Test this tool as if you've never seen the code"
- "Run a blind smoke test"
- "Do exploratory QA testing of the deploy command"

### Customization

- "Focus on the `deploy` subcommand" — narrow testing scope
- "Test with JSON output" — add format flags to all commands
- "Include performance testing" — add timing measurements
- "Skip edge cases" — drop Phase 4 of the protocol

## Output

A `FEEDBACK-blackbox-YYYY-MM-DD.md` file in the repo root containing:

- **Tool Summary** — What the tool appears to do
- **Bugs Found** — Numbered, severity-rated, with reproduction steps
- **UX Issues** — Confusing or inconsistent behaviors
- **What Worked Well** — Things that held up under stress
- **Recommendations** — Prioritized improvement suggestions
- **Test Log** — Every command tried and its outcome

## License

MIT
