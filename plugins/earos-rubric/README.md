# EAROS Rubric Creator

Create architecture evaluation rubrics that conform to the **Enterprise Architecture Rubric Operational Standard (EAROS)**.

## Why rubrics matter

Architecture review is one of the most impactful governance activities in an enterprise. When done well, it catches costly mistakes before they reach production — misaligned quality attributes, unmanaged dependencies, unaddressed compliance gaps. When done poorly, it becomes either a rubber stamp that catches nothing or a subjective gauntlet that blocks good work for the wrong reasons.

The difference between these outcomes is almost always the rubric. Without a structured, evidence-based rubric, reviewers default to personal judgment, tribal knowledge, and pattern-matching from past experience. This creates three problems:

1. **Inconsistency** — Two reviewers score the same artifact differently because they weight different concerns.
2. **Opacity** — Authors don't know what "good" looks like, so they can't improve before the review.
3. **Drift** — Review standards shift over time as people join, leave, or forget what was agreed.

A well-designed rubric solves all three. It makes expectations explicit, evidence requirements visible, and scoring repeatable. And in the age of LLM-assisted review, a machine-readable rubric also enables agent-based evaluation — where an AI can extract evidence, apply scores, and flag gaps before a human reviewer even opens the document.

## What is EAROS?

The **Enterprise Architecture Rubric Operational Standard** is an operating model for creating, governing, and applying rubrics to architecture artifacts. It draws on established frameworks — ISO/IEC/IEEE 42010 for architecture descriptions, SEI's ATAM for quality attribute analysis, The Open Group's compliance review model, and NIST's AI RMF for structured governance — and synthesizes them into a practical system.

EAROS is built on seven core principles:

| Principle | What it means in practice |
|-----------|--------------------------|
| **Concern-driven** | Evaluate whether the artifact answers real stakeholder questions, not whether it has nice formatting |
| **Evidence first** | Every score must cite specific evidence from the artifact, or explicitly state that evidence is missing |
| **Gates before averages** | Mandatory failures (like missing security controls) must not be hidden inside weighted averages |
| **Explainability** | Use a clear 0-4 ordinal scale with guidance, not false numerical precision |
| **Observation vs inference** | Distinguish what you see in the artifact from what you interpret or judge from external standards |
| **Governed assets** | Rubrics themselves are versioned, reviewed, calibrated, and changed under governance |
| **Auditable agents** | When AI helps evaluate, the record must remain inspectable by humans |

## The composition model

EAROS avoids the two extremes that organizations typically fall into: one giant rubric that tries to cover everything (too generic to be useful) and fully bespoke rubrics per project (impossible to govern).

Instead, it uses a **three-layer composition model**:

```
┌──────────────────────────────────────────┐
│          Context Overlays                │
│   (Security, Regulatory, Data, Cloud)    │
├──────────────────────────────────────────┤
│          Artifact Profiles               │
│   (Solution Arch, ADR, Capability Map)   │
├──────────────────────────────────────────┤
│          Core Meta-Rubric                │
│   (9 universal dimensions that apply     │
│    to ALL architecture artifacts)        │
└──────────────────────────────────────────┘
```

### Layer 1: Core Meta-Rubric

Nine dimensions that every architecture artifact should be evaluated against, regardless of type:

| Dimension | The question it answers |
|-----------|----------------------|
| Stakeholder & purpose fit | Who is this for, and what decision does it support? |
| Scope & boundary clarity | What is in scope, out of scope, and where are the boundaries? |
| Concern coverage | Do the views and structures actually address the relevant concerns? |
| Traceability | Can claims be traced back to business drivers, requirements, and principles? |
| Internal consistency | Do the different sections, diagrams, and narratives agree with each other? |
| Risks & tradeoffs | Are material risks, assumptions, constraints, and tradeoffs identified? |
| Standards compliance | Does the artifact align with mandatory standards and controls? |
| Actionability | Can downstream teams actually act on this without major reinterpretation? |
| Maintainability | Is ownership clear? Can the artifact be kept useful over time? |

These are inherited by every profile — you never need to redefine them.

### Layer 2: Artifact Profiles

A profile adds evaluation criteria specific to one artifact type. For example, a **Solution Architecture Profile** adds criteria for option analysis, quality attribute treatment, and delivery readiness — things that only matter for solution architectures, not for ADRs or capability maps.

Good profiles are lean. EAROS recommends **2-5 added dimensions with no more than 12 total criteria**. If you find yourself adding 20 criteria, you're probably mixing artifact-type concerns with cross-cutting domain concerns that belong in an overlay.

### Layer 3: Context Overlays

An overlay adds criteria for a cross-cutting concern — security, regulatory compliance, data governance, cloud platform policy — that can apply to *any* artifact type. This prevents the common failure mode of encoding security requirements separately inside every profile, which creates duplication and drift.

**Rule of thumb:** If the concern changes when the *artifact type* changes, it's a profile. If the concern changes when the *context* changes (different regulation, different platform), it's an overlay.

## The scoring model

EAROS uses a **0-4 ordinal scale** — simple enough for humans and agents to apply consistently, rich enough to distinguish quality levels:

| Score | Meaning | When to use |
|-------|---------|-------------|
| **0** | Absent or contradicted | No evidence, or evidence directly contradicts the criterion |
| **1** | Weak | Acknowledged or implied, but inadequate for decision support |
| **2** | Partial | Explicitly addressed, but incomplete or weakly evidenced |
| **3** | Good | Clearly addressed with adequate evidence and minor gaps only |
| **4** | Strong | Fully addressed, well evidenced, internally consistent, decision-ready |
| **N/A** | Not applicable | The criterion genuinely does not apply in this scope |

### Gates: protecting against hidden failures

Some criteria are so important that a low score should block approval regardless of how well everything else scores. EAROS calls these **gates**:

- **Advisory** — Weak performance triggers recommendations but doesn't block
- **Major** — Failure caps the status at "conditional pass" at best
- **Critical** — Failure blocks pass entirely, regardless of the overall weighted average

This is one of the most important design decisions in rubric design. Without gates, a brilliant executive summary can mask the fact that the security controls are completely absent — the high scores in other areas average out the critical failure. Gates prevent this.

### Confidence: a separate signal

Confidence is recorded separately from score as `low`, `medium`, or `high`. A low-confidence evaluation and a poor artifact are *different problems* — the first means you need more information, the second means the artifact needs rework. EAROS explicitly forbids multiplying score by confidence, because collapsing them hides the distinction.

## The evaluation pattern

EAROS recommends a **three-pass model** for agent-assisted evaluation:

1. **Extractor** — An agent reads the artifact and extracts evidence: sections, diagrams, traceability elements, candidate evidence for each criterion.
2. **Evaluator** — A second agent applies the rubric: scores, rationale, confidence, gaps.
3. **Challenger** — A third agent challenges the evaluation: looks for unsupported claims, contradictory evidence, over-scoring, unacknowledged ambiguity.

This three-pass pattern exists because architecture review is especially vulnerable to confident but weak inference. A single agent can score an artifact highly because the prose *sounds* comprehensive, without noticing that the evidence is actually thin. The challenger catches this.

## Profile design methods

Not all rubrics should be designed the same way. EAROS defines five methods, each suited to different artifact types:

| Method | Best for | Core question |
|--------|----------|---------------|
| **A — Decision-centered** | ADRs, investment reviews, exception requests | What decision does this artifact support, and what must reviewers know to make it? |
| **B — Viewpoint-centered** | Capability maps, reference architectures, landscape views | Is this architecture description fit for purpose given the stakeholders and concerns? |
| **C — Lifecycle-centered** | Roadmaps, transition architectures, handover docs | Is this artifact ready for the next stage, and can downstream teams act on it? |
| **D — Risk-centered** | Security architecture, regulatory impact, resilience | Does this artifact manage the risks it exists to manage? |
| **E — Pattern-library** | Recurring reference architectures, platform patterns | Can we extract a reusable quality pattern from recurring similar artifacts? |

Choosing the right method matters because it determines what questions you ask, what evidence you look for, and what gates you set. A roadmap rubric designed with Method A (decision-centered) will miss transition-state quality because it's focused on the decision rather than the lifecycle position.

## What this skill does

This skill guides you through creating a new EAROS-conformant rubric via a structured interview. It:

- Helps you determine whether you need a profile or an overlay
- Asks targeted questions to understand your review context, stakeholders, and failure modes
- Selects the appropriate profile design method (A-E) based on your answers
- Walks you through designing dimensions, criteria, gates, scoring guidance, and anti-patterns
- Generates a complete, schema-conformant YAML rubric file
- Optionally creates a worked evaluation example for calibration

Every question the skill asks includes context about *why* the question matters and how the answer shapes the rubric. The goal is not just to produce a YAML file, but to help you think clearly about what your architecture review is actually trying to achieve.

## Installation

```shell
/plugin install earos-rubric@thomas-rohde-plugins
```

## Usage

```
/earos-rubric
```

Or ask Claude to create an architecture evaluation rubric, define review criteria, or standardize architecture review — the skill triggers automatically.

## What you get

A YAML rubric file that:

- Inherits from the EAROS core meta-rubric (9 universal dimensions)
- Adds only artifact-specific dimensions and criteria
- Includes full scoring guidance at every level (0-4)
- Specifies exactly what evidence reviewers should look for
- Documents anti-patterns and remediation hints
- Defines gates for true review blockers
- Conforms to the EAROS rubric JSON schema
- Is ready for both human review boards and agent-based evaluation

## Existing rubrics in the EAROS companion pack

The `tmp/` directory contains the starter set:

| Rubric | Type | ID | Dimensions | Criteria |
|--------|------|-----|-----------|----------|
| Core Meta-Rubric | Core | EAROS-CORE-001 | 9 | 10 |
| Solution Architecture | Profile | EAROS-SOL-001 | 3 | 3 |
| Architecture Decision Record | Profile | EAROS-ADR-001 | 3 | 3 |
| Capability Map | Profile | EAROS-CAP-001 | 3 | 3 |
| Security | Overlay | EAROS-OVR-SEC-001 | 1 | 1 |
| Data | Overlay | EAROS-OVR-DATA-001 | 1 | 1 |

Use this skill to extend the set with new artifact types (roadmap, integration architecture, platform strategy, operating model, etc.) or new cross-cutting overlays (regulatory, cloud, resilience, cost governance, etc.).

## Further reading

- `tmp/standard/EAROS.md` — The full EAROS operating standard
- `tmp/standard/profile-authoring-guide.md` — Concise guide for adding new profiles
- `tmp/standard/rubric.schema.json` — JSON schema for rubric files
- `tmp/standard/evaluation.schema.json` — JSON schema for evaluation records
- `tmp/examples/` — Worked evaluation example
