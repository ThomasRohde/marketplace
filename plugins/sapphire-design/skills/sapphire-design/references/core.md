# Core Components

Foundational components needed for virtually every Sapphire-styled page: surface, typography, cards, separators, and layout utilities.

All components use Sapphire design tokens (see `references/tokens.md`). Ensure the token CSS is loaded first.

---

## Surface

The root container that establishes the Sapphire theme and base typography.

```css
.sapphire-surface {
  font-family: var(--sapphire-semantic-font-name-default);
  background: var(--sapphire-semantic-color-background-surface);
  color: var(--sapphire-semantic-color-foreground-primary);
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}
```

```html
<div class="sapphire-theme-default sapphire-surface">
  <!-- All content here -->
</div>
```

---

## Text

### Headings

```css
.sapphire-text {
  font-family: var(--sapphire-semantic-font-name-default);
  color: var(--sapphire-semantic-color-foreground-primary);
  font-weight: var(--sapphire-semantic-font-weight-default-regular);
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

/* Headings share these base styles */
.sapphire-text--heading-2xl,
.sapphire-text--heading-xl,
.sapphire-text--heading-lg,
.sapphire-text--heading-md,
.sapphire-text--heading-sm,
.sapphire-text--heading-xs {
  margin-top: 0;
  margin-bottom: 0;
  line-height: var(--sapphire-global-size-line-height-sm); /* 1.3 */
  letter-spacing: -0.01em;
}

.sapphire-text--heading-2xl {
  font-weight: var(--sapphire-semantic-font-weight-default-regular); /* 400 */
  font-size: var(--sapphire-semantic-size-font-heading-2xl);
}
.sapphire-text--heading-xl {
  font-weight: var(--sapphire-semantic-font-weight-default-medium); /* 500 */
  font-size: var(--sapphire-semantic-size-font-heading-xl);
}
.sapphire-text--heading-lg {
  font-weight: var(--sapphire-semantic-font-weight-default-medium);
  font-size: var(--sapphire-semantic-size-font-heading-lg);
}
.sapphire-text--heading-md {
  font-weight: var(--sapphire-semantic-font-weight-default-medium);
  font-size: var(--sapphire-semantic-size-font-heading-md);
}
.sapphire-text--heading-sm {
  font-weight: var(--sapphire-semantic-font-weight-default-medium);
  font-size: var(--sapphire-semantic-size-font-heading-sm);
}
.sapphire-text--heading-xs {
  font-weight: var(--sapphire-semantic-font-weight-default-medium);
  font-size: var(--sapphire-semantic-size-font-heading-xs);
}
```

### Body Text

```css
.sapphire-text--body-lg,
.sapphire-text--body-md,
.sapphire-text--body-sm,
.sapphire-text--body-xs {
  line-height: var(--sapphire-global-size-line-height-md); /* 1.5 */
  margin-top: 0;
  margin-bottom: 0;
}

.sapphire-text--body-lg { font-size: var(--sapphire-semantic-size-font-body-lg); }   /* 1.125rem */
.sapphire-text--body-md { font-size: var(--sapphire-semantic-size-font-body-md); }   /* 1rem */
.sapphire-text--body-sm { font-size: var(--sapphire-semantic-size-font-body-sm); }   /* 0.875rem */
.sapphire-text--body-xs { font-size: var(--sapphire-semantic-size-font-body-xs); }   /* 0.75rem */
```

### Captions & Subheadings

```css
.sapphire-text--caption-md {
  font-weight: var(--sapphire-semantic-font-weight-default-bold);
  line-height: var(--sapphire-global-size-line-height-sm);
  font-size: var(--sapphire-semantic-size-font-body-sm);
}
.sapphire-text--caption-sm {
  font-weight: var(--sapphire-semantic-font-weight-default-bold);
  line-height: var(--sapphire-global-size-line-height-sm);
  font-size: var(--sapphire-semantic-size-font-body-xs);
}
.sapphire-text--subheading-md {
  line-height: var(--sapphire-global-size-line-height-sm);
  font-size: var(--sapphire-semantic-size-font-body-sm);
}
.sapphire-text--subheading-sm {
  line-height: var(--sapphire-global-size-line-height-sm);
  font-size: var(--sapphire-semantic-size-font-body-xs);
}
```

### Text Modifiers

```css
.sapphire-text--strong { font-weight: var(--sapphire-semantic-font-weight-default-bold); }
.sapphire-text--semibold { font-weight: var(--sapphire-semantic-font-weight-default-medium); }
.sapphire-text--underlined { text-decoration: underline; }
.sapphire-text--secondary { color: var(--sapphire-semantic-color-foreground-secondary); }
.sapphire-text--informative { color: var(--sapphire-semantic-color-foreground-accent); }
.sapphire-text--positive { color: var(--sapphire-semantic-color-foreground-positive); }
.sapphire-text--warning { color: var(--sapphire-semantic-color-foreground-warning); }
.sapphire-text--negative { color: var(--sapphire-semantic-color-foreground-negative); }
```

### Usage

```html
<h1 class="sapphire-text sapphire-text--heading-xl">Page Title</h1>
<h2 class="sapphire-text sapphire-text--heading-md">Section</h2>
<p class="sapphire-text sapphire-text--body-md">Body text content.</p>
<p class="sapphire-text sapphire-text--body-sm sapphire-text--secondary">Secondary info.</p>
<span class="sapphire-text sapphire-text--caption-md">LABEL</span>
```

---

## Card

A card is composed from surface + border + shadow tokens:

```css
.sapphire-card {
  background: var(--sapphire-semantic-color-background-surface);
  border: var(--sapphire-semantic-size-border-sm) solid var(--sapphire-semantic-color-border-secondary);
  border-radius: var(--sapphire-semantic-size-radius-lg); /* 8px */
  padding: var(--sapphire-semantic-size-spacing-xl); /* 1.5rem */
  font-family: var(--sapphire-semantic-font-name-default);
  color: var(--sapphire-semantic-color-foreground-primary);
}

/* Elevated card (with shadow, no border) */
.sapphire-card--elevated {
  border: none;
  box-shadow: var(--sapphire-semantic-shadow-popover);
}
```

---

## Separator

```css
.sapphire-separator {
  height: 1px;
  background-color: var(--sapphire-semantic-color-border-secondary);
  border: none;
  width: 100%;
}

/* Vertical */
.sapphire-separator[aria-orientation='vertical'] {
  width: 1px;
  height: auto;
  min-height: 100%;
  align-self: stretch;
}
```

```html
<hr class="sapphire-separator" />
<hr class="sapphire-separator" aria-orientation="vertical" />
```

---

## Layout Patterns

Sapphire uses flex-based layouts. Here are common patterns:

### Stack (vertical)

```css
.sapphire-stack {
  display: flex;
  flex-direction: column;
}
.sapphire-stack--gap-xs { gap: var(--sapphire-semantic-size-spacing-xs); }
.sapphire-stack--gap-sm { gap: var(--sapphire-semantic-size-spacing-sm); }
.sapphire-stack--gap-md { gap: var(--sapphire-semantic-size-spacing-md); }
.sapphire-stack--gap-lg { gap: var(--sapphire-semantic-size-spacing-lg); }
.sapphire-stack--gap-xl { gap: var(--sapphire-semantic-size-spacing-xl); }
```

### Row (horizontal)

```css
.sapphire-row {
  display: flex;
  flex-direction: row;
  align-items: center;
}
.sapphire-row--gap-xs { gap: var(--sapphire-semantic-size-spacing-xs); }
.sapphire-row--gap-sm { gap: var(--sapphire-semantic-size-spacing-sm); }
.sapphire-row--gap-md { gap: var(--sapphire-semantic-size-spacing-md); }
.sapphire-row--gap-lg { gap: var(--sapphire-semantic-size-spacing-lg); }
```

### Container

```css
.sapphire-container {
  width: 100%;
  max-width: 80rem; /* 1280px */
  margin: 0 auto;
  padding: 0 var(--sapphire-semantic-size-spacing-container-horizontal-md);
}
```
