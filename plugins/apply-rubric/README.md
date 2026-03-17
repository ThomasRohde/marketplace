# Apply Rubric

Apply EAROS evaluation rubrics to architecture artifacts using the **three-pass agent evaluation pattern**.

## Why three passes?

Architecture review has a specific vulnerability: confident but weak inference. A single reviewer — whether human or AI — can read a well-written document and come away with the impression that it's thorough, without noticing that key evidence is thin, internal claims contradict each other, or mandatory controls are absent behind reassuring prose.

The three-pass pattern addresses this by separating three distinct cognitive tasks that are usually tangled together:

### Pass 1: Extractor

The extractor reads the artifact and builds an **evidence map** — a structured inventory of what evidence exists for each criterion, what's missing, and where it was found. The extractor does not score. This separation matters because it prevents confirmation bias: when extraction and scoring happen simultaneously, early impressions color what evidence gets noticed and how it's interpreted.

The evidence map includes:
- **Direct evidence** — quotes and section references from the artifact
- **Evidence gaps** — what the rubric asks for but the artifact doesn't contain
- **Evidence class** — whether each finding is observed (directly stated), inferred (interpreted), or external (from policy or standards knowledge)

### Pass 2: Evaluator

The evaluator receives the pre-extracted evidence and applies the rubric criteria. With evidence already organized, the evaluator can focus on judgment rather than hunting. For each criterion, it assigns:
- A **score** (0-4) with reference to the rubric's scoring guide
- **Confidence** in the score (separate from the score itself)
- **Rationale** explaining why this score and not another
- **Recommended actions** for improvement

For comprehensive artifacts (many sections, many criteria), the skill spawns **multiple evaluator agents in parallel**, each handling a subset of dimensions. This prevents evaluator fatigue — a real problem where later criteria get less careful attention — and speeds up the evaluation.

### Pass 3: Challenger

The challenger adversarially reviews every scored criterion. It looks for:
- **Over-scoring** — scores that don't match the evidence or the scoring guide's level descriptions
- **Weak rationale** — scores that may be right but aren't adequately justified
- **Missed evidence** — relevant content the evaluator overlooked
- **Anti-patterns** — rubric-defined warning signs that weren't flagged
- **Gate concerns** — borderline scores on gate criteria that could affect the overall verdict

Material disagreements between evaluator and challenger are flagged for human review. This is a feature, not a bug — the disagreements surface exactly the ambiguous cases where human judgment adds the most value.

## What you get

Two output files:

1. **Evaluation record** (YAML) — machine-readable, schema-conformant record with:
   - Per-criterion scores, evidence, rationale, confidence, and gaps
   - Per-dimension aggregate scores
   - Gate pass/fail results
   - Overall status (pass / conditional pass / rework required / reject)
   - Strengths, weaknesses, risks, and recommended next actions

2. **Narrative report** (Markdown) — human-readable summary with:
   - Executive summary and decision narrative
   - Gate results table
   - Dimension scores with traffic-light indicators
   - Detailed criterion-by-criterion breakdown
   - Challenger findings and disagreement resolution
   - Prioritized action list

## The scoring model

Scores use the EAROS 0-4 ordinal scale:

| Score | Meaning |
|-------|---------|
| 0 | Absent or contradicted |
| 1 | Weak — acknowledged but inadequate |
| 2 | Partial — addressed but incomplete |
| 3 | Good — adequate evidence, minor gaps only |
| 4 | Strong — fully addressed, decision-ready |

The critical boundary is between 2 and 3. A score of 2 means "I can see they tried, but it's not enough for a decision." A score of 3 means "good enough — improvements are possible but this doesn't block approval."

## Gates and status determination

Some criteria are **gates** — mandatory requirements where failure affects the overall verdict regardless of other scores:

| Gate severity | Effect on failure |
|--------------|-------------------|
| Critical | Blocks pass entirely → status becomes `reject` |
| Major | Caps status at `conditional_pass` at best |
| Advisory | Triggers recommendations only |

Gates exist because weighted averages hide critical failures. Without gates, a brilliant executive summary can mask the fact that security controls are completely absent.

## Standard vs parallel evaluation

| Strategy | When used | Agents spawned |
|----------|-----------|---------------|
| **Standard** | Artifact < ~50 pages, < 15 criteria | 1 extractor + 1 evaluator + 1 challenger |
| **Parallel** | Comprehensive artifact or many criteria | 1 extractor + 2-3 evaluators + 1 challenger |

The skill automatically selects the strategy based on artifact scope and criterion count. Parallel evaluators each handle distinct dimensions, so there are no dependencies between them.

## Installation

```shell
/plugin install apply-rubric@thomas-rohde-plugins
```

## Usage

```
/apply-rubric
```

Or ask Claude to evaluate an architecture artifact against a rubric, and the skill triggers automatically.

## Prerequisites

- An EAROS rubric file (profile or overlay) — create one using the `earos-rubric` skill if you don't have one
- An architecture artifact to evaluate (markdown, PDF, or other document)
- The EAROS core meta-rubric at `tmp/profiles/core-meta-rubric.v1.yaml`

## Human review triggers

The skill flags results for human review when:
- Any critical gate fails
- Confidence is low on a gated criterion
- The challenger materially disagrees with the evaluator on a gate criterion
- Overall confidence is low
- The artifact is marked as high-risk or customer-facing

These triggers are a safety net — they identify exactly the cases where human judgment is most needed, so reviewers can focus their attention where it matters most.
