# Form Components

Input components for building forms: text fields, checkboxes, radio buttons, switches, and selects.

All components use Sapphire design tokens (see `references/tokens.md`). Ensure the token CSS is loaded first.

---

## Text Field

```css
.sapphire-text-field {
  outline: solid var(--sapphire-semantic-size-border-sm)
    var(--sapphire-semantic-color-border-field-default);
  outline-offset: calc(0px - var(--sapphire-semantic-size-border-sm));
  box-sizing: border-box;
  display: flex;
  align-items: center;
  border-radius: var(--sapphire-semantic-size-radius-md); /* 6px */
  cursor: text;
  color: var(--sapphire-semantic-color-foreground-primary);
  background: var(--sapphire-semantic-color-background-field);
  height: var(--sapphire-semantic-size-height-control-lg); /* 3rem */
  font-family: var(--sapphire-semantic-font-name-default);
  font-size: var(--sapphire-semantic-size-font-control-lg); /* 1rem */
  -webkit-font-smoothing: antialiased;
}

/* Medium size variant */
.sapphire-text-field--md {
  border-radius: var(--sapphire-semantic-size-radius-sm); /* 4px */
  height: var(--sapphire-semantic-size-height-control-md); /* 2.5rem */
  font-size: var(--sapphire-semantic-size-font-control-md); /* 0.875rem */
}

.sapphire-text-field__input {
  box-sizing: border-box;
  width: 100%;
  height: 100%;
  margin: 0;
  padding: 0 var(--sapphire-semantic-size-spacing-control-horizontal-lg);
  line-height: var(--sapphire-semantic-size-line-height-md);
  font-family: inherit;
  font-size: inherit;
  font-weight: var(--sapphire-semantic-font-weight-default-regular);
  color: inherit;
  background: transparent;
  border: none;
  outline: none;
}

.sapphire-text-field__input::placeholder {
  opacity: 1;
  color: var(--sapphire-semantic-color-foreground-secondary);
}

/* Error state */
.sapphire-text-field--error {
  outline-color: var(--sapphire-semantic-color-border-negative-default);
}

/* Focus state */
.sapphire-text-field:focus-within {
  outline: solid var(--sapphire-semantic-size-focus-ring)
    var(--sapphire-semantic-color-focus-ring);
  outline-offset: calc(0px - var(--sapphire-semantic-size-focus-ring));
}

/* Disabled */
.sapphire-text-field:has([disabled]) {
  cursor: not-allowed;
  opacity: var(--sapphire-semantic-opacity-disabled);
}
```

### Usage

```html
<!-- Default (large) -->
<div class="sapphire-text-field">
  <input class="sapphire-text-field__input" type="text" placeholder="Enter value..." />
</div>

<!-- Medium size -->
<div class="sapphire-text-field sapphire-text-field--md">
  <input class="sapphire-text-field__input" type="text" placeholder="Compact..." />
</div>

<!-- Error state -->
<div class="sapphire-text-field sapphire-text-field--error">
  <input class="sapphire-text-field__input" type="text" value="Invalid" />
</div>

<!-- With label -->
<div style="display: flex; flex-direction: column; gap: var(--sapphire-semantic-size-spacing-3xs);">
  <label class="sapphire-text sapphire-text--body-sm">Email</label>
  <div class="sapphire-text-field">
    <input class="sapphire-text-field__input" type="email" placeholder="name@example.com" />
  </div>
</div>
```

---

## Checkbox

```css
.sapphire-checkbox {
  font-family: var(--sapphire-semantic-font-name-default);
  display: inline-flex;
  position: relative;
  max-width: 100%;
  cursor: pointer;
}

.sapphire-checkbox__input {
  margin: 0;
  position: absolute;
  top: 0; left: 0;
  height: 100%; width: 100%;
  opacity: 0.0001;
  z-index: 1;
  cursor: pointer;
}

.sapphire-checkbox__box {
  box-sizing: border-box;
  position: relative;
  width: var(--sapphire-semantic-size-height-box-lg); /* 1.25rem */
  height: var(--sapphire-semantic-size-height-box-lg);
  border-radius: var(--sapphire-semantic-size-radius-sm); /* 4px */
  border: var(--sapphire-semantic-size-border-sm) solid
    var(--sapphire-semantic-color-border-field-default);
  background: var(--sapphire-semantic-color-background-field);
  transition: all 0.1s;
  flex-shrink: 0;
  display: inline-flex;
  justify-content: center;
  align-items: center;
}

.sapphire-checkbox__label {
  margin-left: var(--sapphire-semantic-size-spacing-sm);
  font-size: var(--sapphire-semantic-size-font-control-lg); /* 1rem */
  color: var(--sapphire-semantic-color-foreground-primary);
  line-height: var(--sapphire-semantic-size-height-control-xs);
  display: inline-flex;
  align-items: center;
  -webkit-font-smoothing: antialiased;
}

/* Checked state */
.sapphire-checkbox--checked .sapphire-checkbox__box {
  border-width: 0;
  background: var(--sapphire-semantic-color-background-accent);
}

.sapphire-checkbox__box-icon {
  color: var(--sapphire-semantic-color-foreground-on-accent);
  height: var(--sapphire-semantic-size-height-box-lg);
  width: var(--sapphire-semantic-size-height-box-lg);
}

/* Focus */
.sapphire-checkbox:has(input:focus-visible) .sapphire-checkbox__box {
  outline: var(--sapphire-semantic-size-focus-ring) solid var(--sapphire-semantic-color-focus-ring);
  outline-offset: var(--sapphire-semantic-size-focus-ring);
}

/* Disabled */
.sapphire-checkbox:has(:disabled) {
  opacity: var(--sapphire-semantic-opacity-disabled);
  cursor: not-allowed;
}
```

### Usage

```html
<label class="sapphire-checkbox sapphire-checkbox--checked">
  <input class="sapphire-checkbox__input" type="checkbox" checked />
  <span class="sapphire-checkbox__box">
    <svg class="sapphire-checkbox__box-icon" viewBox="0 0 20 20" fill="none">
      <path d="M5 10l3 3 7-7" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
    </svg>
  </span>
  <span class="sapphire-checkbox__label">Accept terms</span>
</label>
```

---

## Radio

```css
.sapphire-radio {
  display: inline-flex;
  font-family: var(--sapphire-semantic-font-name-default);
  max-width: 100%;
  position: relative;
}

.sapphire-radio__input {
  margin: 0;
  position: absolute;
  top: 0; left: 0;
  height: 100%; width: 100%;
  opacity: 0.0001;
  z-index: 1;
  cursor: pointer;
}

.sapphire-radio__box {
  box-sizing: border-box;
  background-color: var(--sapphire-semantic-color-background-field);
  width: var(--sapphire-semantic-size-height-box-lg); /* 1.25rem */
  height: var(--sapphire-semantic-size-height-box-lg);
  flex-shrink: 0;
  border-radius: 50%;
  border: var(--sapphire-semantic-size-border-sm) solid var(--sapphire-semantic-color-border-field-default);
  margin-top: var(--sapphire-semantic-size-spacing-4xs);
  transition: background-color 0.1s, border-color 0.1s, border-width 0.1s;
}

.sapphire-radio__label {
  margin-left: var(--sapphire-semantic-size-spacing-sm);
  font-size: var(--sapphire-semantic-size-font-control-lg);
  line-height: var(--sapphire-semantic-size-height-control-xs);
  color: var(--sapphire-semantic-color-foreground-primary);
  -webkit-font-smoothing: antialiased;
}

/* Checked: thick colored border creates the filled dot effect */
.sapphire-radio--checked .sapphire-radio__box {
  border-color: var(--sapphire-semantic-color-background-action-primary-default);
  border-width: calc((var(--sapphire-semantic-size-height-box-lg) - 0.5rem) / 2);
  background-color: var(--sapphire-semantic-color-foreground-action-on-select-default);
}

/* Focus */
.sapphire-radio:has(input:focus-visible) .sapphire-radio__box {
  outline: var(--sapphire-semantic-size-focus-ring) solid var(--sapphire-semantic-color-focus-ring);
  outline-offset: var(--sapphire-semantic-size-focus-ring);
}

/* Disabled */
.sapphire-radio:has(:disabled) {
  opacity: var(--sapphire-semantic-opacity-disabled);
  cursor: not-allowed;
}
```

### Usage

```html
<label class="sapphire-radio sapphire-radio--checked">
  <input class="sapphire-radio__input" type="radio" name="option" checked />
  <span class="sapphire-radio__box"></span>
  <span class="sapphire-radio__label">Selected option</span>
</label>

<label class="sapphire-radio">
  <input class="sapphire-radio__input" type="radio" name="option" />
  <span class="sapphire-radio__box"></span>
  <span class="sapphire-radio__label">Other option</span>
</label>
```

---

## Switch

```css
.sapphire-switch {
  display: inline-flex;
  align-items: center;
  position: relative;
  max-width: 100%;
  gap: var(--sapphire-semantic-size-spacing-sm);
}

.sapphire-switch-input {
  margin: 0;
  position: absolute;
  width: 100%; height: 100%;
  top: 0; left: 0;
  opacity: 0.0001;
  z-index: 1;
  cursor: pointer;
}

.sapphire-switch-label {
  display: flex;
  align-items: center;
  font-family: var(--sapphire-semantic-font-name-default);
  font-size: var(--sapphire-semantic-size-font-control-lg);
  line-height: var(--sapphire-semantic-size-height-control-xs);
  color: var(--sapphire-semantic-color-foreground-primary);
  -webkit-font-smoothing: antialiased;
}

/* Track */
.sapphire-switch-track {
  background: var(--sapphire-semantic-color-background-switch-default);
  box-sizing: border-box;
  position: relative;
  width: 2.75rem; /* generic-110 */
  height: var(--sapphire-semantic-size-height-control-xs); /* 1.5rem */
  border-radius: calc(var(--sapphire-semantic-size-height-control-xs) / 2);
  flex-shrink: 0;
  transition: background 0.1s;
}

/* Knob handle */
.sapphire-switch-track::after {
  content: '';
  position: absolute;
  box-sizing: border-box;
  padding: 2px;
  height: 100%;
  aspect-ratio: 1/1;
  border-radius: 50%;
  background: white;
  background-clip: content-box;
  left: 0;
  transition: left 0.1s var(--sapphire-semantic-transitions-dynamic);
}

/* Checked state */
.sapphire-switch-input:checked ~ .sapphire-switch-track {
  background: var(--sapphire-semantic-color-background-accent);
}
.sapphire-switch-input:checked ~ .sapphire-switch-track::after {
  left: calc(100% - var(--sapphire-semantic-size-height-control-xs));
}

/* Focus */
.sapphire-switch:has(input:focus-visible) .sapphire-switch-track {
  outline: var(--sapphire-semantic-size-focus-ring) solid var(--sapphire-semantic-color-focus-ring);
  outline-offset: var(--sapphire-semantic-size-focus-ring);
}

/* Disabled */
.sapphire-switch-input:disabled ~ .sapphire-switch-track,
.sapphire-switch-input:disabled ~ .sapphire-switch-label {
  opacity: var(--sapphire-semantic-opacity-disabled);
}
.sapphire-switch-input:disabled { cursor: not-allowed; }
```

### Usage

```html
<label class="sapphire-switch">
  <input class="sapphire-switch-input" type="checkbox" checked />
  <span class="sapphire-switch-track"></span>
  <span class="sapphire-switch-label">Enable notifications</span>
</label>
```

---

## Select

```css
.sapphire-select {
  position: relative;
  display: block;
  color: var(--sapphire-semantic-color-foreground-primary);
  font-family: var(--sapphire-semantic-font-name-default);
  -webkit-font-smoothing: antialiased;
}

.sapphire-select__button {
  display: flex;
  align-items: center;
  height: var(--sapphire-semantic-size-height-control-lg); /* 3rem */
  box-sizing: border-box;
  cursor: pointer;
  padding: 0 var(--sapphire-semantic-size-spacing-control-horizontal-md) 0
    var(--sapphire-semantic-size-spacing-control-horizontal-lg);
  border: none;
  background: var(--sapphire-semantic-color-background-field);
  width: 100%;
  outline: 0;
  text-align: left;
  color: inherit;
  font-family: inherit;
  box-shadow: inset 0 0 0 var(--sapphire-semantic-size-border-sm)
    var(--sapphire-semantic-color-border-field-default);
  border-radius: var(--sapphire-semantic-size-radius-md);
  gap: var(--sapphire-semantic-size-spacing-sm);
}

.sapphire-select__value {
  flex: 1;
  min-width: 0;
  font-size: var(--sapphire-semantic-size-font-control-lg);
  font-weight: var(--sapphire-semantic-font-weight-default-regular);
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.sapphire-select__placeholder {
  color: var(--sapphire-semantic-color-foreground-secondary);
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.sapphire-select__icon-container {
  width: var(--sapphire-semantic-size-icon-md);
  height: var(--sapphire-semantic-size-icon-md);
  line-height: 0;
}

/* Focus */
.sapphire-select:focus-within .sapphire-select__button {
  box-shadow: inset 0 0 0 var(--sapphire-semantic-size-focus-ring)
    var(--sapphire-semantic-color-focus-ring);
}

/* Error */
.sapphire-select--error .sapphire-select__button {
  box-shadow: inset 0 0 0 1px var(--sapphire-semantic-color-border-negative-default);
}

/* Disabled */
.sapphire-select.is-disabled .sapphire-select__button {
  cursor: not-allowed;
  opacity: var(--sapphire-semantic-opacity-disabled);
}

/* Medium size */
.sapphire-select--md .sapphire-select__button {
  border-radius: var(--sapphire-semantic-size-radius-sm);
  height: var(--sapphire-semantic-size-height-control-md);
  padding: 0 var(--sapphire-semantic-size-spacing-control-horizontal-md);
}
.sapphire-select--md .sapphire-select__value {
  font-size: var(--sapphire-semantic-size-font-control-md);
}
```

### Usage

```html
<div class="sapphire-select">
  <button class="sapphire-select__button" type="button">
    <span class="sapphire-select__value">Selected option</span>
    <span class="sapphire-select__icon-container">
      <svg width="32" height="32" viewBox="0 0 32 32" fill="none"><path d="M16 22L6 12L7.4 10.6L16 19.2L24.6 10.6L26 12L16 22Z" fill="currentColor"/></svg>
    </span>
  </button>
</div>
```
