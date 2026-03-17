# Process Summary: DORA Compliance Overlay Rubric (Without Skill)

## Approach

This rubric was produced using only general knowledge of the Digital Operational Resilience Act (EU Regulation 2022/2554), its regulatory technical standards (RTS), and enterprise architecture evaluation best practices. No skill templates, reference files, or existing rubric structures were consulted.

## Design Decisions

### Structure: Five Pillars Aligned to DORA's Legislative Structure

The rubric is organized around DORA's five regulatory pillars, which directly mirror the regulation's chapter structure:

1. **ICT Risk Management** (Articles 5-16) - weighted at 25%
2. **ICT-Related Incident Management and Reporting** (Articles 17-23) - weighted at 20%
3. **Digital Operational Resilience Testing** (Articles 24-27) - weighted at 20%
4. **ICT Third-Party Risk Management** (Articles 28-44) - weighted at 25%
5. **Information Sharing** (Article 45) - weighted at 10%

Weights reflect the relative regulatory emphasis and practical significance. Pillars 1 and 4 receive the highest weights because they represent the broadest compliance surface and the areas where architecture artifacts most commonly fall short.

### Scoring Model

A 5-point scale (0-4) was chosen to provide sufficient granularity to distinguish between:
- **Not addressed** (0) - a compliance gap
- **Mentioned** (1) - the common failure mode where architects name-check compliance without operationalizing it
- **Partially mapped** (2) - meaningful but incomplete coverage
- **Fully mapped** (3) - the target compliance state
- **Evidenced** (4) - exceeds requirements with testable, traceable evidence

The passing threshold of 2.5 with a minimum of 2.0 per dimension ensures no pillar can be entirely neglected while allowing some criteria to compensate for others within a pillar.

### Addressing the Core Problem

The user's core problem is that architects "mention compliance but don't actually map controls to their designs." The rubric addresses this directly through:

- **Evidence examples** on every criterion, making it concrete what "mapped" looks like
- **Scoring guidance** that explicitly penalizes "mentioned but not mapped" (score of 1)
- **A mandatory Regulatory Traceability Matrix** (cross-cutting concern CC3) that forces article-to-design-element mapping
- **An evaluation workflow** that provides a repeatable process for assessment

### Cross-Cutting Concerns

Three cross-cutting concerns were added that apply regardless of which pillar is being evaluated:
- Governance and accountability (ensuring management body responsibility is visible)
- Proportionality (DORA's risk-based approach is reflected)
- Regulatory traceability (the explicit control-to-design mapping that is currently missing)

### Practical Usability

The rubric includes:
- An evaluation workflow with 5 clear steps
- Output templates for the evaluation report
- Risk ratings tied to scores for prioritization
- Article-level traceability on every criterion

## Limitations

- This rubric was built from general knowledge only. It may not align with the organization's existing rubric format, terminology, or tooling conventions.
- The RTS and ITS under DORA (published by ESAs) contain additional detailed requirements that could further refine individual criteria.
- The rubric does not account for national transposition nuances or supervisory expectations specific to any particular EU member state's competent authority.
- Without access to the organization's existing architecture artifact templates, the evidence examples are generic rather than mapped to specific document sections.

## Time and Method

- Duration: Single-pass generation from general regulatory and architecture knowledge
- No files from the repository were consulted
- No iterative refinement based on existing rubric patterns was performed
