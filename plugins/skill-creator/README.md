# Skill Creator Plugin for Claude Code

Create new skills, modify and improve existing skills, and measure skill performance with iterative evaluation loops.

## Features

- **Skill drafting**: Guide users through creating skills from scratch with structured workflows
- **Eval-driven iteration**: Run test prompts, collect qualitative and quantitative feedback, and iterate
- **Benchmarking**: Aggregate benchmark results with variance analysis across multiple runs
- **Description optimization**: Optimize skill descriptions for better triggering accuracy
- **Eval viewer**: HTML-based review interface for examining skill evaluation results

## Installation

Add this plugin to your Claude Code configuration:

```bash
claude --plugin-dir /path/to/skill-creator
```

Or copy to your project's `.claude-plugin/` directory.

## Usage

### Automatic Skill Activation

The `skill-creator` skill activates automatically when you ask to:
- Create a new skill from scratch
- Modify or improve an existing skill
- Run evals to test a skill
- Benchmark skill performance with variance analysis
- Optimize a skill's description for better triggering

### Example Requests

- "Create a skill for generating API documentation"
- "Run evals on my custom skill"
- "Benchmark this skill across multiple test cases"
- "Optimize this skill's trigger description"

## Components

- **Skill**: `skill-creator` — full skill creation and iteration workflow
- **Agents**: `analyzer`, `comparator`, `grader` — specialized agents for evaluation
- **Scripts**: eval runner, benchmark aggregator, report generator, description optimizer
- **Eval Viewer**: HTML-based review interface for evaluation results
- **References**: `schemas.md` — skill schema documentation

## License

See LICENSE.txt
