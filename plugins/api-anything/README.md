# api-anything

Generate enterprise-ready, agent-first CLIs from OpenAPI / Swagger specifications.

## What it does

`api-anything` takes an OpenAPI 3.x or Swagger 2.0 spec and produces a complete, production-grade CLI with:

- **Normalized resource commands** instead of raw REST path mirroring
- **Enterprise auth profiles** (API key, OAuth 2.0, OIDC, mTLS, custom gateway headers)
- **Structured JSON output** with a single consistent envelope across all commands
- **Agent-first design** following the [CLI-MANIFEST](https://gist.githubusercontent.com/ThomasRohde/d4e99da015786674dbfd0233efb4f809/raw/42bf9031c89e79e3a5780e53ccf520234a74a4bd/CLI-MANIFEST.md) contract
- **Multi-layered validation** inspired by [CLI-Anything](https://github.com/HKUDS/CLI-Anything)
- **Safe mutation defaults** with dry-run, plan/validate/apply/verify workflows, and idempotency

## Install

```shell
/plugin install api-anything@thomas-rohde-plugins
```

## Usage

Invoke with `/api-anything` or trigger naturally with phrases like:

- "generate a CLI from this OpenAPI spec"
- "turn this Swagger API into an agent-friendly CLI"
- "scaffold an enterprise REST CLI from this OAS file"
- "create a CLI wrapper around this REST API"

## Inputs

- OpenAPI 3.x or Swagger 2.0 spec (URL, local file path, or pasted content)
- Optional: auth overrides, environment profiles, technology preferences

## Outputs

- Complete CLI project scaffold with command tree
- Enterprise auth configuration layer
- Structured output contract (JSON envelope)
- Test suite (unit, integration, subprocess verification)
- Agent guidance documentation (`guide` command, examples)

## Components

- **Skill:** `api-anything` — main workflow from spec ingestion through validated CLI scaffold
- **References:**
  - `cli-manifest-contract.md` — normative CLI design contract
  - `auth-patterns.md` — enterprise authentication patterns and profiles
  - `validation-strategy.md` — 7-layer validation framework
  - `normalization-guide.md` — spec-to-command normalization pipeline
  - `output-contract.md` — JSON envelope and error taxonomy
  - `examples.md` — concrete walkthroughs

## License

MIT
