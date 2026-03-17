# EAROS Rubric Creation Process Summary

## Rubric produced

| Field | Value |
|-------|-------|
| Rubric ID | EAROS-MIG-001 |
| Version | 0.1.0 |
| Kind | Profile |
| Status | Draft |
| Artifact type | migration_architecture |
| Design method | C -- Lifecycle-centered |
| Dimensions added | 5 |
| Criteria added | 7 |
| Gate criteria | 4 (2 critical, 2 major) |

## How the skill guided the process

### Phase 1: Classification (Profile vs. Overlay)

The skill asked what type of architecture artifact is being evaluated and whether it requires a standalone profile or a cross-cutting overlay. Migration architecture documents are a specific artifact type with unique quality expectations -- they are not a cross-cutting concern like security or regulatory compliance. The classification was **profile**.

Key reasoning: Migration architecture documents have quality expectations that are fundamentally about the *artifact type itself* (transition planning, dependency mapping, rollback strategies) rather than a concern that would apply to many artifact types. A cloud overlay might address "is cloud-native design considered?" across all artifact types, but this rubric evaluates the completeness and quality of a migration plan as a specific class of document.

### Phase 2: Review context and method selection

The skill required understanding who reviews these documents, what decision the review supports, and what has gone wrong historically. This phase was critical -- it surfaced the real concerns that the rubric must address:

**Reviewers and decision:** Cloud migration review board (cloud architects, infrastructure, security, service management, finance) deciding whether to approve a workload for migration execution. This is a governance gate.

**Historical failures surfaced:**
1. Payment processing service migrated without mapping its dependency on an on-prem message broker (4-hour outage)
2. Claims system migrated with no rollback plan (3-week revert)
3. Teams underestimating cloud costs by 60% by not modeling the hybrid period

**Method selection -- Method C (Lifecycle-centered):** The skill's method selection table made this clear. Migration architecture documents sit at a lifecycle stage boundary: they bridge current-state and target-state and are reviewed before execution begins. The artifact's value is defined by what downstream consumers (migration teams, operations, finance) need to execute safely. This is not a decision record (Method A), a structured architecture description (Method B), a risk management artifact (Method D), or a recurring pattern (Method E). Method C directs the designer to:
- Place the artifact in the lifecycle (governance gate before execution)
- Identify what downstream users need next (executable migration plan)
- Define readiness, sequencing, and dependency criteria
- Add stage-specific gates
- Add evidence rules for actionability

### Phase 3: Dimension design

The skill required that each proposed dimension address a concern the core meta-rubric does not cover. The core meta-rubric already evaluates 9 universal dimensions (stakeholder fit, scope clarity, concern coverage, traceability, consistency, risks/tradeoffs, compliance, actionability, maintainability). Five migration-specific dimensions were designed:

| Dimension | Why it is not covered by core |
|-----------|-------------------------------|
| MT1: Transition-state and sequencing clarity | Core covers scope generically; migration requires phased transition states with entry/exit criteria |
| MT2: Dependency mapping and impact analysis | Core covers traceability generically; migration requires per-dependency impact across transition states |
| MT3: Rollback and contingency planning | Core covers risks generically; migration requires executable rollback plans with triggers and time windows |
| MT4: Data migration strategy | Entirely migration-specific; no core dimension addresses data movement |
| MT5: Cost and operational readiness for hybrid state | Core covers actionability generically; migration requires transition-period cost modeling and operational readiness |

At 5 dimensions, this is at the upper limit recommended by EAROS but justified because each dimension maps to a distinct, evidenced failure mode.

### Phase 4: Criteria design

Seven criteria were designed across the 5 dimensions, well within the 5-12 criteria limit. For each criterion, the skill required:
- A specific evaluation question
- Required evidence (not generic -- specific to migration artifacts)
- Full scoring guide (0-4 with migration-specific descriptions at each level)
- Anti-patterns drawn from real failure modes
- Remediation hints

The scoring guides were designed so that two independent reviewers could distinguish each score level. For example, MIG-01 (transition-state clarity) distinguishes "no transition states" (0) from "mentioned in prose" (1) from "phases identified but no entry/exit criteria" (2) from "phases with criteria but minor gaps" (3) from "fully sequenced and executable" (4).

### Phase 5: Decision logic

The skill required defining profile-specific escalation rules beyond the standard EAROS thresholds. Four escalation rules were defined, each tied to a specific risk condition:
- MIG-02 < 3 for workloads with >5 integration points (high dependency risk)
- MIG-04 < 3 for Tier-1 or customer-facing workloads (high rollback risk)
- MIG-05 < 3 for workloads with >1TB data (high data migration risk)
- Any two criteria scoring 1 or below (pattern of insufficient treatment)

### Phase 6: Assembly and validation

The skill's review checklist was applied:

- [x] Rubric type (profile) is justified -- artifact type has unique quality expectations
- [x] Profile design method (C -- Lifecycle-centered) was selected and applied
- [x] Core meta-rubric is inherited via `inherits: EAROS-CORE-001@1.0.0`, not duplicated
- [x] All 7 criteria are artifact-specific (migration-specific, not generic)
- [x] Each criterion has: question, evidence, scoring guide, anti-patterns, remediation hints
- [x] Gates are limited to true review blockers (2 critical: dependency mapping, rollback; 2 major: transition-state, data migration)
- [x] Scoring guidance distinguishes each level clearly
- [x] Profile adds 5 dimensions / 7 criteria (within limits)
- [x] Escalation rules are defined (4 profile-specific rules)
- [x] Simulated user reviewed and approved each dimension
- [x] No unresolved ambiguities

## Gate criteria summary

| Criterion | Gate severity | Rationale |
|-----------|--------------|-----------|
| MIG-01 (Transition-state sequencing) | Major | Migration without defined phases is not executable, but can be remediated |
| MIG-02 (Dependency mapping) | Critical | Unmapped dependencies are the primary cause of migration outages; this is a hard blocker |
| MIG-04 (Rollback planning) | Critical | Migrations without rollback capability represent unacceptable operational risk |
| MIG-05 (Data migration strategy) | Major | Critical for data-bearing workloads; may be N/A for stateless workloads |
| MIG-07 (Operational readiness) | Major | Operations must be ready for hybrid period to avoid service degradation |

## Recommended next steps

1. **Calibrate with real artifacts:** Apply this rubric to at least 3 real migration architecture documents (one lift-and-shift, one re-platform, one re-architect) to validate that scoring guides produce consistent results across reviewers.
2. **Get a second reviewer:** Have the review board members (especially infrastructure and service management) review the criteria and scoring guides for completeness and clarity.
3. **Pilot with agent evaluation:** Run one evaluation using the three-pass agentic model (extractor, evaluator, challenger) to verify the rubric is machine-evaluable.
4. **Consider companion overlays:** Security and regulatory concerns for migration should be addressed via overlays (EAROS-OVR-SEC-001, EAROS-OVR-REG-001) rather than adding those criteria to this profile.
5. **Promote to candidate:** After calibration with 3 examples and review board sign-off, promote from `draft` to `candidate` status.
