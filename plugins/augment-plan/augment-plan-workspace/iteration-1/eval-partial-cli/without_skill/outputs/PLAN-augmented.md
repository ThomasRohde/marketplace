# Build a Config File Manager CLI

This ExecPlan is a living document. The sections `Progress`, `Surprises & Discoveries`, `Decision Log`, and `Outcomes & Retrospective` must be kept up to date as work proceeds.

## Purpose / Big Picture

After this change, developers can manage application configuration files using the `cfgctl` CLI. They can inspect current config values, set individual keys, validate configs against a schema, and diff configs between environments. To see it working, run `cfgctl inspect --file config.yaml` to see the current configuration, then `cfgctl set --file config.yaml --key database.host --value localhost` to change a value.

## Progress

- [ ] Set up the Python project with Click and PyYAML
- [ ] Configure linting (ruff) and formatting (ruff format)
- [ ] Set up pre-commit hooks
- [ ] Implement structured output layer (text, JSON, YAML output modes)
- [ ] Define exit code conventions and error handling framework
- [ ] Implement `cfgctl inspect` to display config file contents
- [ ] Implement `cfgctl set` to modify config values by key path
- [ ] Implement `cfgctl validate` to check config against a JSON Schema
- [ ] Implement `cfgctl diff` to compare two config files
- [ ] Write unit tests with pytest
- [ ] Write integration / CLI-invocation tests
- [ ] Set up CI pipeline (GitHub Actions)
- [ ] Write README and architecture documentation
- [ ] Run full test suite and verify all pass
- [ ] Run linter and verify zero violations

## Surprises & Discoveries

No discoveries yet -- this section will be populated during implementation.

## Decision Log

- Decision: Use Click instead of argparse or Typer.
  Rationale: Click provides a clean decorator-based API for subcommands and has excellent support for nested groups. Typer is built on Click but adds type-annotation magic that can be harder to debug.
  Date/Author: 2026-03-10 / Plan Author

- Decision: Support YAML and JSON config files, with YAML as the default.
  Rationale: YAML is the dominant config format in the cloud-native ecosystem. JSON support is low-effort since PyYAML handles both.
  Date/Author: 2026-03-10 / Plan Author

- Decision: Use ruff for both linting and formatting.
  Rationale: Ruff is a single, fast tool that replaces flake8, isort, and black. It reduces toolchain complexity and runs in milliseconds, making it viable as a pre-commit hook and CI gate.
  Date/Author: 2026-03-10 / Augmentation

- Decision: Support `--output` flag with `text`, `json`, and `yaml` modes on all read commands.
  Rationale: Machine-readable output (JSON/YAML) is essential for composability with other tools (jq, yq, scripts). Text mode remains default for human users. This follows the convention used by tools like kubectl, gh, and docker.
  Date/Author: 2026-03-10 / Augmentation

- Decision: Use well-defined exit codes (0 = success, 1 = general error, 2 = usage/argument error, 3 = file-not-found, 4 = validation failure, 5 = schema error).
  Rationale: Distinct exit codes allow callers to programmatically distinguish error classes without parsing stderr. This is standard practice for production CLIs.
  Date/Author: 2026-03-10 / Augmentation

- Decision: Emit all diagnostic/error output to stderr; reserve stdout for data output only.
  Rationale: Separating data from diagnostics allows piping stdout to other tools without corruption. This follows the Unix convention used by curl, git, and other composable CLIs.
  Date/Author: 2026-03-10 / Augmentation

## Outcomes & Retrospective

To be completed at major milestones and at plan completion.

## Context and Orientation

This plan creates `cfgctl`, a Python CLI for managing configuration files. The tool reads, modifies, validates, and diffs YAML/JSON configuration files. It uses Click for CLI argument parsing, PyYAML for YAML handling, and jsonschema for validation.

The original plan produces only formatted text output. This augmented plan adds:
- **Structured output**: every read command supports `--output text|json|yaml` so output is machine-parseable.
- **Error handling**: a unified error model with typed exceptions, well-defined exit codes, and stderr-only diagnostics.
- **Project scaffolding**: README, architecture docs, CI pipeline, linting, formatting, pre-commit hooks, and a layered testing strategy.

Project structure:

    cfgctl/
    ├── src/
    │   └── cfgctl/
    │       ├── __init__.py
    │       ├── cli.py              # Click group, global options (--output, --quiet, --verbose)
    │       ├── commands/
    │       │   ├── __init__.py
    │       │   ├── inspect.py      # `cfgctl inspect` command
    │       │   ├── set.py          # `cfgctl set` command
    │       │   ├── validate.py     # `cfgctl validate` command
    │       │   └── diff.py         # `cfgctl diff` command
    │       ├── config.py           # Config file loading and manipulation utilities
    │       ├── output.py           # Structured output rendering (text/json/yaml)
    │       ├── errors.py           # Error types and exit code constants
    │       └── logging.py          # Stderr logging helpers (--verbose / --quiet)
    ├── tests/
    │   ├── conftest.py             # Shared fixtures (tmp config files, Click CLI runner)
    │   ├── unit/
    │   │   ├── test_config.py      # Unit tests for config loading/saving/set_nested
    │   │   ├── test_output.py      # Unit tests for output formatting
    │   │   └── test_errors.py      # Unit tests for error mapping
    │   ├── integration/
    │   │   ├── test_inspect.py     # CLI invocation tests for inspect
    │   │   ├── test_set.py         # CLI invocation tests for set
    │   │   ├── test_validate.py    # CLI invocation tests for validate
    │   │   └── test_diff.py        # CLI invocation tests for diff
    │   └── fixtures/
    │       ├── sample-config.yaml
    │       ├── sample-config.json
    │       ├── valid-schema.json
    │       └── invalid-schema.json
    ├── docs/
    │   └── architecture.md         # Architecture decision records and design overview
    ├── .github/
    │   └── workflows/
    │       └── ci.yml              # Lint, test, build on push/PR
    ├── .pre-commit-config.yaml
    ├── pyproject.toml
    └── README.md

Key terms:
- **Key path**: A dot-separated path into a nested config structure, e.g., `database.host` refers to `{"database": {"host": "..."}}`.
- **JSON Schema**: A standard for describing the expected shape of a JSON/YAML document, used by the `validate` command to check correctness.
- **Structured output**: Machine-readable output format (JSON or YAML) as an alternative to human-readable text, selected via `--output json` or `--output yaml`.
- **Exit code**: A numeric status returned to the calling shell. Zero means success; non-zero values distinguish specific failure categories.

## Plan of Work

Initialize the Python project with pyproject.toml and tooling configuration, then build the core infrastructure (error handling, output formatting, config utilities), and finally implement the four commands on top of that infrastructure. Each command supports structured output from the start.

The original plan has commands printing formatted text tables or colored YAML. This augmented plan wraps all output through an `OutputRenderer` that switches between text (Rich-formatted), JSON, and YAML based on the `--output` global option. Errors are routed through a centralized handler that maps exception types to exit codes and writes diagnostics to stderr.

## Concrete Steps

### Phase 0: Project Scaffolding

1. Create `pyproject.toml` with project metadata, dependencies, dev dependencies, tool configuration, and a console script entry point:

       [project]
       name = "cfgctl"
       version = "0.1.0"
       requires-python = ">=3.11"
       dependencies = [
           "click>=8.1,<9",
           "pyyaml>=6.0,<7",
           "jsonschema>=4.20,<5",
           "rich>=13.0,<14",
       ]

       [project.optional-dependencies]
       dev = [
           "pytest>=8.0,<9",
           "pytest-cov>=5.0,<6",
           "ruff>=0.3,<1",
           "pre-commit>=3.6,<4",
       ]

       [project.scripts]
       cfgctl = "cfgctl.cli:cli"

       [tool.ruff]
       target-version = "py311"
       line-length = 100

       [tool.ruff.lint]
       select = [
           "E",    # pycodestyle errors
           "W",    # pycodestyle warnings
           "F",    # pyflakes
           "I",    # isort
           "N",    # pep8-naming
           "UP",   # pyupgrade
           "B",    # flake8-bugbear
           "SIM",  # flake8-simplify
           "RUF",  # ruff-specific rules
       ]

       [tool.pytest.ini_options]
       testpaths = ["tests"]
       addopts = "-v --tb=short --strict-markers"

       [build-system]
       requires = ["setuptools>=68"]
       build-backend = "setuptools.backends._legacy:_Backend"

2. Create `.pre-commit-config.yaml`:

       repos:
         - repo: https://github.com/astral-sh/ruff-pre-commit
           rev: v0.3.0
           hooks:
             - id: ruff
               args: [--fix]
             - id: ruff-format

3. Create `.github/workflows/ci.yml`:

       name: CI
       on:
         push:
           branches: [main]
         pull_request:
       jobs:
         lint:
           runs-on: ubuntu-latest
           steps:
             - uses: actions/checkout@v4
             - uses: actions/setup-python@v5
               with:
                 python-version: "3.11"
             - run: pip install -e ".[dev]"
             - run: ruff check .
             - run: ruff format --check .
         test:
           runs-on: ubuntu-latest
           strategy:
             matrix:
               python-version: ["3.11", "3.12", "3.13"]
           steps:
             - uses: actions/checkout@v4
             - uses: actions/setup-python@v5
               with:
                 python-version: ${{ matrix.python-version }}
             - run: pip install -e ".[dev]"
             - run: pytest --cov=cfgctl --cov-report=term-missing

4. Create `README.md` with sections: Overview, Installation (`pip install -e ".[dev]"`), Usage (one example per command, showing both text and JSON output), Exit Codes table, Development (lint, test, pre-commit), and License.

5. Create `docs/architecture.md` covering: system context diagram (user -> cfgctl -> filesystem), component overview (CLI layer, command layer, core library, output renderer, error handler), data flow for each command, and the structured output contract.

### Phase 1: Core Infrastructure

6. Implement `src/cfgctl/errors.py` -- exit code constants and typed exceptions:

       # Exit codes
       EXIT_SUCCESS = 0
       EXIT_GENERAL_ERROR = 1
       EXIT_USAGE_ERROR = 2
       EXIT_FILE_NOT_FOUND = 3
       EXIT_VALIDATION_FAILURE = 4
       EXIT_SCHEMA_ERROR = 5

       class CfgctlError(click.ClickException):
           """Base error with an associated exit code."""
           exit_code: int = EXIT_GENERAL_ERROR

       class FileNotFoundError(CfgctlError):
           exit_code = EXIT_FILE_NOT_FOUND

       class ValidationFailureError(CfgctlError):
           exit_code = EXIT_VALIDATION_FAILURE

       class SchemaError(CfgctlError):
           exit_code = EXIT_SCHEMA_ERROR

   The base `CfgctlError` extends `click.ClickException` so Click's built-in error handling routes the message to stderr and uses the `exit_code` attribute to set the process return code.

7. Implement `src/cfgctl/output.py` -- structured output renderer:

       from enum import Enum

       class OutputFormat(str, Enum):
           TEXT = "text"
           JSON = "json"
           YAML = "yaml"

       class OutputRenderer:
           def __init__(self, fmt: OutputFormat, file=sys.stdout):
               self.fmt = fmt
               self.file = file

           def render(self, data: Any, text_formatter: Callable | None = None) -> None:
               """Render data to stdout in the requested format.

               Args:
                   data: The data to render. For json/yaml modes this is
                       serialized directly. For text mode, text_formatter
                       is called with data if provided, otherwise data is
                       printed with Rich.
                   text_formatter: Optional callable for custom text output.
               """
               if self.fmt == OutputFormat.JSON:
                   json.dump(data, self.file, indent=2, default=str)
               elif self.fmt == OutputFormat.YAML:
                   yaml.dump(data, self.file, default_flow_style=False)
               else:
                   if text_formatter:
                       text_formatter(data)
                   else:
                       rich.print_json(data=data)

   Every command receives the renderer via Click's context and calls `renderer.render(data)` instead of printing directly. This guarantees that `--output json` works uniformly.

8. Implement `src/cfgctl/logging.py` -- stderr-only diagnostic logging:

       import logging
       import click

       def configure_logging(verbose: bool, quiet: bool) -> None:
           level = logging.DEBUG if verbose else (logging.WARNING if quiet else logging.INFO)
           handler = logging.StreamHandler(sys.stderr)
           handler.setFormatter(logging.Formatter("%(levelname)s: %(message)s"))
           logging.root.addHandler(handler)
           logging.root.setLevel(level)

   This ensures all log messages go to stderr, keeping stdout clean for data.

9. Implement `src/cfgctl/config.py` -- config file loading and manipulation:

       def load_config(path: str) -> dict:
           """Load a YAML or JSON config file. Raises FileNotFoundError."""
           ...

       def save_config(path: str, data: dict) -> None:
           """Write data back to the config file, preserving format."""
           ...

       def set_nested(data: dict, key_path: str, value: Any) -> None:
           """Set a value at a dot-separated key path.
           Creates intermediate dicts as needed.
           Raises KeyError for invalid traversals (e.g., trying to
           descend into a scalar).
           """
           ...

       def diff_configs(a: dict, b: dict) -> list[dict]:
           """Return a list of diff entries: {path, old, new, change_type}.
           change_type is one of: 'added', 'removed', 'changed'.
           This structured representation can be rendered as text or JSON.
           """
           ...

       def validate_config(data: dict, schema_path: str) -> list[dict]:
           """Validate data against a JSON Schema file.
           Returns a list of error dicts: {path, message, validator}.
           Empty list means valid.
           Raises SchemaError if the schema file itself is invalid.
           """
           ...

   All return values are plain dicts/lists so they serialize directly to JSON/YAML via the output renderer.

### Phase 2: CLI Layer and Commands

10. Implement `src/cfgctl/cli.py` -- Click group with global options:

        @click.group()
        @click.option("--output", "-o", type=click.Choice(["text", "json", "yaml"]),
                       default="text", help="Output format.")
        @click.option("--verbose", "-v", is_flag=True, help="Enable debug logging to stderr.")
        @click.option("--quiet", "-q", is_flag=True, help="Suppress informational messages.")
        @click.version_option(package_name="cfgctl")
        @click.pass_context
        def cli(ctx, output, verbose, quiet):
            """cfgctl -- Configuration file manager."""
            ctx.ensure_object(dict)
            configure_logging(verbose, quiet)
            ctx.obj["renderer"] = OutputRenderer(OutputFormat(output))

11. Implement `src/cfgctl/commands/inspect.py`:

        @cli.command("inspect")
        @click.option("--file", "-f", required=True, type=click.Path(exists=True),
                       help="Path to config file.")
        @click.pass_context
        def inspect_cmd(ctx, file):
            """Display the contents of a config file."""
            data = load_config(file)
            renderer = ctx.obj["renderer"]
            renderer.render(data, text_formatter=lambda d: print_rich_yaml(d))

    Text mode: pretty-prints YAML with Rich syntax highlighting (original behavior preserved).
    JSON mode: outputs `{"database": {"host": "postgres", "port": 5432}}`.
    YAML mode: outputs raw YAML.

12. Implement `src/cfgctl/commands/set.py`:

        @cli.command("set")
        @click.option("--file", "-f", required=True, type=click.Path(exists=True))
        @click.option("--key", "-k", required=True, help="Dot-separated key path.")
        @click.option("--value", required=True)
        @click.option("--type", "value_type", type=click.Choice(["str", "int", "float", "bool"]),
                       default="str", help="Cast the value to this type before setting.")
        @click.pass_context
        def set_cmd(ctx, file, key, value, value_type):
            """Set a configuration value by key path."""
            data = load_config(file)
            cast_value = cast_to_type(value, value_type)
            set_nested(data, key, cast_value)
            save_config(file, data)
            result = {"key": key, "value": cast_value, "file": file}
            renderer = ctx.obj["renderer"]
            renderer.render(result,
                text_formatter=lambda d: click.echo(f"Set {d['key']} = {d['value']}", err=False))

    The `--type` flag (augmented) lets users set numeric and boolean values without them being stored as strings. This is a common pain point with config CLIs.

13. Implement `src/cfgctl/commands/validate.py`:

        @cli.command("validate")
        @click.option("--file", "-f", required=True, type=click.Path(exists=True))
        @click.option("--schema", "-s", required=True, type=click.Path(exists=True),
                       help="Path to JSON Schema file.")
        @click.pass_context
        def validate_cmd(ctx, file, schema):
            """Validate a config file against a JSON Schema."""
            data = load_config(file)
            errors = validate_config(data, schema)
            renderer = ctx.obj["renderer"]
            if not errors:
                result = {"valid": True, "errors": []}
                renderer.render(result,
                    text_formatter=lambda d: click.echo("Config is valid."))
                ctx.exit(EXIT_SUCCESS)
            else:
                result = {"valid": False, "errors": errors}
                renderer.render(result,
                    text_formatter=lambda d: print_validation_errors(d["errors"]))
                ctx.exit(EXIT_VALIDATION_FAILURE)

    The exit code distinguishes "config is invalid" (exit 4) from "schema file is broken" (exit 5) and "file not found" (exit 3). In JSON mode the caller gets a structured `{"valid": false, "errors": [...]}` payload.

14. Implement `src/cfgctl/commands/diff.py`:

        @cli.command("diff")
        @click.option("--file-a", "-a", required=True, type=click.Path(exists=True),
                       help="First config file.")
        @click.option("--file-b", "-b", required=True, type=click.Path(exists=True),
                       help="Second config file.")
        @click.pass_context
        def diff_cmd(ctx, file_a, file_b):
            """Show differences between two config files."""
            data_a = load_config(file_a)
            data_b = load_config(file_b)
            diffs = diff_configs(data_a, data_b)
            renderer = ctx.obj["renderer"]
            if not diffs:
                result = {"identical": True, "differences": []}
                renderer.render(result,
                    text_formatter=lambda d: click.echo("Files are identical."))
            else:
                result = {"identical": False, "differences": diffs}
                renderer.render(result,
                    text_formatter=lambda d: print_rich_diff_table(d["differences"]))

    In text mode the diff is rendered as a Rich table (original behavior). In JSON mode the output is a list of `{path, old, new, change_type}` objects.

### Phase 3: Testing

15. Create `tests/conftest.py` with shared fixtures:

        @pytest.fixture
        def cli_runner():
            """Click test runner for invoking commands."""
            return CliRunner(mix_stderr=False)

        @pytest.fixture
        def sample_yaml(tmp_path):
            """Write a sample YAML config to a temp file and return its path."""
            ...

        @pytest.fixture
        def sample_schema(tmp_path):
            """Write a sample JSON Schema to a temp file and return its path."""
            ...

16. Write unit tests in `tests/unit/`:
    - `test_config.py`: Test `load_config` for YAML and JSON files, `set_nested` for simple keys / nested keys / creating intermediate dicts / error on scalar traversal, `diff_configs` for added/removed/changed keys, `validate_config` for valid and invalid configs.
    - `test_output.py`: Test `OutputRenderer.render` produces correct JSON, YAML, and text output by capturing stdout.
    - `test_errors.py`: Test that each error type carries the correct exit code.

17. Write integration tests in `tests/integration/`:
    - `test_inspect.py`: Invoke `cfgctl inspect --file ... --output json`, parse stdout as JSON, assert structure. Also test `--output text` produces non-empty output. Test with missing file, assert exit code 3.
    - `test_set.py`: Invoke `cfgctl set`, then `cfgctl inspect --output json` to round-trip verify. Test `--type int` stores an integer, not a string. Test with invalid key path, assert exit code 1.
    - `test_validate.py`: Test valid config exits 0. Test invalid config exits 4. Test broken schema exits 5. Verify JSON output contains `{"valid": false, ...}`.
    - `test_diff.py`: Diff identical files, assert exit 0 and `{"identical": true}`. Diff different files, assert structured differences.

18. Verify full test suite:

        pytest tests/ -v --cov=cfgctl --cov-report=term-missing

    Expected: all tests pass, coverage >= 90% on `src/cfgctl/`.

### Phase 4: Linting, Formatting, and Final Checks

19. Run linter and formatter:

        ruff check src/ tests/
        ruff format --check src/ tests/

    Expected: zero violations.

20. Install and run pre-commit hooks:

        pre-commit install
        pre-commit run --all-files

    Expected: all hooks pass.

21. Run the full CI pipeline locally (lint + test) to verify it matches what GitHub Actions will do:

        ruff check . && ruff format --check . && pytest tests/ -v --cov=cfgctl

    Expected: clean pass.

## Validation and Acceptance

Create a sample config file and verify both human and machine output modes:

    echo "database:\n  host: postgres\n  port: 5432" > test-config.yaml

    # Human-readable output (default)
    cfgctl inspect --file test-config.yaml
    # Expected: pretty-printed YAML output showing database.host and database.port

    # Machine-readable JSON output
    cfgctl inspect --file test-config.yaml --output json
    # Expected: {"database": {"host": "postgres", "port": 5432}}

    cfgctl set --file test-config.yaml --key database.host --value localhost
    # Expected: prints "Set database.host = localhost", exit code 0

    cfgctl set --file test-config.yaml --key database.port --value 3306 --type int
    # Expected: stores 3306 as integer, not string "3306"

    cfgctl inspect --file test-config.yaml --output json
    # Expected: {"database": {"host": "localhost", "port": 3306}}

    cfgctl validate --file test-config.yaml --schema schema.json
    # Expected: "Config is valid", exit code 0

    cfgctl validate --file bad-config.yaml --schema schema.json
    # Expected: validation errors listed, exit code 4

    cfgctl validate --file test-config.yaml --schema schema.json --output json
    # Expected: {"valid": true, "errors": []}

    cfgctl diff --file-a staging.yaml --file-b production.yaml --output json
    # Expected: {"identical": false, "differences": [{"path": "database.host", ...}]}

    # Error handling
    cfgctl inspect --file nonexistent.yaml
    # Expected: error message on stderr, exit code 3

    # Full test suite
    pytest tests/ -v --cov=cfgctl --cov-report=term-missing
    # Expected: all tests pass, coverage >= 90%

    # Linting
    ruff check . && ruff format --check .
    # Expected: zero violations

## Idempotence and Recovery

The `inspect`, `validate`, and `diff` commands are read-only and safe to run repeatedly. The `set` command overwrites the config file directly. Running `set` twice with the same key and value produces the same result.

For crash safety during `set`: write the updated config to a temporary file in the same directory, then atomically rename it over the original. This prevents partial writes from corrupting the config file if the process is interrupted. The implementation should use `tempfile.NamedTemporaryFile(dir=..., delete=False)` followed by `os.replace()`.

## Artifacts and Notes

- `README.md` -- user-facing documentation with install, usage, and exit code reference.
- `docs/architecture.md` -- internal architecture overview and design decisions.
- `.github/workflows/ci.yml` -- CI pipeline definition.
- `.pre-commit-config.yaml` -- pre-commit hook configuration.

## Interfaces and Dependencies

- **click** (>=8.1, <9) -- CLI framework
- **pyyaml** (>=6.0, <7) -- YAML parsing
- **jsonschema** (>=4.20, <5) -- Schema validation
- **rich** (>=13.0, <14) -- Pretty printing and syntax highlighting
- **pytest** (>=8.0, <9) -- Test framework (dev)
- **pytest-cov** (>=5.0, <6) -- Coverage reporting (dev)
- **ruff** (>=0.3, <1) -- Linting and formatting (dev)
- **pre-commit** (>=3.6, <4) -- Git hook management (dev)

Key functions:
- `load_config(path: str) -> dict` -- Load YAML or JSON config; raises `FileNotFoundError`.
- `save_config(path: str, data: dict) -> None` -- Atomically write config back to file.
- `set_nested(data: dict, key_path: str, value: Any) -> None` -- Set value at dot-separated path.
- `validate_config(data: dict, schema_path: str) -> list[dict]` -- Returns list of `{path, message, validator}` error dicts.
- `diff_configs(a: dict, b: dict) -> list[dict]` -- Returns list of `{path, old, new, change_type}` diff entries.
- `OutputRenderer.render(data, text_formatter=None) -> None` -- Renders data in the configured format to stdout.
- `configure_logging(verbose: bool, quiet: bool) -> None` -- Sets up stderr-only logging.

Exit codes:
| Code | Meaning |
|------|---------|
| 0 | Success |
| 1 | General / unexpected error |
| 2 | Usage / argument error (handled by Click) |
| 3 | File not found |
| 4 | Validation failure (config does not match schema) |
| 5 | Schema error (schema file itself is invalid) |

Global CLI flags:
| Flag | Description |
|------|-------------|
| `--output, -o` | Output format: `text` (default), `json`, `yaml` |
| `--verbose, -v` | Enable debug logging to stderr |
| `--quiet, -q` | Suppress informational messages on stderr |
| `--version` | Print version and exit |
| `--help` | Print help and exit |
