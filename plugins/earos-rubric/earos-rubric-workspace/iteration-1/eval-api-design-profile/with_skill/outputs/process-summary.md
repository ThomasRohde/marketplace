# EAROS Rubric Creator: Process Summary

## Rubric produced

| Field | Value |
|-------|-------|
| Rubric ID | EAROS-API-001 |
| Version | 0.1.0 |
| Kind | Profile |
| Status | Draft |
| Artifact type | api_design_document |
| Title | API Design Document Profile |

## Skill phases followed

### Phase 1: Classify the rubric type

**Question asked:** What type of architecture artifact do you want to evaluate? Is this a new artifact type that needs its own profile, or a cross-cutting concern?

**Simulated user answer:** We want to evaluate API design documents. These are a specific artifact type -- not a cross-cutting concern. They go through our API governance board before implementation starts.

**Decision:** Profile. API design documents have unique quality expectations (contract completeness, error handling, versioning, platform pattern compliance) that are not covered by cross-cutting overlays like security or regulatory compliance. The artifact type itself has distinct quality dimensions.

### Phase 2: Understand the review context

**Round 2 -- Who reviews and why?**

Questions asked:
- Who are the primary reviewers?
- What decision does this review support?
- What goes wrong when this review is done poorly?

Simulated answers:
- **Reviewers:** API governance board consisting of platform architects, security architects, and API product owners.
- **Decision supported:** Approve API designs for implementation. Once approved, engineering teams proceed to build. This is a governance gate.
- **What goes wrong:** APIs get approved but turn out to be inconsistent with platform standards and missing error handling contracts. Consumers discover inconsistencies after implementation starts, causing rework and integration friction. The organization identified incomplete RFC 7807 compliance and missing versioning analysis as the top two recurring issues.

**Round 3 -- Scope and lifecycle**

Questions asked:
- At what point in the lifecycle is this artifact reviewed?
- Are there mandatory standards, policies, or controls?
- What are the typical failure modes?

Simulated answers:
- **Lifecycle point:** Design-time governance gate, before implementation begins.
- **Mandatory standards:** REST API design standards (resource naming, HTTP method semantics), RFC 7807 Problem Details for error responses, API versioning policy (URL-based major versions, header-based minor), platform patterns catalog.
- **Typical failure modes:** (1) Error handling acknowledged but contracts incomplete -- no RFC 7807 schemas, missing error codes for edge cases. (2) Versioning strategy stated but breaking changes not analyzed. (3) Contracts look fine in isolation but conflict with existing platform APIs in naming, pagination, or authentication patterns. (4) Consumer experience not validated.

### Phase 2 (continued): Design method selection

**Method selected:** A -- Decision-centered

**Rationale:** The API design document exists to support a specific governance decision: approve for implementation. The decision-centered method (Method A) is the best fit because it focuses on identifying the minimum questions the governance board must answer to make the approval decision confidently. The approach works as follows: identify the decision, determine minimum questions decision-makers must answer, map to core dimensions, add only needed criteria, declare gates, write examples, pilot.

**Other methods considered and rejected:**
- Method B (Viewpoint-centered) -- better suited for architecture descriptions with formal viewpoints, not for API contracts
- Method C (Lifecycle-centered) -- while the review occurs at a lifecycle gate, the artifact itself is not a lifecycle artifact like a roadmap or transition architecture
- Method D (Risk-centered) -- error handling and security are concerns, but the artifact type is broader than risk management
- Method E (Pattern-library) -- API designs recur but are not identical enough for a pattern-library approach; each API has unique business logic

### Phase 3: Design the dimensions

**Core meta-rubric coverage analysis:**

The 9 core dimensions (D1-D9) already cover: stakeholder fit, scope clarity, concern coverage, traceability, consistency, risks/tradeoffs, compliance, actionability, and maintainability. The profile must only add what the core does not cover for API design documents.

**Dimensions proposed and accepted (4):**

| ID | Name | Gap filled |
|----|------|-----------|
| AP1 | API contract completeness | Core covers general scope; this addresses API-specific contract elements (schemas, status codes, operations) |
| AP2 | Platform pattern compliance | Core D5 checks internal consistency; this checks consistency with the broader platform API landscape |
| AP3 | Consumer experience and integration design | Core D8 covers downstream actionability; this targets API consumer integration experience specifically |
| AP4 | Security and data contract | Core compliance is general; this addresses API-specific auth models and data classification in payloads |

**Dimension count check:** 4 dimensions with 8 criteria total. Well within the EAROS guideline of no more than 5 dimensions / 12 criteria.

### Phase 4: Design the criteria

**Criteria designed (8 total):**

| ID | Dimension | Question summary | Gate |
|----|-----------|-----------------|------|
| API-01 | AP1 | API contract completeness (resources, operations, schemas, status codes) | Major |
| API-02 | AP1 | Error handling contract (RFC 7807, error codes, retry guidance) | Critical |
| API-03 | AP2 | Platform naming conventions and REST pattern compliance | Major |
| API-04 | AP2 | Versioning strategy and breaking change analysis | Major |
| API-05 | AP3 | Consumer journey, integration scenarios, developer experience | None |
| API-06 | AP3 | Operational concerns for consumers (SLOs, rate limits, caching) | None |
| API-07 | AP4 | Authentication and authorization model | Major |
| API-08 | AP4 | Data sensitivity classification and handling in payloads | None |

**Gate distribution:**
- 1 critical gate (API-02: error handling) -- reflects the organization's #1 pain point
- 4 major gates (API-01, API-03, API-04, API-07) -- contract completeness, platform compliance, versioning, and auth are true review blockers
- 3 scoring-only criteria (API-05, API-06, API-08) -- consumer experience, operational specs, and data classification are important but not hard gates

**Design rationale for making API-02 the only critical gate:** The user identified incomplete error handling contracts as the single most damaging failure mode. APIs that pass governance review without error contracts cause the most rework. Making this a critical gate ensures it cannot be hidden by strong scores in other areas.

### Phase 5: Define decision logic

**Profile-specific escalation rules:**
- Escalate to human review when API-02 (error handling contract) scores below 3 for payment or financial transaction APIs
- Escalate to human review when API-03 (platform pattern compliance) scores below 3 for any public-facing or partner-facing API
- Escalate to human review when API-07 (auth model) scores below 3 for any API handling financial data or PII

**N/A policy restrictions:** API-02 (error handling) and API-07 (auth model) may not be marked N/A for production APIs.

**Standard EAROS thresholds inherited:** Pass >= 3.2, conditional pass 2.4-3.19, rework < 2.4, reject on critical gate failure.

### Phase 6: Assemble and validate

**Review checklist results:**

- [x] Rubric type (profile) is justified -- API design documents have unique quality expectations
- [x] Profile design method (A -- Decision-centered) was selected and applied
- [x] Core meta-rubric is inherited (EAROS-CORE-001@1.0.0), not duplicated
- [x] All 8 criteria are artifact-specific (not generic)
- [x] Each criterion has: question, evidence, scoring guide, anti-patterns, remediation hints
- [x] Gates are limited to true review blockers (1 critical, 4 major, 3 none)
- [x] Scoring guidance distinguishes each level clearly (0-4 with specific descriptions)
- [x] Profile adds 4 dimensions / 8 criteria (within 5/12 limit)
- [x] Three escalation rules are defined
- [x] User reviewed and approved each dimension (simulated)
- [x] No unresolved ambiguities

### Phase 7: Worked evaluation example

Skipped for this iteration. The skill offered to create a worked evaluation example for calibration. In a production workflow, at least 3 calibration examples would be required before the rubric moves from draft to candidate status.

### Phase 8: Save and summarize

**Output file:** `api-design.v1.yaml`

## Unresolved items and recommended next steps

1. **Calibrate with real artifacts:** Apply this rubric to at least 3 real API design documents that have already been through governance review. Compare rubric scores to the actual review outcomes. Adjust scoring guidance where the rubric produces scores that diverge from expert judgment.

2. **Consider a security overlay:** Dimension AP4 (Security and data contract) covers API-specific security design. For broader security controls (threat modeling, penetration testing, compliance frameworks), the organization should consider attaching the security overlay (EAROS-OVR-SEC-001) rather than expanding this profile.

3. **Validate with governance board members:** Have at least 2 platform architects and 1 API product owner independently score the same artifact using this rubric. If their scores diverge by more than 1 point on any criterion, the scoring guidance needs refinement.

4. **Integrate with API linting:** Several criteria (API-01, API-03) could be partially automated by running OpenAPI linting tools. Consider integrating automated evidence collection for these criteria in the agentic evaluation pipeline.

5. **Promote to candidate:** After successful calibration with 3+ artifacts and inter-rater agreement verification, promote from draft (0.1.0) to candidate (0.2.0) status.
