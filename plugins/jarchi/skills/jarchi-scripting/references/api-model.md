# JArchi API: Model Operations

Detailed reference for model-level operations including loading, saving, and management.

## The Current Model

The global `model` variable references the current model:

```javascript
// Check if model is set
if (!model.isSet()) {
    console.error("No model selected!");
    exit();
}

// Model properties
console.log(model.name);
console.log(model.id);
console.log(model.purpose);  // Model documentation
```

### Model Properties

```javascript
model.id           // Unique ID (read-only)
model.name         // Model name
model.purpose      // Model purpose/documentation

// Get file path (null if not saved)
var path = model.getPath();
```

## Creating Models

### Create Empty Model

```javascript
var newModel = $.model.create("My New Model");
newModel.setAsCurrent();  // Make it the current model
```

### Create from Template

CLI only:
```bash
Archi --createEmptyModel "template.architemplate"
```

## Loading Models

### Load from File

```javascript
var loadedModel = $.model.load("C:/path/to/model.archimate");
loadedModel.setAsCurrent();

// Optionally open in UI
model.openInUI();
```

### Check if Model is Loaded

```javascript
var isLoaded = $.model.isModelLoaded(someModel);
```

### Get All Loaded Models

```javascript
var models = $.model.getLoadedModels();
models.forEach(function(m) {
    console.log(m.name);
});
```

### Iterate Through Models

```javascript
$.model.getLoadedModels().forEach(function(m) {
    m.setAsCurrent();
    console.log("Processing: " + model.name);
    // Work with model...
});
```

## Saving Models

### Save to Current Location

```javascript
model.save();  // Saves to current path
```

### Save to New Location

```javascript
model.save("C:/path/to/new-model.archimate");
```

## Model References

### Copy Reference

```javascript
var modelRef = model.copy();  // Copy reference (not the model itself)
```

### Set as Current

```javascript
someModel.setAsCurrent();
// Now 'model' global variable refers to someModel
```

### Open in UI

```javascript
model.openInUI();  // Shows in Models Tree (UI only, not CLI)
```

## Merging Models

### Merge from File

```javascript
var messages = [];
model.merge("path/to/other.archimate", true, true, messages);

messages.forEach(function(msg) {
    console.log(msg);
});
```

### Merge from Loaded Model

```javascript
var otherModel = $.model.load("path/to/other.archimate");
var messages = [];
model.merge(otherModel, true, true, messages);
```

### Merge Parameters

```javascript
model.merge(source, update, updateAll, messages)
```

- `source` - File path or model reference
- `update` - If true, update/replace target objects with source
- `updateAll` - If true, update model name, purpose, properties, folder structure
- `messages` - Optional array to receive merge log messages

## Specializations

### Create Specialization

```javascript
// Without image
var spec = model.createSpecialization("Cloud Service", "application-component");

// With image
var image = model.createImage("path/to/cloud-icon.png");
var spec = model.createSpecialization("Cloud Service", "application-component", image);
```

### Find Specialization

```javascript
var spec = model.findSpecialization("Cloud Service", "application-component");
if (spec) {
    console.log("Found: " + spec.name);
}
```

### List All Specializations

```javascript
model.specializations.forEach(function(spec) {
    console.log(spec.name + " (" + spec.type + ")");
    if (spec.image) {
        console.log("  Image: " + spec.image.width + "x" + spec.image.height);
    }
});
```

### Specialization Properties

```javascript
spec.name         // Name (read/write)
spec.type         // Concept type (read/write)
spec.image        // Image object (read/write)

// Delete specialization
spec.delete();    // Removes from all concepts
```

### Apply Specialization

```javascript
element.specialization = "Cloud Service";
var specName = element.specialization;
```

## Images

### Create/Load Image

```javascript
var image = model.createImage("path/to/image.png");
console.log("Size: " + image.width + "x" + image.height);
```

Images are matched by content - loading the same image twice returns the same object.

### Use Image

```javascript
// On visual object
diagramObject.imageSource = IMAGE_SOURCE.CUSTOM;
diagramObject.image = image;

// On specialization
var spec = model.createSpecialization("Custom", "node", image);
```

## Folders

### Top-Level Folders

Every model has these top-level folders:
- Strategy
- Business
- Application
- Technology & Physical
- Motivation
- Implementation & Migration
- Other
- Views

Access via selector:

```javascript
var businessFolder = $("folder.Business").first();
var viewsFolder = $("folder.Views").first();
```

### Create Subfolder

```javascript
var parent = $("folder.Business").first();
var subfolder = parent.createFolder("Processes");
```

### Move Objects to Folder

```javascript
var folder = $("folder.Business").first().createFolder("Actors");
var actor = model.createElement("business-actor", "Customer");
folder.add(actor);

// Move existing element
var existingElement = $("business-actor.Partner").first();
folder.add(existingElement);  // Moves from current folder
```

### Folder Properties

```javascript
folder.name           // Folder name
folder.documentation  // Folder documentation
folder.id             // Unique ID (read-only)
folder.type           // "folder"

// Folder label expression
folder.labelExpression = "${name} (${property:Status})";
```

## Relationship Validation

### Check if Relationship Allowed

```javascript
var allowed = $.model.isAllowedRelationship(
    "assignment-relationship",
    "business-actor",
    "business-role"
);

if (allowed) {
    model.createRelationship("assignment-relationship", "", actor, role);
}
```

## Process Information

### Script Engine

```javascript
var engine = $.process.engine;
console.log("Running on: " + engine);
```

### Platform

```javascript
var platform = $.process.platform;  // "win32", "linux", "darwin"
```

### Version Information

```javascript
console.log("Archi: " + $.process.release.archiName);
console.log("Archi Version: " + $.process.release.archiVersion);
console.log("jArchi: " + $.process.release.jArchiName);
console.log("jArchi Version: " + $.process.release.jArchiVersion);
```

### Command Line Arguments

When running via CLI:

```javascript
var args = $.process.argv;
args.forEach(function(arg) {
    console.log("Arg: " + arg);
});

// Parse named arguments
function getArg(name) {
    var args = $.process.argv;
    for (var i = 0; i < args.length; i++) {
        if (args[i] === "--" + name && i + 1 < args.length) {
            return args[i + 1];
        }
    }
    return null;
}

var outputPath = getArg("output");
if (outputPath) {
    console.log("Output to: " + outputPath);
}
```

## Common Model Patterns

### Initialization Check

```javascript
// Always start scripts with this check
if (!model.isSet()) {
    window.alert("Please select a model first!");
    exit();
}
```

### Process All Models

```javascript
$.model.getLoadedModels().forEach(function(m) {
    m.setAsCurrent();
    console.log("\n=== " + model.name + " ===");

    // Count elements
    var count = $("element").size();
    console.log("Elements: " + count);
});
```

### Find or Create

```javascript
function findOrCreateFolder(parentPath, name) {
    var parent = $(parentPath).first();
    var existing = $(parent).children("folder." + name).first();
    if (existing) {
        return existing;
    }
    return parent.createFolder(name);
}

var processesFolder = findOrCreateFolder("folder.Business", "Processes");
```

### Backup Before Changes

```javascript
// Save backup before destructive operations
var backupPath = model.getPath().replace(".archimate", "-backup.archimate");
model.save(backupPath);
console.log("Backup saved to: " + backupPath);

// Now make changes...
```

### Model Statistics

```javascript
console.log("=== Model Statistics ===");
console.log("Name: " + model.name);
console.log("Elements: " + $("element").size());
console.log("Relationships: " + $("relationship").size());
console.log("Views: " + $("view").size());
console.log("");

// By layer
console.log("Business: " + $("element").filter(function(e) {
    return e.type.startsWith("business-");
}).size());

console.log("Application: " + $("element").filter(function(e) {
    return e.type.startsWith("application-");
}).size());

console.log("Technology: " + $("element").filter(function(e) {
    return e.type.startsWith("technology-") ||
           e.type.startsWith("node") ||
           e.type.startsWith("device");
}).size());
```
