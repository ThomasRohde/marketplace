---
description: Create a DrawIO diagram file from description
argument-hint: [diagram-type or description]
allowed-tools: Read, Write, Glob
---

Create a production-ready `.drawio` diagram file based on the user's request.

## Input Analysis

User request: $ARGUMENTS

Determine the diagram type from the request:
- **Flowchart**: process flows, decision trees, workflows, "flow", "process"
- **Architecture**: system design, microservices, infrastructure, "architecture", "system"
- **Sequence**: interactions, message passing, "sequence", "timeline", "call flow"
- **ER Diagram**: database schema, entities, relationships, "ER", "database", "schema"
- **Class Diagram**: UML classes, inheritance, "class", "OOP", "UML class"
- **Network**: topology, infrastructure, servers, "network", "topology"
- **Org Chart**: hierarchy, organizational structure, "org chart", "hierarchy", "team"
- **ArchiMate**: enterprise architecture, business/application/technology layers, "ArchiMate", "TOGAF"
- **C4 Model**: software architecture, context/container/component, "C4", "C4 model", "container diagram"

## Output Requirements

1. **Analyze the request** to identify:
   - Diagram type (flowchart, architecture, sequence, ER, class, network, org chart, ArchiMate, C4)
   - Key elements/nodes to include
   - Relationships/connections between elements
   - Any specific styling or layout requirements

2. **Generate a complete .drawio file** with:
   - Proper XML structure with mxfile, diagram, mxGraphModel, and root elements
   - Unique IDs for all mxCell elements (starting from id="2")
   - Appropriate shapes for the diagram type
   - Clear labels and readable text
   - Professional color scheme (blue/green/orange/red palette)
   - Logical layout with proper spacing (150-200px horizontal, 80-100px vertical)
   - Orthogonal connectors with arrows where appropriate

3. **File naming**:
   - Use descriptive kebab-case filename
   - Extension: `.drawio`
   - Example: `user-authentication-flow.drawio`, `microservices-architecture.drawio`

4. **Quality standards**:
   - All shapes must have unique IDs
   - Use consistent styling within the diagram
   - Ensure connectors have proper source/target references
   - Include appropriate page dimensions for the content

## DrawIO Knowledge

Load the drawio-creation skill for comprehensive DrawIO XML format knowledge including:
- Shape styles for different diagram types
- Color palettes and styling options
- Connector configurations
- Layout best practices

Consult skill references at `${CLAUDE_PLUGIN_ROOT}/skills/drawio-creation/references/` for detailed information:
- `xml-structure.md` - Complete XML format
- `shape-library.md` - Available shapes and styles
- `styling-guide.md` - Colors, fonts, and effects

Review examples at `${CLAUDE_PLUGIN_ROOT}/skills/drawio-creation/examples/` for working templates.

## Execution

After generating the diagram:
1. Write the file to the current working directory (or user-specified location)
2. Confirm the file was created with filename
3. Briefly describe what the diagram contains
4. Mention the file can be opened in draw.io or diagrams.net
