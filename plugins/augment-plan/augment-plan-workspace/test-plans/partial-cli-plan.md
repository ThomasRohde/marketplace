# Build a Config File Manager CLI

This ExecPlan is a living document. The sections `Progress`, `Surprises & Discoveries`, `Decision Log`, and `Outcomes & Retrospective` must be kept up to date as work proceeds.

## Purpose / Big Picture

After this change, developers can manage application configuration files using the `cfgctl` CLI. They can inspect current config values, set individual keys, validate configs against a schema, and diff configs between environments. To see it working, run `cfgctl inspect --file config.yaml` to see the current configuration, then `cfgctl set --file config.yaml --key database.host --value localhost` to change a value.

## Progress

- [ ] Set up the Python project with Click and PyYAML
- [ ] Implement `cfgctl inspect` to display config file contents
- [ ] Implement `cfgctl set` to modify config values by key path
- [ ] Implement `cfgctl validate` to check config against a JSON Schema
- [ ] Implement `cfgctl diff` to compare two config files
- [ ] Write tests with pytest
- [ ] Run tests and verify all pass

## Surprises & Discoveries

No discoveries yet — this section will be populated during implementation.

## Decision Log

- Decision: Use Click instead of argparse or Typer.
  Rationale: Click provides a clean decorator-based API for subcommands and has excellent support for nested groups. Typer is built on Click but adds type-annotation magic that can be harder to debug.
  Date/Author: 2026-03-10 / Plan Author

- Decision: Support YAML and JSON config files, with YAML as the default.
  Rationale: YAML is the dominant config format in the cloud-native ecosystem. JSON support is low-effort since PyYAML handles both.
  Date/Author: 2026-03-10 / Plan Author

## Outcomes & Retrospective

To be completed at major milestones and at plan completion.

## Context and Orientation

This plan creates `cfgctl`, a Python CLI for managing configuration files. The tool reads, modifies, validates, and diffs YAML/JSON configuration files. It uses Click for CLI argument parsing, PyYAML for YAML handling, and jsonschema for validation.

Project structure:

    cfgctl/
    ├── src/
    │   └── cfgctl/
    │       ├── __init__.py
    │       ├── cli.py          # Click group and command registration
    │       ├── commands/
    │       │   ├── __init__.py
    │       │   ├── inspect.py  # `cfgctl inspect` command
    │       │   ├── set.py      # `cfgctl set` command
    │       │   ├── validate.py # `cfgctl validate` command
    │       │   └── diff.py     # `cfgctl diff` command
    │       └── config.py       # Config file loading and manipulation utilities
    ├── tests/
    │   ├── test_inspect.py
    │   ├── test_set.py
    │   ├── test_validate.py
    │   └── test_diff.py
    ├── pyproject.toml
    └── README.md

Key terms:
- **Key path**: A dot-separated path into a nested config structure, e.g., `database.host` refers to `{"database": {"host": "..."}}`.
- **JSON Schema**: A standard for describing the expected shape of a JSON/YAML document, used by the `validate` command to check correctness.

## Plan of Work

Initialize the Python project with pyproject.toml, then implement the four commands. The `inspect` command prints the current config. The `set` command modifies a value at a key path. The `validate` command checks against a JSON Schema file. The `diff` command shows differences between two config files.

Currently, the commands print their output as formatted text tables or colored YAML. For example, `inspect` prints the YAML content with syntax highlighting, and `diff` shows a side-by-side colored diff.

## Concrete Steps

1. Create `pyproject.toml` with Click, PyYAML, jsonschema, and rich as dependencies. Add pytest as dev dependency.

2. Implement `src/cfgctl/cli.py`:

       import click

       @click.group()
       def cli():
           """Configuration file manager."""
           pass

3. Implement `src/cfgctl/commands/inspect.py`:

       @cli.command()
       @click.option("--file", required=True, help="Path to config file")
       def inspect(file):
           """Display the contents of a config file."""
           data = load_config(file)
           print_yaml(data)  # Pretty-prints with Rich

4. Implement `src/cfgctl/commands/set.py`:

       @cli.command()
       @click.option("--file", required=True)
       @click.option("--key", required=True, help="Dot-separated key path")
       @click.option("--value", required=True)
       def set(file, key, value):
           """Set a configuration value."""
           data = load_config(file)
           set_nested(data, key, value)
           save_config(file, data)
           click.echo(f"Set {key} = {value}")

5. Implement `validate` and `diff` commands similarly.

6. Write tests:

       pytest tests/ -v

   Expected: all tests pass.

## Validation and Acceptance

Create a sample config file and verify:

    echo "database:\n  host: postgres\n  port: 5432" > test-config.yaml

    cfgctl inspect --file test-config.yaml
    # Expected: pretty-printed YAML output showing database.host and database.port

    cfgctl set --file test-config.yaml --key database.host --value localhost
    # Expected: prints "Set database.host = localhost"

    cfgctl inspect --file test-config.yaml
    # Expected: database.host now shows "localhost"

    cfgctl validate --file test-config.yaml --schema schema.json
    # Expected: "Config is valid" or validation errors

    pytest tests/ -v
    # Expected: all tests pass

## Idempotence and Recovery

The `inspect`, `validate`, and `diff` commands are read-only and safe to run repeatedly. The `set` command overwrites the config file directly. Running `set` twice with the same key and value produces the same result.

## Artifacts and Notes

None yet.

## Interfaces and Dependencies

- **click** (^8.x) — CLI framework
- **pyyaml** (^6.x) — YAML parsing
- **jsonschema** (^4.x) — Schema validation
- **rich** (^13.x) — Pretty printing and syntax highlighting
- **pytest** (^8.x) — Test framework

Key functions:
- `load_config(path: str) -> dict`
- `save_config(path: str, data: dict) -> None`
- `set_nested(data: dict, key_path: str, value: Any) -> None`
- `validate_config(data: dict, schema_path: str) -> list[ValidationError]`
- `diff_configs(a: dict, b: dict) -> list[DiffEntry]`
