# Build a Config File Manager CLI

This ExecPlan is a living document. The sections `Progress`, `Surprises & Discoveries`, `Decision Log`, and `Outcomes & Retrospective` must be kept up to date as work proceeds.

## Purpose / Big Picture

After this change, developers can manage application configuration files using the `cfgctl` CLI. They can inspect current config values, set individual keys, validate configs against a schema, and diff configs between environments. To see it working, run `cfgctl inspect --file config.yaml` to see the current configuration, then `cfgctl set --file config.yaml --key database.host --value localhost` to change a value.

Every command returns a structured JSON envelope so both humans and agents can consume `cfgctl` output reliably. Mutating commands (`set`) support `--dry-run` and `--backup` for safe, recoverable operations. A built-in `guide` command lets agents bootstrap full CLI knowledge in a single call.

## Progress

### Milestone 0 — Scaffold Repository Structure and Guidance Files
- [ ] Create `pyproject.toml` with all dependencies and project metadata
- [ ] Create `README.md` with quick-start, repo structure, and test instructions
- [ ] Create `PROJECT.md` with problem statement, goals, non-goals, constraints
- [ ] Create `ARCHITECTURE.md` with stack rationale, component map, data flows
- [ ] Create `TESTING.md` with strategy, test pyramid, coverage expectations
- [ ] Create `CONTRIBUTING.md` with branch workflow, code style, commit conventions
- [ ] Create `CHANGELOG.md` with initial entry
- [ ] Create `DECISIONS/ADR-0001-initial-architecture.md`
- [ ] Create `AGENTS.md` with project overview, coding rules, validation instructions
- [ ] Create `.editorconfig`
- [ ] Create `.gitignore` for Python
- [ ] Configure `ruff` for linting and formatting in `pyproject.toml`
- [ ] Create `.github/workflows/ci.yml` with lint, type-check, and test steps
- [ ] Validate: all guidance files exist, README has a working quick-start, CI workflow is syntactically valid YAML, `ruff check .` runs without config errors

### Milestone 1 — Establish CLI Contract and Foundations
- [ ] Define the `Envelope` Pydantic model in `src/cfgctl/envelope.py`
- [ ] Define the `CLIError` Pydantic model with `code`, `message`, `retryable`, `suggested_action`, and `details`
- [ ] Implement envelope serializer that wraps every command response
- [ ] Define the error code taxonomy (`ERR_VALIDATION_*`, `ERR_IO_*`, `ERR_INTERNAL_*`)
- [ ] Map error categories to exit code ranges (0, 10, 50, 90)
- [ ] Implement the `cfgctl guide` command returning full CLI schema as JSON
- [ ] Add `--output` flag (json/text) with json as default when piped
- [ ] Add `isatty()` detection for automatic output mode switching
- [ ] Add `LLM=true` environment variable support
- [ ] Add `--quiet` and `--verbose` flags on the root group
- [ ] Add `schema_version` and `request_id` to every envelope
- [ ] Add `metrics.duration_ms` timing to every envelope
- [ ] Add examples in `--help` epilog for every command
- [ ] Validate: run `cfgctl guide`, parse the JSON, verify it contains all commands, error codes, and exit code mappings
- [ ] Validate: run `cfgctl inspect --file test.yaml --output json | python -m json.tool`, verify envelope shape matches contract

### Milestone 2 — Implement Read Commands (inspect, validate, diff)
- [ ] Implement `cfgctl inspect` returning config contents in the structured envelope
- [ ] Implement `cfgctl validate` returning validation results in the structured envelope
- [ ] Implement `cfgctl diff` returning structured diff entries in the envelope
- [ ] All read commands return rich structured metadata (key paths, types, values)
- [ ] All read commands use deterministic output ordering (sorted keys)
- [ ] Write tests for inspect, validate, and diff with pytest

### Milestone 3 — Implement Mutation Command (set) with Safety Rails
- [ ] Implement `cfgctl set` returning a change record with before/after in the envelope
- [ ] Add `--dry-run` flag to `set` that previews the change without writing
- [ ] Add `--backup` flag to `set` that creates a timestamped copy before writing
- [ ] Implement atomic writes (write to temp file, fsync, rename)
- [ ] Add `--force` flag for overwriting read-only files (refused by default with `ERR_VALIDATION_READONLY`)
- [ ] Write tests for set, including dry-run, backup, and atomic write behavior

### Milestone 4 — Integration Testing and Validation
- [ ] Create sample config files for end-to-end testing
- [ ] Run full acceptance scenarios (inspect, set, validate, diff cycle)
- [ ] Verify all commands return valid envelopes
- [ ] Verify error codes and exit codes match the contract
- [ ] Run `pytest tests/ -v` and verify all tests pass
- [ ] Run `ruff check .` and verify no lint errors

## Surprises & Discoveries

No discoveries yet — this section will be populated during implementation.

## Decision Log

- Decision: Use Click instead of argparse or Typer.
  Rationale: Click provides a clean decorator-based API for subcommands and has excellent support for nested groups. Typer is built on Click but adds type-annotation magic that can be harder to debug.
  Date/Author: 2026-03-10 / Plan Author

- Decision: Support YAML and JSON config files, with YAML as the default.
  Rationale: YAML is the dominant config format in the cloud-native ecosystem. JSON support is low-effort since PyYAML handles both.
  Date/Author: 2026-03-10 / Plan Author

- Decision: Apply CLI Manifest Parts I (Foundations), II (Read & Discover), and III (Safe Mutation).
  Rationale: `cfgctl` is a CLI that both reads config files (inspect, validate, diff) and writes them (set). Part I provides the structured envelope, error codes, exit codes, guide command, and output controls every CLI needs. Part II ensures read commands return rich structured metadata. Part III adds dry-run, change records, backup, and atomic writes for the `set` command. Parts IV and V are not applicable — `cfgctl` does not use a plan/apply workflow or coordinate between multiple agents.
  Date/Author: 2026-03-10 / Augmentation

- Decision: Add a scaffolding milestone (Milestone 0) before any feature work.
  Rationale: The original plan jumped straight to implementation without establishing the repo foundation — no README, ARCHITECTURE.md, AGENTS.md, CI, or linter config. Adding these first makes the project navigable for humans and future coding agents from the start.
  Date/Author: 2026-03-10 / Augmentation

- Decision: Use Pydantic for the response envelope model.
  Rationale: Pydantic is the standard Python library for structured data models with validation and serialization. It integrates well with the existing stack (Click, PyYAML) and provides `model_dump()` for JSON serialization. It also provides schema generation for the `guide` command.
  Date/Author: 2026-03-10 / Augmentation

- Decision: Use Ruff for linting and formatting instead of separate Black + flake8.
  Rationale: Ruff is a single tool that replaces Black, flake8, isort, and other Python quality tools. It is fast, has a single config section in pyproject.toml, and is the current community standard.
  Date/Author: 2026-03-10 / Augmentation

## Outcomes & Retrospective

To be completed at major milestones and at plan completion.

## Context and Orientation

This plan creates `cfgctl`, a Python CLI for managing configuration files. The tool reads, modifies, validates, and diffs YAML/JSON configuration files. It uses Click for CLI argument parsing, PyYAML for YAML handling, jsonschema for validation, and Pydantic for the structured response envelope.

### Project structure

```
cfgctl/
├── src/
│   └── cfgctl/
│       ├── __init__.py
│       ├── cli.py              # Click group, root flags, output mode logic
│       ├── envelope.py         # Envelope and CLIError Pydantic models, serializer
│       ├── errors.py           # Error code constants and exit code mapping
│       ├── commands/
│       │   ├── __init__.py
│       │   ├── inspect.py      # `cfgctl inspect` command
│       │   ├── set.py          # `cfgctl set` command
│       │   ├── validate.py     # `cfgctl validate` command
│       │   ├── diff.py         # `cfgctl diff` command
│       │   └── guide.py        # `cfgctl guide` command
│       └── config.py           # Config file loading, manipulation, atomic writes
├── tests/
│   ├── conftest.py             # Shared fixtures (temp config files, CLI runner)
│   ├── test_envelope.py        # Envelope shape and serialization tests
│   ├── test_inspect.py
│   ├── test_set.py
│   ├── test_validate.py
│   ├── test_diff.py
│   └── test_guide.py
├── AGENTS.md
├── ARCHITECTURE.md
├── CHANGELOG.md
├── CONTRIBUTING.md
├── DECISIONS/
│   └── ADR-0001-initial-architecture.md
├── PROJECT.md
├── README.md
├── TESTING.md
├── pyproject.toml
├── .editorconfig
├── .gitignore
└── .github/
    └── workflows/
        └── ci.yml
```

### Key terms

- **Key path**: A dot-separated path into a nested config structure, e.g., `database.host` refers to `{"database": {"host": "..."}}`.
- **JSON Schema**: A standard for describing the expected shape of a JSON/YAML document, used by the `validate` command to check correctness.
- **Envelope**: The structured JSON wrapper returned by every `cfgctl` command. Contains `schema_version`, `request_id`, `ok`, `command`, `target`, `result`, `errors`, `warnings`, and `metrics`. Agents parse this single shape for every command — success or failure.
- **Error code**: A stable, machine-readable string (e.g., `ERR_IO_FILE_NOT_FOUND`) that agents branch on. Humans read the accompanying `message` field. Error codes are never renamed or removed.
- **Exit code**: A numeric process exit code mapped to an error category. Agents and shell scripts use these to branch without parsing JSON. Each error category has a distinct range.
- **Change record**: A structured before/after diff returned by mutating commands. Contains the previous value, the new value, and what was affected.
- **Guide command**: A built-in `cfgctl guide` command that returns the full CLI schema (all commands, flags, error codes, exit codes, examples) as a single JSON document. Agents call this once to bootstrap knowledge of the CLI.
- **TOON (Terse Output or None)**: stdout is exclusively for structured data (JSON). Progress, diagnostics, and decorative output go to stderr.
- **`LLM=true`**: An environment variable convention signaling that an AI agent is driving the CLI. When set, `cfgctl` suppresses banners, forces JSON output, and disables interactive prompts.

### CLI Design Contract

Every command in `cfgctl` follows these rules:

**Structured envelope** — Every command returns the same JSON shape on stdout:

```python
from pydantic import BaseModel, Field
from typing import Any, Optional
import uuid
import time

class CLIError(BaseModel):
    code: str                                    # e.g., "ERR_IO_FILE_NOT_FOUND"
    message: str                                 # Human-readable description
    retryable: bool = False                      # Can the agent retry this?
    suggested_action: str = "fix_input"          # "retry" | "fix_input" | "escalate"
    details: dict[str, Any] = Field(default_factory=dict)

class Envelope(BaseModel):
    schema_version: str = "1.0"
    request_id: str = Field(default_factory=lambda: f"req_{uuid.uuid4().hex[:12]}")
    ok: bool
    command: str                                 # Dotted command ID, e.g., "config.inspect"
    target: Optional[dict[str, Any]] = None      # What was acted on
    result: Optional[Any] = None                 # Command-specific payload (null on failure)
    warnings: list[str] = Field(default_factory=list)
    errors: list[CLIError] = Field(default_factory=list)
    metrics: dict[str, Any] = Field(default_factory=dict)
```

**Error code taxonomy** — All error codes for `cfgctl`:

| Code | Meaning | Exit code | Retryable | Suggested action |
|------|---------|-----------|-----------|-----------------|
| `ERR_VALIDATION_MISSING_OPTION` | Required CLI option not provided | 10 | No | `fix_input` |
| `ERR_VALIDATION_INVALID_KEY_PATH` | Dot-separated key path is malformed | 10 | No | `fix_input` |
| `ERR_VALIDATION_SCHEMA_FAIL` | Config does not match the provided JSON Schema | 10 | No | `fix_input` |
| `ERR_VALIDATION_INVALID_FORMAT` | File is not valid YAML or JSON | 10 | No | `fix_input` |
| `ERR_VALIDATION_READONLY` | Target file is read-only; use `--force` | 10 | No | `fix_input` |
| `ERR_IO_FILE_NOT_FOUND` | Specified file does not exist | 50 | No | `fix_input` |
| `ERR_IO_PERMISSION_DENIED` | Cannot read or write the specified file | 50 | No | `escalate` |
| `ERR_IO_WRITE_FAILED` | Failed to write to disk (disk full, etc.) | 50 | Yes | `retry` |
| `ERR_INTERNAL_UNEXPECTED` | Unexpected internal error (bug) | 90 | No | `escalate` |

**Exit code ranges:**

| Exit code | Category |
|-----------|----------|
| 0 | Success |
| 10 | Validation error (bad input, schema mismatch) |
| 50 | I/O error (file not found, permission denied, disk full) |
| 90 | Internal error (bug) |

**Output mode precedence** (highest to lowest):
1. Explicit `--output json` or `--output text` flag
2. `LLM=true` environment variable (forces JSON)
3. `isatty()` check — if stdout is not a terminal, use JSON; if terminal, use text

**Read/write separation** — Commands are clearly separated by intent:

| Command | Group | Mutates? | Verb |
|---------|-------|----------|------|
| `cfgctl inspect` | read | No | inspect |
| `cfgctl validate` | read | No | validate |
| `cfgctl diff` | read | No | diff |
| `cfgctl guide` | read | No | guide |
| `cfgctl set` | write | Yes | set |

## Plan of Work

This plan is organized into four milestones executed in order:

1. **Milestone 0 — Scaffold** establishes the repository foundation: guidance files (README, ARCHITECTURE, AGENTS, etc.), quality infrastructure (Ruff, CI), and developer environment.
2. **Milestone 1 — CLI Contract** builds the structured envelope, error taxonomy, exit codes, guide command, output mode detection, and help text — the contract that every subsequent command relies on.
3. **Milestone 2 — Read Commands** implements `inspect`, `validate`, and `diff`, all returning structured metadata inside the envelope.
4. **Milestone 3 — Mutation Command** implements `set` with dry-run, backup, change records, and atomic writes.
5. **Milestone 4 — Integration Testing** validates the full CLI end-to-end against the contract.

Currently, the commands print their output as formatted text tables or colored YAML. The augmented plan replaces this with a structured JSON envelope on stdout (with optional human-readable text mode for terminals) and moves decorative output to stderr.

## Concrete Steps

### Milestone 0 — Scaffold Repository Structure and Guidance Files

**Step 0.1.** Create `pyproject.toml` with project metadata, dependencies, and tool configuration:

```toml
[project]
name = "cfgctl"
version = "0.1.0"
description = "Configuration file manager CLI"
requires-python = ">=3.11"
dependencies = [
    "click>=8.0,<9.0",
    "pyyaml>=6.0,<7.0",
    "jsonschema>=4.0,<5.0",
    "pydantic>=2.0,<3.0",
]

[project.optional-dependencies]
dev = [
    "pytest>=8.0,<9.0",
    "ruff>=0.4.0",
]

[project.scripts]
cfgctl = "cfgctl.cli:cli"

[tool.ruff]
target-version = "py311"
line-length = 100

[tool.ruff.lint]
select = ["E", "F", "I", "W", "UP", "B", "SIM"]

[tool.pytest.ini_options]
testpaths = ["tests"]
```

Note: Rich is removed from dependencies. Structured JSON output replaces Rich-based pretty printing. Human-readable text mode uses plain formatting via Click's built-in echo.

**Step 0.2.** Create `README.md` with:
- One-paragraph project description
- Quick start: `pip install -e ".[dev]"`, then `cfgctl guide` to see all commands
- Repo structure summary (from Context and Orientation above)
- How to run tests: `pytest tests/ -v`
- Link to CONTRIBUTING.md

**Step 0.3.** Create `PROJECT.md` with:
- Problem statement: developers need a CLI to inspect, modify, validate, and diff config files
- Goals: structured output, safe mutations, agent-friendly design
- Non-goals: GUI, config file generation from scratch, remote config stores
- Constraints: Python 3.11+, no runtime dependencies beyond Click/PyYAML/jsonschema/Pydantic

**Step 0.4.** Create `ARCHITECTURE.md` with:
- Stack rationale (Click for CLI, Pydantic for envelope, PyYAML for parsing, jsonschema for validation)
- Component map: `cli.py` (entry point) -> `commands/` (subcommands) -> `envelope.py` (response wrapping) -> `config.py` (file I/O)
- Data flow: CLI input -> load config -> execute operation -> wrap in envelope -> serialize to stdout
- Trade-offs: Click over Typer (debuggability over type-annotation convenience)

**Step 0.5.** Create `TESTING.md` with:
- Strategy: unit tests for each command, integration tests for end-to-end flows
- All tests use Click's `CliRunner` to invoke commands and parse JSON output
- Coverage expectation: every command tested for success, error, and edge cases
- Every PR must pass `pytest tests/ -v` and `ruff check .`

**Step 0.6.** Create `CONTRIBUTING.md`, `CHANGELOG.md`, and `DECISIONS/ADR-0001-initial-architecture.md` with initial content per the scaffolding guide.

**Step 0.7.** Create `AGENTS.md` with:
- Project overview: Python CLI, Click-based, structured JSON envelope on every response
- Authoritative files: this PLAN, ARCHITECTURE.md, the envelope definition in `envelope.py`
- Coding rules: every command must return an `Envelope`, stdout is JSON only, stderr for diagnostics
- How to validate: `pytest tests/ -v && ruff check .`
- When to stop: if a command's error taxonomy is unclear, add a `TODO` rather than guessing codes

**Step 0.8.** Create `.editorconfig`, `.gitignore` (Python template), and `.github/workflows/ci.yml`:

```yaml
# .github/workflows/ci.yml
name: CI
on: [push, pull_request]
jobs:
  check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: "3.11"
      - run: pip install -e ".[dev]"
      - run: ruff check .
      - run: pytest tests/ -v
```

**Step 0.9 (Validation).** Verify:
- All files from steps 0.2-0.8 exist and are non-empty
- `README.md` contains a "Quick start" section
- `.github/workflows/ci.yml` is valid YAML (`python -c "import yaml; yaml.safe_load(open('.github/workflows/ci.yml'))"`)
- `ruff check .` runs without configuration errors (may report issues in code — that's fine at this stage)

---

### Milestone 1 — Establish CLI Contract and Foundations

**Step 1.1.** Create `src/cfgctl/envelope.py` with the `Envelope` and `CLIError` Pydantic models as specified in the CLI Design Contract section above. Include a helper function:

```python
import sys
import os
import time
import json

def emit(envelope: Envelope) -> None:
    """Serialize envelope to stdout and exit with the appropriate code."""
    start = envelope.metrics.get("_start_time")
    if start:
        envelope.metrics["duration_ms"] = round((time.time() - start) * 1000)
        del envelope.metrics["_start_time"]

    output = envelope.model_dump(mode="json")
    json.dump(output, sys.stdout, indent=2)
    sys.stdout.write("\n")

    if not envelope.ok and envelope.errors:
        code = envelope.errors[0].code
        raise SystemExit(_exit_code_for(code))
    raise SystemExit(0)
```

**Step 1.2.** Create `src/cfgctl/errors.py` with the error code constants and exit code mapping:

```python
# Error code constants
ERR_VALIDATION_MISSING_OPTION = "ERR_VALIDATION_MISSING_OPTION"
ERR_VALIDATION_INVALID_KEY_PATH = "ERR_VALIDATION_INVALID_KEY_PATH"
ERR_VALIDATION_SCHEMA_FAIL = "ERR_VALIDATION_SCHEMA_FAIL"
ERR_VALIDATION_INVALID_FORMAT = "ERR_VALIDATION_INVALID_FORMAT"
ERR_VALIDATION_READONLY = "ERR_VALIDATION_READONLY"
ERR_IO_FILE_NOT_FOUND = "ERR_IO_FILE_NOT_FOUND"
ERR_IO_PERMISSION_DENIED = "ERR_IO_PERMISSION_DENIED"
ERR_IO_WRITE_FAILED = "ERR_IO_WRITE_FAILED"
ERR_INTERNAL_UNEXPECTED = "ERR_INTERNAL_UNEXPECTED"

# Exit code mapping
EXIT_CODES: dict[str, int] = {
    "ERR_VALIDATION": 10,
    "ERR_IO": 50,
    "ERR_INTERNAL": 90,
}

def exit_code_for(error_code: str) -> int:
    """Map an error code to its exit code by prefix match."""
    for prefix, code in EXIT_CODES.items():
        if error_code.startswith(prefix):
            return code
    return 90  # Default to internal error
```

**Step 1.3.** Update `src/cfgctl/cli.py` to add root-level flags and output mode detection:

```python
import click
import sys
import os

def _detect_output_mode(explicit: str | None) -> str:
    """Determine output mode: json or text.

    Precedence: explicit flag > LLM=true > isatty() check.
    """
    if explicit:
        return explicit
    if os.environ.get("LLM") == "true":
        return "json"
    if not sys.stdout.isatty():
        return "json"
    return "text"

@click.group()
@click.option("--output", type=click.Choice(["json", "text"]), default=None,
              help="Output format. Default: json when piped, text in terminal.")
@click.option("--quiet", is_flag=True, help="Suppress stderr output.")
@click.option("--verbose", is_flag=True, help="Include extra diagnostics.")
@click.pass_context
def cli(ctx, output, quiet, verbose):
    """cfgctl — Configuration file manager."""
    ctx.ensure_object(dict)
    ctx.obj["output_mode"] = _detect_output_mode(output)
    ctx.obj["quiet"] = quiet
    ctx.obj["verbose"] = verbose
```

**Step 1.4.** Implement `src/cfgctl/commands/guide.py` — the `cfgctl guide` command that returns the full CLI schema as JSON:

```python
@cli.command()
@click.pass_context
def guide(ctx):
    """Return the full CLI schema as JSON for agent bootstrapping."""
    result = {
        "schema_version": "1.0",
        "cli": "cfgctl",
        "description": "Configuration file manager",
        "commands": {
            "config.inspect": {
                "group": "read",
                "description": "Display the contents of a config file",
                "args": ["--file"],
                "flags": ["--output", "--quiet", "--verbose"],
                "mutates": False,
            },
            "config.set": {
                "group": "write",
                "description": "Set a configuration value by key path",
                "args": ["--file", "--key", "--value"],
                "flags": ["--dry-run", "--backup", "--force", "--output", "--quiet", "--verbose"],
                "mutates": True,
            },
            "config.validate": {
                "group": "read",
                "description": "Validate a config file against a JSON Schema",
                "args": ["--file", "--schema"],
                "flags": ["--output", "--quiet", "--verbose"],
                "mutates": False,
            },
            "config.diff": {
                "group": "read",
                "description": "Compare two config files",
                "args": ["--file-a", "--file-b"],
                "flags": ["--output", "--quiet", "--verbose"],
                "mutates": False,
            },
        },
        "error_codes": {
            "ERR_VALIDATION_MISSING_OPTION": {"exit_code": 10, "retryable": False},
            "ERR_VALIDATION_INVALID_KEY_PATH": {"exit_code": 10, "retryable": False},
            "ERR_VALIDATION_SCHEMA_FAIL": {"exit_code": 10, "retryable": False},
            "ERR_VALIDATION_INVALID_FORMAT": {"exit_code": 10, "retryable": False},
            "ERR_VALIDATION_READONLY": {"exit_code": 10, "retryable": False},
            "ERR_IO_FILE_NOT_FOUND": {"exit_code": 50, "retryable": False},
            "ERR_IO_PERMISSION_DENIED": {"exit_code": 50, "retryable": False},
            "ERR_IO_WRITE_FAILED": {"exit_code": 50, "retryable": True},
            "ERR_INTERNAL_UNEXPECTED": {"exit_code": 90, "retryable": False},
        },
        "exit_codes": {
            "0": "Success",
            "10": "Validation error",
            "50": "I/O error",
            "90": "Internal error",
        },
    }
    # guide always outputs JSON regardless of output mode
    emit(Envelope(ok=True, command="guide", result=result))
```

**Step 1.5.** Add examples in `--help` epilog for every command. Use Click's `epilog` parameter or `help` text with embedded examples:

```
Examples:
  # Inspect a config file
  cfgctl inspect --file config.yaml

  # Inspect with JSON output
  cfgctl inspect --file config.yaml --output json

  # Set a value with dry-run preview
  cfgctl set --file config.yaml --key database.host --value localhost --dry-run

  # Validate against a schema
  cfgctl validate --file config.yaml --schema schema.json

  # Diff two config files
  cfgctl diff --file-a staging.yaml --file-b production.yaml

  # Get full CLI schema for agent bootstrapping
  cfgctl guide
```

**Step 1.6.** Write `tests/test_envelope.py` to verify:
- `Envelope` always has `schema_version`, `request_id`, `ok`, `command`, `result`, `errors`, `warnings`, `metrics`
- `errors` and `warnings` are always lists, never `None`
- `result` is `None` on failure, not a missing key
- `CLIError` serializes `code`, `message`, `retryable`, `suggested_action`

**Step 1.7.** Write `tests/test_guide.py` to verify:
- `cfgctl guide` returns valid JSON with `ok: true`
- The result contains `commands`, `error_codes`, and `exit_codes` keys
- Every command listed in the guide matches an actual registered Click command

**Step 1.8 (Validation).** Run:
```bash
cfgctl guide | python -m json.tool
# Verify: valid JSON, contains all commands, error codes, exit codes

cfgctl inspect --file nonexistent.yaml --output json 2>/dev/null
echo $?
# Verify: exit code is 50 (ERR_IO_FILE_NOT_FOUND), stdout is a valid envelope with ok=false

pytest tests/test_envelope.py tests/test_guide.py -v
# Verify: all tests pass
```

---

### Milestone 2 — Implement Read Commands (inspect, validate, diff)

**Step 2.1.** Implement `src/cfgctl/config.py` with config loading and manipulation utilities:

```python
def load_config(path: str) -> dict:
    """Load a YAML or JSON config file. Raises CLIError on failure."""
    ...

def set_nested(data: dict, key_path: str, value: Any) -> tuple[Any, Any]:
    """Set a value at a dot-separated key path. Returns (old_value, new_value)."""
    ...

def diff_configs(a: dict, b: dict) -> list[dict]:
    """Compare two config dicts. Returns list of {path, old, new} entries."""
    ...
```

**Step 2.2.** Implement `src/cfgctl/commands/inspect.py`:

```python
@cli.command()
@click.option("--file", "file_path", required=True, help="Path to config file")
@click.pass_context
def inspect(ctx, file_path):
    """Display the contents of a config file.

    Examples:
      cfgctl inspect --file config.yaml
      cfgctl inspect --file config.yaml --output json
    """
    start = time.time()
    data = load_config(file_path)  # Returns dict or raises with CLIError

    emit(Envelope(
        ok=True,
        command="config.inspect",
        target={"file": file_path},
        result={"config": data, "format": _detect_format(file_path), "keys": sorted(data.keys())},
        metrics={"_start_time": start},
    ))
```

In text mode, format the config as readable YAML to stderr and emit the envelope to stdout. The envelope always goes to stdout.

**Step 2.3.** Implement `src/cfgctl/commands/validate.py`:

```python
@cli.command()
@click.option("--file", "file_path", required=True, help="Path to config file")
@click.option("--schema", "schema_path", required=True, help="Path to JSON Schema file")
@click.pass_context
def validate(ctx, file_path, schema_path):
    """Validate a config file against a JSON Schema.

    Examples:
      cfgctl validate --file config.yaml --schema schema.json
    """
    start = time.time()
    data = load_config(file_path)
    schema = load_config(schema_path)
    validation_errors = validate_config(data, schema)

    if validation_errors:
        emit(Envelope(
            ok=False,
            command="config.validate",
            target={"file": file_path, "schema": schema_path},
            result=None,
            errors=[CLIError(
                code=ERR_VALIDATION_SCHEMA_FAIL,
                message=f"Config validation failed: {len(validation_errors)} error(s)",
                details={"violations": [str(e) for e in validation_errors]},
            )],
            metrics={"_start_time": start},
        ))
    else:
        emit(Envelope(
            ok=True,
            command="config.validate",
            target={"file": file_path, "schema": schema_path},
            result={"valid": True, "checks_passed": len(schema.get("properties", {}))},
            metrics={"_start_time": start},
        ))
```

**Step 2.4.** Implement `src/cfgctl/commands/diff.py`:

```python
@cli.command()
@click.option("--file-a", required=True, help="Path to first config file")
@click.option("--file-b", required=True, help="Path to second config file")
@click.pass_context
def diff(ctx, file_a, file_b):
    """Compare two config files and show differences.

    Examples:
      cfgctl diff --file-a staging.yaml --file-b production.yaml
    """
    start = time.time()
    data_a = load_config(file_a)
    data_b = load_config(file_b)
    differences = diff_configs(data_a, data_b)

    emit(Envelope(
        ok=True,
        command="config.diff",
        target={"file_a": file_a, "file_b": file_b},
        result={
            "identical": len(differences) == 0,
            "total_differences": len(differences),
            "differences": differences,  # List of {path, value_a, value_b}
        },
        metrics={"_start_time": start},
    ))
```

**Step 2.5.** Write tests for each read command in `tests/test_inspect.py`, `tests/test_validate.py`, `tests/test_diff.py`. Every test:
- Uses Click's `CliRunner` to invoke the command
- Parses stdout as JSON
- Verifies the envelope shape (has `ok`, `command`, `result`, `errors`, `warnings`, `metrics`)
- Verifies the command-specific result payload
- Tests error cases (file not found, invalid format) and verifies the correct error code and exit code

**Step 2.6 (Validation).** Run:
```bash
cfgctl inspect --file test-config.yaml --output json | python -m json.tool
# Verify: valid envelope, result.config contains the config data, result.keys is sorted

cfgctl validate --file test-config.yaml --schema schema.json --output json | python -m json.tool
# Verify: valid envelope, ok is true/false depending on validity

cfgctl diff --file-a config-a.yaml --file-b config-b.yaml --output json | python -m json.tool
# Verify: valid envelope, result.differences is a list

pytest tests/test_inspect.py tests/test_validate.py tests/test_diff.py -v
# Verify: all tests pass
```

---

### Milestone 3 — Implement Mutation Command (set) with Safety Rails

**Step 3.1.** Implement atomic write support in `src/cfgctl/config.py`:

```python
import tempfile
import os

def save_config_atomic(path: str, data: dict) -> None:
    """Write config to file atomically: temp file -> fsync -> rename."""
    dir_name = os.path.dirname(os.path.abspath(path))
    with tempfile.NamedTemporaryFile(
        mode="w", dir=dir_name, suffix=".tmp", delete=False
    ) as tmp:
        yaml.dump(data, tmp, default_flow_style=False)
        tmp.flush()
        os.fsync(tmp.fileno())
        tmp_path = tmp.name
    os.replace(tmp_path, path)  # Atomic on POSIX, near-atomic on Windows

def create_backup(path: str) -> str:
    """Create a timestamped backup copy. Returns the backup path."""
    from datetime import datetime, timezone
    ts = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ")
    backup_path = f"{path}.{ts}.bak"
    shutil.copy2(path, backup_path)
    return backup_path
```

**Step 3.2.** Implement `src/cfgctl/commands/set.py` with dry-run, backup, and change records:

```python
@cli.command()
@click.option("--file", "file_path", required=True, help="Path to config file")
@click.option("--key", required=True, help="Dot-separated key path (e.g., database.host)")
@click.option("--value", required=True, help="New value to set")
@click.option("--dry-run", is_flag=True, help="Preview changes without writing")
@click.option("--backup", is_flag=True, help="Create a timestamped backup before writing")
@click.option("--force", is_flag=True, help="Overwrite read-only files")
@click.pass_context
def set(ctx, file_path, key, value, dry_run, backup, force):
    """Set a configuration value at a dot-separated key path.

    Examples:
      cfgctl set --file config.yaml --key database.host --value localhost
      cfgctl set --file config.yaml --key database.port --value 3306 --dry-run
      cfgctl set --file config.yaml --key database.host --value newhost --backup
    """
    start = time.time()
    data = load_config(file_path)
    old_value, new_value = set_nested(data, key, value)

    change_record = {
        "type": "config.set",
        "target": f"{file_path}:{key}",
        "before": old_value,
        "after": new_value,
    }

    if dry_run:
        emit(Envelope(
            ok=True,
            command="config.set",
            target={"file": file_path, "key": key},
            result={"dry_run": True, "changes": [change_record]},
            metrics={"_start_time": start},
        ))
        return

    # Check writable
    if os.path.exists(file_path) and not os.access(file_path, os.W_OK):
        if not force:
            emit(Envelope(
                ok=False,
                command="config.set",
                target={"file": file_path, "key": key},
                result=None,
                errors=[CLIError(
                    code=ERR_VALIDATION_READONLY,
                    message=f"File '{file_path}' is read-only. Use --force to overwrite.",
                )],
                metrics={"_start_time": start},
            ))
            return

    backup_path = None
    if backup:
        backup_path = create_backup(file_path)

    save_config_atomic(file_path, data)

    emit(Envelope(
        ok=True,
        command="config.set",
        target={"file": file_path, "key": key},
        result={
            "dry_run": False,
            "changes": [change_record],
            "backup": backup_path,
        },
        metrics={"_start_time": start},
    ))
```

**Step 3.3.** Write tests in `tests/test_set.py`:
- Test successful set: verify envelope has `ok: true`, change record has correct before/after
- Test dry-run: verify file is not modified, envelope has `dry_run: true`
- Test backup: verify backup file is created with `.bak` extension
- Test read-only file without `--force`: verify `ERR_VALIDATION_READONLY` error code and exit code 10
- Test read-only file with `--force`: verify file is overwritten
- Test invalid key path: verify `ERR_VALIDATION_INVALID_KEY_PATH` error code
- Test file not found: verify `ERR_IO_FILE_NOT_FOUND` error code and exit code 50
- Test idempotence: running set twice with the same key/value produces the same result

**Step 3.4 (Validation).** Run:
```bash
echo "database:\n  host: postgres\n  port: 5432" > /tmp/test-config.yaml

# Dry-run preview
cfgctl set --file /tmp/test-config.yaml --key database.host --value localhost --dry-run --output json
# Verify: ok=true, result.dry_run=true, changes[0].before="postgres", changes[0].after="localhost"
# Verify: file is unchanged

# Actual set with backup
cfgctl set --file /tmp/test-config.yaml --key database.host --value localhost --backup --output json
# Verify: ok=true, result.dry_run=false, result.backup is a path ending in .bak

# Verify the change
cfgctl inspect --file /tmp/test-config.yaml --output json
# Verify: result.config.database.host == "localhost"

pytest tests/test_set.py -v
# Verify: all tests pass
```

---

### Milestone 4 — Integration Testing and Validation

**Step 4.1.** Create `tests/test_integration.py` with end-to-end scenarios:
- Full cycle: inspect -> set (dry-run) -> set (actual) -> inspect (verify change) -> diff (compare with backup)
- Error scenarios: every error code is triggered and verified
- Output modes: verify JSON output when piped, verify text output in terminal mode
- `LLM=true`: verify JSON output is forced when env var is set

**Step 4.2.** Create `tests/conftest.py` with shared fixtures:
- `tmp_config`: creates a temporary YAML config file with known contents
- `tmp_schema`: creates a temporary JSON Schema file
- `cli_runner`: configured Click `CliRunner` for invoking commands

**Step 4.3.** Run the full test suite and acceptance scenarios:
```bash
# Full test suite
pytest tests/ -v
# Expected: all tests pass

# Lint
ruff check src/ tests/
# Expected: no errors

# End-to-end acceptance
cfgctl guide | python -c "import sys, json; d = json.load(sys.stdin); assert d['ok']; assert 'commands' in d['result']"
echo $?
# Expected: 0
```

## Validation and Acceptance

Create a sample config file and verify all commands return valid envelopes:

```bash
echo "database:\n  host: postgres\n  port: 5432" > test-config.yaml

# Inspect — envelope with config contents
cfgctl inspect --file test-config.yaml --output json
# Expected: {"ok": true, "command": "config.inspect", "result": {"config": {"database": {"host": "postgres", "port": 5432}}, ...}, ...}

# Set with dry-run — preview without writing
cfgctl set --file test-config.yaml --key database.host --value localhost --dry-run --output json
# Expected: {"ok": true, ..., "result": {"dry_run": true, "changes": [{"before": "postgres", "after": "localhost"}]}}

# Set — actual mutation with change record
cfgctl set --file test-config.yaml --key database.host --value localhost --output json
# Expected: {"ok": true, ..., "result": {"dry_run": false, "changes": [{"before": "postgres", "after": "localhost"}]}}

# Inspect — verify the change took effect
cfgctl inspect --file test-config.yaml --output json
# Expected: result.config.database.host == "localhost"

# Validate — check against schema
cfgctl validate --file test-config.yaml --schema schema.json --output json
# Expected: {"ok": true, ...} or {"ok": false, "errors": [{"code": "ERR_VALIDATION_SCHEMA_FAIL", ...}]}

# Error case — file not found
cfgctl inspect --file nonexistent.yaml --output json 2>/dev/null
echo $?
# Expected: exit code 50, envelope has ok=false, errors[0].code == "ERR_IO_FILE_NOT_FOUND"

# Guide — full CLI schema
cfgctl guide
# Expected: valid JSON with all commands, error codes, exit codes

# Full test suite
pytest tests/ -v
# Expected: all tests pass
```

## Idempotence and Recovery

The `inspect`, `validate`, `diff`, and `guide` commands are read-only and safe to run repeatedly. They never modify files or state.

The `set` command writes to config files. Running `set` twice with the same key and value produces the same result (idempotent). The `--dry-run` flag previews changes without writing. The `--backup` flag creates a timestamped copy before writing, enabling recovery. Atomic writes (temp file + fsync + rename) ensure that a crash mid-write leaves the original file intact.

## Artifacts and Notes

None yet.

## Interfaces and Dependencies

- **click** (^8.x) — CLI framework
- **pyyaml** (^6.x) — YAML parsing
- **jsonschema** (^4.x) — Schema validation
- **pydantic** (^2.x) — Response envelope model and serialization
- **pytest** (^8.x) — Test framework
- **ruff** (^0.4.x) — Linting and formatting

Key functions:
- `load_config(path: str) -> dict` — Load a YAML or JSON config file
- `save_config_atomic(path: str, data: dict) -> None` — Atomic write: temp file + fsync + rename
- `create_backup(path: str) -> str` — Create a timestamped `.bak` copy
- `set_nested(data: dict, key_path: str, value: Any) -> tuple[Any, Any]` — Set value at key path, return (old, new)
- `validate_config(data: dict, schema: dict) -> list[ValidationError]` — Validate against JSON Schema
- `diff_configs(a: dict, b: dict) -> list[dict]` — Compare two config dicts
- `Envelope.model_dump() -> dict` — Serialize the response envelope to a dict for JSON output
- `emit(envelope: Envelope) -> None` — Serialize envelope to stdout and exit with appropriate code
- `exit_code_for(error_code: str) -> int` — Map error code prefix to exit code
