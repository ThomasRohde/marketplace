# JArchi API: Elements and Relationships

Detailed reference for creating and manipulating ArchiMate elements and relationships.

## Creating Elements

### model.createElement()

Create and add a new element to its default folder:

```javascript
model.createElement(type, name)
model.createElement(type, name, folder)
```

**Parameters:**
- `type` - Element type in kebab-case (see type tables below)
- `name` - Display name for the element
- `folder` - Optional target folder

**Examples:**
```javascript
var actor = model.createElement("business-actor", "Customer");
var process = model.createElement("business-process", "Order Processing");
var component = model.createElement("application-component", "Payment Service");

// Create in specific folder
var folder = $("folder.Business").first();
var role = model.createElement("business-role", "Account Manager", folder);
```

## Element Types by Layer

### Strategy Layer

| Type | Description |
|------|-------------|
| `resource` | Asset owned or controlled by an individual or organization |
| `capability` | Ability that an organization possesses |
| `course-of-action` | Approach or plan for achieving a goal |
| `value-stream` | Sequence of activities creating overall result for customer |

### Business Layer

| Type | Description |
|------|-------------|
| `business-actor` | Organizational entity capable of performing behavior |
| `business-role` | Responsibility for specific behavior |
| `business-collaboration` | Aggregate of two or more roles |
| `business-interface` | Point of access for business services |
| `business-process` | Sequence of behaviors achieving specific result |
| `business-function` | Collection of behavior based on criteria |
| `business-interaction` | Behavior produced by collaboration |
| `business-event` | Something that happens and may influence behavior |
| `business-service` | Explicitly defined behavior offered to environment |
| `business-object` | Concept used within business domain |
| `contract` | Formal or informal specification of agreement |
| `representation` | Perceptible form of information carried by business object |
| `product` | Coherent collection of services and/or objects |

### Application Layer

| Type | Description |
|------|-------------|
| `application-component` | Encapsulation of application functionality |
| `application-collaboration` | Aggregate of application components |
| `application-interface` | Point of access for application services |
| `application-function` | Automated behavior performed by component |
| `application-process` | Sequence of application behaviors |
| `application-interaction` | Behavior produced by application collaboration |
| `application-event` | Application state change |
| `application-service` | Explicitly defined exposed application behavior |
| `data-object` | Data structured for automated processing |

### Technology Layer

| Type | Description |
|------|-------------|
| `node` | Computational or physical resource |
| `device` | Physical IT resource with processing capability |
| `system-software` | Software providing platform for other software |
| `technology-collaboration` | Aggregate of nodes |
| `technology-interface` | Point of access for technology services |
| `path` | Link between nodes for information transfer |
| `communication-network` | Set of structures connecting nodes |
| `technology-function` | Collection of technology behavior |
| `technology-process` | Sequence of technology behaviors |
| `technology-interaction` | Behavior produced by technology collaboration |
| `technology-event` | Technology state change |
| `technology-service` | Explicitly defined technology behavior |
| `artifact` | Piece of data used or produced |

### Physical Layer

| Type | Description |
|------|-------------|
| `equipment` | Physical machines, tools, instruments |
| `facility` | Physical structure or environment |
| `distribution-network` | Physical network for material distribution |
| `material` | Tangible physical matter |

### Motivation Layer

| Type | Description |
|------|-------------|
| `stakeholder` | Role of individual, team, or organization with interests |
| `driver` | External or internal condition motivating organization |
| `assessment` | Result of analysis of some driver |
| `goal` | High-level statement of intent or direction |
| `outcome` | End result that has been achieved |
| `principle` | Qualitative statement of intent |
| `requirement` | Statement of need |
| `constraint` | Factor limiting realization of goals |
| `meaning` | Knowledge or expertise in specific area |
| `value` | Relative worth, utility, or importance |

### Implementation & Migration Layer

| Type | Description |
|------|-------------|
| `work-package` | Series of actions to achieve result |
| `deliverable` | Precisely-defined outcome of work package |
| `implementation-event` | State change related to implementation |
| `plateau` | Relatively stable state of architecture at point in time |
| `gap` | Statement of difference between two plateaus |

### Other Elements

| Type | Description |
|------|-------------|
| `location` | Place or position |
| `grouping` | Aggregation of arbitrary concepts |
| `junction` | Connect relationships (and/or) |

## Element Properties

### Common Properties

All elements share these properties:

```javascript
element.id              // Read-only unique identifier
element.name            // Element name (read/write)
element.documentation   // Documentation text (read/write)
element.type            // Element type (read/write - changes element type!)

// Model reference
element.model           // Returns containing model
```

### Custom Properties

Elements can have custom key-value properties:

```javascript
// Get property keys
var keys = element.prop();

// Get property value
var value = element.prop("Status");

// Set property (add or update)
element.prop("Status", "Active");

// Allow duplicate keys
element.prop("Tag", "Finance", true);  // Adds even if "Tag" exists

// Get all values for duplicate key
var allTags = element.prop("Tag", true);  // Returns array

// Remove property
element.removeProp("Status");
element.removeProp("Tag", "Finance");  // Remove specific value only
```

### Junction Type

Junctions have a type property:

```javascript
junction.junctionType = "and";  // "and" or "or"
// or
junction.attr("junction-type", "or");
```

### Specializations

Apply specializations (custom icons/styling):

```javascript
// Create specialization with image
var image = model.createImage("path/to/icon.png");
var spec = model.createSpecialization("Cloud Service", "application-component", image);

// Apply to element
element.specialization = "Cloud Service";

// Get specialization name
var specName = element.specialization;
```

## Element Operations

### Duplicate

Copy an element:

```javascript
// Duplicate to same folder
var copy = element.duplicate();

// Duplicate to target folder
var folder = $("folder.Business").first().createFolder("Copies");
var copy = element.duplicate(folder);
```

### Merge

Merge one element into another:

```javascript
element.merge(otherElement);
```

Effects:
- Diagram instances of other element replaced with this element
- Elements must be same type
- Documentation appended
- Properties appended
- Relationships transferred
- Other element NOT deleted (delete manually if needed)

### Delete

Remove element from model:

```javascript
element.delete();
```

**Note:** Deleting an element also removes its relationships and view references.

## Creating Relationships

### model.createRelationship()

```javascript
model.createRelationship(type, name, source, target)
model.createRelationship(type, name, source, target, folder)
```

**Parameters:**
- `type` - Relationship type in kebab-case
- `name` - Relationship name (often empty string "")
- `source` - Source element
- `target` - Target element
- `folder` - Optional target folder

**Examples:**
```javascript
var actor = model.createElement("business-actor", "Customer");
var role = model.createElement("business-role", "Account Holder");

// Create assignment relationship
var rel = model.createRelationship("assignment-relationship", "", actor, role);

// Create named flow relationship
var flow = model.createRelationship("flow-relationship", "Order Data", component1, component2);
```

### Checking Valid Relationships

```javascript
var isAllowed = $.model.isAllowedRelationship(
    "assignment-relationship",
    "business-actor",
    "business-role"
);
```

## Relationship Types

| Type | Notation | Description |
|------|----------|-------------|
| `composition-relationship` | Filled diamond | Whole-part, lifecycle dependency |
| `aggregation-relationship` | Empty diamond | Whole-part, no lifecycle dependency |
| `assignment-relationship` | Filled circle + line | Allocation of responsibility |
| `realization-relationship` | Dashed line + empty arrow | Implementation |
| `serving-relationship` | Open arrow | Providing functionality |
| `access-relationship` | Dashed line + arrow | Accessing data |
| `influence-relationship` | Dashed line + arrow | Affecting motivation |
| `triggering-relationship` | Filled arrow | Temporal/causal |
| `flow-relationship` | Dashed line + filled arrow | Transfer of objects |
| `specialization-relationship` | Empty arrow | More specific form |
| `association-relationship` | Simple line | Unspecified relationship |

## Relationship Properties

### Common Properties

```javascript
relationship.id              // Read-only unique identifier
relationship.name            // Relationship name
relationship.documentation   // Documentation text
relationship.type            // Relationship type
relationship.source          // Source element (read/write)
relationship.target          // Target element (read/write)
```

### Access Type

For access relationships:

```javascript
rel.accessType = "read";      // "access", "read", "write", "readwrite"
// or
rel.attr("access-type", "write");
```

### Association Directed

For association relationships:

```javascript
rel.associationDirected = true;   // true or false
// or
rel.attr("association-directed", true);
```

### Influence Strength

For influence relationships:

```javascript
rel.influenceStrength = "++";     // Any string: "+", "++", "---", etc.
// or
rel.attr("influence-strength", "++");
```

### Merge Relationships

```javascript
relationship.merge(otherRelationship);
```

Same rules as element merge - types must match, documentation/properties appended.

## Navigating Relationships

### From Elements

```javascript
// All relationships
var rels = $(element).rels();

// Incoming relationships (element is target)
var incoming = $(element).inRels();

// Outgoing relationships (element is source)
var outgoing = $(element).outRels();

// Filter by type
var servingRels = $(element).rels("serving-relationship");
```

### From Relationships

```javascript
// Both ends
var ends = $(relationship).ends();

// Source element
var source = $(relationship).sourceEnds();

// Target element
var target = $(relationship).targetEnds();
```

### Traversal Example

Find all application components serving a business process:

```javascript
var process = $("business-process.Order Processing").first();

$(process).inRels("serving-relationship").each(function(rel) {
    if (rel.source.type === "application-service") {
        console.log("Served by: " + rel.source.name);

        // Find realizing components
        $(rel.source).inRels("realization-relationship").each(function(realRel) {
            if (realRel.source.type === "application-component") {
                console.log("  Component: " + realRel.source.name);
            }
        });
    }
});
```
