# Sapphire Design Tokens

Copy this CSS block into your project to get all Sapphire design tokens. Apply the `.sapphire-theme-default` class to your root element.

## Table of Contents

- [Complete Token Block](#complete-token-block) - Copy-paste ready CSS
- [Color Palette](#color-palette) - Global and semantic colors
- [Spacing](#spacing) - Spacing scale
- [Typography](#typography) - Font sizes, weights, line heights
- [Sizing](#sizing) - Control heights, icon sizes, radii, borders
- [Effects](#effects) - Shadows, opacity, transitions
- [Responsive Overrides](#responsive-overrides) - Breakpoint adjustments

## Complete Token Block

```css
.sapphire-theme-default,
.sapphire-theme--secondary,
.sapphire-theme--tertiary,
.sapphire-theme--contrast {
  /* ===== BREAKPOINTS ===== */
  --sapphire-semantic-size-breakpoint-xl: 1400px;
  --sapphire-semantic-size-breakpoint-lg: 1200px;
  --sapphire-semantic-size-breakpoint-md: 960px;
  --sapphire-semantic-size-breakpoint-sm: 768px;
  --sapphire-semantic-size-breakpoint-xs: 576px;

  /* ===== FONT WEIGHTS ===== */
  --sapphire-semantic-font-weight-default-bold: 600;
  --sapphire-semantic-font-weight-default-medium: 500;
  --sapphire-semantic-font-weight-default-regular: 400;
  --sapphire-semantic-font-weight-default-light: 300;

  /* ===== TRANSITIONS ===== */
  --sapphire-global-transitions-ease-in: cubic-bezier(0, 0, 0, 1);
  --sapphire-global-transitions-ease-in-out-quick: cubic-bezier(0.5, 0, 0, 1);
  --sapphire-global-transitions-ease-in-out: cubic-bezier(0.7, 0, 0.2, 1);
  --sapphire-semantic-transitions-fade: var(--sapphire-global-transitions-ease-in);
  --sapphire-semantic-transitions-dynamic: var(--sapphire-global-transitions-ease-in-out-quick);
  --sapphire-semantic-transitions-standard: var(--sapphire-global-transitions-ease-in-out);

  /* ===== TIMING ===== */
  --sapphire-global-time-2000: 2.00s;
  --sapphire-global-time-1800: 1.80s;
  --sapphire-global-time-1000: 1.00s;
  --sapphire-global-time-400: 0.40s;
  --sapphire-global-time-200: 0.20s;
  --sapphire-global-time-100: 0.10s;
  --sapphire-semantic-time-motion-quick: var(--sapphire-global-time-100);
  --sapphire-semantic-time-motion-default: var(--sapphire-global-time-200);
  --sapphire-semantic-time-motion-slow: var(--sapphire-global-time-400);
  --sapphire-semantic-time-motion-very-slow: var(--sapphire-global-time-1000);
  --sapphire-semantic-time-fade-slow: var(--sapphire-global-time-1800);
  --sapphire-semantic-time-fade-quick: var(--sapphire-global-time-100);
  --sapphire-semantic-time-fade-default: var(--sapphire-global-time-200);

  /* ===== LINE HEIGHTS ===== */
  --sapphire-global-size-line-height-md: 1.5;
  --sapphire-global-size-line-height-sm: 1.3;
  --sapphire-semantic-size-line-height-md: var(--sapphire-global-size-line-height-md);
  --sapphire-semantic-size-line-height-sm: var(--sapphire-global-size-line-height-sm);

  /* ===== FONT SIZES ===== */
  --sapphire-global-size-font-300: 3rem;
  --sapphire-global-size-font-250: 2.5rem;
  --sapphire-global-size-font-200: 2rem;
  --sapphire-global-size-font-175: 1.75rem;
  --sapphire-global-size-font-163: 1.625rem;
  --sapphire-global-size-font-150: 1.5rem;
  --sapphire-global-size-font-125: 1.25rem;
  --sapphire-global-size-font-112: 1.125rem;
  --sapphire-global-size-font-100: 1rem;
  --sapphire-global-size-font-88: 0.875rem;
  --sapphire-global-size-font-75: 0.75rem;
  --sapphire-global-size-font-60: 0.625rem;

  /* Semantic font sizes (mobile-first, overridden at 960px) */
  --sapphire-semantic-size-font-heading-2xl: var(--sapphire-global-size-font-175);
  --sapphire-semantic-size-font-heading-xl: var(--sapphire-global-size-font-150);
  --sapphire-semantic-size-font-heading-lg: var(--sapphire-global-size-font-125);
  --sapphire-semantic-size-font-heading-md: var(--sapphire-global-size-font-125);
  --sapphire-semantic-size-font-heading-sm: var(--sapphire-global-size-font-100);
  --sapphire-semantic-size-font-heading-xs: var(--sapphire-global-size-font-100);
  --sapphire-semantic-size-font-body-lg: var(--sapphire-global-size-font-112);
  --sapphire-semantic-size-font-body-md: var(--sapphire-global-size-font-100);
  --sapphire-semantic-size-font-body-sm: var(--sapphire-global-size-font-88);
  --sapphire-semantic-size-font-body-xs: var(--sapphire-global-size-font-75);
  --sapphire-semantic-size-font-control-lg: var(--sapphire-semantic-size-font-body-md);
  --sapphire-semantic-size-font-control-md: var(--sapphire-semantic-size-font-body-sm);
  --sapphire-semantic-size-font-control-sm: var(--sapphire-semantic-size-font-body-xs);
  --sapphire-semantic-size-font-label-md: var(--sapphire-semantic-size-font-body-sm);
  --sapphire-semantic-size-font-label-sm: var(--sapphire-semantic-size-font-body-xs);
  --sapphire-semantic-font-name-default: 'Danske', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;

  /* ===== GENERIC SIZES (used by spacing, control heights, icons) ===== */
  --sapphire-global-size-generic-200: 5rem;
  --sapphire-global-size-generic-180: 4.5rem;
  --sapphire-global-size-generic-160: 4rem;
  --sapphire-global-size-generic-140: 3.5rem;
  --sapphire-global-size-generic-120: 3rem;
  --sapphire-global-size-generic-110: 2.75rem;
  --sapphire-global-size-generic-100: 2.5rem;
  --sapphire-global-size-generic-80: 2rem;
  --sapphire-global-size-generic-60: 1.5rem;
  --sapphire-global-size-generic-50: 1.25rem;
  --sapphire-global-size-generic-40: 1rem;
  --sapphire-global-size-generic-35: 0.875rem;
  --sapphire-global-size-generic-30: 0.75rem;
  --sapphire-global-size-generic-25: 0.625rem;
  --sapphire-global-size-generic-20: 0.5rem;
  --sapphire-global-size-generic-15: 0.375rem;
  --sapphire-global-size-generic-10: 0.25rem;
  --sapphire-global-size-generic-5: 0.125rem;
  --sapphire-global-size-generic-2: 0.0625rem;
  --sapphire-global-size-generic-0: 0rem;
  --sapphire-global-size-generic-240: 6rem;
  --sapphire-global-size-generic-750: 18.75rem;

  /* Static sizes (px-based, don't scale with rem) */
  --sapphire-global-size-static-60: 24px;
  --sapphire-global-size-static-40: 16px;
  --sapphire-global-size-static-30: 12px;
  --sapphire-global-size-static-20: 8px;
  --sapphire-global-size-static-15: 6px;
  --sapphire-global-size-static-10: 4px;
  --sapphire-global-size-static-5: 2px;
  --sapphire-global-size-static-2: 1px;
  --sapphire-global-size-static-0: 0px;

  /* ===== SPACING SCALE ===== */
  --sapphire-semantic-size-spacing-6xl: var(--sapphire-global-size-generic-180);  /* 4.5rem */
  --sapphire-semantic-size-spacing-5xl: var(--sapphire-global-size-generic-160);  /* 4rem */
  --sapphire-semantic-size-spacing-4xl: var(--sapphire-global-size-generic-120);  /* 3rem */
  --sapphire-semantic-size-spacing-3xl: var(--sapphire-global-size-generic-100);  /* 2.5rem */
  --sapphire-semantic-size-spacing-2xl: var(--sapphire-global-size-generic-80);   /* 2rem */
  --sapphire-semantic-size-spacing-xl: var(--sapphire-global-size-generic-60);    /* 1.5rem */
  --sapphire-semantic-size-spacing-lg: var(--sapphire-global-size-generic-50);    /* 1.25rem */
  --sapphire-semantic-size-spacing-md: var(--sapphire-global-size-generic-40);    /* 1rem */
  --sapphire-semantic-size-spacing-sm: var(--sapphire-global-size-generic-30);    /* 0.75rem */
  --sapphire-semantic-size-spacing-xs: var(--sapphire-global-size-generic-20);    /* 0.5rem */
  --sapphire-semantic-size-spacing-2xs: var(--sapphire-global-size-generic-15);   /* 0.375rem */
  --sapphire-semantic-size-spacing-3xs: var(--sapphire-global-size-generic-10);   /* 0.25rem */
  --sapphire-semantic-size-spacing-4xs: var(--sapphire-global-size-generic-5);    /* 0.125rem */

  /* Container spacing */
  --sapphire-semantic-size-spacing-container-horizontal-md: var(--sapphire-semantic-size-spacing-2xl);
  --sapphire-semantic-size-spacing-container-horizontal-sm: var(--sapphire-semantic-size-spacing-sm);
  --sapphire-semantic-size-spacing-control-horizontal-lg: var(--sapphire-semantic-size-spacing-md);
  --sapphire-semantic-size-spacing-control-horizontal-md: var(--sapphire-semantic-size-spacing-sm);
  --sapphire-semantic-size-spacing-control-vertical-lg: var(--sapphire-semantic-size-spacing-sm);
  --sapphire-semantic-size-spacing-control-vertical-md: var(--sapphire-semantic-size-spacing-xs);
  --sapphire-semantic-size-spacing-control-vertical-sm: var(--sapphire-semantic-size-spacing-3xs);

  /* ===== BORDER RADII ===== */
  --sapphire-semantic-size-radius-2xl: var(--sapphire-global-size-static-40);  /* 16px */
  --sapphire-semantic-size-radius-xl: var(--sapphire-global-size-static-30);   /* 12px */
  --sapphire-semantic-size-radius-lg: var(--sapphire-global-size-static-20);   /* 8px */
  --sapphire-semantic-size-radius-md: var(--sapphire-global-size-static-15);   /* 6px */
  --sapphire-semantic-size-radius-sm: var(--sapphire-global-size-static-10);   /* 4px */
  --sapphire-semantic-size-radius-xs: var(--sapphire-global-size-static-5);    /* 2px */
  --sapphire-semantic-size-radius-popover: var(--sapphire-semantic-size-radius-md);

  /* ===== BORDERS ===== */
  --sapphire-semantic-size-border-md: var(--sapphire-global-size-static-5);  /* 2px - thick borders, focus rings */
  --sapphire-semantic-size-border-sm: var(--sapphire-global-size-static-2);  /* 1px - regular borders */
  --sapphire-semantic-size-focus-ring: var(--sapphire-semantic-size-border-md);

  /* ===== CONTROL HEIGHTS ===== */
  --sapphire-semantic-size-height-control-4xl: var(--sapphire-global-size-generic-200);  /* 5rem */
  --sapphire-semantic-size-height-control-3xl: var(--sapphire-global-size-generic-180);  /* 4.5rem */
  --sapphire-semantic-size-height-control-2xl: var(--sapphire-global-size-generic-160);  /* 4rem */
  --sapphire-semantic-size-height-control-xl: var(--sapphire-global-size-generic-140);   /* 3.5rem */
  --sapphire-semantic-size-height-control-lg: var(--sapphire-global-size-generic-120);   /* 3rem - large buttons, text fields */
  --sapphire-semantic-size-height-control-md: var(--sapphire-global-size-generic-100);   /* 2.5rem - medium buttons */
  --sapphire-semantic-size-height-control-sm: var(--sapphire-global-size-generic-80);    /* 2rem - small buttons, badges */
  --sapphire-semantic-size-height-control-xs: var(--sapphire-global-size-generic-60);    /* 1.5rem - small badges */
  --sapphire-semantic-size-height-control-2xs: var(--sapphire-global-size-generic-50);   /* 1.25rem - checkboxes, radios */
  --sapphire-semantic-size-height-box-lg: var(--sapphire-semantic-size-height-control-2xs);  /* checkbox/radio large */
  --sapphire-semantic-size-height-box-md: var(--sapphire-global-size-generic-40);            /* checkbox/radio medium */

  /* ===== ICON SIZES ===== */
  --sapphire-semantic-size-icon-xl: var(--sapphire-global-size-generic-80);  /* 2rem */
  --sapphire-semantic-size-icon-lg: var(--sapphire-global-size-generic-60);  /* 1.5rem */
  --sapphire-semantic-size-icon-md: var(--sapphire-global-size-generic-50);  /* 1.25rem */
  --sapphire-semantic-size-icon-sm: var(--sapphire-global-size-generic-40);  /* 1rem */

  /* ===== FIELD WIDTHS ===== */
  --sapphire-semantic-size-width-field: var(--sapphire-global-size-generic-750);  /* 18.75rem */

  /* ===== SHADOW ===== */
  --sapphire-global-shadow-md: 0px 0px 0px 1px hsl(212 63% 12% / 0.1) inset, 0px 4px 24px 0px hsl(212 63% 12% / 0.04);
  --sapphire-semantic-shadow-popover: var(--sapphire-global-shadow-md);

  /* ===== OPACITY ===== */
  --sapphire-global-opacity-30: 0.3;
  --sapphire-semantic-opacity-disabled: var(--sapphire-global-opacity-30);

  /* ===== GLOBAL COLORS ===== */
  --sapphire-global-color-white: hsla(0, 0%, 100%, 1);
  --sapphire-global-color-black: hsla(0, 0%, 0%, 1);
  --sapphire-global-color-transparent: hsla(0, 0%, 100%, 0);

  /* Blue scale (primary brand) */
  --sapphire-global-color-blue-950: hsl(210 100% 9%);
  --sapphire-global-color-blue-900: hsl(210 100% 14%);
  --sapphire-global-color-blue-800: hsl(211 100% 21%);
  --sapphire-global-color-blue-700: hsl(211 100% 28%);
  --sapphire-global-color-blue-600: hsl(212 100% 37%);
  --sapphire-global-color-blue-500: hsl(218 92% 49%);
  --sapphire-global-color-blue-400: hsl(216 100% 63%);
  --sapphire-global-color-blue-300: hsl(215 100% 74%);
  --sapphire-global-color-blue-200: hsl(214 100% 83%);
  --sapphire-global-color-blue-100: hsl(214 100% 90%);
  --sapphire-global-color-blue-50: hsl(219 100% 95%);

  /* Gray scale */
  --sapphire-global-color-gray-950: hsl(210 94% 7%);
  --sapphire-global-color-gray-900: hsl(211 64% 13%);
  --sapphire-global-color-gray-800: hsl(213 48% 17%);
  --sapphire-global-color-gray-700: hsl(212 33% 27%);
  --sapphire-global-color-gray-600: hsl(212 27% 35%);
  --sapphire-global-color-gray-500: hsl(211 19% 49%);
  --sapphire-global-color-gray-400: hsl(211 22% 63%);
  --sapphire-global-color-gray-300: hsl(211 22% 77%);
  --sapphire-global-color-gray-200: hsl(210 26% 85%);
  --sapphire-global-color-gray-100: hsl(208 29% 91%);
  --sapphire-global-color-gray-50: hsl(206 33% 96%);

  /* Sand scale (warm neutral) */
  --sapphire-global-color-sand-950: hsl(39 23% 12%);
  --sapphire-global-color-sand-900: hsl(41 23% 18%);
  --sapphire-global-color-sand-800: hsl(43 22% 25%);
  --sapphire-global-color-sand-700: hsl(42 20% 33%);
  --sapphire-global-color-sand-600: hsl(42 20% 40%);
  --sapphire-global-color-sand-500: hsl(43 14% 52%);
  --sapphire-global-color-sand-400: hsl(39 20% 66%);
  --sapphire-global-color-sand-300: hsl(48 20% 75%);
  --sapphire-global-color-sand-200: hsl(48 15% 87%);
  --sapphire-global-color-sand-100: hsl(60 11% 91%);
  --sapphire-global-color-sand-50: hsl(60 9% 96%);

  /* Red scale (negative/error) */
  --sapphire-global-color-red-950: hsl(358 57% 10%);
  --sapphire-global-color-red-900: hsl(1 53% 17%);
  --sapphire-global-color-red-800: hsl(358 55% 27%);
  --sapphire-global-color-red-700: hsl(359 57% 36%);
  --sapphire-global-color-red-600: hsl(359 59% 44%);
  --sapphire-global-color-red-500: hsl(0 65% 51%);
  --sapphire-global-color-red-400: hsl(1 90% 66%);
  --sapphire-global-color-red-300: hsl(1 92% 74%);
  --sapphire-global-color-red-200: hsl(2 100% 84%);
  --sapphire-global-color-red-100: hsl(4 100% 92%);
  --sapphire-global-color-red-50: hsl(0 82% 96%);

  /* Green scale (positive/success) */
  --sapphire-global-color-green-950: hsl(129 42% 9%);
  --sapphire-global-color-green-900: hsl(131 40% 14%);
  --sapphire-global-color-green-800: hsl(128 38% 18%);
  --sapphire-global-color-green-700: hsl(129 41% 23%);
  --sapphire-global-color-green-600: hsl(127 47% 30%);
  --sapphire-global-color-green-500: hsl(125 50% 35%);
  --sapphire-global-color-green-400: hsl(122 39% 49%);
  --sapphire-global-color-green-300: hsl(124 39% 60%);
  --sapphire-global-color-green-200: hsl(124 42% 73%);
  --sapphire-global-color-green-100: hsl(125 46% 84%);
  --sapphire-global-color-green-50: hsl(129 33% 92%);

  /* Yellow scale (warning) */
  --sapphire-global-color-yellow-950: hsl(24 91% 14%);
  --sapphire-global-color-yellow-900: hsl(25 84% 22%);
  --sapphire-global-color-yellow-800: hsl(27 86% 28%);
  --sapphire-global-color-yellow-700: hsl(31 94% 33%);
  --sapphire-global-color-yellow-600: hsl(36 97% 40%);
  --sapphire-global-color-yellow-500: hsl(41 95% 46%);
  --sapphire-global-color-yellow-400: hsl(46 94% 54%);
  --sapphire-global-color-yellow-300: hsl(46 97% 65%);
  --sapphire-global-color-yellow-200: hsl(51 92% 75%);
  --sapphire-global-color-yellow-100: hsl(51 90% 88%);
  --sapphire-global-color-yellow-50: hsl(53 100% 92%);

  /* Secondary palette: Blue */
  --sapphire-global-color-secondary-blue-4: hsl(220 48% 81%);
  --sapphire-global-color-secondary-blue-3: hsl(217 60% 71%);
  --sapphire-global-color-secondary-blue-2: hsl(218 51% 52%);
  --sapphire-global-color-secondary-blue-1: hsl(212 100% 24%);

  /* Secondary palette: Gold */
  --sapphire-global-color-secondary-gold-4: hsl(45 57% 73%);
  --sapphire-global-color-secondary-gold-3: hsl(40 57% 62%);
  --sapphire-global-color-secondary-gold-2: hsl(32 47% 48%);
  --sapphire-global-color-secondary-gold-1: hsl(32 59% 28%);

  /* Secondary palette: Copper */
  --sapphire-global-color-secondary-copper-4: hsl(24 65% 77%);
  --sapphire-global-color-secondary-copper-3: hsl(21 56% 65%);
  --sapphire-global-color-secondary-copper-2: hsl(18 52% 49%);
  --sapphire-global-color-secondary-copper-1: hsl(20 64% 27%);

  /* Secondary palette: Green */
  --sapphire-global-color-secondary-green-4: hsl(132 42% 76%);
  --sapphire-global-color-secondary-green-3: hsl(146 40% 61%);
  --sapphire-global-color-secondary-green-2: hsl(155 50% 43%);
  --sapphire-global-color-secondary-green-1: hsl(158 58% 19%);

  /* Alpha colors (semi-transparent, used for overlays and states) */
  --sapphire-global-color-alpha-blue-500: hsl(215 99% 45% / 0.995);
  --sapphire-global-color-alpha-blue-400: hsl(216 100% 50% / 0.74);
  --sapphire-global-color-alpha-blue-300: hsl(215 100% 50% / 0.513);
  --sapphire-global-color-alpha-blue-200: hsl(214 100% 50% / 0.349);
  --sapphire-global-color-alpha-blue-100: hsl(214 100% 50% / 0.2);
  --sapphire-global-color-alpha-blue-50: hsl(219 100% 50% / 0.091);
  --sapphire-global-color-alpha-gray-900: hsl(211 63% 13% / 0.952);
  --sapphire-global-color-alpha-gray-800: hsl(213 100% 9% / 0.909);
  --sapphire-global-color-alpha-gray-700: hsl(213 100% 11% / 0.819);
  --sapphire-global-color-alpha-gray-600: hsl(212 100% 13% / 0.74);
  --sapphire-global-color-alpha-gray-500: hsl(212 100% 15% / 0.603);
  --sapphire-global-color-alpha-gray-400: hsl(211 100% 18% / 0.455);
  --sapphire-global-color-alpha-gray-300: hsl(211 100% 20% / 0.282);
  --sapphire-global-color-alpha-gray-200: hsl(210 100% 21% / 0.188);
  --sapphire-global-color-alpha-gray-100: hsl(208 98% 23% / 0.114);
  --sapphire-global-color-alpha-gray-50: hsl(206 100% 25% / 0.055);
  --sapphire-global-color-alpha-sand-950: hsl(40 100% 3% / 0.905);
  --sapphire-global-color-alpha-sand-900: hsl(41 100% 5% / 0.858);
  --sapphire-global-color-alpha-sand-500: hsl(43 100% 12% / 0.548);
  --sapphire-global-color-alpha-sand-400: hsl(39 100% 17% / 0.411);
  --sapphire-global-color-alpha-sand-300: hsl(48 100% 17% / 0.294);
  --sapphire-global-color-alpha-sand-200: hsl(48 100% 13% / 0.153);
  --sapphire-global-color-alpha-sand-100: hsl(60 100% 10% / 0.098);
  --sapphire-global-color-alpha-sand-50: hsl(60 100% 10% / 0.043);
  --sapphire-global-color-alpha-red-500: hsl(0 100% 39% / 0.815);
  --sapphire-global-color-alpha-red-400: hsl(1 100% 47% / 0.65);
  --sapphire-global-color-alpha-red-50: hsl(0 98% 45% / 0.079);
  --sapphire-global-color-alpha-green-500: hsl(124 100% 21% / 0.822);
  --sapphire-global-color-alpha-green-400: hsl(122 100% 28% / 0.701);
  --sapphire-global-color-alpha-green-50: hsl(129 100% 25% / 0.11);
  --sapphire-global-color-alpha-yellow-700: hsl(31 100% 32% / 0.979);
  --sapphire-global-color-alpha-yellow-800: hsl(27 100% 25% / 0.959);
  --sapphire-global-color-alpha-yellow-900: hsl(25 100% 19% / 0.963);
  --sapphire-global-color-alpha-yellow-50: hsl(53 100% 50% / 0.161);

  /* ===== SEMANTIC COLORS (Light Theme) ===== */

  /* Foreground */
  --sapphire-semantic-color-foreground-primary: var(--sapphire-global-color-blue-900);
  --sapphire-semantic-color-foreground-secondary: color(from var(--sapphire-global-color-blue-900) xyz x y z / 0.64);
  --sapphire-semantic-color-foreground-accent: var(--sapphire-global-color-alpha-blue-500);
  --sapphire-semantic-color-foreground-negative: var(--sapphire-global-color-alpha-red-500);
  --sapphire-semantic-color-foreground-warning: var(--sapphire-global-color-alpha-yellow-700);
  --sapphire-semantic-color-foreground-positive: var(--sapphire-global-color-alpha-green-500);

  /* Foreground on backgrounds */
  --sapphire-semantic-color-foreground-on-accent: var(--sapphire-global-color-white);
  --sapphire-semantic-color-foreground-on-negative: var(--sapphire-global-color-white);
  --sapphire-semantic-color-foreground-on-positive: var(--sapphire-global-color-white);
  --sapphire-semantic-color-foreground-on-warning: var(--sapphire-global-color-alpha-yellow-900);
  --sapphire-semantic-color-foreground-on-warning-subtle: var(--sapphire-global-color-alpha-yellow-800);
  --sapphire-semantic-color-foreground-on-accent-subtle: var(--sapphire-semantic-color-foreground-accent);
  --sapphire-semantic-color-foreground-on-negative-subtle: var(--sapphire-semantic-color-foreground-negative);
  --sapphire-semantic-color-foreground-on-positive-subtle: var(--sapphire-semantic-color-foreground-positive);
  --sapphire-semantic-color-foreground-on-neutral-subtle: var(--sapphire-semantic-color-foreground-primary);
  --sapphire-semantic-color-foreground-on-signature: var(--sapphire-global-color-white);

  /* Backgrounds */
  --sapphire-semantic-color-background-surface: var(--sapphire-global-color-white);
  --sapphire-semantic-color-background-popover: var(--sapphire-global-color-white);
  --sapphire-semantic-color-background-field: var(--sapphire-global-color-white);
  --sapphire-semantic-color-background-signature: var(--sapphire-global-color-blue-900);
  --sapphire-semantic-color-background-accent: var(--sapphire-global-color-blue-500);
  --sapphire-semantic-color-background-positive: var(--sapphire-global-color-green-500);
  --sapphire-semantic-color-background-warning: var(--sapphire-global-color-yellow-300);
  --sapphire-semantic-color-background-negative: var(--sapphire-global-color-red-500);
  --sapphire-semantic-color-background-accent-subtle: var(--sapphire-global-color-alpha-blue-50);
  --sapphire-semantic-color-background-positive-subtle: var(--sapphire-global-color-alpha-green-50);
  --sapphire-semantic-color-background-warning-subtle: var(--sapphire-global-color-alpha-yellow-50);
  --sapphire-semantic-color-background-negative-subtle: var(--sapphire-global-color-alpha-red-50);
  --sapphire-semantic-color-background-neutral-subtle: var(--sapphire-global-color-alpha-sand-50);

  /* Action backgrounds */
  --sapphire-semantic-color-background-action-primary-default: var(--sapphire-semantic-color-background-accent);
  --sapphire-semantic-color-background-action-secondary-default: var(--sapphire-global-color-alpha-sand-100);
  --sapphire-semantic-color-background-action-tertiary-default: var(--sapphire-global-color-transparent);
  --sapphire-semantic-color-background-action-danger-default: var(--sapphire-semantic-color-background-negative);
  --sapphire-semantic-color-background-action-danger-secondary-default: var(--sapphire-semantic-color-background-negative-subtle);

  /* Action foregrounds */
  --sapphire-semantic-color-foreground-action-on-primary-default: var(--sapphire-semantic-color-foreground-on-accent);
  --sapphire-semantic-color-foreground-action-on-secondary-default: var(--sapphire-semantic-color-foreground-on-neutral-subtle);
  --sapphire-semantic-color-foreground-action-on-tertiary-default: var(--sapphire-semantic-color-foreground-primary);
  --sapphire-semantic-color-foreground-action-on-danger-default: var(--sapphire-semantic-color-foreground-on-negative);
  --sapphire-semantic-color-foreground-action-link-default: var(--sapphire-semantic-color-foreground-accent);
  --sapphire-semantic-color-foreground-action-danger-default: var(--sapphire-semantic-color-foreground-negative);
  --sapphire-semantic-color-foreground-action-select-default: var(--sapphire-semantic-color-foreground-accent);
  --sapphire-semantic-color-foreground-action-on-select-default: var(--sapphire-semantic-color-foreground-on-accent);

  /* Borders */
  --sapphire-semantic-color-border-primary: color(from var(--sapphire-global-color-blue-900) xyz x y z / 0.16);
  --sapphire-semantic-color-border-secondary: color(from var(--sapphire-global-color-blue-900) xyz x y z / 0.08);
  --sapphire-semantic-color-border-tertiary: color(from var(--sapphire-global-color-blue-900) xyz x y z / 0.06);
  --sapphire-semantic-color-border-field-default: color(from var(--sapphire-global-color-blue-900) xyz x y z / 0.48);
  --sapphire-semantic-color-border-negative-default: var(--sapphire-global-color-red-500);
  --sapphire-semantic-color-border-accent: var(--sapphire-global-color-blue-500);

  /* Focus */
  --sapphire-semantic-color-focus-ring: var(--sapphire-global-color-blue-400);

  /* Interaction states */
  --sapphire-semantic-color-state-accent-hover: color(from var(--sapphire-global-color-blue-900) xyz x y z / 0.12);
  --sapphire-semantic-color-state-accent-active: color(from var(--sapphire-global-color-blue-900) xyz x y z / 0.2);
  --sapphire-semantic-color-state-neutral-hover: color(from var(--sapphire-global-color-sand-900) xyz x y z / 0.06);
  --sapphire-semantic-color-state-neutral-active: color(from var(--sapphire-global-color-sand-900) xyz x y z / 0.1);
  --sapphire-semantic-color-state-neutral-ghost-hover: color(from var(--sapphire-global-color-sand-900) xyz x y z / 0.06);
  --sapphire-semantic-color-state-neutral-ghost-active: color(from var(--sapphire-global-color-sand-900) xyz x y z / 0.1);
  --sapphire-semantic-color-state-accent-subtle-hover: color(from var(--sapphire-global-color-blue-500) xyz x y z / 0.06);
  --sapphire-semantic-color-state-accent-subtle-active: color(from var(--sapphire-global-color-blue-500) xyz x y z / 0.12);
  --sapphire-semantic-color-state-negative-hover: color(from var(--sapphire-global-color-red-900) xyz x y z / 0.12);
  --sapphire-semantic-color-state-negative-active: color(from var(--sapphire-global-color-red-900) xyz x y z / 0.2);
  --sapphire-semantic-color-state-negative-subtle-hover: color(from var(--sapphire-global-color-red-500) xyz x y z / 0.06);
  --sapphire-semantic-color-state-negative-subtle-active: color(from var(--sapphire-global-color-red-500) xyz x y z / 0.1);
  --sapphire-semantic-color-state-border-hover: color(from var(--sapphire-global-color-blue-900) xyz x y z / 0.12);
  --sapphire-semantic-color-state-border-active: color(from var(--sapphire-global-color-blue-900) xyz x y z / 0.2);

  /* Decorative (for badges, avatars, etc.) */
  --sapphire-semantic-color-background-decorative-neutral: var(--sapphire-global-color-alpha-sand-50);
  --sapphire-semantic-color-foreground-on-decorative-neutral: var(--sapphire-global-color-blue-900);
  --sapphire-semantic-color-background-decorative-1: var(--sapphire-global-color-secondary-blue-1);
  --sapphire-semantic-color-background-decorative-2: var(--sapphire-global-color-secondary-blue-2);
  --sapphire-semantic-color-background-decorative-3: var(--sapphire-global-color-secondary-blue-3);
  --sapphire-semantic-color-background-decorative-4: var(--sapphire-global-color-secondary-blue-4);
  --sapphire-semantic-color-background-decorative-5: var(--sapphire-global-color-secondary-gold-1);
  --sapphire-semantic-color-background-decorative-6: var(--sapphire-global-color-secondary-gold-2);
  --sapphire-semantic-color-background-decorative-7: var(--sapphire-global-color-secondary-gold-3);
  --sapphire-semantic-color-background-decorative-8: var(--sapphire-global-color-secondary-gold-4);
  --sapphire-semantic-color-background-decorative-9: var(--sapphire-global-color-secondary-copper-1);
  --sapphire-semantic-color-background-decorative-10: var(--sapphire-global-color-secondary-copper-2);
  --sapphire-semantic-color-background-decorative-11: var(--sapphire-global-color-secondary-copper-3);
  --sapphire-semantic-color-background-decorative-12: var(--sapphire-global-color-secondary-copper-4);
  --sapphire-semantic-color-background-decorative-13: var(--sapphire-global-color-secondary-green-1);
  --sapphire-semantic-color-background-decorative-14: var(--sapphire-global-color-secondary-green-2);
  --sapphire-semantic-color-background-decorative-15: var(--sapphire-global-color-secondary-green-3);
  --sapphire-semantic-color-background-decorative-16: var(--sapphire-global-color-secondary-green-4);
}

/* ===== RESPONSIVE OVERRIDES ===== */
@media screen and (min-width: 960px) {
  .sapphire-theme-default,
  .sapphire-theme--secondary,
  .sapphire-theme--tertiary,
  .sapphire-theme--contrast {
    --sapphire-semantic-size-font-heading-sm: var(--sapphire-global-size-font-125);
    --sapphire-semantic-size-font-heading-md: var(--sapphire-global-size-font-150);
    --sapphire-semantic-size-font-heading-lg: var(--sapphire-global-size-font-200);
    --sapphire-semantic-size-font-heading-xl: var(--sapphire-global-size-font-250);
    --sapphire-semantic-size-font-heading-2xl: var(--sapphire-global-size-font-300);
  }
}

@media (prefers-reduced-motion) {
  .sapphire-theme-default,
  .sapphire-theme--secondary,
  .sapphire-theme--tertiary,
  .sapphire-theme--contrast {
    --sapphire-semantic-time-motion-slow: 0.00s;
    --sapphire-semantic-time-motion-default: 0.00s;
    --sapphire-semantic-time-motion-quick: 0.00s;
  }
}
```

## Color Palette

### Simplified Color Reference (Resolved Values)

If you need hardcoded values (e.g. for non-CSS contexts like design tools or email), here are the key resolved colors:

| Token | Role | Value |
|-------|------|-------|
| blue-900 | Primary foreground / brand | `hsl(210 100% 14%)` |
| blue-500 | Accent / links / primary buttons | `hsl(218 92% 49%)` |
| blue-400 | Focus rings | `hsl(216 100% 63%)` |
| blue-50 | Accent subtle bg | `hsl(219 100% 95%)` |
| red-500 | Negative / error | `hsl(0 65% 51%)` |
| green-500 | Positive / success | `hsl(125 50% 35%)` |
| yellow-300 | Warning bg | `hsl(46 97% 65%)` |
| sand-50 | Secondary surface | `hsl(60 9% 96%)` |
| sand-100 | Tertiary surface | `hsl(60 11% 91%)` |
| gray-900 | Dark/contrast surface | `hsl(211 64% 13%)` |
| white | Primary surface | `hsla(0, 0%, 100%, 1)` |

## Spacing

### Quick Reference

| Token | Size |
|-------|------|
| `spacing-4xs` | 0.125rem (2px) |
| `spacing-3xs` | 0.25rem (4px) |
| `spacing-2xs` | 0.375rem (6px) |
| `spacing-xs` | 0.5rem (8px) |
| `spacing-sm` | 0.75rem (12px) |
| `spacing-md` | 1rem (16px) |
| `spacing-lg` | 1.25rem (20px) |
| `spacing-xl` | 1.5rem (24px) |
| `spacing-2xl` | 2rem (32px) |
| `spacing-3xl` | 2.5rem (40px) |
| `spacing-4xl` | 3rem (48px) |
| `spacing-5xl` | 4rem (64px) |
| `spacing-6xl` | 4.5rem (72px) |
