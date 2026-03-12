# Thomas Rohde's Claude Code Plugin Marketplace

A curated collection of Claude Code plugins by Thomas Klok Rohde.

## Quick Start

### Add the Marketplace

Users can add the marketplace with:

```shell
/plugin marketplace add ThomasRohde/marketplace
```

For local testing, use:

```shell
/plugin marketplace add ./path/to/marketplace
```

### Install Plugins

After adding the marketplace, install any plugin with:

```shell
/plugin install <plugin-name>@thomas-rohde-plugins
```

For example:

```shell
/plugin install drawio@thomas-rohde-plugins
```

## Available Plugins

### drawio

Create production-ready DrawIO diagram files with comprehensive XML knowledge for flowcharts, architecture diagrams, UML, network diagrams, and more.

**Install:**
```shell
/plugin install drawio@thomas-rohde-plugins
```

**Keywords:** drawio, diagrams, flowchart, architecture, uml, visualization

### jarchi

Commands and skills for jArchi scripting: automate Archi models, views, and exports.

**Install:**
```shell
/plugin install jarchi@thomas-rohde-plugins
```

**Keywords:** jarchi, archi, automation, scripts, archimate

### archimate

ArchiMate enterprise architecture modeling assistance for element selection, relationships, patterns, and model quality guidance.

**Install:**
```shell
/plugin install archimate@thomas-rohde-plugins
```

**Keywords:** archimate, enterprise-architecture, modeling, archi, togaf

### create-plan

Generate self-contained, agent-executable Execution Plans (ExecPlans) from PRD files that any coding agent or human novice can follow end-to-end.

**Install:**
```shell
/plugin install create-plan@thomas-rohde-plugins
```

**Keywords:** execplan, execution-plan, prd, planning, implementation, agentic, milestones

### copilot-customization

Create, scaffold, and configure GitHub Copilot customizations for VS Code projects, including instructions, prompts, agents, skills, hooks, and MCP integration.

**Install:**
```shell
/plugin install copilot-customization@thomas-rohde-plugins
```

**Keywords:** copilot, github-copilot, customization, instructions, agents, skills, hooks, mcp

### plugin-integrator

Package standalone skills into properly structured plugins and register them in the Claude Code plugin marketplace.

**Install:**
```shell
/plugin install plugin-integrator@thomas-rohde-plugins
```

**Keywords:** plugins, marketplace, skills, integration, scaffolding, packaging

### prd-writer

Write enterprise-ready, agent-executable Product Requirements Documents (PRDs) through interactive guided sessions with ambiguity tracking.

**Install:**
```shell
/plugin install prd-writer@thomas-rohde-plugins
```

**Keywords:** prd, product-requirements, agentic, planning, requirements, enterprise, specifications

### improve-skill

Analyze and improve existing Claude Code skills using research-backed SkillsBench findings — audit, score, and optimize skills for maximum effectiveness.

**Install:**
```shell
/plugin install improve-skill@thomas-rohde-plugins
```

**Keywords:** skills, skillsbench, improve, optimize, audit, skill-improvement, best-practices

### skill-creator

Create new skills, modify and improve existing skills, and measure skill performance with iterative eval-driven development loops.

**Install:**
```shell
/plugin install skill-creator@thomas-rohde-plugins
```

**Keywords:** skills, skill-creation, evals, benchmarking, iteration, testing

### augment-plan

Augment existing Execution Plans with agent-first CLI design requirements and project scaffolding guidance.

**Install:**
```shell
/plugin install augment-plan@thomas-rohde-plugins
```

**Keywords:** augment, plan, cli, scaffold, agent-first, execplan, cli-manifest

### sapphire-design

Approximate Danske Bank's Sapphire design system using plain CSS and HTML — no `@danske/sapphire-*` packages required. Includes complete design tokens, 20+ component patterns, and 700+ icons.

**Install:**
```shell
/plugin install sapphire-design@thomas-rohde-plugins
```

**Keywords:** sapphire, danske-bank, design-system, css, tokens, components, ui, fintech

### blackbox-test

Run isolated blackbox tests of any CLI tool — a zero-knowledge subagent explores, stress-tests, and reports bugs without reading source code. Works with any tech stack.

**Install:**
```shell
/plugin install blackbox-test@thomas-rohde-plugins
```

**Keywords:** blackbox, testing, qa, cli, exploratory, smoke-test, blind-test

### api-anything

Generate enterprise-ready, agent-first CLIs from OpenAPI/Swagger specs with normalized commands, enterprise auth profiles, structured output contracts, and multi-layered validation.

**Install:**
```shell
/plugin install api-anything@thomas-rohde-plugins
```

**Keywords:** openapi, swagger, cli, api, rest, agent-first, enterprise, code-generation, auth, oas

## Managing Updates

Update your local copy of this marketplace:

```shell
/plugin marketplace update thomas-rohde-plugins
```

Update all installed plugins from this marketplace:

```shell
/plugin update
```

## Contributing

For issues, suggestions, or contributions, please visit the [GitHub repository](https://github.com/ThomasRohde/marketplace).

## Marketplace Structure

```
marketplace/
├── .claude-plugin/
│   └── marketplace.json     # Marketplace configuration
├── plugins/
│   ├── archimate/           # ArchiMate modeling plugin
│   ├── augment-plan/        # Plan augmentation with CLI & scaffolding
│   ├── create-plan/           # PRD-to-ExecPlan generation
│   ├── copilot-customization/ # GitHub Copilot customization plugin
│   ├── drawio/              # DrawIO diagram plugin
│   ├── improve-skill/       # Skill improvement plugin
│   ├── plugin-integrator/   # Skill-to-plugin integration
│   ├── prd-writer/          # PRD writing with ambiguity tracking
│   ├── jarchi/              # jArchi scripting plugin
│   ├── sapphire-design/     # Sapphire design system plugin
│   ├── skill-creator/       # Skill creation & eval plugin
│   ├── blackbox-test/       # Blackbox CLI testing plugin
│   └── api-anything/        # OpenAPI/Swagger to agent-first CLI generator
└── README.md               # This file
```

## Contact

**Maintainer:** Thomas Klok Rohde
**Email:** thomas@rohde.name
**GitHub:** [@ThomasRohde](https://github.com/ThomasRohde)

## License

Each plugin may have its own license. Please check individual plugin directories for licensing information.
