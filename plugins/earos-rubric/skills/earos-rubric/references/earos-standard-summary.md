# EAROS Standard Summary

This is a condensed reference for the Enterprise Architecture Rubric Operational Standard (EAROS) v1.0. Read this when you need to understand the operating model, principles, composition rules, or profile design methods.

## Table of contents

1. [Purpose](#1-purpose)
2. [Core principles](#2-core-principles)
3. [Composition model](#3-composition-model)
4. [Scoring standard](#4-scoring-standard)
5. [Core meta-rubric dimensions](#5-core-meta-rubric-dimensions)
6. [Evidence standard](#6-evidence-standard)
7. [Methods for adding profiles](#7-methods-for-adding-profiles)
8. [Profiles versus overlays](#8-profiles-versus-overlays)
9. [Profile composition rules](#9-profile-composition-rules)
10. [Profile design rules](#10-profile-design-rules)
11. [Agentic evaluation pattern](#11-agentic-evaluation-pattern)
12. [Governance model](#12-governance-model)

---

## 1. Purpose

EAROS standardizes how architecture evaluation rubrics are created, governed, extended, and applied. It covers three distinct judgments that must not be collapsed:

1. **Artifact quality** — completeness, coherence, clarity, traceability, fitness for purpose
2. **Architectural fitness** — soundness relative to business drivers, quality attributes, risks, tradeoffs
3. **Governance fit** — compliance with mandatory principles, standards, controls, review expectations

## 2. Core principles

1. **Concern-driven, not document-driven** — Rubrics evaluate whether an artifact answers stakeholder concerns, not whether it has pretty formatting
2. **Evidence first** — Every score must cite evidence or explicitly state evidence is missing
3. **Gates before averages** — Mandatory failures must not be hidden by weighted averages
4. **Explainability over fake precision** — Ordinal 0-4 scale with clear guidance, not false numerical granularity
5. **Separate observation from inference** — Distinguish observed (in artifact), inferred (reasonable interpretation), and external (from standard/policy)
6. **Rubrics are governed assets** — Versioned, reviewed, calibrated, changed under governance
7. **Agentic use must remain auditable** — Evaluation records must be inspectable by humans

## 3. Composition model

Three-layer composition:

| Layer | What | Example |
|-------|------|---------|
| **Core meta-rubric** | Universal dimensions for all architecture artifacts | EAROS-CORE-001 |
| **Artifact profile** | Type-specific criteria for one artifact class | Solution Architecture, ADR, Capability Map |
| **Context overlay** | Cross-cutting concern that applies to any artifact type | Security, Data, Regulatory, Cloud |

This avoids the extremes of one mega-rubric (too generic) and fully bespoke rubrics (ungovernable).

## 4. Scoring standard

### Scale: 0-4 ordinal plus N/A

| Score | Meaning |
|-------|---------|
| 0 | Absent or contradicted |
| 1 | Weak — acknowledged but inadequate |
| 2 | Partial — addressed but incomplete |
| 3 | Good — adequate with minor gaps |
| 4 | Strong — fully addressed and decision-ready |
| N/A | Genuinely not applicable |

### Gate types

| Gate | Effect |
|------|--------|
| `none` | Score contribution only |
| `advisory` | Triggers recommendations |
| `major` | Caps status at conditional_pass |
| `critical` | Blocks pass regardless of average |

### Status model

| Status | Conditions |
|--------|------------|
| **Pass** | No critical gate failures, overall >= 3.2, no dimension < 2.0 |
| **Conditional pass** | No critical gate failures, overall 2.4-3.19, weaknesses containable |
| **Rework required** | Overall < 2.4, repeated weak dimensions, or insufficient evidence |
| **Reject / Not reviewable** | Critical gate failure, wrong artifact type, or evidence too incomplete |

### Confidence

Reported separately as `low`, `medium`, or `high`. Never multiply score by confidence — they measure different things.

## 5. Core meta-rubric dimensions

The core meta-rubric (EAROS-CORE-001) defines 9 universal dimensions:

| ID | Dimension | Key question |
|----|-----------|-------------|
| D1 | Stakeholder and purpose fit | Who is this for and what decision does it support? |
| D2 | Scope and boundary clarity | What is in/out of scope? |
| D3 | Concern coverage and viewpoint appropriateness | Do the views fit the concerns? |
| D4 | Traceability | Can it be traced to drivers, requirements, principles? |
| D5 | Internal consistency and integrity | Are claims coherent across sections? |
| D6 | Risks, assumptions, constraints, and tradeoffs | Are material issues identified? |
| D7 | Standards and policy compliance | Is alignment to mandatory standards shown? |
| D8 | Actionability | Can downstream teams act on it? |
| D9 | Artifact maintainability | Is ownership and update expectation clear? |

Profiles inherit all of these. They should only add criteria the core does not cover.

## 6. Evidence standard

### Evidence anchors

Each criterion specifies what counts as evidence: section references, diagram identifiers, traceability table rows, risk records, etc.

### Evidence sufficiency

Record as: `sufficient`, `partial`, `insufficient`, `none`

### Evidence classes

Record each finding as: `observed` (in artifact), `inferred` (interpretation), `external` (from standard/policy)

Missing evidence is a first-class result — evaluators must not silently fill gaps.

## 7. Methods for adding profiles

### Method A — Decision-centered

**Best for:** ADRs, investment reviews, exception requests

Steps: identify the decision → identify minimum questions decision-makers must answer → map to core dimensions → add only needed criteria → declare gates → write examples → pilot

### Method B — Viewpoint-centered

**Best for:** Capability maps, business architecture views, platform reference architectures

Steps: identify stakeholders and concerns → identify viewpoint/modeling style → define good coverage → add criteria for completeness, modeling integrity, scope, traceability → add anti-patterns → validate

### Method C — Lifecycle-centered

**Best for:** Current-state assessments, transition architectures, roadmaps, operational handover

Steps: place artifact in lifecycle → identify what downstream users need next → define readiness/sequencing/dependency criteria → add stage-specific gates → add evidence rules for actionability

### Method D — Risk-centered

**Best for:** Security architecture, regulatory impact, resilience architecture

Steps: identify risk classes and failure modes → identify mandatory controls → create hard gates → add criteria for residual risk visibility → often better as an overlay than a profile

### Method E — Pattern-library

**Best for:** Recurring reference architectures, integration patterns, platform service definitions

Steps: identify recurring artifact family → extract recurring success criteria → turn into profile criteria → separate mandatory pattern integrity from optional optimization → publish and calibrate

## 8. Profiles versus overlays

**Use a profile when** the artifact type itself has unique quality expectations.
- ADR → profile
- Capability Map → profile
- Solution Architecture → profile

**Use an overlay when** a cross-cutting concern must apply to many artifact types.
- Security → overlay
- Regulatory → overlay
- Data retention → overlay
- Cloud landing zone → overlay

Common failure mode: encoding security or regulatory expectations directly inside every profile. This creates duplication and drift.

## 9. Profile composition rules

A valid profile must:
- Inherit the core scale and status model (unless approved exception)
- Map every added criterion to a dimension
- Define applicability rules
- Define evidence anchors
- Define gate types explicitly
- Explain any profile-specific weights
- Include examples and anti-patterns
- Include at least one calibration artifact before approval

## 10. Profile design rules

- Add **no more than 5-12 specific criteria** beyond the core meta-rubric
- If more than 12 criteria are proposed, the profile is probably mixing concerns that should be overlays

### Good profile behavior
- Sharpens evaluation for a real artifact class
- Improves decision quality
- Reduces reviewer ambiguity
- Adds explicit evidence requirements
- Remains teachable and calibratable

### Bad profile behavior
- Duplicates the entire core rubric
- Adds vague criteria like "high quality"
- Mixes artifact type and domain policy
- Creates project-specific trivia as enterprise standard
- Has no examples
- Cannot be applied consistently

## 11. Agentic evaluation pattern

Recommended three-pass model:

1. **Pass 1 — Extractor**: Extract evidence from artifact, identify sections, diagrams, candidate evidence per criterion
2. **Pass 2 — Evaluator**: Apply rubric, produce scores, rationale, confidence, gaps
3. **Pass 3 — Challenger**: Challenge evaluation for unsupported claims, contradictory evidence, rubric misuse, over-scoring

Require human review when:
- Any critical gate fails
- Confidence is low on a major criterion
- Status changes due to inference rather than evidence
- Challenger materially disagrees with evaluator
- Artifact is high-impact or high-risk

## 12. Governance model

### Roles
- **Rubric owner** — content, lifecycle, versioning, quality
- **Review authority** — approves major changes
- **Evaluator** — applies the rubric
- **Challenger** — reviews evaluation quality
- **Calibration lead** — owns benchmark examples
- **Agent steward** — owns prompts, workflows, schemas

### Change classes
- **Patch** — wording, typo, example addition
- **Minor** — added guidance, non-breaking updates
- **Major** — new criterion, changed scale/gates/weights/thresholds → requires recalibration

### Decision rules for new profiles
Before approving, ask: Does the artifact type recur enough? Is the core rubric insufficient? Are the additions stable? Would an overlay work better? Can it be calibrated? Does it improve decision quality enough to justify governance overhead?
