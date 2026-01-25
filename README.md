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
│   └── drawio/             # DrawIO plugin
│       ├── .claude-plugin/
│       │   └── plugin.json
│       ├── commands/
│       ├── skills/
│       └── README.md
└── README.md               # This file
```

## Contact

**Maintainer:** Thomas Klok Rohde
**Email:** thomas@rohde.name
**GitHub:** [@ThomasRohde](https://github.com/ThomasRohde)

## License

Each plugin may have its own license. Please check individual plugin directories for licensing information.
