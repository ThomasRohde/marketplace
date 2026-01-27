---
description: Create a jArchi script for Archi (ArchiMate modeling tool)
argument-hint: [description of what the script should do]
allowed-tools: Read, Write, Glob
---

Create a complete jArchi script (.ajs file) based on the user's request, with detailed code comments explaining each section.

## Input Analysis

User request: $ARGUMENTS

Analyze the request to determine:
- **Script purpose**: What the script should accomplish
- **Required operations**: Query, create, update, delete, export, etc.
- **Target elements**: Element types, relationships, views involved
- **Output format**: Console output, file export, visual changes, etc.
- **Execution mode**: Interactive (GUI) or headless (CLI)

## Script Requirements

Generate a complete, well-documented `.ajs` script that:

1. **Starts with a documentation header**:
   ```javascript
   /**
    * Script Name
    *
    * Description of what this script does.
    *
    * Usage:
    * - GUI: Run from Scripts Manager in Archi
    * - CLI: Archi -application ... --script.runScript "script.ajs"
    */
   ```

2. **Includes model validation**:
   ```javascript
   if (!model.isSet()) {
       console.error("Please select a model first!");
       exit();
   }
   ```

3. **Uses proper jArchi patterns**:
   - jQuery-like selectors: `$("business-actor")`, `$(".Name")`, `$("#id")`
   - Collection methods: `.each()`, `.filter()`, `.first()`, `.size()`
   - Navigation: `.rels()`, `.inRels()`, `.outRels()`, `.viewRefs()`
   - Attribute access: `.attr()`, `.prop()`

4. **Includes detailed comments** explaining:
   - What each major section does
   - Why specific approaches are used
   - Expected inputs and outputs

5. **Handles errors gracefully**

## JArchi Knowledge

Load the jarchi-scripting skill for comprehensive API knowledge including:
- Element and relationship types
- Collection and selector methods
- View manipulation and styling
- Console, dialogs, and file operations
- CLI automation patterns

Consult skill references at `${CLAUDE_PLUGIN_ROOT}/skills/jarchi-scripting/references/` for:
- `api-elements.md` - Element creation and properties
- `api-collections.md` - Selectors and traversal
- `api-views.md` - View manipulation and styling
- `api-model.md` - Model operations
- `api-utilities.md` - Console, dialogs, file I/O
- `cli-reference.md` - CLI execution

Review examples at `${CLAUDE_PLUGIN_ROOT}/skills/jarchi-scripting/examples/` for working patterns.

## Output Requirements

After generating the script:

1. **Write the .ajs file** to the current working directory (or user-specified location)
   - Use descriptive kebab-case filename (e.g., `export-business-actors.ajs`)

2. **Provide CLI commands** to run the script headlessly:

   **PowerShell:**
   ```powershell
   & "C:\Program Files\Archi\Archi.exe" -application com.archimatetool.commandline.app `
       -consoleLog -nosplash `
       --loadModel "model.archimate" `
       --script.runScript "script-name.ajs"
   ```

   **Bash:**
   ```bash
   Archi -application com.archimatetool.commandline.app \
       -consoleLog -nosplash \
       --loadModel "model.archimate" \
       --script.runScript "script-name.ajs"
   ```

3. **Summarize** what the script does and any prerequisites

## Common Script Patterns

### Query and Report
```javascript
$("element-type").each(function(e) {
    console.log(e.name + ": " + e.documentation);
});
```

### Create Elements and Relationships
```javascript
var element = model.createElement("type", "Name");
var rel = model.createRelationship("type", "", source, target);
```

### Export to CSV
```javascript
var csv = "Name,Type\n";
$("element").each(function(e) {
    csv += e.name + "," + e.type + "\n";
});
$.fs.writeFile("export.csv", csv, "UTF8");
```

### Create View with Elements
```javascript
var view = model.createArchimateView("View Name");
var obj = view.add(element, x, y, width, height);
obj.fillColor = "#dae8fc";
```

### Batch Update
```javascript
$(selection).filter("element").each(function(e) {
    e.prop("Status", "Reviewed");
});
```

## Execution

1. Analyze the user's request
2. Determine the appropriate jArchi patterns
3. Generate the complete script with comments
4. Write the .ajs file
5. Provide CLI execution commands
6. Confirm creation with usage instructions
