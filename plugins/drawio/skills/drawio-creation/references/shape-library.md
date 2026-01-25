# DrawIO Shape Library Reference

Comprehensive catalog of shape styles for DrawIO diagrams.

## Basic Shapes

### Rectangle

```
rounded=0;whiteSpace=wrap;html=1;
```

### Rounded Rectangle

```
rounded=1;whiteSpace=wrap;html=1;
```

### Ellipse / Circle

```
ellipse;whiteSpace=wrap;html=1;
```

For circle: use equal width and height.

### Diamond / Rhombus

```
rhombus;whiteSpace=wrap;html=1;
```

### Triangle

```
triangle;whiteSpace=wrap;html=1;
```

### Parallelogram

```
shape=parallelogram;perimeter=parallelogramPerimeter;whiteSpace=wrap;html=1;size=0.1;
```

### Hexagon

```
shape=hexagon;perimeter=hexagonPerimeter2;whiteSpace=wrap;html=1;fixedSize=1;size=20;
```

### Trapezoid

```
shape=trapezoid;perimeter=trapezoidPerimeter;whiteSpace=wrap;html=1;fixedSize=1;size=20;
```

## Flowchart Shapes

### Process

```
rounded=1;whiteSpace=wrap;html=1;
```

### Decision

```
rhombus;whiteSpace=wrap;html=1;
```

### Start/End (Terminator)

```
ellipse;whiteSpace=wrap;html=1;
```

### Data / I/O

```
shape=parallelogram;perimeter=parallelogramPerimeter;whiteSpace=wrap;html=1;fixedSize=1;size=20;
```

### Document

```
shape=document;whiteSpace=wrap;html=1;boundedLbl=1;
```

### Multiple Documents

```
shape=mxgraph.basic.document;whiteSpace=wrap;html=1;
```

### Predefined Process

```
shape=process;whiteSpace=wrap;html=1;backgroundOutline=1;
```

### Manual Input

```
shape=manualInput;whiteSpace=wrap;html=1;size=0.1;
```

### Preparation

```
shape=hexagon;perimeter=hexagonPerimeter2;whiteSpace=wrap;html=1;fixedSize=1;size=15;
```

### Manual Operation

```
shape=trapezoid;perimeter=trapezoidPerimeter;whiteSpace=wrap;html=1;fixedSize=1;size=15;flipV=1;
```

### Delay

```
shape=delay;whiteSpace=wrap;html=1;
```

### Storage

```
shape=cylinder3;whiteSpace=wrap;html=1;boundedLbl=1;backgroundOutline=1;size=15;
```

### Database / Cylinder

```
shape=cylinder3;whiteSpace=wrap;html=1;boundedLbl=1;backgroundOutline=1;size=15;
```

### Internal Storage

```
shape=internalStorage;whiteSpace=wrap;html=1;backgroundOutline=1;dx=20;dy=20;
```

## UML Shapes

### Actor

```
shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;
```

### Use Case

```
ellipse;whiteSpace=wrap;html=1;
```

### Class Box (Simple)

```
swimlane;fontStyle=0;align=center;verticalAlign=top;childLayout=stackLayout;horizontal=1;startSize=26;horizontalStack=0;resizeParent=1;resizeParentMax=0;resizeLast=0;collapsible=0;marginBottom=0;html=1;
```

### Interface

```
ellipse;whiteSpace=wrap;html=1;fontStyle=2;
```

### Package

```
shape=folder;fontStyle=1;tabWidth=110;tabHeight=30;tabPosition=left;html=1;boundedLbl=1;labelInHeader=1;
```

### Component

```
rounded=0;whiteSpace=wrap;html=1;
```

With ports:
```
shape=component;align=left;spacingLeft=36;
```

### Node

```
shape=cube;whiteSpace=wrap;html=1;boundedLbl=1;backgroundOutline=1;size=10;darkOpacity=0.05;darkOpacity2=0.1;
```

### Lifeline (Sequence Diagram)

```
shape=umlLifeline;perimeter=lifelinePerimeter;whiteSpace=wrap;html=1;container=1;collapsible=0;recursiveResize=0;outlineConnect=0;portConstraint=eastwest;
```

### Activation Bar

```
rounded=0;whiteSpace=wrap;html=1;fillColor=#ffffff;
```

### Frame

```
shape=umlFrame;whiteSpace=wrap;html=1;width=100;height=20;boundedLbl=1;
```

## ER Diagram Shapes

### Entity Table

```
swimlane;fontStyle=1;align=center;verticalAlign=top;childLayout=stackLayout;horizontal=1;startSize=26;horizontalStack=0;resizeParent=1;resizeParentMax=0;resizeLast=0;collapsible=1;marginBottom=0;whiteSpace=wrap;html=1;
```

### Table Row / Attribute

```
text;strokeColor=none;fillColor=none;align=left;verticalAlign=top;spacingLeft=4;spacingRight=4;overflow=hidden;rotatable=0;points=[[0,0.5],[1,0.5]];portConstraint=eastwest;whiteSpace=wrap;html=1;
```

### Primary Key Row

```
text;strokeColor=none;fillColor=none;align=left;verticalAlign=top;spacingLeft=4;spacingRight=4;overflow=hidden;rotatable=0;points=[[0,0.5],[1,0.5]];portConstraint=eastwest;whiteSpace=wrap;html=1;fontStyle=1;
```

### Divider Line

```
line;strokeWidth=1;fillColor=none;align=left;verticalAlign=middle;spacingTop=-1;spacingLeft=3;spacingRight=3;rotatable=0;labelPosition=right;points=[];portConstraint=eastwest;strokeColor=inherit;
```

## Network / Infrastructure Shapes

### Server

```
shape=mxgraph.basic.rect;fillColor=#dae8fc;strokeColor=#6c8ebf;
```

Or use cube:
```
shape=cube;whiteSpace=wrap;html=1;boundedLbl=1;backgroundOutline=1;size=10;darkOpacity=0.05;darkOpacity2=0.1;
```

### Cloud

```
ellipse;shape=cloud;whiteSpace=wrap;html=1;
```

### Database

```
shape=cylinder3;whiteSpace=wrap;html=1;boundedLbl=1;backgroundOutline=1;size=15;
```

### Router

```
shape=mxgraph.cisco.routers.router;html=1;pointerEvents=1;dashed=0;fillColor=#036897;strokeColor=#ffffff;strokeWidth=2;verticalLabelPosition=bottom;verticalAlign=top;align=center;outlineConnect=0;
```

### Switch

```
shape=mxgraph.cisco.switches.workgroup_switch;html=1;pointerEvents=1;dashed=0;fillColor=#036897;strokeColor=#ffffff;strokeWidth=2;verticalLabelPosition=bottom;verticalAlign=top;align=center;outlineConnect=0;
```

### Firewall

```
shape=mxgraph.cisco.security.firewall;html=1;pointerEvents=1;dashed=0;fillColor=#DA4026;strokeColor=#ffffff;strokeWidth=2;verticalLabelPosition=bottom;verticalAlign=top;align=center;outlineConnect=0;
```

### Computer/Desktop

```
shape=mxgraph.basic.rect;fillColor=#f5f5f5;strokeColor=#666666;
```

### User/Person

```
shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;
```

## Container Shapes

### Swimlane (Horizontal)

```
swimlane;whiteSpace=wrap;html=1;fillColor=#f5f5f5;strokeColor=#666666;startSize=23;
```

### Swimlane (Vertical)

```
swimlane;horizontal=0;whiteSpace=wrap;html=1;fillColor=#f5f5f5;strokeColor=#666666;startSize=23;
```

### Group

```
group;
```

### Folder

```
shape=folder;fontStyle=1;tabWidth=80;tabHeight=20;tabPosition=left;html=1;boundedLbl=1;
```

### Note

```
shape=note;whiteSpace=wrap;html=1;backgroundOutline=1;darkOpacity=0.05;size=15;
```

## Arrow and Connector Shapes

### Arrow (Block)

```
shape=singleArrow;whiteSpace=wrap;html=1;arrowWidth=0.6;arrowSize=0.3;
```

### Double Arrow

```
shape=doubleArrow;whiteSpace=wrap;html=1;arrowWidth=0.6;arrowSize=0.3;
```

### Callout

```
shape=callout;whiteSpace=wrap;html=1;perimeter=calloutPerimeter;size=30;position=0.5;
```

## AWS / Cloud Icons

### Generic AWS Service

```
sketch=0;outlineConnect=0;fontColor=#232F3E;gradientColor=none;strokeColor=#232F3E;fillColor=#ffffff;dashed=0;verticalLabelPosition=bottom;verticalAlign=top;align=center;html=1;fontSize=12;fontStyle=0;aspect=fixed;shape=mxgraph.aws4.resourceIcon;resIcon=mxgraph.aws4.lambda;
```

Common AWS shapes (change resIcon):
- `mxgraph.aws4.lambda` - Lambda
- `mxgraph.aws4.ec2` - EC2
- `mxgraph.aws4.s3` - S3
- `mxgraph.aws4.rds` - RDS
- `mxgraph.aws4.api_gateway` - API Gateway
- `mxgraph.aws4.dynamodb` - DynamoDB

### AWS Group

```
points=[[0,0],[0.25,0],[0.5,0],[0.75,0],[1,0],[1,0.25],[1,0.5],[1,0.75],[1,1],[0.75,1],[0.5,1],[0.25,1],[0,1],[0,0.75],[0,0.5],[0,0.25]];outlineConnect=0;gradientColor=none;html=1;whiteSpace=wrap;fontSize=12;fontStyle=0;container=1;pointerEvents=0;collapsible=0;recursiveResize=0;shape=mxgraph.aws4.group;grIcon=mxgraph.aws4.group_vpc;strokeColor=#248814;fillColor=none;verticalAlign=top;align=left;spacingLeft=30;fontColor=#AAB7B8;dashed=0;
```

## Special Shapes

### Image

```
shape=image;verticalLabelPosition=bottom;labelBackgroundColor=#ffffff;verticalAlign=top;aspect=fixed;imageAspect=0;image=data:image/png;base64,...;
```

### Link

```
link;html=1;
```

### Tooltip Shape

```
shape=note;whiteSpace=wrap;html=1;backgroundOutline=1;darkOpacity=0.05;size=15;
```

## Shape Modifiers

Add these to any style:

### Rotation

```
rotation=45;
```

### Flip

```
flipH=1;  // Horizontal flip
flipV=1;  // Vertical flip
```

### Shadow

```
shadow=1;
```

### Glass Effect

```
glass=1;
```

### Sketch Style

```
sketch=1;curveFitting=1;jiggle=2;
```

### Dashed Outline

```
dashed=1;dashPattern=8 8;
```

### Rounded Corners Size

```
rounded=1;arcSize=20;
```

### Opacity

```
opacity=50;  // 0-100
```
