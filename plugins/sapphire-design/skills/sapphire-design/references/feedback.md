# Feedback & Navigation Components

Components for displaying status, navigation, user identity, and overlays: badges, alerts, tabs, dialogs, and avatars.

All components use Sapphire design tokens (see `references/tokens.md`). Ensure the token CSS is loaded first.

---

## Badge

```css
.sapphire-badge {
  display: inline-flex;
  justify-content: center;
  align-items: center;
  white-space: nowrap;
  border-radius: var(--sapphire-semantic-size-radius-sm); /* 4px */
  font-family: var(--sapphire-semantic-font-name-default);
  font-weight: var(--sapphire-semantic-font-weight-default-regular);
  box-sizing: border-box;
  height: var(--sapphire-semantic-size-height-control-sm); /* 2rem */
  padding: 0 var(--sapphire-semantic-size-spacing-sm); /* 0 0.75rem */
  font-size: var(--sapphire-semantic-size-font-control-md); /* 0.875rem */
  -webkit-font-smoothing: antialiased;
  /* Default: neutral */
  color: var(--sapphire-semantic-color-foreground-on-decorative-neutral);
  background: var(--sapphire-semantic-color-background-decorative-neutral);
}

/* Small */
.sapphire-badge--sm {
  height: var(--sapphire-semantic-size-height-control-xs); /* 1.5rem */
  padding: 0 var(--sapphire-semantic-size-spacing-xs);
  font-size: var(--sapphire-semantic-size-font-control-sm);
}

/* Semantic variants */
.sapphire-badge--primary-positive {
  color: var(--sapphire-semantic-color-foreground-on-positive);
  background: var(--sapphire-semantic-color-background-positive);
}
.sapphire-badge--secondary-positive {
  color: var(--sapphire-semantic-color-foreground-on-positive-subtle);
  background: var(--sapphire-semantic-color-background-positive-subtle);
}
.sapphire-badge--primary-negative {
  color: var(--sapphire-semantic-color-foreground-on-negative);
  background: var(--sapphire-semantic-color-background-negative);
}
.sapphire-badge--secondary-negative {
  color: var(--sapphire-semantic-color-foreground-on-negative-subtle);
  background: var(--sapphire-semantic-color-background-negative-subtle);
}
.sapphire-badge--primary-warning {
  color: var(--sapphire-semantic-color-foreground-on-warning);
  background: var(--sapphire-semantic-color-background-warning);
}
.sapphire-badge--secondary-warning {
  color: var(--sapphire-semantic-color-foreground-on-warning-subtle);
  background: var(--sapphire-semantic-color-background-warning-subtle);
}
.sapphire-badge--primary-informative {
  color: var(--sapphire-semantic-color-foreground-on-accent);
  background: var(--sapphire-semantic-color-background-accent);
}
.sapphire-badge--secondary-informative {
  color: var(--sapphire-semantic-color-foreground-on-accent-subtle);
  background: var(--sapphire-semantic-color-background-accent-subtle);
}
```

### Usage

```html
<span class="sapphire-badge">Neutral</span>
<span class="sapphire-badge sapphire-badge--primary-positive">Approved</span>
<span class="sapphire-badge sapphire-badge--secondary-negative">Rejected</span>
<span class="sapphire-badge sapphire-badge--primary-warning sapphire-badge--sm">Pending</span>
<span class="sapphire-badge sapphire-badge--primary-informative">New</span>
```

---

## Alert / Feedback Message

Sapphire doesn't ship a single "alert" component, but you can compose one from tokens:

```css
.sapphire-alert {
  display: flex;
  align-items: flex-start;
  gap: var(--sapphire-semantic-size-spacing-sm);
  padding: var(--sapphire-semantic-size-spacing-md);
  border-radius: var(--sapphire-semantic-size-radius-lg);
  font-family: var(--sapphire-semantic-font-name-default);
  font-size: var(--sapphire-semantic-size-font-body-sm);
  line-height: var(--sapphire-semantic-size-line-height-md);
}

.sapphire-alert--informative {
  background: var(--sapphire-semantic-color-background-accent-subtle);
  color: var(--sapphire-semantic-color-foreground-on-accent-subtle);
}
.sapphire-alert--positive {
  background: var(--sapphire-semantic-color-background-positive-subtle);
  color: var(--sapphire-semantic-color-foreground-on-positive-subtle);
}
.sapphire-alert--warning {
  background: var(--sapphire-semantic-color-background-warning-subtle);
  color: var(--sapphire-semantic-color-foreground-on-warning-subtle);
}
.sapphire-alert--negative {
  background: var(--sapphire-semantic-color-background-negative-subtle);
  color: var(--sapphire-semantic-color-foreground-on-negative-subtle);
}
```

---

## Tabs

```css
.sapphire-tabs {
  display: inline-flex;
  align-items: center;
  box-sizing: border-box;
  height: var(--sapphire-semantic-size-height-control-xl); /* 3.5rem */
  position: relative;
  overflow: hidden;
  min-width: 100%;
}

/* Bottom border line */
.sapphire-tabs::after {
  content: '';
  display: block;
  position: absolute;
  bottom: 0;
  width: 100%;
  height: var(--sapphire-global-size-static-2); /* 1px */
  background: var(--sapphire-semantic-color-border-secondary);
  border-radius: var(--sapphire-semantic-size-border-md);
}

.sapphire-tabs__tab {
  display: flex;
  align-items: center;
  font-family: var(--sapphire-semantic-font-name-default);
  font-weight: var(--sapphire-semantic-font-weight-default-regular);
  font-size: var(--sapphire-semantic-size-font-control-md);
  color: var(--sapphire-semantic-color-foreground-primary);
  white-space: nowrap;
  border: none;
  background: transparent;
  padding: 0 var(--sapphire-semantic-size-spacing-md);
  height: var(--sapphire-semantic-size-height-control-md);
  border-radius: var(--sapphire-semantic-size-height-control-md);
  cursor: pointer;
  z-index: 1;
  transition: background 0.1s, color 0.1s;
  text-decoration: none;
}

.sapphire-tabs__tab:hover {
  background: var(--sapphire-semantic-color-state-neutral-ghost-hover);
}

/* Active tab */
.sapphire-tabs__tab--active {
  color: var(--sapphire-semantic-color-foreground-action-select-default);
}

/* Active underline indicator */
.sapphire-tabs__underline {
  position: absolute;
  bottom: 0;
  height: var(--sapphire-semantic-size-border-md); /* 2px */
  background: var(--sapphire-semantic-color-foreground-action-select-default);
  z-index: 2;
}

/* Focus */
.sapphire-tabs__tab:focus-visible {
  outline: var(--sapphire-semantic-size-focus-ring) solid var(--sapphire-semantic-color-focus-ring);
}

/* Size variants */
.sapphire-tabs--sm { height: var(--sapphire-semantic-size-height-control-lg); }
.sapphire-tabs--sm .sapphire-tabs__tab {
  font-size: var(--sapphire-semantic-size-font-control-sm);
  padding: 0 var(--sapphire-semantic-size-spacing-sm);
  height: var(--sapphire-semantic-size-height-control-sm);
}
.sapphire-tabs--lg { height: var(--sapphire-semantic-size-height-control-2xl); }
.sapphire-tabs--lg .sapphire-tabs__tab {
  font-size: var(--sapphire-semantic-size-font-control-lg);
  padding: 0 var(--sapphire-semantic-size-spacing-lg);
}
```

### Usage

```html
<div class="sapphire-tabs" role="tablist">
  <button class="sapphire-tabs__tab sapphire-tabs__tab--active" role="tab" aria-selected="true">
    Overview
  </button>
  <button class="sapphire-tabs__tab" role="tab" aria-selected="false">
    Details
  </button>
  <button class="sapphire-tabs__tab" role="tab" aria-selected="false">
    Settings
  </button>
</div>
```

---

## Avatar

Circular element for user initials, icons, or images.

```css
.sapphire-avatar {
  display: inline-flex;
  justify-content: center;
  align-items: center;
  height: var(--sapphire-semantic-size-height-control-md); /* 2.5rem */
  width: var(--sapphire-semantic-size-height-control-md);
  border-radius: var(--sapphire-semantic-size-height-control-md); /* circle */
  white-space: nowrap;
  font-family: var(--sapphire-semantic-font-name-default);
  font-weight: var(--sapphire-semantic-font-weight-default-medium);
  font-size: var(--sapphire-semantic-size-font-body-md);
  text-transform: capitalize;
  -webkit-font-smoothing: antialiased;
  color: var(--sapphire-semantic-color-foreground-on-decorative-neutral);
  background: var(--sapphire-semantic-color-background-decorative-neutral);
}

/* Sizes */
.sapphire-avatar--sm {
  height: var(--sapphire-semantic-size-height-control-sm); /* 2rem */
  width: var(--sapphire-semantic-size-height-control-sm);
  border-radius: var(--sapphire-semantic-size-height-control-sm);
  font-size: var(--sapphire-semantic-size-font-body-sm);
}
.sapphire-avatar--lg {
  height: var(--sapphire-semantic-size-height-control-lg); /* 3rem */
  width: var(--sapphire-semantic-size-height-control-lg);
  border-radius: var(--sapphire-semantic-size-height-control-lg);
  font-size: 1.25rem;
}

/* Decorative colors (1-16) */
.sapphire-avatar--decorative-1 {
  color: var(--sapphire-semantic-color-foreground-on-decorative-1);
  background: var(--sapphire-semantic-color-background-decorative-1);
}
/* ... same pattern for --decorative-2 through --decorative-16 */
```

### Usage

```html
<span class="sapphire-avatar">JD</span>
<span class="sapphire-avatar sapphire-avatar--sm sapphire-avatar--decorative-3">AB</span>
<span class="sapphire-avatar sapphire-avatar--lg sapphire-avatar--decorative-7">MK</span>
```

---

## Dialog

```css
@keyframes sapphire-fade-in {
  from { opacity: 0; }
  to { opacity: 1; }
}
@keyframes sapphire-fade-out {
  from { opacity: 1; }
  to { opacity: 0; }
}

.sapphire-dialog {
  border-radius: var(--sapphire-semantic-size-radius-2xl); /* 16px */
  background: var(--sapphire-semantic-color-background-popover);
  font-family: var(--sapphire-semantic-font-name-default);
  color: var(--sapphire-semantic-color-foreground-primary);
  box-sizing: border-box;
  overflow: hidden;
  max-height: 90vh;
  max-width: 90vw;
  display: flex;
  flex-direction: column;
  outline: none;
  animation: sapphire-fade-in 0.2s forwards;
}

.sapphire-dialog--padded {
  padding: var(--sapphire-semantic-size-spacing-3xl) var(--sapphire-semantic-size-spacing-3xl)
    var(--sapphire-semantic-size-spacing-2xl) var(--sapphire-semantic-size-spacing-3xl);
}

/* Sizes */
.sapphire-dialog--xs { width: 22.5rem; }   /* 360px */
.sapphire-dialog--sm { width: 35rem; }      /* 560px */
.sapphire-dialog--md { width: 48rem; }      /* 768px */
.sapphire-dialog--lg { width: 64rem; }      /* 1024px */

/* Backdrop */
.sapphire-backdrop {
  position: fixed;
  inset: 0;
  background: color(from var(--sapphire-global-color-gray-950) xyz x y z / 0.6);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 100;
}
```

### Usage

```html
<div class="sapphire-backdrop">
  <div class="sapphire-dialog sapphire-dialog--sm sapphire-dialog--padded" role="dialog" aria-modal="true">
    <h2 class="sapphire-text sapphire-text--heading-md">Dialog Title</h2>
    <p class="sapphire-text sapphire-text--body-md" style="margin-top: var(--sapphire-semantic-size-spacing-md);">
      Dialog content goes here.
    </p>
    <div style="display: flex; justify-content: flex-end; gap: var(--sapphire-semantic-size-spacing-sm); margin-top: var(--sapphire-semantic-size-spacing-xl);">
      <button class="sapphire-button sapphire-button--secondary">Cancel</button>
      <button class="sapphire-button sapphire-button--primary">Confirm</button>
    </div>
  </div>
</div>
```
