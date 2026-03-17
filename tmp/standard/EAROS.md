# Enterprise Architecture Rubric Operational Standard (EAROS)
Version: 1.0  
Status: Draft operating standard  
Audience: Enterprise architects, architecture boards, design authorities, reviewers, and LLM/automation teams

## 1. Purpose

This document defines an operational standard for creating, governing, extending, and applying rubrics to enterprise architecture artifacts and related architecture work products.

The goal is to make architecture evaluation more consistent, more explainable, and more automatable. The standard is designed for both human review and agentic application. It standardizes:

- what a rubric is
- how a rubric is structured
- how criteria are scored
- how evidence is recorded
- how artifact-specific profiles are added
- how results are documented and governed
- how agents can help develop and apply rubrics safely

This standard assumes a simple but important distinction:

1. **Artifact quality** — whether the artifact is complete, coherent, clear, traceable, and fit for its stated purpose  
2. **Architectural fitness** — whether the architecture described appears sound relative to business drivers, quality attributes, risks, and tradeoffs  
3. **Governance fit** — whether the artifact and/or proposed design complies with mandatory principles, standards, controls, and review expectations

These must not be collapsed into one opaque score. They are related but distinct judgments.

## 2. Design foundations

This standard is intentionally aligned to widely used architecture and evaluation concepts:

- ISO/IEC/IEEE 42010 frames architecture descriptions around stakeholders, concerns, viewpoints, and architecture descriptions rather than generic documentation alone. [R1]
- The Open Group describes architecture compliance review as a scrutiny of a project against established architectural criteria, spirit, and business objectives. [R2]
- SEI’s ATAM treats architecture evaluation as an explicit examination of quality attribute goals, tradeoffs, and risks that may inhibit business goals. [R3]
- NIST’s AI RMF Playbook is useful as an operational pattern because it combines governance, mapping, measurement, and management in an iterative, non-checklist way and is also available in structured formats such as JSON and CSV. [R4]
- ISO/IEC 25010:2023 provides a reference model in which quality characteristics are defined so they can be specified, measured, and evaluated. [R5]

The standard below is therefore not just a scorecard template. It is an operating model for architecture evaluation.

## 3. Core principles

### 3.1 Principle 1 — Concern-driven, not document-driven
Rubrics evaluate whether an artifact answers the stakeholder concerns it exists to address. A beautiful artifact that does not answer the decision at hand should not score well.

### 3.2 Principle 2 — Evidence first
Every score must point to evidence in the artifact or explicitly state that evidence is missing.

### 3.3 Principle 3 — Gates before averages
Mandatory failures must not be hidden by weighted averages.

### 3.4 Principle 4 — Explainability over fake precision
Prefer a disciplined ordinal scale with clear guidance over false numerical granularity.

### 3.5 Principle 5 — Separate observation from inference
Reviewers and agents must distinguish:
- **Observed**: directly supported by artifact evidence
- **Inferred**: reasonable interpretation not directly stated
- **External**: judgment based on a standard, policy, or source outside the artifact

### 3.6 Principle 6 — Rubrics are governed assets
Rubrics, profiles, and overlays are versioned, reviewed, calibrated, and changed under governance.

### 3.7 Principle 7 — Agentic use must remain auditable
An agent may propose, score, summarize, and challenge, but the evaluation record must remain inspectable by a human reviewer.

## 4. Scope

This standard can be applied to any architecture artifact, including but not limited to:

- enterprise capability maps
- business architecture views
- application and integration architecture diagrams
- target-state architectures
- transition architectures
- solution architectures
- architecture decision records (ADRs)
- principle sets
- technology standards profiles
- roadmaps
- data architecture artifacts
- security architecture artifacts
- operating model and platform strategy documents

## 5. Operating model

The standard uses a three-layer composition model.

### 5.1 Layer 1 — Core meta-rubric
The core meta-rubric applies to **all** architecture artifacts. It standardizes the base dimensions and scoring model.

### 5.2 Layer 2 — Artifact profile
Each artifact type has a profile that adds or specializes criteria for that artifact class.

Examples:
- Capability Map Profile
- Solution Architecture Profile
- Target State Profile
- ADR Profile
- Roadmap Profile

### 5.3 Layer 3 — Context overlay
Overlays add criteria or gates required by a specific context.

Examples:
- Security Overlay
- Data Governance Overlay
- Regulatory Overlay
- Cloud Platform Overlay
- Critical Production Change Overlay

This layered model is important because one global rubric becomes too generic, while fully bespoke rubrics become ungovernable.

## 6. Standard rubric anatomy

Every rubric, profile, and overlay must include the following fields.

### 6.1 Mandatory metadata

- `rubric_id`
- `title`
- `version`
- `status` (draft, approved, deprecated)
- `owner`
- `artifact_type`
- `review_purpose`
- `intended_decision_type`
- `applicable_stakeholders`
- `applicable_viewpoints`
- `scale_definition`
- `status_rules`
- `change_log`
- `effective_date`

### 6.2 Mandatory criterion fields

Every criterion must define:

- `criterion_id`
- `name`
- `dimension`
- `question`
- `description`
- `metric_type`
- `score_scale`
- `weight`
- `gate_type`
- `required_evidence`
- `scoring_guidance`
- `anti_patterns`
- `dependencies`
- `applicability_rule`
- `rationale`

### 6.3 Mandatory evaluation output fields

Every evaluation result must capture:

- `artifact_id`
- `artifact_type`
- `rubric_id`
- `rubric_version`
- `evaluated_by`
- `evaluation_mode` (human, agent, hybrid)
- `evaluation_date`
- `criterion_results`
- `dimension_results`
- `gate_failures`
- `overall_status`
- `overall_score`
- `confidence`
- `evidence_gaps`
- `recommended_actions`
- `decision_summary`

## 7. Scoring standard

### 7.1 Recommended scale

Use a **0–4 ordinal scale** plus `N/A`.

- **0 — Absent / contradicted**  
  No meaningful evidence, or evidence directly contradicts the criterion

- **1 — Weak**  
  Criterion is acknowledged or implied, but inadequate for decision support

- **2 — Partial**  
  Criterion is explicitly addressed, but coverage is incomplete, inconsistent, or weakly evidenced

- **3 — Good**  
  Criterion is clearly addressed with adequate evidence and only minor gaps

- **4 — Strong**  
  Criterion is fully addressed, well evidenced, internally consistent, and decision-ready

- **N/A — Not applicable**  
  Criterion genuinely does not apply in the stated scope and context

### 7.2 Why this scale
The 0–4 scale is strong enough to distinguish quality levels but simple enough for humans and agents to apply consistently. A 1–10 scale creates false precision and lowers calibration quality.

### 7.3 Gate types

Use explicit gate categories:

- `none` — contributes to score only
- `advisory` — weak performance triggers recommendations
- `major` — significant weakness may cap status
- `critical` — failure blocks pass status regardless of average

### 7.4 Status model

A recommended default decision model:

- **Pass**
  - no critical gate failures
  - overall weighted score >= 3.2
  - no dimension score < 2.0

- **Conditional pass**
  - no critical gate failures
  - overall weighted score between 2.4 and 3.19
  - weaknesses are containable with named actions and owners

- **Rework required**
  - overall weighted score < 2.4
  - or repeated weak dimensions
  - or insufficient evidence for decision support

- **Not reviewable / reject**
  - critical gate failure
  - artifact does not match the declared type
  - artifact purpose is unclear
  - evidence is too incomplete to score responsibly

### 7.5 Confidence standard

Confidence must be recorded separately from score.

Use:
- `low`
- `medium`
- `high`

Confidence is driven by:
- completeness of evidence
- clarity of scope
- ambiguity of criterion
- consistency across sections/views
- reviewer certainty

Do **not** multiply score by confidence. A low-confidence evaluation and a poor artifact are different problems.

## 8. Core meta-rubric dimensions

The core meta-rubric should apply across all architecture artifact types.

### 8.1 Stakeholder and purpose fit
Is the artifact explicit about who it serves, what decision it supports, and why it exists?

### 8.2 Scope and boundary clarity
Does it define scope, exclusions, assumptions, constraints, and boundaries clearly enough to avoid misreading?

### 8.3 Concern coverage and viewpoint appropriateness
Does the artifact address the relevant concerns using views or structures that fit the problem?

### 8.4 Traceability
Can the artifact be traced to business drivers, requirements, principles, policies, and key decisions?

### 8.5 Internal consistency and integrity
Are the claims, models, views, and narratives internally coherent, or do they conflict?

### 8.6 Risk, assumptions, constraints, and tradeoffs
Does it identify meaningful risks, assumptions, constraints, and architectural tradeoffs?

### 8.7 Standards and policy compliance
Does it demonstrate alignment with mandatory standards, controls, and governance expectations?

### 8.8 Actionability and implementation relevance
Can downstream teams act on it? Does it inform design, sequencing, funding, governance, or delivery choices?

### 8.9 Maintainability of the artifact
Is ownership clear? Is the artifact versioned, current enough, and structured so it can be kept useful over time?

## 9. Metric types

Criteria may use different measurement patterns, but they must be declared explicitly.

### 9.1 Ordinal
Used when maturity or adequacy is judged on a defined rubric scale.  
Example: “How complete is traceability to business capabilities?”

### 9.2 Binary
Used for hard checks.  
Example: “Is the artifact owner named?”

### 9.3 Enumerated categorical
Used when one of a small set of states is appropriate.  
Example: `none`, `partial`, `full`, `not-applicable`

### 9.4 Quantified ratio or count
Used sparingly.  
Example: “Percentage of diagrams with legend and scope annotation”

### 9.5 Derived metric
Computed from multiple criterion results.  
Example: concern coverage index, evidence sufficiency index, reviewability score

Quantified metrics can be useful, but architecture evaluation is usually strongest when the quantitative element supports rather than replaces reasoned judgment.

## 10. Evidence standard

### 10.1 Evidence anchors
Each criterion must specify what counts as acceptable evidence.

Typical evidence anchors:
- section references
- page numbers
- diagram identifiers
- ADR identifiers
- traceability table rows
- standards mappings
- risk records
- roadmap milestones
- linked source documents

### 10.2 Evidence sufficiency
Record one of:
- `sufficient`
- `partial`
- `insufficient`
- `none`

### 10.3 Evidence classes
Record each finding as:
- `observed`
- `inferred`
- `external`

### 10.4 Missing evidence is a first-class result
Evaluators must not silently fill gaps. Missing evidence must be visible in the record.

## 11. Documentation standard

Every rubric package must contain five documentation assets.

### 11.1 Rubric specification
The normative definition of dimensions, criteria, scale, gates, weights, applicability, and outputs.

### 11.2 Scoring guidance
A reviewer guide with:
- interpretation notes
- examples
- counterexamples
- anti-patterns
- boundary cases
- tie-break guidance

### 11.3 Calibration pack
A set of sample artifacts with benchmark evaluations and rationale.

### 11.4 Evaluation record template
The format for storing applied scores, evidence, rationale, gaps, and actions.

### 11.5 Decision log template
The format for recording disposition, review outcome, waivers, owners, due dates, and exceptions.

## 12. Agentic operating pattern

### 12.1 Recommended evaluation pattern
Use a **two-pass or three-pass model**.

#### Pass 1 — Extractor
An agent extracts evidence from the artifact, identifies sections, diagrams, traceability elements, and candidate evidence for each criterion.

#### Pass 2 — Evaluator
A second agent applies the rubric and produces criterion scores, rationale, confidence, and gaps.

#### Pass 3 — Challenger
A third agent challenges the evaluation by looking for:
- unsupported claims
- contradictory evidence
- rubric misuse
- over-scoring
- unacknowledged ambiguity
- missing gating issues

This pattern is safer than single-agent scoring because architecture review is vulnerable to confident but weak inference.

### 12.2 Human review threshold
Require human review when:
- any critical gate fails
- confidence is low on a major criterion
- overall status changes because of inference rather than direct evidence
- the challenger disagrees materially with the evaluator
- the artifact is high impact or high risk

### 12.3 Agent output standard
Agent-generated outputs must contain:
- criterion-by-criterion result
- evidence references
- rationale
- confidence
- explicit gaps
- recommended actions
- model/version metadata if required by internal policy

## 13. Calibration and quality control

### 13.1 Why calibration matters
Without calibration, the same rubric will drift across teams, reviewers, and agents.

### 13.2 Calibration method
For a new rubric or profile:

1. select 10–20 representative artifacts
2. score them independently with at least two reviewers or two review modes
3. compare results
4. identify ambiguous criteria and rewrite scoring guidance
5. repeat until agreement is stable enough for operational use

### 13.3 Agreement metrics
For ordinal scoring, weighted kappa is a useful agreement measure because it accounts for ordered disagreements rather than treating all disagreements equally. [R6]

### 13.4 What to calibrate
Calibrate:
- score distributions
- gate consistency
- treatment of `N/A`
- confidence usage
- evidence sufficiency judgments
- action recommendations

### 13.5 Recalibration triggers
Recalibrate when:
- a profile changes materially
- a new overlay is introduced
- agreement drops
- new artifact formats appear
- agent behavior changes materially
- governance expectations change

## 14. Profile model

Profiles are the main extension mechanism for different artifact types.

### 14.1 What a profile is
A profile is a rubric extension for a specific artifact class. It inherits the core meta-rubric and adds, removes, constrains, or specializes criteria.

### 14.2 What a profile is not
A profile is not:
- a totally independent scoring system
- a one-off project checklist
- a domain overlay masquerading as an artifact type
- a replacement for the core rubric

### 14.3 Profile composition rules
A valid profile must:

- inherit the core scale and status model unless there is an approved exception
- map every added criterion to a dimension
- define applicability rules
- define evidence anchors
- define gate types explicitly
- explain any profile-specific weights
- include examples and anti-patterns
- include at least one calibration artifact before approval

## 15. Methods for adding profiles

This is the part most teams get wrong. They add profiles by brainstorming criteria. That produces bloated and unstable rubrics. Profiles should be added through a controlled method.

### Method A — Decision-centered profile design
Use this when the artifact exists to support a specific decision type.

**Best for:** ADRs, investment review artifacts, target-state decisions, exception requests

Steps:
1. Identify the decision the artifact is supposed to support
2. Identify the minimum questions decision-makers must answer
3. Map those questions to the core dimensions
4. Add only the profile criteria needed to make the decision responsibly
5. Declare gates for mandatory questions
6. Write examples of good and weak evidence
7. Pilot on 3–5 real artifacts

**Description:**  
This method keeps profiles lean and tightly linked to real governance choices. It is the best default method for architecture boards.

### Method B — Viewpoint-centered profile design
Use this when the artifact is primarily a structured architecture description for a viewpoint or stakeholder group.

**Best for:** capability maps, business architecture views, platform reference architectures, integration landscape maps

Steps:
1. Identify stakeholders and concerns
2. Identify the viewpoint or modeling style used
3. Define what good coverage looks like for that viewpoint
4. Add profile criteria for completeness, modeling integrity, scope, and traceability
5. Add profile anti-patterns typical of that view
6. Validate against existing examples

**Description:**  
This method is closest to the architecture-description logic behind ISO/IEC/IEEE 42010. It is useful when the question is less “Is this decision right?” and more “Is this architecture view fit for purpose?” [R1]

### Method C — Lifecycle-centered profile design
Use this when the artifact sits at a particular stage of the architecture or delivery lifecycle.

**Best for:** current-state assessments, transition-state designs, roadmap artifacts, operational handover architecture

Steps:
1. Place the artifact in the lifecycle
2. Identify what downstream users need next
3. Define criteria for readiness, sequencing, dependencies, and handoff quality
4. Add stage-specific gates
5. Add evidence rules that prove the artifact is actionable

**Description:**  
This method prevents profiles from becoming abstract. It forces the profile to answer: what happens next if this artifact is accepted?

### Method D — Risk-centered profile design
Use this when the artifact is only worth reviewing because it manages a class of risk.

**Best for:** security architecture, regulatory impact architecture, resilience architecture, critical data architecture

Steps:
1. Identify the risk classes and failure modes
2. Identify mandatory controls and review obligations
3. Create hard gates for non-negotiables
4. Add criteria for residual risk visibility, ownership, and tradeoffs
5. Attach the resulting requirements as a profile or, more often, as an overlay

**Description:**  
This method is often better implemented as an overlay rather than a pure artifact profile, because the same risk lens may need to apply to multiple artifact types.

### Method E — Pattern-library profile design
Use this when many similar artifacts recur and you want a reusable quality pattern.

**Best for:** recurring reference architectures, recurring integration patterns, recurring platform service definitions

Steps:
1. identify the recurring artifact family
2. extract the recurring success criteria
3. turn them into profile criteria with examples
4. separate mandatory pattern integrity from optional optimization
5. publish and calibrate as a reusable profile pack

**Description:**  
This is the best method when you want architecture governance to scale.

## 16. Profile creation workflow

Use this workflow whenever a new profile is proposed.

### Step 1 — Create a profile proposal
The proposal must include:
- candidate profile name
- artifact type
- intended decisions supported
- stakeholders
- why the core rubric alone is insufficient
- candidate dimensions affected
- proposed criteria list
- estimated review frequency
- expected users

### Step 2 — Classify the profile type
Classify whether the proposal is:
- an artifact profile
- a context overlay
- a project-specific checklist
- a one-off temporary review aid

Only the first two should normally become governed assets.

### Step 3 — Choose the profile design method
Use one of Methods A–E above and record the chosen method explicitly.

### Step 4 — Draft the profile
Draft:
- profile scope
- inherited dimensions
- added/specialized criteria
- gating rules
- evidence anchors
- anti-patterns
- examples
- weight rationale

### Step 5 — Build the calibration pack
Select representative artifacts, including:
- at least one strong example
- at least one weak example
- at least one ambiguous example
- at least one incomplete example

### Step 6 — Run a calibration round
Use at least:
- one experienced human reviewer
- one secondary reviewer or agentic reviewer

### Step 7 — Revise
Tighten criteria that produce inconsistent judgments.

### Step 8 — Approve and publish
Approval should include:
- owner assignment
- version number
- effective date
- next review date

### Step 9 — Monitor in production
Track:
- usage frequency
- common failure criteria
- calibration drift
- waiver frequency
- reviewer feedback
- agent disagreement rate

## 17. Profile design rules

A profile should normally add **no more than 5–12 specific criteria** beyond the core meta-rubric. If a team wants to add 20 more criteria, it usually means the profile is mixing concerns that should be overlays or guidance notes instead.

### 17.1 Good profile behavior
A good profile:
- sharpens evaluation for a real artifact class
- improves decision quality
- reduces reviewer ambiguity
- adds explicit evidence requirements
- remains teachable and calibratable

### 17.2 Bad profile behavior
A bad profile:
- duplicates the entire core rubric
- adds vague criteria like “high quality”
- mixes artifact type and domain policy without distinction
- creates project-specific trivia as enterprise standard
- has no examples
- cannot be applied consistently

## 18. Overlays versus profiles

This distinction matters a lot.

### Use a profile when:
- the artifact type itself has unique quality expectations

### Use an overlay when:
- a cross-cutting concern must apply to many artifact types

Examples:

- **ADR** -> profile  
- **Capability Map** -> profile  
- **Security** -> overlay  
- **Regulatory** -> overlay  
- **Data retention** -> overlay  
- **Cloud landing zone policy** -> overlay  

A common failure mode is encoding security or regulatory expectations directly inside every profile. That creates duplication and drift. Keep cross-cutting requirements as overlays unless there is a compelling reason not to.

## 19. Starter profile examples

### 19.1 Capability Map Profile
Likely extra criteria:
- decomposition quality
- non-overlap / non-duplication
- stable capability naming
- ownership clarity
- business outcome linkage
- level consistency
- strategic relevance

Typical anti-patterns:
- organization chart masquerading as capability map
- mixed abstraction levels
- solution names in place of capabilities
- duplicated capabilities

### 19.2 Solution Architecture Profile
Likely extra criteria:
- problem statement clarity
- option analysis
- quality attribute treatment
- integration and dependency treatment
- operational model coverage
- deployment and runtime assumptions
- non-functional requirement traceability

Typical anti-patterns:
- only one option shown
- deployment view missing
- target design contradicts constraints
- security delegated to “later”

### 19.3 ADR Profile
Likely extra criteria:
- decision statement clarity
- options considered
- consequences
- tradeoff visibility
- reversibility
- trigger conditions for revisit
- traceability to broader architecture

Typical anti-patterns:
- decision already implemented before record exists
- only chosen option documented
- no consequences listed
- no context for future readers

### 19.4 Roadmap Profile
Likely extra criteria:
- dependency realism
- sequencing logic
- transition-state clarity
- owner and funding linkage
- risk and contingency treatment
- measurable milestones

Typical anti-patterns:
- date list without dependencies
- no transition architecture
- no ownership
- roadmap not connected to target state

## 20. Governance model

### 20.1 Roles

#### Rubric owner
Owns content, lifecycle, versioning, and quality of a rubric or profile.

#### Review authority
Approves major rubric changes and profile publication.

#### Evaluator
Applies the rubric.

#### Challenger
Reviews evaluation quality and disputes weak reasoning.

#### Calibration lead
Owns benchmark examples and agreement monitoring.

#### Agent steward
Owns prompts, agent workflows, schemas, and automation controls.

### 20.2 Change classes

- **Patch change** — wording clarification, typo, example addition
- **Minor change** — added criterion guidance, anti-pattern updates, non-breaking applicability updates
- **Major change** — new criterion, changed scale, changed gates, changed weights, changed status rules

Major changes require recalibration.

## 21. Metrics for rubric performance

Do not only measure artifact scores. Measure rubric performance itself.

Recommended operational metrics:

- rubric usage count
- profile usage count
- pass / conditional / rework / reject distribution
- critical gate failure frequency
- average evidence sufficiency
- reviewer agreement rate
- agent-human agreement rate
- waiver rate
- time to evaluate
- action closure rate
- defect escape correlation if available
- profile drift incidents
- stale rubric count

These metrics help determine whether the rubric system is actually improving architecture governance.

## 22. Recommended repository structure

```text
architecture-rubrics/
  standard/
    EAROS.md
    rubric.schema.json
    evaluation.schema.json
    profile.schema.json
    overlay.schema.json
  core/
    core-meta-rubric.v1.yaml
    scoring-guidance.v1.md
  profiles/
    capability-map.v1.yaml
    solution-architecture.v1.yaml
    adr.v1.yaml
    roadmap.v1.yaml
  overlays/
    security.v1.yaml
    regulatory.v1.yaml
    data-governance.v1.yaml
    cloud.v1.yaml
  calibration/
    capability-map/
    solution-architecture/
    adr/
  evaluations/
    2026/
      ART-001/
        artifact/
        result.json
        report.md
        decision.md
```

## 23. Machine-readable templates

### 23.1 Rubric template

```yaml
rubric_id: EAROS-SOL-001
title: Solution Architecture Profile
version: 1.0.0
status: approved
owner: enterprise-architecture
artifact_type: solution_architecture
review_purpose: decision_review
intended_decision_type:
  - architecture_board_review
  - funding_gate
applicable_stakeholders:
  - architecture_board
  - engineering
  - security
  - operations
scale_definition:
  type: ordinal_0_4_plus_na
status_rules:
  pass:
    min_weighted_score: 3.2
    no_critical_gate_failures: true
dimensions:
  - id: stakeholder_fit
    name: Stakeholder and purpose fit
    criteria:
      - criterion_id: STK-01
        name: Stakeholders, concerns, viewpoints
        question: Does the artifact explicitly identify stakeholders, concerns, and viewpoints?
        description: Checks whether the artifact is anchored in named stakeholders and their concerns.
        metric_type: ordinal
        score_scale: [0,1,2,3,4,"N/A"]
        weight: 1.0
        gate_type: major
        required_evidence:
          - stakeholder_list
          - concern_list
          - viewpoint_mapping
        scoring_guidance:
          "0": absent or contradicted
          "1": implied only
          "2": explicit but incomplete
          "3": explicit and mostly complete
          "4": explicit, complete, and consistently used
        anti_patterns:
          - generic audience only
          - no concern-to-view mapping
        dependencies: []
        applicability_rule: always
        rationale: Architecture review should be concern-driven.
```

### 23.2 Evaluation template

```yaml
artifact_id: ART-2026-0042
artifact_type: solution_architecture
rubric_id: EAROS-SOL-001
rubric_version: 1.0.0
evaluated_by:
  - role: evaluator
    actor: agent
  - role: challenger
    actor: human
evaluation_mode: hybrid
evaluation_date: 2026-03-16
criterion_results:
  - criterion_id: STK-01
    score: 2
    confidence: medium
    evidence_sufficiency: partial
    evidence_refs:
      - section: Audience
      - page: 3
    evidence_class: observed
    rationale: Stakeholders are listed but concerns are not systematically mapped to views.
    evidence_gaps:
      - No explicit viewpoint model
    recommended_actions:
      - Add stakeholder-concern-view matrix
dimension_results:
  - dimension_id: stakeholder_fit
    weighted_score: 2.0
gate_failures: []
overall_status: conditional_pass
overall_score: 2.8
confidence: medium
recommended_actions:
  - Add viewpoint mapping
  - Clarify decision scope
decision_summary: Usable with rework before final board review.
```

## 24. Suggested minimum documentation for every new profile

Before a new profile is considered operational, it should have:

1. the profile YAML/JSON definition
2. a profile guide in prose
3. at least 3 worked examples
4. at least 1 anti-example
5. a calibration record
6. an owner
7. a next review date

If one of those is missing, the profile is not yet mature enough for enterprise use.

## 25. Recommended initial rollout

Do not start with ten profiles. Start with a controlled seed set.

Recommended first set:
- Core Meta-Rubric
- Capability Map Profile
- Solution Architecture Profile
- ADR Profile
- Security Overlay
- Regulatory Overlay

Run these on real artifacts for 6–8 weeks, then tune before wider rollout.

## 26. Anti-patterns to avoid

- one mega-rubric for every artifact
- criteria with no evidence anchors
- too many weighted criteria
- hidden gates inside averages
- policy and artifact-type concerns mixed without structure
- no distinction between missing evidence and low quality
- no calibration
- profile sprawl
- agent-only scoring with no challenger
- no versioning of rubrics
- reviewing artifacts without declaring purpose and decision context

## 27. Practical review workflow

A practical enterprise workflow can be:

1. select artifact type
2. resolve applicable profile
3. resolve applicable overlays
4. assemble composed rubric
5. extract evidence
6. apply scoring
7. challenge scoring
8. finalize status and actions
9. store machine-readable evaluation
10. store human-readable report
11. capture decision and waivers
12. feed results back into calibration

## 28. Decision rules for choosing whether to add a new profile

Before approving a new profile, ask:

- Does this artifact type recur enough to justify standardization?
- Is the core meta-rubric insufficient by itself?
- Are the proposed additions stable across teams and time?
- Would an overlay solve the problem better?
- Can the profile be calibrated with real examples?
- Does the profile improve decision quality enough to justify the governance overhead?

If the answer to several of these is “no”, do not add the profile.

## 29. Summary standard statement

The enterprise standard should be:

> All architecture rubrics shall be managed as governed, versioned, evidence-based evaluation assets composed from a common core meta-rubric, artifact-specific profiles, and context overlays. All scoring shall be explainable, evidence-linked, calibrated, and suitable for both human and agent-assisted application.

## 30. Recommended next deliverables

To operationalize this standard, create these next:

1. `core-meta-rubric.v1.yaml`
2. `solution-architecture.v1.yaml`
3. `adr.v1.yaml`
4. `capability-map.v1.yaml`
5. `security.v1.yaml`
6. `evaluation.schema.json`
7. `calibration-pack.md`
8. `review-report-template.md`

---

## References

- **[R1] ISO/IEC/IEEE 42010 architecture description overview** — ISO Online Browsing Platform. Describes architecture description in terms of stakeholders, concerns, viewpoints, and model kinds.  
  https://www.iso.org/obp/ui/en/

- **[R2] Architecture compliance review overview** — The Open Group, “IT Architecture Compliance.” Describes architecture compliance review as scrutiny against established architectural criteria, spirit, and business objectives.  
  https://www.opengroup.org/architecture/togaf7-doc/arch/p4/comp/comp.htm

- **[R3] Architecture Tradeoff Analysis Method (ATAM)** — Carnegie Mellon SEI. Describes ATAM as a method for evaluating software architectures relative to quality attribute goals and exposing architectural risks and tradeoffs.  
  https://www.sei.cmu.edu/library/architecture-tradeoff-analysis-method-collection/

- **[R4] NIST AI RMF Playbook** — NIST AI Resource Center. Describes iterative suggested actions aligned to the AI RMF functions Govern, Map, Measure, and Manage and publishes structured formats such as JSON and CSV.  
  https://airc.nist.gov/airmf-resources/playbook/

- **[R5] ISO/IEC 25010:2023 product quality model** — ISO. Defines a product quality model whose characteristics and subcharacteristics provide a reference model for quality to be specified, measured, and evaluated.  
  https://www.iso.org/standard/78176.html

- **[R6] Interrater reliability and kappa** — McHugh, *Biochemia Medica* / PMC. Useful background on kappa as an inter-rater reliability statistic; weighted variants are appropriate when disagreement magnitude matters.  
  https://pmc.ncbi.nlm.nih.gov/articles/PMC3900052/
