# JArchi API: Views and Visual Objects

Detailed reference for creating and manipulating views and diagram objects.

## Creating Views

### ArchiMate Views

```javascript
// Create in default Views folder
var view = model.createArchimateView("View Name");

// Create in specific folder
var folder = $("folder.Views").first().createFolder("My Views");
var view = model.createArchimateView("View Name", folder);
```

### Canvas Views

```javascript
var canvas = model.createCanvasView("Canvas Name");
var canvas = model.createCanvasView("Canvas Name", folder);
```

### Sketch Views

```javascript
var sketch = model.createSketchView("Sketch Name");
var sketch = model.createSketchView("Sketch Name", folder);
```

## View Properties

### Common Properties

```javascript
view.id             // Unique ID (read-only)
view.name           // View name
view.documentation  // Documentation text
view.type           // View type (read-only)
```

### Viewpoint (ArchiMate Views Only)

```javascript
// Set viewpoint
view.viewpoint = "application_cooperation";

// Get viewpoint
var vp = view.viewpoint;
console.log(vp.id);    // e.g., "application_cooperation"
console.log(vp.name);  // e.g., "Application Cooperation"

// Clear viewpoint (show all)
view.viewpoint = "";
```

**Available Viewpoints:**
- `application_cooperation`
- `application_usage`
- `business_process_cooperation`
- `capability`
- `goal_realization`
- `implementation_deployment`
- `implementation_migration`
- `information_structure`
- `layered`
- `migration`
- `motivation`
- `organization`
- `outcome_realization`
- `physical`
- `product`
- `project`
- `requirements_realization`
- `resource`
- `service_realization`
- `stakeholder`
- `strategy`
- `technology`
- `technology_usage`

### Connection Router

```javascript
view.connectionRouter = CONNECTION_ROUTER.MANHATTAN;  // Right-angle routing
view.connectionRouter = CONNECTION_ROUTER.BENDPOINT;  // Manual bendpoints
```

### Check Viewpoint Compliance

```javascript
var allowed = view.isAllowedConceptForViewpoint("business-actor");
```

## Adding Elements to Views

### Add ArchiMate Element

```javascript
view.add(element, x, y, width, height)
view.add(element, x, y, width, height, autoNest)
```

**Parameters:**
- `element` - Existing ArchiMate element
- `x, y` - Position (top-left corner)
- `width, height` - Size (-1 for default size)
- `autoNest` - If true, nest inside containing object at position

**Examples:**
```javascript
var actor = model.createElement("business-actor", "Customer");
var role = model.createElement("business-role", "Account Holder");

// Add with explicit size
var obj1 = view.add(actor, 100, 100, 120, 60);

// Add with default size
var obj2 = view.add(role, 300, 100, -1, -1);

// Add with auto-nesting
var obj3 = view.add(component, 150, 150, 100, 50, true);
```

### Add Relationship

```javascript
view.add(relationship, sourceObject, targetObject)
```

**Example:**
```javascript
var rel = model.createRelationship("assignment-relationship", "", actor, role);
var connection = view.add(rel, obj1, obj2);
```

### Create Note

```javascript
var note = view.createObject("diagram-model-note", x, y, width, height);
var note = view.createObject("note", x, y, -1, -1);  // Short form

note.text = "This is a note\nWith multiple lines";
```

### Create Group

```javascript
var group = view.createObject("diagram-model-group", x, y, width, height);
var group = view.createObject("group", x, y, 200, 150);

group.name = "Backend Services";
```

### Create View Reference

```javascript
var otherView = $("view.Detail View").first();
var viewRef = view.createViewReference(otherView, x, y, width, height);
```

### Create Non-ArchiMate Connection

```javascript
var connection = view.createConnection(sourceObject, targetObject);
connection.name = "Annotation Link";
```

**Note:** Cannot connect two ArchiMate diagram objects with non-ArchiMate connections.

## Visual Object Properties

### Position and Size

```javascript
// Get bounds
var x = obj.bounds.x;
var y = obj.bounds.y;
var width = obj.bounds.width;
var height = obj.bounds.height;

// Set bounds
obj.bounds = {x: 100, y: 100, width: 120, height: 60};
obj.bounds = {x: 100, y: 100};  // Keep current size
obj.bounds = {width: 150, height: 80};  // Keep current position
```

### Colors

Colors use hex format (#rrggbb):

```javascript
// Fill color (background)
obj.fillColor = "#dae8fc";  // Light blue
obj.fillColor = null;       // Reset to default

// Line color (border)
obj.lineColor = "#6c8ebf";  // Darker blue
obj.lineColor = null;       // Reset to default

// Font color
obj.fontColor = "#333333";  // Dark gray
obj.fontColor = null;       // Reset to default

// Icon color (ArchiMate icon in corner)
obj.iconColor = "#666666";
obj.iconColor = "";         // Reset to default
```

**Common Color Schemes:**
```javascript
// Blue
fillColor: "#dae8fc", lineColor: "#6c8ebf"

// Green
fillColor: "#d5e8d4", lineColor: "#82b366"

// Orange
fillColor: "#ffe6cc", lineColor: "#d79b00"

// Red
fillColor: "#f8cecc", lineColor: "#b85450"

// Purple
fillColor: "#e1d5e7", lineColor: "#9673a6"

// Gray
fillColor: "#f5f5f5", lineColor: "#666666"
```

### Fonts

```javascript
obj.fontName = "Arial";
obj.fontSize = 12;
obj.fontStyle = "bold";  // "normal", "bold", "italic", "bolditalic"
```

### Opacity

```javascript
obj.opacity = 255;        // Fully opaque (default)
obj.opacity = 128;        // 50% transparent
obj.opacity = 0;          // Fully transparent

obj.outlineOpacity = 200; // Border opacity
```

### Line Style

```javascript
obj.lineWidth = 1;        // Normal
obj.lineWidth = 2;        // Medium
obj.lineWidth = 3;        // Heavy

obj.lineStyle = LINE_STYLE.SOLID;   // Default
obj.lineStyle = LINE_STYLE.DASHED;
obj.lineStyle = LINE_STYLE.DOTTED;
obj.lineStyle = LINE_STYLE.NONE;
```

### Gradient

```javascript
obj.gradient = GRADIENT.NONE;    // No gradient
obj.gradient = GRADIENT.TOP;     // Lighter at top
obj.gradient = GRADIENT.BOTTOM;  // Lighter at bottom
obj.gradient = GRADIENT.LEFT;
obj.gradient = GRADIENT.RIGHT;
```

### Text Alignment

```javascript
obj.textAlignment = TEXT_ALIGNMENT.CENTER;  // Default
obj.textAlignment = TEXT_ALIGNMENT.LEFT;
obj.textAlignment = TEXT_ALIGNMENT.RIGHT;

obj.textPosition = TEXT_POSITION.CENTER;  // Default
obj.textPosition = TEXT_POSITION.TOP;
obj.textPosition = TEXT_POSITION.BOTTOM;
```

### Figure Type

Some elements have alternate visual representations:

```javascript
obj.figureType = 0;  // Default appearance
obj.figureType = 1;  // Alternate appearance
```

### Border Type

For notes and groups:

```javascript
// Notes
note.borderType = BORDER.DOGEAR;     // Folded corner (default)
note.borderType = BORDER.RECTANGLE;
note.borderType = BORDER.NONE;

// Groups
group.borderType = BORDER.TABBED;    // Tab at top (default)
group.borderType = BORDER.RECTANGLE;
```

### Show Icon

```javascript
obj.showIcon = SHOW_ICON.IF_NO_IMAGE;  // Default
obj.showIcon = SHOW_ICON.ALWAYS;
obj.showIcon = SHOW_ICON.NEVER;
```

### Derive Line Color

```javascript
obj.deriveLineColor = true;   // Line color from fill color
obj.deriveLineColor = false;  // Use explicit line color
```

### Label Expression

Custom label formatting:

```javascript
obj.labelExpression = "${name}";                    // Just name
obj.labelExpression = "${name}\n${type}";           // Name and type
obj.labelExpression = "${name}\n${property:Status}"; // Name and property
obj.labelExpression = "";                           // Reset to default

// Read computed label value
var displayedText = obj.labelValue;
```

### Images

```javascript
// Load and set custom image
obj.imageSource = IMAGE_SOURCE.CUSTOM;
obj.image = model.createImage("path/to/image.png");

// Use specialization image
obj.imageSource = IMAGE_SOURCE.SPECIALIZATION;

// Image position
obj.imagePosition = IMAGE_POSITION.TOP_LEFT;
obj.imagePosition = IMAGE_POSITION.TOP_CENTRE;
obj.imagePosition = IMAGE_POSITION.TOP_RIGHT;
obj.imagePosition = IMAGE_POSITION.MIDDLE_LEFT;
obj.imagePosition = IMAGE_POSITION.MIDDLE_CENTRE;
obj.imagePosition = IMAGE_POSITION.MIDDLE_RIGHT;
obj.imagePosition = IMAGE_POSITION.BOTTOM_LEFT;
obj.imagePosition = IMAGE_POSITION.BOTTOM_CENTRE;
obj.imagePosition = IMAGE_POSITION.BOTTOM_RIGHT;
obj.imagePosition = IMAGE_POSITION.FILL;
```

## Z-Order (Layering)

```javascript
obj.bringToFront();   // Move to top
obj.bringForward();   // Move up one level
obj.sendBackward();   // Move down one level
obj.sendToBack();     // Move to bottom

// Direct index control (0 = back)
obj.index = 0;        // Send to back
obj.index = -1;       // Bring to front
obj.index++;          // Bring forward
obj.index--;          // Send backward
```

## Nesting Objects

### Add Element to Container

```javascript
// Add to view first
var group = view.createObject("group", 50, 50, 300, 200);
group.name = "Service Layer";

// Then add element inside group
var component = model.createElement("application-component", "API");
var obj = group.add(component, 20, 40, 100, 50);  // Relative to group
```

### Move Object to Container

```javascript
// Move existing object into container
var obj = $(view).find(".API").first();
var group = $(view).find("diagram-model-group.Service Layer").first();
group.add(obj, 20, 40);  // New position relative to group

// Move object to view (out of container)
view.add(obj, 100, 100);
```

### Create Nested Objects

```javascript
// Nested notes in group
var group = view.createObject("group", 100, 100, 250, 180);
var note1 = group.createObject("note", 10, 30, 100, 50);
var note2 = group.createObject("note", 130, 30, 100, 50);
```

## Connection Properties

### Accessing Connection

```javascript
// Get underlying concept
var relationship = connection.concept;

// Get source and target objects
var sourceObj = connection.source;
var targetObj = connection.target;

// Get containing view
var view = connection.view;
```

### Connection Text Position

```javascript
connection.textPosition = CONNECTION_TEXT_POSITION.MIDDLE;  // Default
connection.textPosition = CONNECTION_TEXT_POSITION.SOURCE;
connection.textPosition = CONNECTION_TEXT_POSITION.TARGET;
```

### Bendpoints

```javascript
// Get relative bendpoints (read-only)
var bendpoints = connection.relativeBendpoints;
```

## View Operations

### Duplicate View

```javascript
// Duplicate to same folder
var copy = view.duplicate();

// Duplicate to specific folder
var folder = $("folder.Views").first().createFolder("Copies");
var copy = view.duplicate(folder);
```

### Open View in UI

```javascript
view.openInUI();  // Opens view in Archi editor
```

### Delete Visual Object

```javascript
// Delete visual object only (keep concept)
diagramObject.delete();

// Delete visual object and underlying concept
diagramObject.concept.delete();

// Delete but keep children (reparent to parent)
diagramObject.delete(false);
```

## Rendering Views

### Export to Image File

```javascript
// PNG
$.model.renderViewToFile(view, "output.png", "PNG");
$.model.renderViewToFile(view, "output.png", "PNG", {scale: 2, margin: 20});

// Other formats
$.model.renderViewToFile(view, "output.jpg", "JPG");
$.model.renderViewToFile(view, "output.bmp", "BMP");
```

### Export to PDF

```javascript
$.model.renderViewToPDF(view, "output.pdf");

// With options
$.model.renderViewToPDF(view, "output.pdf", {
    textAsShapes: false,      // Render text as text
    embedFonts: true,         // Embed fonts
    textOffsetWorkaround: true // Fix font clipping
});
```

### Export to SVG

```javascript
$.model.renderViewToSVG(view, "output.svg", true);  // true = set viewBox

// With options
$.model.renderViewToSVG(view, "output.svg", {
    setViewBox: true,
    viewBoxBounds: "0 0 1000 800",
    textAsShapes: false,
    embedFonts: true
});

// As string
var svgString = $.model.renderViewAsSVGString(view, true);
```

### Export as Base64

```javascript
var base64 = $.model.renderViewAsBase64(view, "PNG");
var base64 = $.model.renderViewAsBase64(view, "PNG", {scale: 2, margin: 10});

// Embed in HTML
var html = '<img src="data:image/png;base64,' + base64 + '">';
```

## Layout Patterns

### Grid Layout

```javascript
var elements = $("business-actor");
var x = 50, y = 50;
var colWidth = 150, rowHeight = 80;
var cols = 4;

elements.each(function(element, index) {
    var col = index % cols;
    var row = Math.floor(index / cols);
    view.add(element, x + col * colWidth, y + row * rowHeight, 120, 60);
});
```

### Horizontal Layout

```javascript
var x = 50;
$("application-component").each(function(comp) {
    view.add(comp, x, 100, 120, 60);
    x += 150;
});
```

### Layer Layout

```javascript
// Business layer
var businessY = 50;
$("business-process").each(function(proc, i) {
    view.add(proc, 50 + i * 150, businessY, 120, 60);
});

// Application layer
var appY = 200;
$("application-service").each(function(svc, i) {
    view.add(svc, 50 + i * 150, appY, 120, 60);
});

// Technology layer
var techY = 350;
$("node").each(function(node, i) {
    view.add(node, 50 + i * 150, techY, 120, 60);
});
```
