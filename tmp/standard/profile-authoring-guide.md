# Profile Authoring Guide

This guide explains how to add a new EAROS profile in a controlled and agent-friendly way.

## 1. When to add a profile

Create a new profile only when all of the following are true:

- the artifact type is used repeatedly
- the artifact supports a distinct review or decision pattern
- the artifact has concerns that are not well captured by the core meta-rubric alone
- the organization can supply stable examples and scoring guidance

Do **not** create a profile just because a team wants its own scorecard. Start with an overlay unless the artifact type itself is different.

## 2. Profiles versus overlays

Use a **profile** when the artifact type changes.

Examples:
- ADR
- solution architecture
- capability map
- target-state architecture
- standards profile

Use an **overlay** when the context changes but the artifact type stays the same.

Examples:
- security overlay
- data overlay
- regulatory overlay
- cloud platform overlay
- resilience overlay

## 3. Required authoring steps

### Step 1 — Define the review intent
State:
- artifact type
- intended decision
- primary stakeholders
- expected viewpoints or model kinds
- whether the evaluation is design-time, governance-time, or assurance-time

### Step 2 — Identify reusable versus specific criteria
Map the artifact to the core meta-rubric and identify which concerns are already covered. Only add criteria that are artifact-specific.

### Step 3 — Define dimensions
A good profile normally adds 2–5 dimensions. More than that usually means the profile is too broad.

Each dimension must:
- represent a coherent concern area
- contain no duplicated criterion
- be understandable by both humans and agents

### Step 4 — Define criteria
Every criterion must include:
- stable id
- evaluation question
- description
- metric type
- scale
- gate or non-gate designation
- required evidence
- scoring guidance
- anti-patterns
- suggested remediation

### Step 5 — Define decision logic
Specify:
- which criteria are gates
- overall scoring method
- pass thresholds
- escalation thresholds
- what triggers “not reviewable”

### Step 6 — Add examples
For each profile, add at least:
- one good example
- one weak example
- one ambiguous example

These become calibration assets for humans and agents.

### Step 7 — Calibrate
Run at least two human reviewers and one agent against the same examples. Adjust guidance until disagreements narrow and the rationale becomes stable.

## 4. Authoring heuristics

- Prefer a 0–4 ordinal scale plus `N/A`
- Keep gates rare and meaningful
- Use equal weights by default
- Do not hide missing evidence
- Separate confidence from score
- Add anti-patterns because agents respond well to them
- Add remediation because a rubric should improve artifacts, not just judge them

## 5. Minimum profile contents

A valid profile should contain:

- profile id and version
- inheritance reference to the core meta-rubric
- artifact type
- stakeholders
- dimensions
- criteria
- scoring method
- output requirements
- calibration status
- change history

## 6. Change management

Treat these as **breaking changes**:
- changing a criterion meaning
- changing score semantics
- changing gates
- changing thresholds
- removing required evidence

Treat these as **non-breaking changes**:
- typo fixes
- clearer examples
- added remediation hints
- added narrative guidance that does not affect scoring

## 7. Review checklist for new profiles

Before operational release, confirm:

- Does the profile solve a repeatable decision problem?
- Does it inherit the core rather than duplicate it?
- Are all added criteria artifact-specific?
- Are gates justified?
- Is required evidence explicit?
- Is scoring guidance concrete?
- Is a calibration pack available?
- Can an agent apply it without hidden organizational assumptions?

## 8. Agent authoring pattern

A good agent workflow is:

1. Read the EAROS standard
2. Read the core profile
3. Read 2–3 example artifacts of the target type
4. Propose candidate dimensions
5. Challenge for duplication and overlap
6. Draft the profile in YAML
7. Validate against the rubric schema
8. Create one worked evaluation example
9. Route to human review
