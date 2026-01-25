# DrawIO XML Structure Reference

Complete reference for DrawIO file format and XML structure.

## File Container (mxfile)

```xml
<mxfile
  host="app.diagrams.net"
  modified="2024-01-01T00:00:00.000Z"
  agent="Claude"
  version="21.0.0"
  type="device"
  etag="unique-tag"
  compressed="false">
  <!-- diagrams go here -->
</mxfile>
```

### Attributes

| Attribute | Description | Example |
|-----------|-------------|---------|
| host | Application that created file | `app.diagrams.net` |
| modified | ISO 8601 timestamp | `2024-01-01T00:00:00.000Z` |
| agent | User agent/creator | `Claude` |
| version | DrawIO version | `21.0.0` |
| type | Storage type | `device`, `google`, `dropbox` |
| etag | Change tracking tag | Random string |
| compressed | Content compression | `true`, `false` |

## Diagram Element

```xml
<diagram id="unique-id" name="Page Name">
  <mxGraphModel>...</mxGraphModel>
</diagram>
```

Multiple diagrams create multiple pages in DrawIO.

## Graph Model (mxGraphModel)

```xml
<mxGraphModel
  dx="1000"
  dy="600"
  grid="1"
  gridSize="10"
  guides="1"
  tooltips="1"
  connect="1"
  arrows="1"
  fold="1"
  page="1"
  pageScale="1"
  pageWidth="850"
  pageHeight="1100"
  background="#ffffff"
  math="0"
  shadow="0">
  <root>...</root>
</mxGraphModel>
```

### Attributes

| Attribute | Description | Default |
|-----------|-------------|---------|
| dx | Horizontal scroll offset | 0 |
| dy | Vertical scroll offset | 0 |
| grid | Show grid | 1 (on) |
| gridSize | Grid cell size in pixels | 10 |
| guides | Enable guides | 1 |
| tooltips | Show tooltips | 1 |
| connect | Enable connections | 1 |
| arrows | Show arrows | 1 |
| fold | Enable folding | 1 |
| page | Show page breaks | 1 |
| pageScale | Page zoom level | 1 |
| pageWidth | Page width in pixels | 850 |
| pageHeight | Page height in pixels | 1100 |
| background | Background color | #ffffff |
| math | Enable math rendering | 0 |
| shadow | Global shadow | 0 |

## Cell Structure (mxCell)

### Root Cells (Required)

```xml
<root>
  <mxCell id="0" />
  <mxCell id="1" parent="0" />
  <!-- User cells start from id="2" -->
</root>
```

- `id="0"` - Absolute root cell (required)
- `id="1"` - Default parent for all user shapes (required)

### Vertex (Shape)

```xml
<mxCell
  id="2"
  value="Label Text"
  style="rounded=1;whiteSpace=wrap;html=1;"
  vertex="1"
  parent="1"
  connectable="1">
  <mxGeometry x="100" y="100" width="120" height="60" as="geometry" />
</mxCell>
```

### Edge (Connector)

```xml
<mxCell
  id="3"
  value="Label"
  style="edgeStyle=orthogonalEdgeStyle;rounded=0;"
  edge="1"
  parent="1"
  source="2"
  target="4">
  <mxGeometry relative="1" as="geometry">
    <mxPoint x="200" y="150" as="sourcePoint" />
    <mxPoint x="400" y="150" as="targetPoint" />
    <Array as="points">
      <mxPoint x="300" y="150" />
    </Array>
  </mxGeometry>
</mxCell>
```

### Cell Attributes

| Attribute | Description | Values |
|-----------|-------------|--------|
| id | Unique identifier | String (must be unique) |
| value | Display text/HTML | String or HTML |
| style | Semicolon-separated styles | Style string |
| vertex | Is this a shape? | "1" for shapes |
| edge | Is this a connector? | "1" for edges |
| parent | Parent cell ID | ID string |
| source | Source vertex ID (edges) | ID string |
| target | Target vertex ID (edges) | ID string |
| connectable | Can connect to this? | "0" or "1" |

## Geometry (mxGeometry)

### For Vertices

```xml
<mxGeometry x="100" y="100" width="120" height="60" as="geometry" />
```

| Attribute | Description |
|-----------|-------------|
| x | Left position (pixels from canvas origin) |
| y | Top position (pixels from canvas origin) |
| width | Shape width in pixels |
| height | Shape height in pixels |

### For Edges

```xml
<mxGeometry relative="1" as="geometry">
  <mxPoint x="160" y="130" as="sourcePoint" />
  <mxPoint x="340" y="130" as="targetPoint" />
  <Array as="points">
    <mxPoint x="250" y="130" />
    <mxPoint x="250" y="200" />
  </Array>
  <mxPoint as="offset" />
</mxGeometry>
```

| Element | Description |
|---------|-------------|
| relative | Use relative positioning (1) |
| sourcePoint | Start point if no source cell |
| targetPoint | End point if no target cell |
| points | Waypoints for routing |
| offset | Label offset from center |

## Nested Structures

### Container with Children

```xml
<!-- Parent container -->
<mxCell id="2" value="Container" style="swimlane;..." vertex="1" parent="1">
  <mxGeometry x="40" y="40" width="300" height="200" as="geometry" />
</mxCell>

<!-- Child inside container (parent="2") -->
<mxCell id="3" value="Child" style="rounded=1;..." vertex="1" parent="2">
  <mxGeometry x="20" y="40" width="100" height="50" as="geometry" />
</mxCell>
```

Child geometry is relative to parent's origin.

### Group

```xml
<mxCell id="group1" value="" style="group" vertex="1" connectable="0" parent="1">
  <mxGeometry x="100" y="100" width="200" height="150" as="geometry" />
</mxCell>
<mxCell id="4" value="Item 1" style="..." vertex="1" parent="group1">
  <mxGeometry x="10" y="10" width="80" height="40" as="geometry" />
</mxCell>
```

## Points and Arrays

### Waypoints for Edges

```xml
<Array as="points">
  <mxPoint x="200" y="100" />
  <mxPoint x="200" y="200" />
  <mxPoint x="300" y="200" />
</Array>
```

### Connection Points

```xml
<mxCell id="2" value="Shape" style="points=[[0,0.5],[1,0.5],[0.5,0],[0.5,1]];" vertex="1" parent="1">
  <mxGeometry x="100" y="100" width="100" height="60" as="geometry" />
</mxCell>
```

Points array defines connection points as [x%, y%] relative to shape bounds.

## HTML Labels

```xml
<mxCell id="2" value="&lt;b&gt;Bold&lt;/b&gt;&lt;br&gt;&lt;i&gt;Italic&lt;/i&gt;" style="html=1;..." vertex="1" parent="1">
```

Use HTML entities:
- `&lt;` for <
- `&gt;` for >
- `&amp;` for &
- `&quot;` for "
- `&#xa;` for newline

## Compression

When `compressed="true"`, diagram content is:
1. Deflate compressed
2. Base64 encoded
3. URL encoded

For simplicity, always use `compressed="false"` or omit the attribute.

## Complete Example

```xml
<?xml version="1.0" encoding="UTF-8"?>
<mxfile host="app.diagrams.net" modified="2024-01-01T00:00:00.000Z" agent="Claude" version="21.0.0" type="device">
  <diagram id="main-diagram" name="Main">
    <mxGraphModel dx="1000" dy="600" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="850" pageHeight="1100" math="0" shadow="0">
      <root>
        <mxCell id="0" />
        <mxCell id="1" parent="0" />
        <mxCell id="2" value="Start" style="ellipse;whiteSpace=wrap;html=1;fillColor=#d5e8d4;strokeColor=#82b366;" vertex="1" parent="1">
          <mxGeometry x="200" y="40" width="80" height="40" as="geometry" />
        </mxCell>
        <mxCell id="3" value="Process" style="rounded=1;whiteSpace=wrap;html=1;" vertex="1" parent="1">
          <mxGeometry x="180" y="120" width="120" height="60" as="geometry" />
        </mxCell>
        <mxCell id="4" value="" style="endArrow=classic;html=1;" edge="1" parent="1" source="2" target="3">
          <mxGeometry relative="1" as="geometry" />
        </mxCell>
      </root>
    </mxGraphModel>
  </diagram>
</mxfile>
```
