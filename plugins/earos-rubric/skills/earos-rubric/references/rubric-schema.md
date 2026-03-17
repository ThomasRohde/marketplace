# Rubric YAML Schema Reference

This document defines the exact structure for EAROS rubric files (profiles and overlays). All generated rubrics must conform to this structure.

## Top-level fields

```yaml
# Required fields
rubric_id: EAROS-XXX-001        # Unique ID. Profiles: EAROS-XXX-001. Overlays: EAROS-OVR-XXX-001
version: 1.0.0                  # Semantic version
kind: profile                   # One of: core_rubric, profile, overlay
title: Human-readable title     # Descriptive name
artifact_type: the_artifact     # What this evaluates (use "any" for overlays)

# Required arrays
dimensions: [...]               # See Dimension structure below
scoring: {...}                  # See Scoring structure below
outputs: {...}                  # See Outputs structure below

# Recommended fields
status: draft                   # One of: draft, candidate, approved, deprecated
inherits:                       # What this extends
  - EAROS-CORE-001@1.0.0
purpose:                        # Review contexts
  - design_review
  - governance_review
stakeholders:                   # Who uses this rubric
  - architecture_board
  - domain_architect
viewpoints:                     # Architecture viewpoints addressed
  - context
  - logical

# Optional fields
applicability: {}               # Conditions for when this rubric applies
calibration: {}                 # Calibration requirements
change_log: []                  # Version history
metadata: {}                    # Additional metadata
```

## Dimension structure

Each dimension is an object in the `dimensions` array:

```yaml
dimensions:
  - id: SD1                     # Short unique ID (2-4 chars)
    name: Dimension name        # Human-readable name
    description: Why this...    # Optional but recommended
    weight: 1.0                 # Relative weight (default 1.0)
    criteria:                   # Array of criteria (1-3 per dimension)
      - ...
```

## Criterion structure

Every criterion must include all required fields:

```yaml
criteria:
  - id: SOL-01                  # Unique within rubric (PREFIX-NN format)
    question: >                 # The evaluation question (required)
      Does the artifact explain the chosen option
      and the rejected alternatives?
    description: >              # Optional longer explanation
      Checks whether meaningful alternatives were
      considered and the rationale is explicit.
    metric_type: ordinal        # One of: ordinal, binary, count, presence, coverage
    scale:                      # The scoring scale (required)
      - 0
      - 1
      - 2
      - 3
      - 4
      - N/A

    # Gate configuration (required — use false if not a gate)
    gate: false                 # Simple form: not a gate
    # OR structured form:
    gate:
      enabled: true
      severity: major           # One of: advisory, major, critical
      failure_effect: >         # What happens on failure
        Cannot pass above conditional_pass

    # Evidence requirements (required, array of strings)
    required_evidence:
      - option comparison
      - selection rationale
      - decision criteria

    # Scoring guidance (required, maps score values to descriptions)
    scoring_guide:
      '0': No alternatives or rationale
      '1': Choice asserted only
      '2': Alternatives mentioned but weakly compared
      '3': Clear rationale and meaningful comparison
      '4': Decision is explicit, evidence-backed, and tied to concerns

    # Anti-patterns (required, array of strings)
    anti_patterns:
      - Single option dressed as comparison
      - Cost and risk ignored

    # Remediation hints (recommended, array of strings)
    remediation_hints:
      - Add option table
      - Explain why rejected options failed

    # Optional fields
    weight: 1.0                 # Criterion-level weight
    tags: []                    # Classification tags
```

## Scoring structure

```yaml
scoring:
  scale: 0-4 ordinal plus N/A
  method: merge_with_inherited_and_apply_core_thresholds  # For profiles
  # OR
  method: append_to_base_rubric                           # For overlays
  thresholds:
    # Profile-specific escalation rules
    profile_specific_escalation: >
      Escalate to human review when SOL-02 score < 3
      for customer-facing or high-risk solutions
  # Optional
  na_policy: >
    Exclude N/A criteria from denominator;
    evaluator must justify N/A in narrative
  confidence_policy: >
    Confidence is reported separately and must not
    mathematically modify the score
```

## Outputs structure

```yaml
outputs:
  require_evidence_refs: true   # Must cite evidence locations
  require_confidence: true      # Must report confidence per criterion
  require_actions: true         # Must recommend actions for weak scores
  formats:                      # Output format support
    - yaml
    - json
    - markdown-report
```

## Calibration structure (optional but recommended)

```yaml
calibration:
  required_before_production: true
  minimum_examples: 3
  recommended_reviewers:
    - 2 human reviewers
    - 1 evaluator agent
    - 1 challenger agent
```

## ID conventions

| Rubric type | ID pattern | Example |
|-------------|-----------|---------|
| Core rubric | EAROS-CORE-NNN | EAROS-CORE-001 |
| Profile | EAROS-XXX-NNN | EAROS-SOL-001, EAROS-ADR-001, EAROS-RDM-001 |
| Overlay | EAROS-OVR-XXX-NNN | EAROS-OVR-SEC-001, EAROS-OVR-DATA-001 |
| Criterion (core) | 3-letter prefix + NN | STK-01, SCP-01, TRC-01 |
| Criterion (profile) | Profile prefix + NN | SOL-01, ADR-01, CAP-01 |
| Criterion (overlay) | Overlay prefix + NN | SEC-01, DAT-01, REG-01 |
| Dimension (core) | D + N | D1, D2, ... D9 |
| Dimension (profile) | 2-3 char prefix + N | SD1, AD1, CP1 |
| Dimension (overlay) | 3-4 char prefix + N | SEC1, DAT1, REG1 |
