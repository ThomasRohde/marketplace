# EAROS Companion Pack v1

This package provides a machine-readable starter kit for the **Enterprise Architecture Rubric Operational Standard (EAROS)**.

It is designed for three uses:

1. **Human governance** — architecture boards, review teams, and design authorities can define and govern rubric families consistently.
2. **Agentic rubric authoring** — LLM agents can generate or extend rubric profiles using the authoring constraints and schemas in this pack.
3. **Agentic evaluation** — LLM agents can apply rubrics to architecture artifacts while producing auditable evidence-backed records.

## Package structure

- `standard/EAROS.md` — the operating standard
- `standard/rubric.schema.json` — schema for rubric/profile files
- `standard/evaluation.schema.json` — schema for evaluation result files
- `standard/profile-authoring-guide.md` — concise operational guide for adding new profiles
- `profiles/core-meta-rubric.v1.yaml` — common rubric base for all architecture artifacts
- `profiles/solution-architecture.v1.yaml` — solution architecture profile
- `profiles/adr.v1.yaml` — architecture decision record profile
- `profiles/capability-map.v1.yaml` — enterprise capability map profile
- `overlays/security.v1.yaml` — optional security overlay
- `overlays/data.v1.yaml` — optional data overlay
- `templates/new-profile.template.yaml` — blank profile template
- `templates/evaluation-record.template.yaml` — blank evaluation result template
- `examples/example-solution-architecture.evaluation.yaml` — worked example

## Operating model

The intended sequence is:

1. Start from `profiles/core-meta-rubric.v1.yaml`
2. Add a profile for a specific artifact type
3. Attach one or more overlays where context requires it
4. Apply the rubric to an artifact and record evidence in an evaluation file
5. Calibrate humans and agents against the same gold-set examples

## How to add a new profile

Use `standard/profile-authoring-guide.md` and `templates/new-profile.template.yaml`.

The short rule is simple:

- create a new profile only when an artifact type has stable concerns and repeated review decisions
- inherit the core meta-rubric rather than rewriting common criteria
- add only artifact-specific dimensions and criteria
- keep gates limited to true review blockers
- define required evidence explicitly
- provide scoring guidance and anti-patterns
- include at least one calibration example before operational rollout

## Suggested governance

- version profiles semantically
- treat score changes caused by guidance changes as breaking changes
- require calibration after material scoring changes
- keep machine-readable files under version control
- require every evaluation to cite evidence and confidence separately

## Notes for agentic application

When an LLM agent authors or applies a rubric, keep these behaviors mandatory:

- never score without citing evidence or stating that evidence is missing
- distinguish observed, inferred, and external judgments
- do not collapse gate failures into weighted averages
- produce both structured output and a short narrative report
- route low-confidence or high-impact cases to human review
