---
name: DrawIO Diagram Creation
description: This skill should be used when the user asks to "create a diagram", "make a flowchart", "generate a .drawio file", "draw.io diagram", "diagrams.net", "architecture diagram", "sequence diagram", "ER diagram", "class diagram", "network diagram", "org chart", "workflow diagram", "UML diagram", "ArchiMate diagram", "C4 diagram", "C4 model", "enterprise architecture", or mentions "drawio", "mxGraph", or diagram visualization. Provides comprehensive knowledge for creating production-ready DrawIO XML files.
version: 1.0.0
---

# DrawIO Diagram Creation

Create production-ready `.drawio` files with proper XML structure, styling, and layout. DrawIO (diagrams.net) uses an XML-based format built on mxGraph library.

## Core Concepts

### File Format

DrawIO files are XML documents with `.drawio` extension (also `.drawio.xml` or `.drawio.svg`). The format uses mxGraph's XML serialization with compressed or uncompressed content.

### Basic Structure

Every DrawIO file follows this structure:

```xml
<mxfile host="app.diagrams.net" modified="2024-01-01T00:00:00.000Z" agent="Claude" version="21.0.0" type="device">
  <diagram id="diagram-id" name="Page-1">
    <mxGraphModel dx="1000" dy="600" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="850" pageHeight="1100" math="0" shadow="0">
      <root>
        <mxCell id="0" />
        <mxCell id="1" parent="0" />
        <!-- Shapes and connectors go here -->
      </root>
    </mxGraphModel>
  </diagram>
</mxfile>
```

**Key elements:**
- `mxfile` - Root container, can hold multiple diagrams (pages)
- `diagram` - Single page with unique id and name
- `mxGraphModel` - Canvas settings (size, grid, guides)
- `root` - Contains all cells (shapes and edges)
- `mxCell id="0"` - Required root cell
- `mxCell id="1"` - Required default parent for all shapes

### Cell Types

**Vertex (Shape):**
```xml
<mxCell id="2" value="Label" style="rounded=1;whiteSpace=wrap;html=1;" vertex="1" parent="1">
  <mxGeometry x="100" y="100" width="120" height="60" as="geometry" />
</mxCell>
```

**Edge (Connector):**
```xml
<mxCell id="3" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;" edge="1" parent="1" source="2" target="4">
  <mxGeometry relative="1" as="geometry" />
</mxCell>
```

## Creating Diagrams

### ID Management

Assign unique IDs to every cell. Use a simple incrementing pattern starting from "2" (0 and 1 are reserved):

```xml
<mxCell id="2" ... />  <!-- First shape -->
<mxCell id="3" ... />  <!-- First edge -->
<mxCell id="4" ... />  <!-- Second shape -->
```

### Positioning

Use x/y coordinates relative to the canvas origin (top-left). Typical spacing:
- Horizontal gap between shapes: 150-200 pixels
- Vertical gap between shapes: 80-100 pixels
- Shape width: 100-160 pixels
- Shape height: 40-80 pixels

### Common Styles

**Rectangle (default):**
```
rounded=0;whiteSpace=wrap;html=1;
```

**Rounded rectangle:**
```
rounded=1;whiteSpace=wrap;html=1;
```

**Ellipse/Circle:**
```
ellipse;whiteSpace=wrap;html=1;
```

**Diamond (decision):**
```
rhombus;whiteSpace=wrap;html=1;
```

**Cylinder (database):**
```
shape=cylinder3;whiteSpace=wrap;html=1;boundedLbl=1;backgroundOutline=1;size=15;
```

**Document:**
```
shape=document;whiteSpace=wrap;html=1;boundedLbl=1;
```

**Process (rectangle with side lines):**
```
shape=process;whiteSpace=wrap;html=1;backgroundOutline=1;
```

### Connector Styles

**Orthogonal (right angles):**
```
edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;
```

**Curved:**
```
edgeStyle=orthogonalEdgeStyle;curved=1;orthogonalLoop=1;jettySize=auto;html=1;
```

**Straight:**
```
edgeStyle=none;orthogonalLoop=1;jettySize=auto;html=1;
```

**With arrow:**
```
endArrow=classic;html=1;
```

**Dashed:**
```
dashed=1;
```

### Colors and Styling

Add to style string:
- Fill color: `fillColor=#dae8fc;`
- Stroke color: `strokeColor=#6c8ebf;`
- Font color: `fontColor=#333333;`
- Font size: `fontSize=12;`
- Bold: `fontStyle=1;`
- Stroke width: `strokeWidth=2;`

**Common color schemes:**
- Blue: `fillColor=#dae8fc;strokeColor=#6c8ebf;`
- Green: `fillColor=#d5e8d4;strokeColor=#82b366;`
- Orange: `fillColor=#ffe6cc;strokeColor=#d79b00;`
- Red: `fillColor=#f8cecc;strokeColor=#b85450;`
- Purple: `fillColor=#e1d5e7;strokeColor=#9673a6;`
- Gray: `fillColor=#f5f5f5;strokeColor=#666666;`

## Diagram Types

### Flowchart

Use rectangles for processes, diamonds for decisions, ellipses for start/end:

```xml
<!-- Start -->
<mxCell id="2" value="Start" style="ellipse;whiteSpace=wrap;html=1;fillColor=#d5e8d4;strokeColor=#82b366;" vertex="1" parent="1">
  <mxGeometry x="200" y="40" width="80" height="40" as="geometry" />
</mxCell>
<!-- Process -->
<mxCell id="3" value="Process Step" style="rounded=1;whiteSpace=wrap;html=1;" vertex="1" parent="1">
  <mxGeometry x="170" y="120" width="140" height="60" as="geometry" />
</mxCell>
<!-- Decision -->
<mxCell id="4" value="Condition?" style="rhombus;whiteSpace=wrap;html=1;fillColor=#fff2cc;strokeColor=#d6b656;" vertex="1" parent="1">
  <mxGeometry x="180" y="220" width="120" height="80" as="geometry" />
</mxCell>
```

### Architecture Diagram

Use grouped containers, service shapes, and labeled connectors:

```xml
<!-- Container/Group -->
<mxCell id="2" value="Backend Services" style="swimlane;whiteSpace=wrap;html=1;fillColor=#f5f5f5;strokeColor=#666666;" vertex="1" parent="1">
  <mxGeometry x="40" y="40" width="300" height="200" as="geometry" />
</mxCell>
<!-- Service inside container -->
<mxCell id="3" value="API Gateway" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#dae8fc;strokeColor=#6c8ebf;" vertex="1" parent="2">
  <mxGeometry x="20" y="40" width="120" height="60" as="geometry" />
</mxCell>
```

### Sequence Diagram

Use vertical lifelines with horizontal message arrows:

```xml
<!-- Actor/Lifeline header -->
<mxCell id="2" value="Client" style="shape=umlLifeline;perimeter=lifelinePerimeter;whiteSpace=wrap;html=1;container=1;collapsible=0;recursiveResize=0;outlineConnect=0;portConstraint=eastwest;newEdgeStyle={&quot;edgeStyle&quot;:&quot;elbowEdgeStyle&quot;,&quot;elbow&quot;:&quot;vertical&quot;,&quot;curved&quot;:0,&quot;rounded&quot;:0};" vertex="1" parent="1">
  <mxGeometry x="100" y="40" width="100" height="300" as="geometry" />
</mxCell>
<!-- Message -->
<mxCell id="4" value="request()" style="html=1;verticalAlign=bottom;endArrow=block;edgeStyle=elbowEdgeStyle;elbow=vertical;curved=0;rounded=0;" edge="1" parent="1">
  <mxGeometry relative="1" as="geometry">
    <mxPoint x="150" y="100" as="sourcePoint" />
    <mxPoint x="350" y="100" as="targetPoint" />
  </mxGeometry>
</mxCell>
```

### ER Diagram

Use table shapes with columns:

```xml
<mxCell id="2" value="users" style="swimlane;fontStyle=1;align=center;verticalAlign=top;childLayout=stackLayout;horizontal=1;startSize=26;horizontalStack=0;resizeParent=1;resizeParentMax=0;resizeLast=0;collapsible=1;marginBottom=0;whiteSpace=wrap;html=1;" vertex="1" parent="1">
  <mxGeometry x="100" y="100" width="160" height="130" as="geometry" />
</mxCell>
<mxCell id="3" value="id: INT (PK)" style="text;strokeColor=none;fillColor=none;align=left;verticalAlign=top;spacingLeft=4;spacingRight=4;overflow=hidden;rotatable=0;points=[[0,0.5],[1,0.5]];portConstraint=eastwest;whiteSpace=wrap;html=1;fontStyle=1;" vertex="1" parent="2">
  <mxGeometry y="26" width="160" height="26" as="geometry" />
</mxCell>
<mxCell id="4" value="email: VARCHAR(255)" style="text;strokeColor=none;fillColor=none;align=left;verticalAlign=top;spacingLeft=4;spacingRight=4;overflow=hidden;rotatable=0;points=[[0,0.5],[1,0.5]];portConstraint=eastwest;whiteSpace=wrap;html=1;" vertex="1" parent="2">
  <mxGeometry y="52" width="160" height="26" as="geometry" />
</mxCell>
```

### Class Diagram

Use UML class shapes:

```xml
<mxCell id="2" value="&lt;b&gt;ClassName&lt;/b&gt;" style="swimlane;fontStyle=0;align=center;verticalAlign=top;childLayout=stackLayout;horizontal=1;startSize=26;horizontalStack=0;resizeParent=1;resizeParentMax=0;resizeLast=0;collapsible=0;marginBottom=0;html=1;" vertex="1" parent="1">
  <mxGeometry x="100" y="100" width="160" height="130" as="geometry" />
</mxCell>
<mxCell id="3" value="- privateField: Type" style="text;strokeColor=none;fillColor=none;align=left;verticalAlign=top;spacingLeft=4;spacingRight=4;overflow=hidden;rotatable=0;points=[[0,0.5],[1,0.5]];portConstraint=eastwest;" vertex="1" parent="2">
  <mxGeometry y="26" width="160" height="26" as="geometry" />
</mxCell>
<mxCell id="4" value="" style="line;strokeWidth=1;fillColor=none;align=left;verticalAlign=middle;spacingTop=-1;spacingLeft=3;spacingRight=3;rotatable=0;labelPosition=right;points=[];portConstraint=eastwest;strokeColor=inherit;" vertex="1" parent="2">
  <mxGeometry y="52" width="160" height="8" as="geometry" />
</mxCell>
<mxCell id="5" value="+ publicMethod(): void" style="text;strokeColor=none;fillColor=none;align=left;verticalAlign=top;spacingLeft=4;spacingRight=4;overflow=hidden;rotatable=0;points=[[0,0.5],[1,0.5]];portConstraint=eastwest;" vertex="1" parent="2">
  <mxGeometry y="60" width="160" height="26" as="geometry" />
</mxCell>
```

## Additional Resources

### Reference Files

For detailed information, consult:
- **`references/xml-structure.md`** - Complete XML structure and attributes
- **`references/shape-library.md`** - Comprehensive shape styles and icons
- **`references/styling-guide.md`** - Advanced styling, themes, and formatting

### Example Files

Working examples in `examples/`:
- **`flowchart.drawio`** - Basic flowchart with decision logic
- **`architecture.drawio`** - Microservices architecture diagram
- **`sequence-diagram.drawio`** - UML sequence diagram
- **`er-diagram.drawio`** - Entity-relationship database diagram
- **`class-diagram.drawio`** - UML class diagram
- **`network-diagram.drawio`** - Network topology diagram
- **`org-chart.drawio`** - Organizational hierarchy chart
- **`archimate.drawio`** - ArchiMate enterprise architecture (Business/Application/Technology layers)
- **`c4-diagram.drawio`** - C4 model with Context and Container diagrams

## Best Practices

1. **Unique IDs**: Always ensure every mxCell has a unique id
2. **Consistent spacing**: Use grid alignment (10px increments)
3. **Color coding**: Use consistent colors for similar elements
4. **Readable labels**: Keep text concise, use line breaks for long text
5. **Logical flow**: Arrange shapes left-to-right or top-to-bottom
6. **Grouping**: Use containers/swimlanes for related elements
7. **Edge routing**: Use orthogonal edges for clean diagrams
8. **Test output**: Verify files open correctly in draw.io

## Quick Start Template

Minimal working .drawio file:

```xml
<mxfile host="app.diagrams.net" modified="2024-01-01T00:00:00.000Z" agent="Claude" version="21.0.0" type="device">
  <diagram id="main" name="Diagram">
    <mxGraphModel dx="1000" dy="600" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="850" pageHeight="1100" math="0" shadow="0">
      <root>
        <mxCell id="0" />
        <mxCell id="1" parent="0" />
        <!-- Add shapes here -->
      </root>
    </mxGraphModel>
  </diagram>
</mxfile>
```
