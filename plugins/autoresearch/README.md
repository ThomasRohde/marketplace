# autoresearch

Autonomous agent-driven optimization loop inspired by [Karpathy's autoresearch](https://github.com/karpathy/autoresearch), generalized beyond ML training to any domain with a measurable objective.

## What it does

Sets up and runs an iterative hill-climbing harness where subagents modify an artifact, evaluate against a single scalar metric, and keep improvements — autonomously.

## Usage

```
/autoresearch optimize my sorting algorithm for execution speed
```

The skill will interview you to understand:
- What file(s) to optimize
- How to measure success (evaluation command + metric)
- What constraints to respect
- How many iterations to run

Then it scaffolds a `.autoresearch/` harness and runs the optimization loop using subagents.

## Examples

- **Code performance:** "Optimize my parser for throughput"
- **Prompt engineering:** "Find the best prompt template for classification accuracy"
- **Config tuning:** "Tune my nginx config for requests per second"
- **SQL optimization:** "Optimize this query's execution time"
- **Build optimization:** "Minimize my bundle size"
