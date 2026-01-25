# DrawIO Styling Guide

Advanced styling, themes, and formatting for professional diagrams.

## Style String Format

Styles are semicolon-separated key=value pairs:

```
key1=value1;key2=value2;key3=value3;
```

Always end with a semicolon.

## Fill and Stroke

### Fill Color

```
fillColor=#dae8fc;
```

### Gradient Fill

```
fillColor=#dae8fc;gradientColor=#7ea6e0;gradientDirection=south;
```

Gradient directions: `north`, `south`, `east`, `west`, `radial`

### No Fill

```
fillColor=none;
```

### Stroke Color

```
strokeColor=#6c8ebf;
```

### Stroke Width

```
strokeWidth=2;
```

### No Stroke

```
strokeColor=none;
```

### Dashed Stroke

```
dashed=1;
dashPattern=8 8;
```

Common patterns:
- `8 8` - Standard dash
- `12 4` - Long dash
- `4 4` - Short dash
- `12 4 4 4` - Dash-dot

### Rounded Corners

```
rounded=1;
arcSize=10;  // Corner radius percentage (0-50)
```

## Typography

### Font Family

```
fontFamily=Helvetica;
```

Common fonts: `Helvetica`, `Arial`, `Verdana`, `Times New Roman`, `Courier New`, `Georgia`

### Font Size

```
fontSize=12;
```

### Font Color

```
fontColor=#333333;
```

### Font Style

```
fontStyle=0;  // Normal
fontStyle=1;  // Bold
fontStyle=2;  // Italic
fontStyle=3;  // Bold + Italic
fontStyle=4;  // Underline
fontStyle=5;  // Bold + Underline
```

### Text Alignment

Horizontal:
```
align=center;  // center, left, right
```

Vertical:
```
verticalAlign=middle;  // middle, top, bottom
```

### Text Spacing

```
spacing=5;
spacingTop=5;
spacingBottom=5;
spacingLeft=10;
spacingRight=10;
```

### Text Wrapping

```
whiteSpace=wrap;
```

### Overflow

```
overflow=hidden;  // hidden, visible, fill, width
```

### Label Position

For shapes with external labels:
```
labelPosition=center;  // center, left, right
verticalLabelPosition=middle;  // middle, top, bottom
```

## Color Palettes

### Professional Blue Theme

| Element | Fill | Stroke |
|---------|------|--------|
| Primary | `#dae8fc` | `#6c8ebf` |
| Dark | `#1a365d` | `#0d2137` |
| Light | `#e8f4f8` | `#b8d4e8` |

### Success/Green Theme

| Element | Fill | Stroke |
|---------|------|--------|
| Primary | `#d5e8d4` | `#82b366` |
| Dark | `#2d5016` | `#1a3009` |
| Light | `#e8f5e8` | `#a8d4a8` |

### Warning/Orange Theme

| Element | Fill | Stroke |
|---------|------|--------|
| Primary | `#ffe6cc` | `#d79b00` |
| Dark | `#b35c00` | `#804200` |
| Light | `#fff5e6` | `#ffd699` |

### Error/Red Theme

| Element | Fill | Stroke |
|---------|------|--------|
| Primary | `#f8cecc` | `#b85450` |
| Dark | `#a8201a` | `#6b0f0a` |
| Light | `#fce4e4` | `#f5a8a8` |

### Purple Theme

| Element | Fill | Stroke |
|---------|------|--------|
| Primary | `#e1d5e7` | `#9673a6` |
| Dark | `#5c2d7a` | `#3d1a52` |
| Light | `#f5f0f8` | `#d4c4dc` |

### Neutral/Gray Theme

| Element | Fill | Stroke |
|---------|------|--------|
| Primary | `#f5f5f5` | `#666666` |
| Dark | `#333333` | `#1a1a1a` |
| Light | `#fafafa` | `#cccccc` |

### Dark Mode Palette

| Element | Fill | Stroke |
|---------|------|--------|
| Background | `#1a1a1a` | `#404040` |
| Surface | `#2d2d2d` | `#4a4a4a` |
| Primary | `#3d5a80` | `#6b8cae` |
| Text | `#e8e8e8` | - |

## Edge/Connector Styles

### Edge Style

```
edgeStyle=orthogonalEdgeStyle;  // Right angles
edgeStyle=elbowEdgeStyle;       // Single elbow
edgeStyle=entityRelationEdgeStyle;  // ER diagram style
edgeStyle=segmentEdgeStyle;     // Segmented
edgeStyle=isometricEdgeStyle;   // Isometric
```

Or no edge style for straight lines:
```
edgeStyle=none;
```

### Curved Edges

```
curved=1;
```

### Rounded Corners on Edges

```
rounded=1;
```

### Jump Over (Line Crossing)

```
jumpStyle=arc;  // arc, gap, sharp, line
jumpSize=10;
```

### Arrow Styles

Start arrow:
```
startArrow=classic;  // none, classic, block, open, oval, diamond, diamondThin
startFill=1;  // 1=filled, 0=hollow
startSize=6;
```

End arrow:
```
endArrow=classic;
endFill=1;
endSize=6;
```

Arrow types:
- `none` - No arrow
- `classic` - Standard arrow
- `classicThin` - Thin arrow
- `block` - Filled triangle
- `blockThin` - Thin filled triangle
- `open` - Open arrow (V shape)
- `openThin` - Thin open arrow
- `oval` - Circle
- `diamond` - Diamond shape
- `diamondThin` - Thin diamond
- `dash` - Dash mark
- `cross` - X mark
- `circlePlus` - Circle with plus
- `circle` - Unfilled circle
- `ERone` - ER "one" notation
- `ERmandOne` - ER mandatory one
- `ERmany` - ER "many" notation
- `ERoneToMany` - ER one-to-many
- `ERzeroToOne` - ER zero-to-one
- `ERzeroToMany` - ER zero-to-many

### Edge Label Positioning

```
labelBackgroundColor=#ffffff;
labelBorderColor=#000000;
```

## Effects

### Shadow

```
shadow=1;
```

Custom shadow:
```
shadow=1;shadowColor=#666666;shadowOffsetX=3;shadowOffsetY=3;shadowBlur=4;
```

### Glass Effect

```
glass=1;
```

### Sketch/Hand-drawn Effect

```
sketch=1;
curveFitting=1;
jiggle=2;
```

### Opacity

```
opacity=80;  // 0-100
```

### Rotation

```
rotation=45;  // Degrees
```

### Flip

```
flipH=1;  // Horizontal flip
flipV=1;  // Vertical flip
```

## Layout Properties

### Aspect Ratio

```
aspect=fixed;  // Maintain aspect ratio when resizing
```

### Resize

```
resizable=0;  // Prevent resizing
```

### Movable

```
movable=0;  // Prevent moving
```

### Connectable

```
connectable=0;  // Disable connection points
```

### Editable

```
editable=0;  // Disable label editing
```

## Connection Points

### Default Points

```
points=[];  // No specific connection points
```

### Custom Points

```
points=[[0,0.5],[1,0.5],[0.5,0],[0.5,1]];
```

Format: `[[x1,y1],[x2,y2],...]` where values are 0-1 (percentage of width/height)

### Perimeter

```
perimeter=rectanglePerimeter;
perimeter=ellipsePerimeter;
perimeter=trianglePerimeter;
perimeter=hexagonPerimeter2;
perimeter=parallelogramPerimeter;
```

### Port Constraint

```
portConstraint=eastwest;  // Only connect on east/west sides
portConstraint=northsouth;  // Only connect on north/south sides
```

## Container Styles

### Swimlane

```
swimlane;
whiteSpace=wrap;
html=1;
startSize=23;  // Header height
horizontal=1;  // 0 for vertical
```

### Collapsible

```
collapsible=1;
collapsed=0;  // Initial state
```

### Child Layout

```
childLayout=stackLayout;  // Stack children vertically
horizontalStack=0;  // 1 for horizontal
```

## Complete Style Examples

### Professional Process Box

```
rounded=1;whiteSpace=wrap;html=1;fillColor=#dae8fc;strokeColor=#6c8ebf;strokeWidth=1;fontSize=12;fontColor=#333333;shadow=1;
```

### Decision Diamond

```
rhombus;whiteSpace=wrap;html=1;fillColor=#fff2cc;strokeColor=#d6b656;fontSize=11;fontColor=#333333;
```

### Database Cylinder

```
shape=cylinder3;whiteSpace=wrap;html=1;boundedLbl=1;backgroundOutline=1;size=15;fillColor=#d5e8d4;strokeColor=#82b366;strokeWidth=2;
```

### Styled Connector

```
edgeStyle=orthogonalEdgeStyle;rounded=1;orthogonalLoop=1;jettySize=auto;html=1;strokeWidth=2;strokeColor=#6c8ebf;endArrow=classic;endFill=1;
```

### Container/Group

```
swimlane;whiteSpace=wrap;html=1;fillColor=#f5f5f5;strokeColor=#666666;startSize=30;fontStyle=1;fontSize=14;horizontal=1;
```

### Note/Comment

```
shape=note;whiteSpace=wrap;html=1;backgroundOutline=1;darkOpacity=0.05;size=15;fillColor=#fff2cc;strokeColor=#d6b656;fontStyle=2;
```

### Cloud Shape

```
ellipse;shape=cloud;whiteSpace=wrap;html=1;fillColor=#dae8fc;strokeColor=#6c8ebf;
```

## Theme Templates

### Light Professional Theme

Apply to all shapes:
```
Base: fillColor=#ffffff;strokeColor=#333333;fontColor=#333333;
Primary: fillColor=#dae8fc;strokeColor=#6c8ebf;
Secondary: fillColor=#f5f5f5;strokeColor=#666666;
Accent: fillColor=#d5e8d4;strokeColor=#82b366;
Warning: fillColor=#fff2cc;strokeColor=#d6b656;
Danger: fillColor=#f8cecc;strokeColor=#b85450;
```

### Dark Theme

```
Base: fillColor=#2d2d2d;strokeColor=#606060;fontColor=#e8e8e8;
Primary: fillColor=#3d5a80;strokeColor=#6b8cae;fontColor=#ffffff;
Secondary: fillColor=#404040;strokeColor=#808080;fontColor=#e0e0e0;
Accent: fillColor=#4a7c59;strokeColor=#7ab08a;fontColor=#ffffff;
```

### High Contrast Theme

```
Base: fillColor=#ffffff;strokeColor=#000000;strokeWidth=2;fontColor=#000000;
Primary: fillColor=#0066cc;strokeColor=#003366;fontColor=#ffffff;
Accent: fillColor=#009900;strokeColor=#006600;fontColor=#ffffff;
```
