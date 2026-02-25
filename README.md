# Thomas Rohde's Claude Code Plugin Marketplace

A curated collection of Claude Code plugins by Thomas Klok Rohde.

## Quick Start

### Add the Marketplace

Once this marketplace is hosted on GitHub, users can add it with:

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
│   ├── copilot-customization/ # GitHub Copilot customization plugin
│   ├── drawio/              # DrawIO diagram plugin
│   ├── improve-skill/       # Skill improvement plugin
│   ├── plugin-integrator/   # Skill-to-plugin integration
│   ├── jarchi/              # jArchi scripting plugin
│   └── skill-creator/       # Skill creation & eval plugin
└── README.md               # This file
```

## Contact

**Maintainer:** Thomas Klok Rohde
**Email:** thomas@rohde.name
**GitHub:** [@ThomasRohde](https://github.com/ThomasRohde)

## License

Each plugin may have its own license. Please check individual plugin directories for licensing information.
