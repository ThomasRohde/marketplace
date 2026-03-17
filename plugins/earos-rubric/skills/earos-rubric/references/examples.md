# EAROS Rubric Examples

This file contains worked examples of existing profiles and overlays, plus an evaluation record example. Use these as patterns when creating new rubrics.

## Table of contents

1. [Profile example: Solution Architecture](#1-profile-example-solution-architecture)
2. [Profile example: ADR](#2-profile-example-adr)
3. [Overlay example: Security](#3-overlay-example-security)
4. [Evaluation record example](#4-evaluation-record-example)
5. [Template: New profile](#5-template-new-profile)
6. [Template: Evaluation record](#6-template-evaluation-record)

---

## 1. Profile example: Solution Architecture

This profile adds 3 dimensions (optioning, quality attributes, delivery readiness) to the core meta-rubric. Note how each dimension targets a concern the core does not cover.

```yaml
rubric_id: EAROS-SOL-001
version: 1.0.0
kind: profile
title: Solution Architecture Profile
status: approved
artifact_type: solution_architecture
inherits:
  - EAROS-CORE-001@1.0.0
purpose:
  - design_review
  - architecture_board_review
  - delivery_readiness_review
stakeholders:
  - solution_architect
  - product_owner
  - engineering_lead
  - security
  - operations
  - data
viewpoints:
  - context
  - logical
  - integration
  - deployment
  - security
  - operating_model
dimensions:
  - id: SD1
    name: Solution optioning and rationale
    weight: 1.0
    criteria:
      - id: SOL-01
        question: >
          Does the artifact explain the chosen option and the rejected
          alternatives at a decision-useful level?
        metric_type: ordinal
        scale: [0, 1, 2, 3, 4, N/A]
        gate:
          enabled: true
          severity: major
          failure_effect: Cannot pass above conditional_pass
        required_evidence:
          - option comparison
          - selection rationale
          - decision criteria
        scoring_guide:
          '0': No alternatives or rationale
          '1': Choice asserted only
          '2': Alternatives mentioned but weakly compared
          '3': Clear rationale and meaningful comparison
          '4': Decision is explicit, evidence-backed, and tied to concerns
        anti_patterns:
          - Single option dressed as comparison
          - Cost and risk ignored
        remediation_hints:
          - Add option table
          - Explain why rejected options failed

  - id: SD2
    name: Quality attribute treatment
    weight: 1.0
    criteria:
      - id: SOL-02
        question: >
          Are key quality attributes and non-functional requirements
          translated into architectural mechanisms or constraints?
        metric_type: ordinal
        scale: [0, 1, 2, 3, 4, N/A]
        gate:
          enabled: true
          severity: critical
          failure_effect: Reject when material NFRs are absent or untraceable
        required_evidence:
          - NFR list
          - quality attribute scenarios
          - design responses
        scoring_guide:
          '0': No material NFR treatment
          '1': NFRs listed but not used
          '2': Partial architectural response
          '3': Most material NFRs handled in the design
          '4': Quality attribute response is explicit, traceable, and credible
        anti_patterns:
          - Performance/security/availability mentioned only in prose
          - No mechanism for resilience
        remediation_hints:
          - Add scenario-to-design mapping
          - Tie mechanisms to NFRs

  - id: SD3
    name: Delivery and operability readiness
    weight: 1.0
    criteria:
      - id: SOL-03
        question: >
          Does the solution architecture describe implementation dependencies,
          operational ownership, and migration implications?
        metric_type: ordinal
        scale: [0, 1, 2, 3, 4, N/A]
        gate: false
        required_evidence:
          - dependency list
          - operating model
          - migration or rollout view
        scoring_guide:
          '0': No delivery or operational treatment
          '1': High-level only
          '2': Partial readiness view
          '3': Mostly clear implementation and operability path
          '4': Ready for execution planning and governance
        anti_patterns:
          - Build-time view only
          - No operational owner
        remediation_hints:
          - Add operational responsibilities
          - Add migration dependencies

scoring:
  scale: 0-4 ordinal plus N/A
  method: merge_with_inherited_and_apply_core_thresholds
  thresholds:
    profile_specific_escalation: >
      Escalate to human review when SOL-02 score < 3
      for customer-facing or high-risk solutions
outputs:
  require_evidence_refs: true
  require_confidence: true
  require_actions: true
  formats:
    - yaml
    - json
    - markdown-report
```

## 2. Profile example: ADR

Lean profile — 3 dimensions, 3 criteria, 1 gate. Designed using Method A (decision-centered).

```yaml
rubric_id: EAROS-ADR-001
version: 1.0.0
kind: profile
title: Architecture Decision Record Profile
status: approved
artifact_type: architecture_decision_record
inherits:
  - EAROS-CORE-001@1.0.0
purpose:
  - decision_review
  - decision_quality_review
  - knowledge_retention_review
stakeholders:
  - architect
  - engineering_lead
  - maintainers
  - governance
viewpoints:
  - decision
  - context
  - consequence
dimensions:
  - id: AD1
    name: Decision clarity
    criteria:
      - id: ADR-01
        question: >
          Is the decision stated as a clear, testable, singular decision
          rather than a vague discussion topic?
        metric_type: ordinal
        scale: [0, 1, 2, 3, 4, N/A]
        gate:
          enabled: true
          severity: major
          failure_effect: Cannot pass above conditional_pass
        required_evidence:
          - decision statement
          - status
          - date or trigger context
        scoring_guide:
          '0': No decision
          '1': Topic only
          '2': Partly clear decision
          '3': Clear decision with scope
          '4': Clear, bounded, and testable decision
        anti_patterns:
          - ADR as meeting notes
          - Multiple unrelated decisions in one record
        remediation_hints:
          - Split the ADR
          - Rewrite the decision in one sentence

  - id: AD2
    name: Option space and consequences
    criteria:
      - id: ADR-02
        question: >
          Does the ADR capture meaningful alternatives and the consequences
          of the chosen decision?
        metric_type: ordinal
        scale: [0, 1, 2, 3, 4, N/A]
        gate: false
        required_evidence:
          - alternatives
          - pros and cons
          - consequences
          - reversibility
        scoring_guide:
          '0': No alternatives or consequences
          '1': Superficial mention
          '2': Partial treatment
          '3': Meaningful alternatives and consequences
          '4': Strong rationale with explicit tradeoffs and reversibility
        anti_patterns:
          - Consequences only positive
          - No reversal conditions
        remediation_hints:
          - Add rejected options
          - Document downside and triggers

  - id: AD3
    name: Decision durability and traceability
    criteria:
      - id: ADR-03
        question: >
          Can a future reader understand why the decision was made and when
          it should be revisited?
        metric_type: ordinal
        scale: [0, 1, 2, 3, 4, N/A]
        gate: false
        required_evidence:
          - context
          - drivers
          - review trigger
          - links to related artifacts
        scoring_guide:
          '0': No durable context
          '1': Weak historical trace
          '2': Some future usefulness
          '3': Mostly durable and traceable
          '4': Durable, traceable, and reviewable over time
        anti_patterns:
          - Decision depends on oral history
          - No revisit conditions
        remediation_hints:
          - Add context and links
          - Define revisit triggers

scoring:
  scale: 0-4 ordinal plus N/A
  method: merge_with_inherited_and_apply_core_thresholds
  thresholds:
    profile_specific_escalation: >
      Escalate when ADR-01 < 3 for strategic or cross-team decisions
outputs:
  require_evidence_refs: true
  require_confidence: true
  require_actions: true
  formats: [yaml, json, markdown-report]
```

## 3. Overlay example: Security

Overlays use `artifact_type: any` and `method: append_to_base_rubric`. They add criteria without changing the artifact type.

```yaml
rubric_id: EAROS-OVR-SEC-001
version: 1.0.0
kind: overlay
title: Security Overlay
status: approved
artifact_type: any
purpose:
  - security_assurance
  - control_alignment_review
stakeholders:
  - security
  - risk
  - architecture_board
dimensions:
  - id: SEC1
    name: Threat, control, and ownership treatment
    criteria:
      - id: SEC-01
        question: >
          Does the artifact show material threats, required controls, and
          control ownership at a level suitable for the review?
        metric_type: ordinal
        scale: [0, 1, 2, 3, 4, N/A]
        gate:
          enabled: true
          severity: critical
          failure_effect: Reject or escalate when mandatory controls are unaddressed
        required_evidence:
          - threat view or risk list
          - control mapping
          - ownership
        scoring_guide:
          '0': No material security treatment
          '1': Security assertions only
          '2': Partial threat/control view
          '3': Material controls and owners addressed
          '4': Threats, controls, exceptions, and ownership are explicit
        anti_patterns:
          - Security delegated to delivery without design response
          - No exception handling
        remediation_hints:
          - Map controls to architecture decisions
          - Record residual risk and owner

scoring:
  scale: 0-4 ordinal plus N/A
  method: append_to_base_rubric
  thresholds:
    critical_security_failure: Escalate or reject according to control policy
outputs:
  require_evidence_refs: true
  require_confidence: true
  require_actions: true
  formats: [yaml, json, markdown-report]
```

## 4. Evaluation record example

This shows how a completed evaluation looks. Use this pattern when generating worked examples for new rubrics.

```yaml
evaluation_id: EVAL-SOL-0001
rubric_id: EAROS-SOL-001
rubric_version: 1.0.0
artifact_ref:
  id: SOL-ART-042
  title: Payments API Modernization Solution Architecture
  artifact_type: solution_architecture
  owner: Payments Domain Architecture
  uri: repo://architecture/payments/solution-architecture.md
evaluation_date: '2026-03-16'
evaluators:
  - name: EA reviewer
    role: domain architect
    mode: human
  - name: EAROS evaluator
    role: rubric-evaluator
    mode: agent
  - name: EAROS challenger
    role: rubric-challenger
    mode: challenge-agent
status: conditional_pass
overall_score: 3.0
gate_failures: []
criterion_results:
  - criterion_id: STK-01
    score: 3
    judgment_type: observed
    confidence: high
    evidence_sufficiency: sufficient
    evidence_refs:
      - location: Section 1.0 Audience and Purpose
        excerpt: Architecture board, engineering lead, operations, and security are named.
    rationale: >
      Stakeholders and decision purpose are explicit,
      though not all stakeholder concerns are mapped in detail.
    missing_information:
      - Concern-to-view matrix
    recommended_actions:
      - Add stakeholder-concern-view table
  - criterion_id: SOL-02
    score: 2
    judgment_type: mixed
    confidence: medium
    evidence_sufficiency: partial
    evidence_refs:
      - location: Section 3.4 NFRs
        excerpt: Availability and performance targets are stated.
    rationale: >
      NFRs are stated, but resilience and failover mechanisms
      are not described with enough depth.
    missing_information:
      - Quality attribute scenarios
      - Mapping from resilience goals to mechanisms
    recommended_actions:
      - Add quality attribute scenario table
      - Explain failover and degradation behavior
dimension_results:
  - dimension_id: D1
    score: 3.0
    summary: Purpose and audience are clear, but concern mapping needs improvement.
  - dimension_id: SD2
    score: 2.0
    summary: NFR treatment is insufficiently concrete for a strong pass.
summary:
  strengths:
    - Clear review purpose and bounded scope
    - Meaningful option comparison
  weaknesses:
    - Weak traceability from drivers to decisions
    - Insufficiently concrete quality attribute response
  risks:
    - Operational resilience may be under-designed
  next_actions:
    - Add traceability matrix
    - Add quality attribute scenario and mechanism mapping
    - Re-review after revision
  decision_narrative: >
    The solution architecture is reviewable and directionally sound,
    but it does not yet provide strong enough evidence on traceability
    and quality attribute treatment for an unconditional pass.
```

## 5. Template: New profile

Use this as a starting point when generating new profiles:

```yaml
rubric_id: EAROS-XXX-001
version: 0.1.0
kind: profile
title: New Artifact Profile
status: draft
artifact_type: replace_me
inherits:
  - EAROS-CORE-001@1.0.0
purpose:
  - replace_me
stakeholders:
  - replace_me
viewpoints:
  - replace_me
dimensions:
  - id: PX1
    name: Replace with dimension name
    description: Why this dimension exists
    weight: 1.0
    criteria:
      - id: NEW-01
        question: Replace with evaluation question
        description: Explain the intent of the criterion
        metric_type: ordinal
        scale: [0, 1, 2, 3, 4, N/A]
        gate: false
        required_evidence:
          - replace_me
        scoring_guide:
          '0': Absent or contradicted
          '1': Weak or implied
          '2': Partial
          '3': Mostly complete
          '4': Strong and decision-useful
        anti_patterns:
          - replace_me
        remediation_hints:
          - replace_me
scoring:
  scale: 0-4 ordinal plus N/A
  method: merge_with_inherited_and_apply_core_thresholds
  thresholds:
    profile_specific_escalation: replace_me
  na_policy: Exclude N/A from denominator; justify in narrative
  confidence_policy: Report separately; do not alter score mathematically
outputs:
  require_evidence_refs: true
  require_confidence: true
  require_actions: true
  formats: [yaml, json, markdown-report]
calibration:
  required_before_production: true
  minimum_examples: 3
```

## 6. Template: Evaluation record

```yaml
evaluation_id: EVAL-0001
rubric_id: EAROS-XXX-001
rubric_version: 1.0.0
artifact_ref:
  id: ART-0001
  title: Replace with artifact title
  artifact_type: replace_me
  owner: replace_me
  uri: replace_me
evaluation_date: 'YYYY-MM-DD'
evaluators:
  - name: Lead reviewer
    role: architect
    mode: human
  - name: Rubric evaluator
    role: assistant
    mode: agent
  - name: Challenge reviewer
    role: assistant
    mode: challenge-agent
status: conditional_pass
overall_score: 0.0
gate_failures: []
criterion_results:
  - criterion_id: NEW-01
    score: 0
    judgment_type: observed
    confidence: medium
    evidence_sufficiency: partial
    evidence_refs:
      - location: Section X.X
        excerpt: Quote or summary from the artifact.
    rationale: Explain why this score was given.
    missing_information:
      - What's missing
    recommended_actions:
      - What to fix
dimension_results:
  - dimension_id: PX1
    score: 0.0
    summary: One-line assessment.
summary:
  strengths:
    - What's working
  weaknesses:
    - What needs improvement
  risks:
    - What could go wrong
  next_actions:
    - Concrete next steps
  decision_narrative: Overall assessment in 1-2 sentences.
```
