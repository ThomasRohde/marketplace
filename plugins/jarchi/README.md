# JArchi Plugin for Claude Code

Create jArchi scripts for [Archi](https://www.archimatetool.com/) - the open-source ArchiMate modeling tool.

## Features

- **Script Generation**: Create complete `.ajs` scripts with detailed explanations
- **Comprehensive API Knowledge**: Full jArchi API coverage (elements, relationships, views, visual objects)
- **CLI Automation**: Generate PowerShell and bash commands for headless execution
- **Working Examples**: Ready-to-use script templates for common tasks

## Usage

### Command

```
/jarchi [description of what the script should do]
```

**Examples:**
- `/jarchi export all business processes to CSV`
- `/jarchi create a view showing all application components and their relationships`
- `/jarchi batch update documentation for all elements without descriptions`
- `/jarchi generate an HTML report of the current model`

### Skill

The `jarchi-scripting` skill activates automatically when you ask about:
- jArchi scripting or Archi automation
- ArchiMate model manipulation
- Creating or modifying ArchiMate elements, relationships, or views
- Exporting or reporting from Archi models
- Running Archi scripts headlessly

## Requirements

- [Archi](https://www.archimatetool.com/) with the jArchi plugin installed
- For headless execution: Archi accessible from command line

## Resources

- [jArchi Wiki](https://github.com/archimatetool/archi-scripting-plugin/wiki)
- [Archi Website](https://www.archimatetool.com/)
- [ArchiMate Specification](https://pubs.opengroup.org/architecture/archimate3-doc/)
