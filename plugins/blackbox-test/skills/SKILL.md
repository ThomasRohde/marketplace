---
name: blackbox-test
description: >
  Run a blackbox test of the project's CLI or executable. Use this skill whenever
  the user wants to "blackbox test", "test the CLI blindly", "test as an outsider",
  "test without reading source", "QA test the tool", "smoke test the CLI",
  "exploratory testing", or says anything like "pretend you don't know the code and
  test it". Also triggers when the user mentions "blackbox", "black box", "blind test",
  or "external test" in the context of testing their project. This skill works with
  any tech stack — Python, Node, Rust, Go, or anything else that produces a CLI.
---

# Blackbox Test

Launch an isolated subagent that tests the project's CLI with zero knowledge of the
source code. The agent discovers capabilities solely through the CLI itself, tries to
break it, and produces a structured feedback report.

## Why this matters

Reading source code biases testing — you test what you *know* it does rather than
what a real user would encounter. A blackbox test catches discoverability problems,
misleading help text, confusing error messages, silent failures, and edge cases that
unit tests miss because they reflect the author's assumptions.

## How it works

1. You create a temporary `./blackbox/` directory as an isolation boundary
2. You spawn a subagent inside it with strict instructions: no source code access,
   only CLI interaction
3. The subagent explores, documents, and stress-tests the CLI
4. It writes `FEEDBACK.md` inside the blackbox directory
5. You copy the feedback to the repo root with a timestamped slug name
6. You delete the blackbox directory

## Step 1: Determine the command

Figure out how to invoke the project's CLI. Check, in order:

- Ask the user if they specified a command
- Look at `pyproject.toml` for `[project.scripts]` entries
- Look at `package.json` for `bin` or `scripts.start`
- Look at `Cargo.toml` for `[[bin]]`
- Look for a `Makefile` with a run target
- Look for an obvious entry point (`main.go`, `cli.py`, `index.js`)

Determine the full invocation command, including any virtual environment activation
or path prefix needed. For example:
- Python: `/path/to/.venv/Scripts/python -m mypackage` or `.venv/bin/python -m mypackage`
- Node: `npx mypackage` or `node dist/cli.js`
- Rust: `cargo run --` or `./target/release/mybin`
- Go: `go run .` or `./mybin`

## Step 2: Create the isolation directory

```bash
mkdir -p ./blackbox
```

## Step 3: Spawn the subagent

Use the Agent tool with `mode: "bypassPermissions"` so the tester can run commands
freely. The prompt below is a template — fill in `{{COMMAND}}` and `{{WORKING_DIR}}`.

```
You are a QA tester performing a blackbox test of a CLI tool. You have ZERO prior
knowledge about this tool. You cannot read any source code.

The command to run the tool is: {{COMMAND}}
Your working directory is: {{WORKING_DIR}}/blackbox

## Testing protocol

### Phase 1: Discovery
- Run the tool with no arguments
- Run with --help / -h
- Run with --version / -v
- Explore every subcommand's --help
- Note the tool's apparent purpose, all commands, all flags

### Phase 2: Happy path
- For each subcommand, construct a valid invocation using the help text
- Create any needed input files (markdown, JSON, YAML, CSV, etc.) in your
  working directory
- Verify outputs match what the help text promises

### Phase 3: Error handling
- Missing required arguments
- Invalid flag values and types
- Non-existent file paths
- Permission-denied scenarios (read-only files)
- Empty files, binary files, files with only whitespace
- Extremely long inputs (generate a large file, 1000+ entries)
- Special characters in file names and content (spaces, unicode, quotes)
- CRLF vs LF line endings
- Deeply nested or recursive structures

### Phase 4: Edge cases
- Flags in unusual positions (before/after subcommands)
- Duplicate flags
- Mutually exclusive options used together
- Pipe input (echo "..." | {{COMMAND}})
- Output to stdout vs file vs non-existent directory
- Concurrent invocations if applicable
- Ctrl+C interruption behavior (if testable)

### Phase 5: Consistency
- Are exit codes consistent and meaningful?
- Are error messages helpful and actionable?
- Is output format consistent across commands?
- Does --help match actual behavior?

## Rules
- Do NOT read source code files (.py, .js, .ts, .rs, .go, .java, etc.)
- Do NOT read build configs (pyproject.toml, package.json, Cargo.toml, etc.)
- Do NOT look at test files
- Only interact via the CLI
- Create all test fixtures inside your working directory

## Deliverable
Create {{WORKING_DIR}}/blackbox/FEEDBACK.md with these sections:

# Blackbox Test Report

## Tool Summary
What does this tool appear to do? Based solely on CLI exploration.

## Bugs Found
Numbered list. Each bug has:
- **Title**: one-line summary
- **Severity**: critical / high / medium / low
- **Reproduction**: exact commands to reproduce
- **Expected**: what should happen
- **Actual**: what actually happens

## UX Issues
Numbered list of confusing, inconsistent, or poorly documented behaviors.

## What Worked Well
Things that impressed you or worked correctly under stress.

## Recommendations
Prioritized suggestions for improvement.

## Test Log
Summary table of every command tried and its outcome category
(pass / fail / unexpected / crash).
```

## Step 4: Collect and archive results

After the subagent finishes:

1. Copy the feedback file to the repo root with a slug name:
   ```bash
   cp ./blackbox/FEEDBACK.md ./FEEDBACK-blackbox-$(date +%Y-%m-%d).md
   ```
   If a file with that name already exists, append a counter:
   `FEEDBACK-blackbox-2025-01-15-2.md`

2. Remove the blackbox directory:
   ```bash
   rm -rf ./blackbox
   ```

3. Summarize the results to the user — total bugs found by severity,
   top UX issues, and anything that worked well. Keep it concise.

## Customization

The user can modify the test by saying things like:
- "Focus on the `deploy` subcommand" — narrow Phase 2-4 to that command
- "Test with JSON output" — add `--format json` or equivalent to all commands
- "Include performance testing" — add timing measurements to the protocol
- "Skip edge cases" — drop Phase 4

Adapt the subagent prompt accordingly.
