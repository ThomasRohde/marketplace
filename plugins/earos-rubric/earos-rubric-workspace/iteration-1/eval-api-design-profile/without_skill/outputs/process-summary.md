# Process Summary: API Design Rubric (Without Skill)

## Approach

This rubric was created from general knowledge of API governance, REST design principles, and enterprise architecture practices -- without reference to any skill templates, existing rubric frameworks, or repository files.

## Design Decisions

### Structure

I organized the rubric into six weighted dimensions that map to the concerns raised by the user:

| Dimension | Weight | Gate? | Rationale |
|---|---|---|---|
| REST Contract Completeness | 20% | Yes | Directly addresses the reported problem of incomplete API contracts |
| Error Handling Contracts | 20% | Yes | Directly addresses the RFC 7807 compliance gap the user identified |
| Versioning Strategy | 15% | Yes | Called out as a key concern; critical for fintech backward compatibility |
| Platform Pattern Compliance | 20% | Yes | Directly addresses the "inconsistent with platform standards" problem |
| Consumer Experience | 15% | No | Important but less of a hard blocker; supports API product owner interests |
| Design Document Quality | 10% | No | Ensures the review process itself is efficient |

### Scoring Model

- 4-point scale (Inadequate / Needs Work / Meets Standard / Exemplary) to avoid a neutral midpoint and force a directional judgment.
- "Gate" criteria must score >= 3 to proceed. This directly addresses the stated problem of designs being approved but later found non-compliant.
- Each level has concrete, observable guidance per criterion to reduce reviewer subjectivity.

### Key Standards Referenced

- RFC 7807 (Problem Details) -- the specific standard the user called out for error handling
- RFC 9110 (HTTP Semantics) -- foundational for correct method/status usage
- RFC 8594 (Sunset Header) -- for deprecation policy
- OpenAPI 3.x -- as the expected specification format
- OWASP API Security Top 10 -- critical for fintech security posture
- W3C Trace Context -- for observability in distributed systems

### Review Process

I included a lightweight review workflow and three-tier verdict system (Approved / Conditionally Approved / Rejected) to make the rubric actionable rather than just a scoring checklist.

## Limitations

- The rubric is generic to fintech API governance. It does not reference the organization's specific style guide, internal platform conventions, or tooling.
- Weights and thresholds are reasonable defaults but should be calibrated based on the governance board's actual priorities and historical review data.
- No automated scoring mechanism is included -- this is a human-evaluated rubric.
- The rubric does not include domain-specific regulatory criteria (e.g., PSD2, SOX) that might be relevant in a fintech context.
