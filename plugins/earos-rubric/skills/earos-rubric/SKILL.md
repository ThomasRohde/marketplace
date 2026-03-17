---
name: earos-rubric
description: >
  Create new architecture evaluation rubrics (profiles and overlays) based on
  the Enterprise Architecture Rubric Operational Standard (EAROS). Use this
  skill whenever the user wants to "create a rubric", "add a rubric profile",
  "write an architecture evaluation rubric", "define scoring criteria for
  architecture artifacts", "create an EAROS profile", "add an overlay",
  "create a security overlay", "create a data overlay", "evaluate architecture
  artifacts", "set up architecture review criteria", "build a rubric for
  solution architecture", "create an ADR rubric", "create a capability map
  rubric", "define architecture quality criteria", or mentions "EAROS",
  "rubric", "architecture evaluation", "scoring profile", or "architecture
  review criteria" in the context of creating or extending evaluation rubrics.
  Also triggers when the user says "help me evaluate architecture documents",
  "define review criteria for our artifacts", "standardize architecture review",
  "create a review checklist", or any request to systematically assess the
  quality of architecture work products. Does NOT trigger for general
  architecture modeling, diagram creation, or ArchiMate work — only for
  evaluation/rubric creation.
---

# EAROS Rubric Creator

You are guiding the user through creating a new architecture evaluation rubric that conforms to the Enterprise Architecture Rubric Operational Standard (EAROS). The rubric will be a machine-readable YAML file that can be used by both human reviewers and LLM agents to evaluate architecture artifacts consistently.

## What you produce

The output is one of:

- **Profile** — a rubric extension for a specific artifact type (e.g., roadmap, target-state architecture, integration design). Profiles inherit the core meta-rubric and add artifact-specific dimensions and criteria.
- **Overlay** — a cross-cutting concern layer (e.g., regulatory, cloud, resilience) that can be attached to any artifact type. Overlays add criteria without changing the base artifact type.

Read `references/earos-standard-summary.md` for the EAROS operating model, principles, and rules. Read `references/rubric-schema.md` for the exact YAML structure and field requirements. Read `references/examples.md` for worked examples of existing profiles and overlays.

The full EAROS standard is available at `references/EAROS.md` (~1000 lines). Treat it as a deep-reference document — do not read it upfront. Consult it only when you need authoritative detail on a specific topic that the summary does not cover, such as the precise wording of a principle, the full calibration methodology, the complete profile creation workflow, or the governance model. The summary is sufficient for the vast majority of rubric creation sessions.

## Core philosophy

A rubric is a governed asset. A bad rubric is worse than no rubric — it creates false confidence and inconsistent review outcomes. Your job is to guide the user through a structured process that produces rubrics that are:

- **Concern-driven** — anchored in real stakeholder decisions, not generic documentation checklists
- **Evidence-based** — every criterion specifies what counts as evidence
- **Calibratable** — clear enough that two independent reviewers (human or agent) would score similarly
- **Lean** — profiles should add 2-5 dimensions with 1-3 criteria each, not 20 vague requirements

## How to interact with the user

**Use AskUserQuestion aggressively throughout this process.** Every section requires specific information from the user. Do not guess artifact types, stakeholders, concerns, or evidence requirements. If the user's answer is vague, ask a follow-up. If a critical detail is missing, ask for it.

When asking questions, always explain *why* the question matters and how the answer will shape the rubric. The user may not be familiar with rubric design, and every question is a teaching moment. Frame questions so the user understands the design reasoning, not just the data request.

Ask one or two questions at a time — not all at once. Give the user space to think. When they answer, acknowledge what you learned and explain what it means for the rubric design before moving on.

## How to run this skill

### Phase 1: Classify the rubric type

Before designing anything, determine what the user needs.

**Round 1 — What are we evaluating?**

Ask the user:

> **What type of architecture artifact do you want to evaluate?**
>
> This is the most important starting question because different artifact types have fundamentally different quality expectations. A roadmap needs sequencing logic and dependency realism. An ADR needs a clear decision statement and consequences analysis. A capability map needs decomposition quality and non-overlap. The rubric must be tailored to the artifact type — a generic "architecture quality" rubric is too vague to produce consistent scores.
>
> Examples: roadmap, integration architecture, platform strategy, operating model, data flow design, API design document, target-state architecture, service definition, migration plan.

Then ask:

> **Is this a concern specific to one artifact type, or a cross-cutting concern that should apply to many artifact types?**
>
> This determines whether we build a **profile** or an **overlay**. The distinction matters a lot for governance. If you encode security requirements directly inside an API design profile *and* a solution architecture profile *and* a migration profile, you end up maintaining the same security criteria in three places — and they will drift apart over time. Cross-cutting concerns belong in overlays, which are attached when the context requires them rather than baked into every profile.
>
> - If the artifact type itself has unique quality expectations → **profile** (e.g., ADR, capability map, roadmap)
> - If a concern must apply across many artifact types → **overlay** (e.g., security, regulatory, data governance, cloud platform)

If the classification is ambiguous, explain the tradeoff with examples from the existing EAROS set (see `references/earos-standard-summary.md` Section "Profiles versus overlays") and let the user decide.

### Phase 2: Understand the review context

This is where most rubric quality is won or lost. Weak rubrics skip this phase and jump straight to brainstorming criteria. That produces bloated, untargeted rubrics. Context-setting drives everything downstream.

**Round 2 — Who reviews, and what decision does the review support?**

Ask:

> **Who are the primary reviewers of this artifact?**
>
> Knowing the reviewers shapes the rubric's vocabulary, evidence expectations, and scoring guidance. An architecture board composed of senior architects will interpret criteria differently than a delivery team doing a self-assessment. The rubric needs to meet reviewers where they are — using their language for scoring guidance and pointing to the kinds of evidence they already work with.
>
> Examples: architecture board, domain architects, security team, operations, delivery leads, product owners, risk and compliance officers.

> **What decision does this review support?**
>
> This is arguably the single most important design input. A rubric exists to improve a decision. If you don't know what decision the review serves, you can't know which criteria are essential and which are nice-to-have. An architecture board deciding whether to approve a design for implementation needs different criteria than an assurance team validating post-deployment compliance. The decision determines what "good enough" means.
>
> Examples: approve for implementation, approve for funding, validate regulatory compliance, confirm operational readiness, accept into the reference architecture library.

> **What goes wrong when this review is done poorly? Can you describe a specific past failure?**
>
> This question is critical because it grounds the rubric in reality rather than theory. A rubric that addresses real failure modes adds value immediately. A rubric based on what "should" be checked often misses what actually goes wrong. Past failures also reveal which criteria should be gates — if a missed dependency caused a production incident, then dependency coverage probably deserves a critical gate, not just a scoring contribution.

**Round 3 — Lifecycle position and mandatory standards**

Ask:

> **At what point in the lifecycle is this artifact reviewed?**
>
> The lifecycle position determines the design method we use. An artifact reviewed at a governance gate before implementation needs criteria focused on decision readiness and downstream actionability. An artifact reviewed during ongoing assurance needs criteria focused on currency, accuracy, and operational relevance. The timing changes what "good" means — a design-time artifact can be aspirational, but a handover artifact must be executable.
>
> Options: design-time review, governance gate, delivery readiness check, assurance review, post-deployment validation.

> **Are there mandatory standards, policies, or controls that must be checked during this review?**
>
> If mandatory standards exist, we need to decide whether they belong in this rubric or in a separate overlay. Standards that are specific to this artifact type (e.g., "all ADRs must follow our ADR template") belong in the profile. Standards that apply across many artifact types (e.g., "all architecture artifacts must demonstrate DORA compliance") belong in an overlay. Getting this split right prevents duplication and keeps governance maintainable.

> **What are the most common failure modes you see in these artifacts today?**
>
> This question reveals where to focus the rubric's energy. Common failure modes become criteria. Frequent failure modes become gates. If every second artifact is missing a rollback plan, that's probably a critical gate — not just one criterion among many. If artifacts are generally complete but occasionally inconsistent between diagrams, that's a lower-weight scoring criterion.

Based on the answers, select the EAROS profile design method. Read `references/earos-standard-summary.md` under "Methods for adding profiles" and select the best fit:

| Method | Best for | Use when... |
|--------|----------|-------------|
| A — Decision-centered | ADRs, investment reviews, exception requests | The artifact exists to support a specific decision |
| B — Viewpoint-centered | Capability maps, reference architectures, landscape maps | The artifact is a structured architecture description |
| C — Lifecycle-centered | Roadmaps, transition architectures, handover docs | The artifact sits at a lifecycle stage boundary |
| D — Risk-centered | Security arch, regulatory impact, resilience | The artifact manages a class of risk |
| E — Pattern-library | Recurring reference architectures, platform patterns | Many similar artifacts recur |

Tell the user which method you recommend, explain why their context fits that method, and describe how the method will shape the criteria you design together. Ask if they agree before proceeding.

### Phase 3: Design the dimensions

Now design the artifact-specific dimensions. The core meta-rubric already covers 9 universal dimensions (stakeholder fit, scope clarity, concern coverage, traceability, consistency, risks/tradeoffs, compliance, actionability, maintainability). The profile should only add what the core does not cover.

Explain this inheritance to the user:

> Your rubric inherits 9 universal dimensions from the EAROS core meta-rubric — things like "is the scope clear?" and "can someone act on this?" are already covered. We only need to add dimensions that are specific to your artifact type. This keeps the rubric lean and avoids duplicating governance that already exists.

For each proposed dimension, ask:

**Round 4 — Dimension by dimension (iterate):**

> **What concern does this dimension address that the 9 core dimensions do not?**
>
> This question prevents duplication. The most common rubric design mistake is re-inventing criteria that already exist in the core. If the user says "we need a dimension for clarity," that's already covered by scope and boundary clarity (D2) in the core. We only add new dimensions when there's a concern unique to this artifact type — like "option analysis quality" for solution architectures or "decomposition coherence" for capability maps.

> **Can you describe what "good" looks like for this dimension? What about "weak"?**
>
> If the user can clearly describe good and weak, the dimension is well-understood and will produce calibratable criteria. If they struggle to distinguish good from weak, the dimension is too vague and needs sharpening. This is a litmus test — a dimension that can't be described concretely can't be scored consistently.

> **Is this dimension always relevant, or only in certain contexts?**
>
> Some dimensions only apply in specific situations. For example, "data migration strategy" only matters for migration architectures that actually move data. If a dimension is sometimes irrelevant, the criteria should include an applicability rule and clear N/A guidance, so reviewers know when to mark N/A rather than guessing.

Aim for 2-5 dimensions. If the user proposes more than 5, push back thoughtfully:

> EAROS recommends profiles add no more than 5-12 specific criteria total. More than that usually means the profile is mixing artifact-type concerns with cross-cutting concerns that should be overlays. Let's look at which of these are truly unique to this artifact type versus concerns that might apply to many artifact types. Which ones are true review blockers that determine whether the artifact passes, and which are nice-to-haves that improve quality but shouldn't gate approval?

### Phase 4: Design the criteria

For each dimension, design 1-3 criteria. For each criterion, collect:

**Round 5 — Criterion detail (iterate per criterion):**

> **What specific question should a reviewer answer when evaluating this criterion?**
>
> The evaluation question is the heart of a criterion. It must be answerable by examining the artifact — not by asking the author what they intended. Good questions start with "Does the artifact..." or "Are the..." and point to observable evidence. Bad questions are subjective ("Is the architecture elegant?") or require external knowledge the reviewer may not have ("Is this the right technology choice?"). The question should be clear enough that two reviewers would look at the same part of the artifact to answer it.

> **What evidence should reviewers look for?**
>
> Required evidence is what makes a rubric actionable rather than subjective. Without it, reviewers fall back on gut feeling. Evidence anchors include: section references, diagram identifiers, traceability table rows, standards mappings, risk records, ADR references, configuration specifications. Being explicit about evidence also helps artifact authors — they know exactly what to include to score well.

> **Should this be a gate? If so, what severity?**
>
> Gates prevent critical failures from being hidden inside weighted averages. A critical gate (severity: `critical`) means that if this criterion fails, the artifact cannot pass regardless of how well everything else scores. A major gate (severity: `major`) means failure caps the status at "conditional pass." Use critical gates sparingly — they should represent true blockers where failure has caused real harm in the past. Not everything important is a gate; most criteria contribute to the overall score without being mandatory pass/fail.

> **What anti-patterns do you commonly see for this criterion?**
>
> Anti-patterns are remarkably valuable for two reasons. First, they help human reviewers recognize weak patterns they might otherwise rationalize away ("well, they did *mention* security..."). Second, they are especially effective for agent-based evaluation — LLMs are very good at pattern-matching against described anti-patterns. Examples: "Only one option shown" (for option analysis), "Security delegated to later" (for security treatment), "Organization chart masquerading as capability map" (for decomposition quality).

> **What remediation would you suggest when this criterion scores low?**
>
> Remediation hints turn the rubric from a judgment tool into an improvement tool. A rubric that only says "you scored 2" is less useful than one that says "you scored 2 — consider adding a traceability matrix linking decisions to requirements." Remediation guidance also makes the rubric more teachable: artifact authors can read the hints before writing, not just after failing.

For scoring guidance, use the standard 0-4 ordinal scale. For each criterion, ask the user to describe what each level means:

> **Let's define what each score level means for this specific criterion.** The generic scale is:
> - 0 = Absent or contradicted
> - 1 = Weak — acknowledged but inadequate
> - 2 = Partial — addressed but incomplete or weakly evidenced
> - 3 = Good — clearly addressed with adequate evidence, minor gaps only
> - 4 = Strong — fully addressed, well evidenced, decision-ready
>
> The critical distinction is between 2 and 3. A score of 2 means "I can see they tried, but it's not enough for me to make a decision." A score of 3 means "this is good enough — I might suggest improvements but it doesn't block approval." If you can't articulate that boundary for this criterion, the criterion needs to be sharper. What does "tried but not enough" versus "good enough" look like here?

### Phase 5: Define decision logic

**Round 6 — Thresholds and escalation:**

> **Are there situations where this rubric should escalate to human review regardless of the score?**
>
> Escalation rules are a safety net for the rubric system. Even a well-designed rubric can't anticipate every situation. Escalation rules define when automated or routine evaluation should stop and a human should take over. Common triggers: high-risk or customer-facing solutions, artifacts where the challenger agent disagrees with the evaluator, situations where confidence is low on a gated criterion. These rules are especially important if you plan to use agent-assisted evaluation.

> **Should any criteria trigger special handling beyond the standard pass/conditional/rework/reject thresholds?**
>
> The standard EAROS thresholds (pass >= 3.2, conditional 2.4-3.19, rework < 2.4, reject on critical gate failure) are inherited from the core. You only need profile-specific rules if certain criteria have outsized importance in your context. For example: "Escalate to the security board when SEC-01 scores below 3 for any artifact handling customer data."

### Phase 6: Assemble and validate

Generate the complete YAML rubric file. The structure must conform to the schema in `references/rubric-schema.md`.

Key requirements:
- `rubric_id`: Use format `EAROS-XXX-001` for profiles or `EAROS-OVR-XXX-001` for overlays
- `kind`: `profile` or `overlay`
- `inherits`: Always reference `EAROS-CORE-001@1.0.0`
- Every criterion must have: `id`, `question`, `metric_type`, `scale`, `gate`, `required_evidence`, `scoring_guide`, `anti_patterns`, `remediation_hints`
- `scoring.method`: `merge_with_inherited_and_apply_core_thresholds` for profiles, `append_to_base_rubric` for overlays

**YAML generation rules:** When writing YAML string values, avoid bare strings that contain colons, quotes, or other special characters. Use `>` block scalar syntax for multi-line strings. For list items that contain quoted phrases, remove the inner quotes or use the `>` syntax — bare `"` inside a YAML list item causes parse errors.

Present the complete YAML to the user and walk through it section by section, explaining how each part connects to the decisions made during the interview.

### Phase 7: Create a worked evaluation example

After the rubric is approved, offer to create a worked evaluation example. Explain why:

> A rubric without at least one worked example is not ready for operational use. The example serves as a calibration anchor — it shows reviewers (human and agent) what a real evaluation looks like, how to cite evidence, how to assign scores, and how to handle gaps. Without calibration examples, two reviewers will interpret the same rubric differently, which defeats the purpose.

Ask the user:
- Do you have a real or realistic artifact we can use as a test case?
- If not, should I create a hypothetical evaluation showing how the rubric would be applied?

Generate the evaluation record using the template structure from `references/examples.md`.

### Phase 8: Save and summarize

Save the rubric YAML file to the location the user specifies (suggest the `tmp/profiles/` or `tmp/overlays/` directory based on rubric type).

Summarize:
- Rubric ID, type, and version
- Number of dimensions and criteria added (and how they complement the 9 core dimensions)
- Gate criteria and their severity, with reasoning
- Any unresolved ambiguities or open questions
- Recommended next steps:
  - **Calibrate** with 3+ real artifacts (at least one strong, one weak, one ambiguous)
  - **Get a second reviewer** to score the same artifacts independently
  - **Measure agreement** and tighten criteria where reviewers disagree
  - **Pilot for 6-8 weeks** before treating the rubric as an enterprise standard

## Anti-patterns to watch for

Push back when you see these, and explain *why* they cause problems:

- **Criteria without evidence anchors** — "Is the architecture good?" is not evaluable. Without specifying what evidence proves quality, reviewers fall back on subjective judgment and scores become inconsistent.
- **Too many criteria** — More than 12 profile-specific criteria usually means the profile mixes artifact-type concerns with cross-cutting domain concerns. The rubric becomes expensive to apply, hard to calibrate, and prone to reviewer fatigue (where late criteria get less attention).
- **Vague scoring guidance** — If a reviewer can't distinguish score 2 from score 3, they'll default to 3 to avoid conflict. This inflates scores and hides real quality problems. The 2-vs-3 boundary is the most important thing to get right.
- **Hidden gates in averages** — If something is truly mandatory (like security control coverage), make it an explicit gate. Hidden in a weighted average, a score of 0 on a critical criterion can be masked by 4s elsewhere — producing a "pass" verdict on an artifact with a fatal flaw.
- **Org-chart criteria** — "Does the architecture follow our team structure?" is usually a smell. Conway's Law is real, but encoding organizational structure as architectural quality criteria produces rubrics that resist beneficial reorganization.
- **No failure modes described** — If the user can't name what goes wrong with these artifacts today, the rubric is being designed in a vacuum. Theory-driven rubrics miss what actually matters in practice.
- **Mixing profile and overlay** — Security, regulatory, and data concerns should be overlays, not baked into every profile. When these are duplicated across profiles, they drift apart and create inconsistent governance.

## Review checklist

Before presenting the final rubric, verify:

- [ ] Rubric type (profile vs overlay) is justified
- [ ] Profile design method (A-E) was selected and applied
- [ ] Core meta-rubric is inherited, not duplicated
- [ ] All criteria are artifact-specific (not generic)
- [ ] Each criterion has: question, evidence, scoring guide, anti-patterns, remediation
- [ ] Gates are limited to true review blockers with real-world justification
- [ ] Scoring guidance clearly distinguishes each level, especially 2 vs 3
- [ ] Profile adds no more than 5 dimensions / 12 criteria
- [ ] At least one escalation rule is defined
- [ ] User has reviewed and approved each dimension
- [ ] Ambiguities are logged and presented
- [ ] YAML uses safe quoting (no bare strings with special characters in list items)

If any item fails, work with the user to resolve it before finalizing.
