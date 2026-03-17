# EAROS Rubric Skill Process Summary: DORA Regulatory Compliance Overlay

## Overview

This document summarizes how the EAROS Rubric Creator skill guided the creation of a DORA regulatory compliance overlay (`EAROS-OVR-REG-001`). Each phase of the skill was executed with simulated responses from a risk and compliance architect at a European bank.

---

## Phase 1: Classify the rubric type

**Skill action:** Asked what type of architecture artifact the user wants to evaluate and whether this is a new artifact type or a cross-cutting concern.

**Simulated user response:** "We need a regulatory compliance overlay that can be attached to any architecture artifact. Our concern is DORA compliance evidence -- we keep finding that architects mention compliance but don't actually map controls to their designs. This needs to work across solution architectures, integration designs, platform strategies, and any other artifact type."

**Skill decision:** Classified as **overlay** (not profile). Rationale: regulatory compliance is a cross-cutting concern that applies to many artifact types. The EAROS standard explicitly identifies regulatory concerns as overlay candidates ("Regulatory -> overlay" in the Profiles vs Overlays section). Embedding DORA criteria in every profile would create duplication and drift.

**Outcome:** `kind: overlay`, `artifact_type: any`, rubric ID follows overlay convention: `EAROS-OVR-REG-001`.

---

## Phase 2: Understand the review context

### Round 2 -- Who reviews and why?

**Skill action:** Asked about primary reviewers, what decision the review supports, and what goes wrong when reviews are done poorly.

**Simulated user response:**
- **Primary reviewers:** Architecture board, compliance officers, risk managers, internal audit (post-facto), ICT risk function.
- **Decision supported:** Governance gate approval -- determining whether an architecture artifact demonstrates sufficient DORA compliance to proceed to implementation. Also used for audit evidence that compliance was verified at design time.
- **What goes wrong:** Audit findings where architecture reviews approved artifacts that lacked DORA-mandated controls. Specifically: (1) architects state "DORA compliant" without mapping controls to design decisions, (2) third-party ICT risk is ignored when cloud/SaaS providers are introduced, (3) incident reporting obligations are not reflected in the architecture, (4) resilience testing provisions are absent, (5) the architecture board cannot trace which DORA articles were considered.

### Round 3 -- Scope and lifecycle

**Skill action:** Asked about lifecycle stage, mandatory standards, and typical failure modes.

**Simulated user response:**
- **Lifecycle stage:** Primarily design-time and governance gate reviews. Also used retroactively for assurance reviews and audit evidence.
- **Mandatory standards:** DORA (EU 2022/2554) Chapters II-V, applicable RTS/ITS, the entity's ICT risk management policy, third-party risk management policy, and incident management policy.
- **Typical failure modes:** (1) Generic "we comply with DORA" statements without article-level traceability, (2) third-party providers used without concentration risk assessment, (3) no exit strategy for critical third-party services, (4) incident management treated as purely operational without architectural provisions, (5) resilience testing not considered at design time, (6) DORA compliance decisions undocumented -- auditors must interview architects to verify compliance.

**Skill decision on design method:** Selected **Method D (Risk-centered)**. Rationale: This overlay exists to manage a specific class of risk (regulatory non-compliance with DORA). Method D is the EAROS-recommended approach for security, regulatory, and resilience concerns. The steps align: identify risk classes and failure modes, identify mandatory controls, create hard gates, add criteria for residual risk visibility. The standard also notes that Method D outcomes are "often better as an overlay than a profile," which further confirms the overlay classification from Phase 1.

---

## Phase 3: Design the dimensions

**Skill action:** Asked the user to identify 2-5 dimensions, ensuring each addresses a concern the core meta-rubric does not cover.

**Simulated user response and iterative refinement:**

The user initially proposed six dimensions. The skill pushed back, noting that EAROS recommends overlays remain lean (2-5 dimensions). After discussion, the user consolidated "information sharing" and "regulatory traceability" into a single dimension, arriving at 5 dimensions:

| Dimension | DORA Chapter | Rationale for inclusion |
|-----------|-------------|----------------------|
| REG1: ICT risk management framework alignment | Chapter II (Art. 5-16) | Core meta-rubric D7 (Standards compliance) checks whether standards are mentioned, but does not verify risk-to-control mapping at the architectural level. This dimension fills that gap. |
| REG2: Third-party ICT risk management | Chapter V (Art. 28-30) | Not covered by the core at all. Third-party risk is a DORA-specific obligation that requires dedicated assessment of concentration risk, exit strategies, and contractual compliance. |
| REG3: ICT incident management and reporting readiness | Chapter III (Art. 17-23) | The core D6 (Risks) and D8 (Actionability) touch on risk and operability, but do not assess incident detection, classification, and reporting integration at the architectural level. |
| REG4: Digital operational resilience testing | Chapter IV (Art. 24-27) | Not covered by the core. DORA-specific requirement for testability, TLPT readiness, and integration with the entity's resilience testing programme. |
| REG5: ICT information sharing and regulatory communication | Article 45 + audit traceability | Addresses information sharing obligations and, crucially, the self-documentation requirement: can an auditor verify DORA compliance from the artifact alone? |

**Skill validation:** Confirmed that none of these dimensions duplicate the core meta-rubric. The core D7 (Standards and policy compliance) asks generically whether alignment is shown; the overlay dimensions ask specifically whether DORA control mapping, third-party risk assessment, incident readiness, testing provisions, and regulatory traceability are architecturally embedded.

---

## Phase 4: Design the criteria

**Skill action:** For each dimension, designed 1-2 criteria with full detail (question, evidence, scoring guide, anti-patterns, remediation hints).

**Criteria summary:**

| Criterion | Dimension | Gate | Severity | Key concern |
|-----------|-----------|------|----------|-------------|
| REG-01 | REG1 | Yes | Critical | ICT risk-to-control mapping with ownership and residual risk |
| REG-02 | REG1 | Yes | Major | ICT asset classification and dependency mapping |
| REG-03 | REG2 | Yes | Critical | Third-party ICT risk assessment including concentration and exit strategy |
| REG-04 | REG3 | Yes | Major | Incident detection, classification, and reporting integration |
| REG-05 | REG4 | Yes | Major | Resilience testing provisions and TLPT readiness |
| REG-06 | REG5 | No | -- | DORA compliance traceability and information sharing |

**Total:** 6 criteria across 5 dimensions. This is within the EAROS guideline of 5-12 criteria per overlay.

**Gate design rationale:**
- **Critical gates (REG-01, REG-03):** These represent the two areas where audit findings have been most frequent and material. A design that lacks ICT risk-control mapping or introduces third-party dependencies without risk assessment represents a fundamental DORA compliance gap that cannot be conditionally accepted.
- **Major gates (REG-02, REG-04, REG-05):** These represent significant but remediable gaps. Designs can proceed conditionally if asset classification, incident management, or resilience testing provisions need refinement, but they must be remediated before full governance approval.
- **Non-gate (REG-06):** Information sharing and regulatory traceability are important for audit evidence but are less likely to represent immediate compliance risk. Low scores contribute to the overall assessment but do not block passage on their own.

**Scoring guide quality check:** For each criterion, the skill verified that scores 2 and 3 are clearly distinguishable. The key differentiator is completeness and specificity: score 2 represents partial coverage with significant gaps, while score 3 represents adequate coverage with only minor gaps. This distinction was tested against the user's real-world audit findings to ensure it would catch the common failure modes.

---

## Phase 5: Define decision logic

**Skill action:** Asked about profile-specific escalation rules beyond standard EAROS thresholds.

**Simulated user response:** Four escalation rules were defined:
1. **Critical regulatory failure:** Reject/escalate when REG-01 or REG-03 scores 0 or 1.
2. **Major regulatory gap:** Cap at conditional_pass when REG-02, REG-04, or REG-05 scores below 2.
3. **Escalation to compliance:** Any criterion below 3 for artifacts supporting critical/important business functions triggers compliance officer review.
4. **Escalation to audit:** Automatic audit flag for artifacts with prior DORA audit findings.

Additionally, the N/A policy was tightened: for REG-01 and REG-03, N/A is only valid when the artifact genuinely does not involve ICT systems or third-party providers (which is rare for architecture artifacts at a bank).

---

## Phase 6: Assemble and validate

**Skill action:** Generated the complete YAML rubric and validated against the schema and review checklist.

**Review checklist results:**

| Check | Status | Notes |
|-------|--------|-------|
| Rubric type justified | Pass | Overlay confirmed -- regulatory is cross-cutting |
| Design method selected and applied | Pass | Method D (risk-centered) |
| Core meta-rubric inherited, not duplicated | Pass | `inherits: EAROS-CORE-001@1.0.0`, no core dimensions repeated |
| All criteria are artifact-specific | Pass | All criteria address DORA-specific obligations not covered by core D7 |
| Each criterion has full field set | Pass | question, evidence, scoring guide, anti-patterns, remediation hints |
| Gates limited to true blockers | Pass | 2 critical, 3 major, 1 non-gate -- justified by audit finding history |
| Scoring guidance distinguishes each level | Pass | Verified 2 vs 3 distinction for all criteria |
| Overlay within size limits | Pass | 5 dimensions, 6 criteria |
| At least one escalation rule defined | Pass | 4 escalation rules defined |
| User reviewed and approved | Pass (simulated) | Each dimension reviewed and confirmed |
| Ambiguities logged | Pass | See below |

**Unresolved ambiguities:**
1. The exact RTS/ITS references will need updating as DORA secondary legislation continues to be finalized. The overlay references DORA articles but specific RTS/ITS numbers should be added when applicable.
2. The threshold for "critical or important business functions" depends on the entity's own DORA classification, which may not be complete for all business functions. Calibration should test this boundary.
3. Information sharing arrangements (Article 45) are voluntary for most entities. The scoring guide reflects this but calibration should confirm the right level of expectation.

---

## Phase 7: Worked evaluation example

**Skill action:** Offered to create a worked evaluation example for calibration.

**Decision:** Deferred to calibration phase. The user indicated that they have three real architecture artifacts with prior DORA audit findings that should be used for calibration, which would be more valuable than a hypothetical example. The calibration section of the overlay specifies minimum 3 examples and recommends including at least one artifact with prior audit findings.

---

## Phase 8: Save and summarize

**Output files:**
- Rubric YAML: `regulatory-dora.v1.yaml`
- Process summary: `process-summary.md` (this file)

**Final summary:**

| Attribute | Value |
|-----------|-------|
| Rubric ID | EAROS-OVR-REG-001 |
| Type | Overlay |
| Version | 1.0.0 |
| Status | Draft |
| Design method | D (Risk-centered) |
| Dimensions added | 5 |
| Criteria added | 6 |
| Critical gates | 2 (REG-01, REG-03) |
| Major gates | 3 (REG-02, REG-04, REG-05) |
| Non-gate criteria | 1 (REG-06) |
| Escalation rules | 4 |
| Scoring method | append_to_base_rubric (overlay standard) |

**Recommended next steps:**
1. **Calibrate** with at least 3 real architecture artifacts (including one with prior DORA audit findings) using the overlay.
2. **Validate scoring guides** with 2 compliance officers independently to verify inter-rater reliability.
3. **Update RTS/ITS references** as DORA secondary legislation is finalized.
4. **Integrate** the overlay into the architecture governance toolchain so it is automatically applied at governance gates for DORA-relevant artifacts.
5. **Move to candidate status** after successful calibration, then to approved status after architecture board endorsement.

---

## Skill effectiveness observations

**What the skill did well:**
- Correctly classified the rubric as an overlay (not a profile) based on the cross-cutting regulatory concern.
- Selected Method D (risk-centered) which aligns with the EAROS standard's recommendation for regulatory and resilience concerns.
- Enforced the lean design principle: pushed back when 6 dimensions were proposed, resulting in consolidation to 5 with tighter focus.
- Required evidence anchors and scoring guide detail for every criterion, preventing vague "is it compliant?" criteria.
- Separated gate severity (critical vs major vs non-gate) based on real audit finding frequency and materiality.
- Produced output that uses `method: append_to_base_rubric` (correct for overlays) rather than `merge_with_inherited_and_apply_core_thresholds` (which is for profiles).

**Regulatory domain handling:**
- The skill's Phase 2 context-gathering was particularly valuable for regulatory overlays because it surfaced the specific failure modes (architects stating compliance without control mapping) that shaped the criteria design.
- The risk-centered design method (Method D) was well-suited: the skill's prompt to "identify risk classes and failure modes, identify mandatory controls, create hard gates" mapped directly to the DORA chapter structure.
- The skill correctly advised that regulatory concerns should be overlays, not embedded in profiles, consistent with the EAROS standard's explicit guidance.
