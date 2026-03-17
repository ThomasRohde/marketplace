# Evaluation Record Schema

The evaluation output must conform to this schema. All required fields must be present.

## Complete evaluation record structure

```yaml
# Required fields
evaluation_id: EVAL-SOL-0001          # Format: EVAL-{PREFIX}-{NNNN}
rubric_id: EAROS-SOL-001              # From rubric file
rubric_version: 1.0.0                 # From rubric file
artifact_ref:                          # Required object
  id: SOL-ART-042                     # Artifact identifier
  title: "Payments API Modernization" # Artifact title
  artifact_type: solution_architecture # Matches rubric artifact_type
  owner: "Payments Architecture"      # Optional
  uri: "path/to/artifact.md"          # Optional

evaluation_date: "2026-03-17"         # ISO date string
evaluators:                            # Required array
  - name: "EAROS extractor"
    role: evidence-extractor
    mode: agent
  - name: "EAROS evaluator"
    role: rubric-evaluator
    mode: agent
  - name: "EAROS challenger"
    role: rubric-challenger
    mode: challenge-agent

status: conditional_pass              # Required enum — see Status values
overall_score: 2.8                    # Weighted average (number)
gate_failures: []                     # Array of criterion IDs that failed gates

# Criterion results — one entry per evaluated criterion
criterion_results:
  - criterion_id: STK-01             # Required
    score: 3                          # Required — integer 0-4 or "N/A"
    judgment_type: observed           # Required — observed|inferred|external|mixed
    confidence: high                  # Required — low|medium|high
    evidence_sufficiency: sufficient  # Required — insufficient|partial|sufficient|strong
    evidence_refs:                    # Array of evidence references
      - location: "Section 1.0"
        excerpt: "Stakeholders are named."
    rationale: >                      # Required — explanation of score
      Stakeholders and purpose are explicit.
    missing_information:              # Array of gaps
      - "Concern-to-view matrix"
    recommended_actions:              # Array of improvements
      - "Add stakeholder-concern table"

# Dimension results — one entry per dimension
dimension_results:
  - dimension_id: D1                 # Required
    score: 3.0                        # Required — number
    summary: >                        # Required — one-line assessment
      Purpose and audience are clear.

# Summary — required object
summary:
  strengths:                          # Required array
    - "Clear scope and bounded design"
  weaknesses:                         # Required array
    - "Weak traceability"
  risks:                              # Required array
    - "Operational resilience under-designed"
  next_actions:                       # Required array
    - "Add traceability matrix"
  decision_narrative: >               # Optional but recommended
    The artifact is reviewable but needs work on traceability
    before unconditional approval.

# Optional
approval: {}                          # Approval metadata if applicable
metadata: {}                          # Additional metadata
```

## Status values

| Status | Conditions |
|--------|------------|
| `pass` | No critical gate failures, overall >= 3.2, no dimension < 2.0 |
| `conditional_pass` | No critical gate failures, overall 2.4-3.19 or one weak dimension |
| `rework_required` | Overall < 2.4 or repeated weak dimensions |
| `reject` | Critical gate failure or mandatory control breach |
| `not_reviewable` | Evidence insufficient for core gate criteria |

## Gate failure logic

For each criterion with a gate:
- Read the `gate.severity` and `gate.failure_effect` from the rubric
- If `severity: critical` and score fails the condition → add to `gate_failures`, status = `reject`
- If `severity: major` and score fails the condition → add to `gate_failures`, status capped at `conditional_pass`
- `advisory` gates do not affect status, only trigger recommendations

## Score computation

1. For each dimension, compute: `dimension_score = weighted_avg(criteria_scores)` excluding N/A
2. For overall: `overall_score = weighted_avg(dimension_scores)` using dimension weights
3. Apply gate logic BEFORE status determination — gates override score-based status

## Confidence and evidence sufficiency

These are recorded per-criterion but also summarized:
- If any gated criterion has `confidence: low`, flag for human review
- If more than half of criteria have `evidence_sufficiency: insufficient`, consider `not_reviewable`

## Evaluator entries

Record all agents that participated:

| Role | Mode value | When used |
|------|------------|-----------|
| Evidence extractor | `agent` | Always (Pass 1) |
| Rubric evaluator | `agent` | Always (Pass 2) — may have multiple |
| Rubric challenger | `challenge-agent` | Always (Pass 3) |
| Human reviewer | `human` | When human reconciliation occurs |
