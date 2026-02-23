# Improve Skill Plugin for Claude Code

Analyze and improve existing Claude Code skills using research-backed findings from the SkillsBench paper (arXiv:2602.12670v1), which evaluated 7,308 agent trajectories to identify what makes skills effective.

## Features

- **Structured audit**: Score skills across five research-backed dimensions (procedural density, conciseness, working examples, signal-to-noise, trigger quality)
- **Actionable improvements**: Seven principles (A-G) mapped to specific issues found in the audit
- **Research-grounded**: Based on SkillsBench findings — detailed skills (+18.8pp) outperform comprehensive skills (-2.9pp)
- **Validation checklist**: Post-improvement verification to ensure changes align with optimal parameters

## Installation

Add this plugin to your Claude Code configuration:

```bash
claude --plugin-dir /path/to/improve-skill
```

Or copy to your project's `.claude-plugin/` directory.

## Usage

### Automatic Skill Activation

The `improve-skill` skill activates automatically when you ask to:
- Improve, optimize, or refactor a skill
- Review or audit a skill
- Apply SkillsBench findings to a skill
- Make a skill more effective

### Example Requests

- "Improve the drawio-creation skill"
- "Audit my custom skill for effectiveness"
- "Optimize this skill based on SkillsBench research"
- "Review this skill and suggest improvements"

## Key Research Numbers

| Finding | Value | Implication |
|---|---|---|
| Detailed skills | +18.8pp | Step-by-step with examples wins |
| Compact skills | +17.1pp | Focused essentials also effective |
| Comprehensive skills | -2.9pp | Exhaustive docs hurt performance |
| 2-3 skills per task | +18.6pp | Focused scope is optimal |
| 4+ skills per task | +5.9pp | Cognitive overhead reduces gains |

## Components

- **Skill**: `improve-skill` — full audit and improvement workflow
- **References**: `skillsbench-findings.md` — complete research summary including anti-patterns and evaluation criteria

## License

MIT
