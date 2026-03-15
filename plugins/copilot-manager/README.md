# copilot-manager

Discover, audit, reconcile, modify, and delete GitHub Copilot customizations across both Copilot IDE (VS Code) and Copilot CLI environments.

## What it does

This skill encodes deep knowledge about the file discovery models of both Copilot variants, enabling you to:

- **Discover** every customization file across workspace and user-level locations
- **Audit** for naming collisions, shadowed artifacts, lossy cross-target mappings, MCP drift, and stale cross-reads
- **Reconcile** gaps between Copilot IDE and Copilot CLI (e.g., prompts with no CLI equivalent, MCP config divergence)
- **Modify** frontmatter, tool lists, scopes, and content of existing customization files
- **Delete** customizations with reference checking and cleanup

## When to use

Use this skill when you need to understand or manage *existing* Copilot customizations. For *creating new* customizations from scratch, use the `copilot-customization` skill instead.

## Covered artifact types

Instructions, custom agents, skills, prompt files, hooks, MCP servers, commands, settings, and plugins — for both Copilot IDE and Copilot CLI.
