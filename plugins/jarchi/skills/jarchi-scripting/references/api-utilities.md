# JArchi API: Console, Dialogs, and Utilities

Detailed reference for user interaction, file operations, and utility functions.

## Console Output

### Basic Logging

```javascript
console.log("Simple message");
console.log("Value:", someVariable);
console.log("Multiple", "values", 123, obj);
```

### Error Logging

```javascript
console.error("Error message");  // Shows in red, opens console
```

### Console Management

```javascript
console.show();    // Open console window
console.hide();    // Hide console window
console.clear();   // Clear console content
console.setText("Replace all content with this text");
```

### Console Colors

```javascript
// Set custom text color (RGB values 0-255)
console.setTextColor(255, 0, 0);    // Red text
console.log("This is red");

console.setTextColor(0, 128, 0);    // Green text
console.log("This is green");

console.setDefaultTextColor();       // Reset to default
console.log("Back to normal");
```

## User Dialogs

### Alert

Display information message:

```javascript
window.alert("Operation completed successfully!");
window.alert("Found " + count + " elements");
```

### Confirm

Ask yes/no question:

```javascript
var proceed = window.confirm("Delete all selected elements?");
if (proceed) {
    // User clicked OK
    $(selection).each(function(obj) {
        obj.delete();
    });
} else {
    // User clicked Cancel
    console.log("Operation cancelled");
}
```

### Prompt

Get text input:

```javascript
var name = window.prompt("Enter element name:", "Default Name");

if (name !== null) {
    // User entered value (could be empty string)
    model.createElement("business-actor", name);
} else {
    // User clicked Cancel
    console.log("Cancelled");
}
```

### Selection Dialog

Choose from list of options:

```javascript
var options = ["Option A", "Option B", "Option C"];
var choice = window.promptSelection("Select an option:", options);

if (choice !== null) {
    console.log("Selected: " + choice);
} else {
    console.log("Cancelled");
}
```

## File Dialogs

### Open File Dialog

```javascript
var filePath = window.promptOpenFile({
    title: "Select Model",
    filterExtensions: ["*.archimate"],
    filterPath: "C:/Models"  // Starting directory
});

if (filePath) {
    var loadedModel = $.model.load(filePath);
}
```

### Open Directory Dialog

```javascript
var dirPath = window.promptOpenDirectory({
    title: "Select Output Folder",
    filterPath: "C:/Output"
});

if (dirPath) {
    console.log("Will save to: " + dirPath);
}
```

### Save File Dialog

```javascript
var savePath = window.promptSaveFile({
    title: "Save Report",
    filterExtensions: ["*.csv", "*.txt"]
});

if (savePath) {
    $.fs.writeFile(savePath, content, "UTF8");
}
```

## File Operations

### Write Text File

```javascript
// UTF-8 encoding (default for most text)
$.fs.writeFile("output.txt", "Hello World", "UTF8");

// Write CSV
var csv = "Name,Type,Documentation\n";
$("element").each(function(e) {
    csv += '"' + e.name + '","' + e.type + '","' + (e.documentation || "") + '"\n';
});
$.fs.writeFile("elements.csv", csv, "UTF8");

// Write JSON
var data = {
    model: model.name,
    elements: []
};
$("element").each(function(e) {
    data.elements.push({name: e.name, type: e.type});
});
$.fs.writeFile("model.json", JSON.stringify(data, null, 2), "UTF8");
```

### Write Binary File

```javascript
// Write Base64-encoded binary data
$.fs.writeFile("image.png", base64Data, "BASE64");

// Example: Save view as image
var base64 = $.model.renderViewAsBase64(view, "PNG");
$.fs.writeFile("diagram.png", base64, "BASE64");
```

### Write HTML Report

```javascript
var html = '<!DOCTYPE html>\n<html>\n<head>\n';
html += '<title>' + model.name + '</title>\n';
html += '<style>body{font-family:Arial;} table{border-collapse:collapse;} td,th{border:1px solid #ccc;padding:8px;}</style>\n';
html += '</head>\n<body>\n';
html += '<h1>' + model.name + '</h1>\n';
html += '<table>\n<tr><th>Name</th><th>Type</th></tr>\n';

$("element").each(function(e) {
    html += '<tr><td>' + e.name + '</td><td>' + e.type + '</td></tr>\n';
});

html += '</table>\n</body>\n</html>';
$.fs.writeFile("report.html", html, "UTF8");
```

## Including Scripts

### Load External Script

```javascript
load(__DIR__ + "lib/helpers.js");
load(__DIR__ + "utils/formatting.js");
```

### Script Path Variables

```javascript
__DIR__          // Directory containing current script
__FILE__         // Full path to current script
__LINE__         // Current line number
__SCRIPTS_DIR__  // User's scripts directory (from preferences)
```

### Example: Library Structure

```
scripts/
├── main.ajs
└── lib/
    ├── export.js
    └── formatting.js
```

```javascript
// main.ajs
load(__DIR__ + "lib/export.js");
load(__DIR__ + "lib/formatting.js");

// Now use functions from loaded scripts
exportToCSV(elements, "output.csv");
```

## External Process Execution

### Run External Command

```javascript
$.child_process.exec("notepad.exe", "file.txt");
$.child_process.exec("code", "script.ajs");  // Open in VS Code
$.child_process.exec("explorer.exe", "C:\\Output");
```

**Note:** This is fire-and-forget; cannot capture output.

## Shell Variable

Access SWT Shell for advanced dialogs:

```javascript
// Available for extending with Java dialogs
var currentShell = shell;
```

## Exiting Scripts

### Early Exit

```javascript
if (!model.isSet()) {
    console.error("No model selected");
    exit();  // Stop script execution
}
```

## Common Utility Patterns

### Progress Logging

```javascript
var elements = $("element");
var total = elements.size();
var count = 0;

elements.each(function(e) {
    count++;
    if (count % 100 === 0) {
        console.log("Processing: " + count + "/" + total);
    }
    // Process element...
});

console.log("Done! Processed " + total + " elements");
```

### Error Handling

```javascript
try {
    var data = processElements();
    $.fs.writeFile("output.csv", data, "UTF8");
    console.log("Export successful");
} catch (e) {
    console.error("Error: " + e.message);
    window.alert("Export failed: " + e.message);
}
```

### Interactive Script

```javascript
// Get user input
var elementType = window.promptSelection("Select element type:", [
    "business-actor",
    "business-process",
    "application-component"
]);

if (!elementType) {
    console.log("Cancelled");
    exit();
}

var name = window.prompt("Enter element name:");
if (!name) {
    console.log("Cancelled");
    exit();
}

// Confirm
if (!window.confirm("Create " + elementType + " named '" + name + "'?")) {
    console.log("Cancelled");
    exit();
}

// Create element
var element = model.createElement(elementType, name);
console.log("Created: " + element.id);
```

### CSV Generation

```javascript
function escapeCSV(value) {
    if (!value) return "";
    value = String(value);
    if (value.includes(",") || value.includes('"') || value.includes("\n")) {
        return '"' + value.replace(/"/g, '""') + '"';
    }
    return value;
}

function generateCSV(elements) {
    var csv = "ID,Name,Type,Documentation\n";

    elements.each(function(e) {
        csv += escapeCSV(e.id) + ",";
        csv += escapeCSV(e.name) + ",";
        csv += escapeCSV(e.type) + ",";
        csv += escapeCSV(e.documentation) + "\n";
    });

    return csv;
}

var csv = generateCSV($("element"));
var path = window.promptSaveFile({title: "Save CSV", filterExtensions: ["*.csv"]});
if (path) {
    $.fs.writeFile(path, csv, "UTF8");
    console.log("Saved to: " + path);
}
```

### HTML Report with Images

```javascript
var view = $("view").first();
var base64 = $.model.renderViewAsBase64(view, "PNG", {scale: 1});

var html = '<!DOCTYPE html>\n<html>\n<body>\n';
html += '<h1>' + view.name + '</h1>\n';
html += '<img src="data:image/png;base64,' + base64 + '" />\n';
html += '</body>\n</html>';

$.fs.writeFile("view-report.html", html, "UTF8");
```

### JSON Export

```javascript
function modelToJSON() {
    var result = {
        name: model.name,
        id: model.id,
        purpose: model.purpose,
        elements: [],
        relationships: [],
        views: []
    };

    $("element").each(function(e) {
        result.elements.push({
            id: e.id,
            name: e.name,
            type: e.type,
            documentation: e.documentation
        });
    });

    $("relationship").each(function(r) {
        result.relationships.push({
            id: r.id,
            name: r.name,
            type: r.type,
            source: r.source.id,
            target: r.target.id
        });
    });

    $("view").each(function(v) {
        result.views.push({
            id: v.id,
            name: v.name,
            type: v.type
        });
    });

    return result;
}

var json = JSON.stringify(modelToJSON(), null, 2);
$.fs.writeFile("model-export.json", json, "UTF8");
```

### Batch Processing with Confirmation

```javascript
var elementsToProcess = $("element").filter(function(e) {
    return !e.documentation;
});

var count = elementsToProcess.size();

if (count === 0) {
    window.alert("All elements have documentation!");
    exit();
}

var proceed = window.confirm(
    "Found " + count + " elements without documentation.\n\n" +
    "Add default documentation?"
);

if (!proceed) {
    exit();
}

elementsToProcess.each(function(e) {
    e.documentation = "TODO: Add documentation for this " + e.type;
});

console.log("Updated " + count + " elements");
window.alert("Done! Updated " + count + " elements.");
```
