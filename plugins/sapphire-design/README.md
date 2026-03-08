# Sapphire Design System Plugin for Claude Code

Approximate Danske Bank's Sapphire design system using plain CSS and HTML — no `@danske/sapphire-*` packages required.

## Features

- **Complete design tokens**: Full set of CSS custom properties for colors, spacing, typography, radii, shadows, and control sizes
- **Component patterns**: Ready-to-use CSS class patterns for buttons, text fields, badges, cards, avatars, switches, dialogs, tabs, and more
- **Icon catalog**: 700+ icons as inline SVGs with sizing utilities
- **Framework-agnostic**: Works with React, Vue, Svelte, plain HTML, or any frontend stack
- **Theme support**: Default, secondary, tertiary, and contrast (dark) theme variants

## Installation

```bash
/plugin install sapphire-design@thomas-rohde-plugins
```

## Usage

### Automatic Skill Activation

The skill activates automatically when you:
- Ask to build UI matching the Sapphire or Danske Bank design system
- Mention "sapphire tokens", "sapphire components", or Sapphire-styled UI
- Request banking/fintech UI with Scandinavian design language
- Want to create UI prototypes following the Sapphire visual style

### Quick Start

Every Sapphire-styled page needs two things:

1. **A theme class on a root element** — `class="sapphire-theme-default"` on your `<body>` or root container
2. **The design tokens CSS** — CSS custom properties from the tokens reference

### Example

```html
<body class="sapphire-theme-default sapphire-surface">
  <button class="sapphire-button sapphire-button--primary sapphire-button--lg">
    <span class="sapphire-button__content">Get started</span>
  </button>
</body>
```

## Components

The skill includes patterns for:

| Component | Variants |
|-----------|----------|
| Button | Primary, secondary, tertiary, text, danger (7 variants × 3 sizes) |
| Text Field | Default, medium, multiline, error, prefix/postfix |
| Badge | Neutral + 4 semantic + 16 decorative colors |
| Card | Bordered, elevated |
| Avatar | Small, medium, large + decorative colors |
| Switch/Toggle | Default, checked, disabled |
| Checkbox | Default, checked, disabled |
| Radio | Default, checked, disabled |
| Tabs | Underline tabs with active state |
| Dialog/Modal | 4 sizes with backdrop and animations |
| Select | Dropdown with chevron |
| Alert | Info, success, warning, error |
| Separator | Horizontal, vertical |
| Text | Headings (2xl–xs), body (lg–xs), captions |

## Design Principles

- **Semantic color tokens** — never hardcode colors
- **Pill-shaped buttons** — border-radius equals height
- **Outline-based text fields** — uses `outline` not `border`
- **Focus rings** — 2px solid blue-400 with 2px offset
- **Disabled state** — universal `opacity: 0.3`
- **Spacing scale** — 4xs (0.125rem) to 6xl (4.5rem)

## License

MIT
