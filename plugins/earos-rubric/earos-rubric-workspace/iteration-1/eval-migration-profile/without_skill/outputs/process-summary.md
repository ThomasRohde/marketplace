# Process Summary: Migration Architecture Rubric (Without Skill)

## Approach

This rubric was created from general knowledge only, without referencing any skill definitions, templates, or existing rubric files. The design process followed these steps:

### 1. Stakeholder Analysis

Identified the five review board constituencies (cloud architects, infrastructure, security, service management, finance) and ensured each has explicit ownership of at least one rubric dimension. This prevents any stakeholder from feeling their concerns are afterthoughts.

### 2. Concern-Driven Dimension Design

The six key concerns stated by the user (transition-state clarity, dependency mapping, rollback/contingency, cost modeling, operational readiness, data migration) each became a dedicated dimension. Additional dimensions were added to cover areas that commonly cause migration failures: current-state documentation, target-state architecture, security/compliance, testing/validation, communication, and document quality.

### 3. Scoring Philosophy

- **5-point scale**: Chosen over binary or 3-point scales to provide enough granularity for actionable feedback while remaining quick to apply.
- **Behavioral anchoring**: Each score level describes observable, concrete characteristics rather than subjective quality words. Reviewers should be able to point to specific sections (or their absence) to justify each score.
- **Progressive criteria**: Levels build on each other (level 4 = "all of level 3, plus...") to make scoring unambiguous and to show teams a clear improvement path.

### 4. Blocking Dimensions

Three dimensions were designated as blocking (rollback, data migration, security). A score below 3 on any of these prevents approval regardless of overall score. This reflects the reality that deficiencies in these areas represent unacceptable risk for a regulated insurance company.

### 5. Weighting

Weights were distributed to reflect the stated priorities:
- Highest weight (0.15): Transition-state clarity, since it was the primary gap identified.
- High weight (0.12 each): Dependency mapping, rollback/contingency, data migration, security -- the core risk areas.
- Standard weight (0.10 each): Current-state documentation, target-state architecture, operational readiness.
- Supporting weight (0.05-0.08): Cost modeling, testing, communication, document quality.

### 6. Review Process Guardrails

Added practical review process guidance including submission requirements, approval rules with three possible outcomes, and a feedback format. This addresses the "wildly inconsistent quality" problem not just by defining what good looks like, but by creating a structured process that produces consistent, actionable feedback.

## Limitations

- Built purely from general cloud migration knowledge; not calibrated against this organization's specific migration patterns, tooling, or regulatory environment.
- No reference to existing organizational templates or standards that might already define expected sections.
- Weights and thresholds are initial estimates that should be tuned after a few review cycles.
- Does not include insurance-industry-specific regulatory requirements beyond general mentions of HIPAA, SOC2, and state regulations.
