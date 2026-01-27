# JArchi API: Collections and Selectors

Detailed reference for querying and manipulating collections of model objects.

## The jArchi() Function

The core function for creating collections. `$()` is an alias:

```javascript
$(selector)      // Create collection from selector
$(object)        // Wrap single object in collection
$(collection)    // Returns same collection
jArchi(selector) // Same as $()
```

## Selector Types

### Type Selector

Select all objects of a specific ArchiMate type:

```javascript
$("business-actor")           // All business actors
$("application-component")    // All application components
$("serving-relationship")     // All serving relationships
$("archimate-diagram-model")  // All ArchiMate views
```

### Name Selector

Select objects by name (case-sensitive):

```javascript
$(".Customer")                // All objects named "Customer"
$(".Order Processing")        // All objects named "Order Processing"
$("business-actor.John")      // Business actors named "John"
$("folder.Business")          // Folders named "Business"
```

### ID Selector

Select single object by unique ID:

```javascript
$("#abc-123-def")             // Object with this ID
$("#id-1b40f79345454fe9")     // Object with this ID
```

### Category Selectors

Select broad categories:

```javascript
$("element")        // All ArchiMate elements (not relationships)
$("relationship")   // All relationships
$("concept")        // All elements AND relationships
$("view")           // All views (ArchiMate, Canvas, Sketch)
$("folder")         // All folders
$("*")              // Everything in the model
```

### View Type Selectors

```javascript
$("archimate-diagram-model")  // ArchiMate views only
$("sketch-model")             // Sketch views only
$("canvas-model")             // Canvas views only
```

### Visual Object Selectors

```javascript
$("diagram-model-note")       // Notes in views
$("diagram-model-group")      // Groups in views
$("diagram-model-connection") // Non-ArchiMate connections
$("diagram-model-reference")  // View references
$("diagram-model-image")      // Images in views
```

## Collection Methods

### Traversal Methods

Navigate the model structure (folders and containment):

#### .children()

Get direct children:

```javascript
collection.children()           // All direct children
collection.children(selector)   // Children matching selector
$(folder).children()            // Contents of folder
$(view).children()              // Top-level objects in view
```

#### .parent()

Get parent container:

```javascript
collection.parent()             // Parent of each object
collection.parent(selector)     // Parents matching selector
$(element).parent()             // Folder containing element
$(diagramObject).parent()       // View or parent group
```

#### .parents()

Get all ancestors:

```javascript
collection.parents()            // All ancestors
collection.parents(selector)    // Ancestors matching selector
$(element).parents("folder")    // All ancestor folders
```

#### .find()

Get all descendants:

```javascript
collection.find()               // All descendants
collection.find(selector)       // Descendants matching selector
$(folder).find("business-actor") // All business actors in folder tree
$(view).find()                  // All objects in view (including nested)
```

### Navigation Methods

Navigate through relationships:

#### .rels()

Get all connected relationships:

```javascript
collection.rels()               // All relationships
collection.rels(selector)       // Relationships matching selector
$(element).rels()               // All relationships of element
$(element).rels("flow-relationship") // Only flow relationships
```

#### .inRels()

Get incoming relationships (object is target):

```javascript
collection.inRels()             // Incoming relationships
collection.inRels(selector)     // Filtered by selector
$(service).inRels("realization-relationship") // Who realizes this?
```

#### .outRels()

Get outgoing relationships (object is source):

```javascript
collection.outRels()            // Outgoing relationships
collection.outRels(selector)    // Filtered by selector
$(actor).outRels("assignment-relationship") // What roles assigned?
```

#### .ends()

Get concepts at both ends of relationships:

```javascript
$(relationship).ends()          // Source and target
$(relationships).ends()         // All connected concepts
```

#### .sourceEnds()

Get source concepts:

```javascript
$(relationship).sourceEnds()    // Source concept
$(relationships).sourceEnds()   // All sources
```

#### .targetEnds()

Get target concepts:

```javascript
$(relationship).targetEnds()    // Target concept
$(relationships).targetEnds()   // All targets
```

### View Reference Methods

#### .viewRefs()

Get views containing object:

```javascript
$(element).viewRefs()           // Views where element appears
$(element).viewRefs("archimate-diagram-model") // Only ArchiMate views
```

#### .objectRefs()

Get visual objects referencing a concept:

```javascript
$(element).objectRefs()         // All diagram objects for element
$(element).objectRefs().attr("fillColor", "#ff0000") // Color all red
```

### Filtering Methods

#### .filter()

Keep matching objects:

```javascript
collection.filter(selector)     // Keep by selector
collection.filter(function(obj) { return condition; }) // Keep by function

// Examples
$("element").filter("business-actor")  // Only business actors
$("element").filter(function(e) {
    return e.documentation !== "";     // Only with documentation
})
```

#### .not()

Exclude matching objects:

```javascript
collection.not(selector)        // Exclude by selector
collection.not(otherCollection) // Exclude objects in other collection

// Examples
$("element").not("junction")    // All elements except junctions
$("concept").not($(selection))  // All concepts not in selection
```

#### .has()

Keep objects with matching descendants:

```javascript
collection.has(selector)        // Keep if has descendant

// Example: Views containing business actors
$("view").has("business-actor")
```

#### .add()

Add objects to collection:

```javascript
collection.add(selector)        // Add by selector
collection.add(otherCollection) // Add from other collection

var combined = $("business-actor").add("business-role");
```

### Attribute Methods

#### .attr()

Get or set attributes:

```javascript
// Get (returns first object's value)
collection.attr("name")
collection.attr("documentation")

// Set (applies to all objects)
collection.attr("name", "New Name")
collection.attr("documentation", "Description text")
```

**Common attributes:**
- `name` - Object name
- `documentation` - Documentation text
- `id` - Unique ID (read-only)
- `type` - Object type (read-only for most, writable for concepts)

**Visual attributes (diagram objects only):**
- `fillColor` - Background color (#rrggbb)
- `lineColor` - Border/line color
- `fontColor` - Text color
- `fontSize` - Font size in points
- `fontStyle` - normal, bold, italic, bolditalic
- `opacity` - Transparency (0-255)
- `bounds` - Position and size object

#### .prop()

Get or set custom properties:

```javascript
// Get property keys
collection.prop()               // Array of all property keys

// Get value
collection.prop("Status")       // First value for "Status"
collection.prop("Status", true) // All values (if duplicates)

// Set value
collection.prop("Status", "Active")
collection.prop("Tag", "Finance", true) // Allow duplicate

// Remove
collection.removeProp("Status")
collection.removeProp("Tag", "Finance") // Remove specific value
```

### Utility Methods

#### .each()

Iterate over collection:

```javascript
$("business-actor").each(function(actor) {
    console.log(actor.name);
});

// With index
$("element").each(function(element, index) {
    console.log(index + ": " + element.name);
});
```

#### .first()

Get first object:

```javascript
var actor = $("business-actor").first();
var view = $("view.Overview").first();
```

#### .get()

Get object by index:

```javascript
var second = $("business-actor").get(1);  // 0-based index
```

#### .size()

Count objects:

```javascript
var count = $("business-actor").size();
console.log("Found " + count + " business actors");
```

#### .is()

Check if any match:

```javascript
if ($(selection).is("business-actor")) {
    console.log("Selection contains a business actor");
}
```

#### .clone()

Copy the collection (not the objects):

```javascript
var copy = collection.clone();
```

## Working with Selection

The global `selection` variable contains currently selected objects:

```javascript
// Process selected elements
$(selection).each(function(obj) {
    console.log("Selected: " + obj.name);
});

// Filter selection
var actors = $(selection).filter("business-actor");

// Check selection
if ($(selection).is("element")) {
    // At least one element selected
}

// Apply changes to selection
$(selection).attr("documentation", "Updated via script");
```

## Common Patterns

### Find and Process

```javascript
// Find all business services without documentation
$("business-service").each(function(service) {
    if (!service.documentation) {
        console.log("Missing docs: " + service.name);
    }
});
```

### Relationship Traversal

```javascript
// Find all components that serve a specific process
var process = $("business-process.Order Management").first();

$(process).inRels("serving-relationship").each(function(rel) {
    var source = rel.source;
    if (source.type === "application-service") {
        console.log("Service: " + source.name);

        // Find realizing component
        $(source).inRels("realization-relationship").each(function(realRel) {
            console.log("  -> Component: " + realRel.source.name);
        });
    }
});
```

### Batch Updates

```javascript
// Add property to all selected elements
$(selection).filter("element").each(function(element) {
    element.prop("Review Date", "2024-01-15");
});

// Update all diagram appearances
$(element).objectRefs().each(function(obj) {
    obj.fillColor = "#dae8fc";
});
```

### Finding Orphans

```javascript
// Elements not used in any view
$("element").each(function(element) {
    if ($(element).viewRefs().size() === 0) {
        console.log("Orphan: " + element.type + " - " + element.name);
    }
});

// Elements without relationships
$("element").each(function(element) {
    if ($(element).rels().size() === 0) {
        console.log("Isolated: " + element.name);
    }
});
```

### Collecting Results

```javascript
// Build list of names
var names = [];
$("business-actor").each(function(actor) {
    names.push(actor.name);
});
console.log(names.join(", "));

// Build CSV
var csv = "Type,Name,Documentation\n";
$("element").each(function(e) {
    csv += e.type + "," + e.name + "," + (e.documentation || "") + "\n";
});
$.fs.writeFile("elements.csv", csv, "UTF8");
```
