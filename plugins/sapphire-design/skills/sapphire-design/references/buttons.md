# Button Component

Sapphire buttons are pill-shaped (border-radius matches height), with multiple variants and sizes.

All components use Sapphire design tokens (see `references/tokens.md`). Ensure the token CSS is loaded first.

---

## Base Button CSS

```css
.sapphire-button {
  box-sizing: border-box;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  vertical-align: middle;
  white-space: nowrap;
  margin: 0;
  font-family: var(--sapphire-semantic-font-name-default);
  font-weight: var(--sapphire-semantic-font-weight-default-regular);
  font-size: var(--sapphire-semantic-size-font-control-md); /* 0.875rem */
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  padding: 0 var(--sapphire-semantic-size-spacing-md); /* 0 1rem */
  height: var(--sapphire-semantic-size-height-control-md); /* 2.5rem */
  min-width: var(--sapphire-global-size-generic-200); /* 5rem */
  width: fit-content;
  max-width: 100%;
  border-radius: var(--sapphire-semantic-size-height-control-md); /* pill shape */
  border: none;
  transition: opacity 0.1s, background 0.1s, color 0.1s;
  cursor: pointer;
  text-decoration: none;
}

.sapphire-button__content {
  align-items: center;
  text-align: center;
  white-space: nowrap;
  user-select: none;
  padding: 0 var(--sapphire-semantic-size-spacing-xs);
  overflow: hidden;
  text-overflow: ellipsis;
}
```

## Variants

```css
/* Primary (blue filled) */
.sapphire-button--primary {
  background: var(--sapphire-semantic-color-background-action-primary-default);
  color: var(--sapphire-semantic-color-foreground-action-on-primary-default);
}

/* Secondary (sand/neutral filled) */
.sapphire-button--secondary {
  background: var(--sapphire-semantic-color-background-action-secondary-default);
  color: var(--sapphire-semantic-color-foreground-action-on-secondary-default);
}

/* Tertiary (transparent, ghost) */
.sapphire-button--tertiary {
  background: transparent;
  color: var(--sapphire-semantic-color-foreground-action-on-tertiary-default);
}

/* Danger (red filled) */
.sapphire-button--danger {
  background: var(--sapphire-semantic-color-background-action-danger-default);
  color: var(--sapphire-semantic-color-foreground-action-on-danger-default);
}

/* Danger Secondary (red subtle) */
.sapphire-button--danger-secondary {
  background: var(--sapphire-semantic-color-background-action-danger-secondary-default);
  color: var(--sapphire-semantic-color-foreground-on-negative-subtle);
}

/* Danger Tertiary (transparent, red text) */
.sapphire-button--danger-tertiary {
  background: transparent;
  color: var(--sapphire-semantic-color-foreground-action-danger-default);
}

/* Text link style */
.sapphire-button--text {
  color: var(--sapphire-semantic-color-foreground-action-link-default);
  border-radius: var(--sapphire-semantic-size-radius-xs);
  background: transparent;
  padding: 0;
}
```

## Sizes

```css
/* Large */
.sapphire-button--lg {
  height: var(--sapphire-semantic-size-height-control-lg); /* 3rem */
  min-width: var(--sapphire-global-size-generic-240); /* 6rem */
  padding: 0 var(--sapphire-semantic-size-spacing-lg); /* 0 1.25rem */
  font-size: var(--sapphire-semantic-size-font-control-lg); /* 1rem */
  border-radius: var(--sapphire-semantic-size-height-control-lg);
}

/* Small */
.sapphire-button--sm {
  height: var(--sapphire-semantic-size-height-control-sm); /* 2rem */
  min-width: var(--sapphire-global-size-generic-160); /* 4rem */
  padding: 0 var(--sapphire-semantic-size-spacing-sm); /* 0 0.75rem */
  font-size: var(--sapphire-semantic-size-font-control-sm); /* 0.75rem */
  border-radius: var(--sapphire-semantic-size-height-control-sm);
}
```

## States

```css
/* Disabled */
.sapphire-button:disabled {
  opacity: var(--sapphire-semantic-opacity-disabled); /* 0.3 */
  cursor: not-allowed;
}

/* Focus (keyboard) */
.sapphire-button:focus-visible {
  outline: var(--sapphire-semantic-size-focus-ring) solid var(--sapphire-semantic-color-focus-ring);
  outline-offset: var(--sapphire-semantic-size-focus-ring);
}

/* Hover */
.sapphire-button--primary:not(:disabled):hover {
  filter: brightness(0.92);
}
.sapphire-button--secondary:not(:disabled):hover {
  filter: brightness(0.95);
}
.sapphire-button--tertiary:not(:disabled):hover {
  background: var(--sapphire-semantic-color-state-neutral-ghost-hover);
}
.sapphire-button--text:not(:disabled):hover {
  text-decoration: underline;
}
```

## Icon in Button

```css
.sapphire-button__icon {
  display: flex;
  align-items: center;
  justify-content: center;
  height: var(--sapphire-semantic-size-icon-sm); /* 1rem */
  width: var(--sapphire-semantic-size-icon-sm);
}
.sapphire-button--lg .sapphire-button__icon {
  height: var(--sapphire-semantic-size-icon-md); /* 1.25rem */
  width: var(--sapphire-semantic-size-icon-md);
}
```

## Usage

```html
<button class="sapphire-button sapphire-button--primary">
  <span class="sapphire-button__content">Primary Action</span>
</button>

<button class="sapphire-button sapphire-button--secondary sapphire-button--lg">
  <span class="sapphire-button__content">Large Secondary</span>
</button>

<button class="sapphire-button sapphire-button--danger sapphire-button--sm">
  <span class="sapphire-button__content">Delete</span>
</button>

<!-- With icon -->
<button class="sapphire-button sapphire-button--primary">
  <span class="sapphire-button__icon">
    <svg><!-- icon SVG --></svg>
  </span>
  <span class="sapphire-button__content">With Icon</span>
</button>
```
