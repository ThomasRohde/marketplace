---
name: JArchi Scripting
description: This skill should be used when the user asks to "create a jArchi script", "write an Archi script", "automate ArchiMate", "export from Archi", "query ArchiMate elements", "create ArchiMate views", "run Archi headlessly", "Archi CLI", "batch process ArchiMate model", or mentions "jArchi", ".ajs script", "Archi automation", or ArchiMate scripting. Provides comprehensive jArchi API knowledge and CLI automation support.
version: 1.0.0
---

# JArchi Scripting

Create JavaScript scripts (.ajs files) for Archi, the open-source ArchiMate modeling tool. JArchi enables programmatic access to ArchiMate models for automation, reporting, and batch operations.

## Core Concepts

### Script Basics

JArchi scripts use JavaScript with a jQuery-like API. Scripts have `.ajs` extension and access the model through global variables:

```javascript
// Global variables available in all scripts
model        // The current model (must be selected or loaded)
selection    // Currently selected objects in UI
$(selector)  // jQuery-like selector function (alias for jArchi())
```

### Selectors

Query model objects using CSS-like selectors:

```javascript
// By type (kebab-case ArchiMate types)
$("business-actor")           // All business actors
$("application-component")    // All application components
$("serving-relationship")     // All serving relationships

// By name
$(".Customer Portal")         // Objects named "Customer Portal"

// By ID
$("#abc-123")                 // Object with specific ID

// Special selectors
$("element")                  // All ArchiMate elements
$("relationship")             // All relationships
$("view")                     // All views (ArchiMate, Canvas, Sketch)
$("folder")                   // All folders
$("concept")                  // All elements and relationships
$("*")                        // Everything
```

### Collection Methods

Collections support chaining and iteration:

```javascript
// Traversal
collection.children()         // Direct children
collection.parent()           // Parent folder/container
collection.find(selector)     // Descendants matching selector

// Navigation (relationships)
collection.rels()             // All connected relationships
collection.inRels()           // Incoming relationships
collection.outRels()          // Outgoing relationships
collection.sourceEnds()       // Source concepts of relationships
collection.targetEnds()       // Target concepts of relationships

// Filtering
collection.filter(selector)   // Keep matching objects
collection.not(selector)      // Exclude matching objects
collection.first()            // First object only

// Iteration
collection.each(function(obj) { /* process obj */ });
collection.size()             // Count of objects

// Attributes
collection.attr("name")                  // Get attribute
collection.attr("name", "New Name")      // Set attribute
collection.prop("key")                   // Get property
collection.prop("key", "value")          // Set property
```

### Creating Model Content

```javascript
// Elements
var actor = model.createElement("business-actor", "Customer");
var component = model.createElement("application-component", "API Gateway");

// Relationships
var rel = model.createRelationship("serving-relationship", "", component, actor);

// Views
var view = model.createArchimateView("Overview");

// Add elements to view
var obj1 = view.add(actor, 100, 100, 120, 60);
var obj2 = view.add(component, 300, 100, 120, 60);

// Add relationship to view
view.add(rel, obj1, obj2);

// Folders
var folder = $("folder.Business").first();
var subfolder = folder.createFolder("Processes");
```

### Visual Styling

Set appearance of diagram objects:

```javascript
// Colors (hex format)
diagramObject.fillColor = "#dae8fc";
diagramObject.lineColor = "#6c8ebf";
diagramObject.fontColor = "#333333";

// Font
diagramObject.fontSize = 12;
diagramObject.fontStyle = "bold";  // normal, bold, italic, bolditalic

// Position and size
diagramObject.bounds = {x: 100, y: 100, width: 120, height: 60};

// Other
diagramObject.opacity = 200;       // 0-255
diagramObject.labelExpression = "${name}\n${type}";
```

### Console and Dialogs

```javascript
// Console output
console.log("Message");
console.error("Error message");
console.clear();
console.show();

// User dialogs
window.alert("Information");
var confirmed = window.confirm("Proceed?");
var input = window.prompt("Enter name:", "Default");
var selection = window.promptSelection("Choose:", ["Option 1", "Option 2"]);

// File dialogs
var filePath = window.promptOpenFile({title: "Open", filterExtensions: ["*.csv"]});
var savePath = window.promptSaveFile({title: "Save", filterExtensions: ["*.csv"]});
var dirPath = window.promptOpenDirectory({title: "Select Folder"});
```

### File Operations

```javascript
// Write file
$.fs.writeFile("path/to/file.csv", content, "UTF8");
$.fs.writeFile("path/to/file.bin", base64Data, "BASE64");

// Include other scripts
load(__DIR__ + "lib/helpers.js");

// Special variables
__DIR__          // Directory containing current script
__FILE__         // Path to current script
__SCRIPTS_DIR__  // User's scripts directory
```

### Exporting Views

```javascript
// Render to file
$.model.renderViewToFile(view, "diagram.png", "PNG");
$.model.renderViewToFile(view, "diagram.png", "PNG", {scale: 2, margin: 20});
$.model.renderViewToPDF(view, "diagram.pdf");
$.model.renderViewToSVG(view, "diagram.svg", true);

// Render to string/bytes
var svgString = $.model.renderViewAsSVGString(view, true);
var base64 = $.model.renderViewAsBase64(view, "PNG");
```

## CLI Execution

Run scripts headlessly using Archi Command Line Interface.

### Basic Syntax

**Windows (PowerShell):**
```powershell
& "C:\Program Files\Archi\Archi.exe" -application com.archimatetool.commandline.app `
    -consoleLog -nosplash `
    --loadModel "model.archimate" `
    --script.runScript "script.ajs"
```

**Windows (CMD):**
```cmd
"C:\Program Files\Archi\Archi.exe" -application com.archimatetool.commandline.app ^
    -consoleLog -nosplash ^
    --loadModel "model.archimate" ^
    --script.runScript "script.ajs"
```

**Linux/macOS:**
```bash
Archi -application com.archimatetool.commandline.app \
    -consoleLog -nosplash \
    --loadModel "model.archimate" \
    --script.runScript "script.ajs"
```

### Common CLI Options

```
--loadModel "path/model.archimate"     Load existing model
--createEmptyModel                      Create blank model
--script.runScript "script.ajs"         Run jArchi script
--saveModel "path/output.archimate"     Save model after script
--csv.export "path/output"              Export to CSV
--html.createReport "path/output"       Generate HTML report
--xmlexchange.export "path/output.xml"  Export to Open Exchange XML
```

### Script Arguments

Pass custom arguments to scripts:

```powershell
& Archi.exe -application com.archimatetool.commandline.app -consoleLog -nosplash `
    --loadModel "model.archimate" `
    --script.runScript "script.ajs" `
    --myArg "value" --anotherArg "value2"
```

Access in script:
```javascript
var args = $.process.argv;
args.forEach(function(arg) {
    console.log(arg);
});
```

### Linux Headless Mode

For servers without display:
```bash
xvfb-run Archi -application com.archimatetool.commandline.app \
    -consoleLog -nosplash --loadModel "model.archimate" \
    --script.runScript "script.ajs"
```

## ArchiMate Types Reference

### Element Types

| Layer | Types |
|-------|-------|
| Strategy | `resource`, `capability`, `course-of-action`, `value-stream` |
| Business | `business-actor`, `business-role`, `business-process`, `business-function`, `business-service`, `business-object`, `contract`, `product` |
| Application | `application-component`, `application-function`, `application-service`, `application-interface`, `data-object` |
| Technology | `node`, `device`, `system-software`, `technology-service`, `artifact`, `communication-network`, `path` |
| Physical | `equipment`, `facility`, `distribution-network`, `material` |
| Motivation | `stakeholder`, `driver`, `goal`, `requirement`, `constraint`, `principle`, `outcome` |
| Implementation | `work-package`, `deliverable`, `plateau`, `gap` |
| Other | `location`, `grouping`, `junction` |

### Relationship Types

`composition-relationship`, `aggregation-relationship`, `assignment-relationship`, `realization-relationship`, `serving-relationship`, `access-relationship`, `influence-relationship`, `triggering-relationship`, `flow-relationship`, `specialization-relationship`, `association-relationship`

## Best Practices

1. **Check model is set** before operations:
   ```javascript
   if (!model.isSet()) {
       console.error("No model selected");
       exit();
   }
   ```

2. **Use meaningful names** when creating elements

3. **Batch operations** - collect changes, apply at end

4. **Handle errors** gracefully with try/catch

5. **Log progress** for long-running scripts

6. **Use folders** to organize created elements

## Additional Resources

### Reference Files

For detailed API documentation, consult:
- **`references/api-elements.md`** - Element types, creation, properties
- **`references/api-collections.md`** - Selectors, traversal, filtering
- **`references/api-views.md`** - Views, visual objects, styling
- **`references/api-model.md`** - Model operations, loading, saving
- **`references/api-utilities.md`** - Console, dialogs, file I/O
- **`references/cli-reference.md`** - Complete CLI options and automation

### Example Scripts

Working examples in `examples/`:
- **`query-elements.ajs`** - Query and report on model elements
- **`create-view.ajs`** - Create view with elements and relationships
- **`export-report.ajs`** - Export model data to CSV
- **`batch-update.ajs`** - Batch update element properties
- **`cli-automation.ps1`** - PowerShell automation script
- **`cli-automation.sh`** - Bash automation script
