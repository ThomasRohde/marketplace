# Sapphire Icons

Sapphire includes 700+ icons as SVGs. All icons use a 32x32 viewBox and `fill="currentColor"` so they inherit the text color of their parent element.

## Table of Contents

- [How to Use Icons](#how-to-use-icons)
- [Icon Sizing](#icon-sizing)
- [Common Icons (SVG)](#common-icons-svg) - Copy-paste ready SVGs for the most frequently used icons
- [Complete Icon Catalog](#complete-icon-catalog) - Full list of all available icon names

## How to Use Icons

### Inline SVG (Recommended)

Drop the SVG directly into your HTML. It inherits color from the parent:

```html
<span style="color: var(--sapphire-semantic-color-foreground-accent); width: 1.25rem; height: 1.25rem; display: inline-flex;">
  <svg width="32" height="32" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg">
    <path d="..." fill="currentColor"/>
  </svg>
</span>
```

### Icon Wrapper

For consistent sizing, wrap icons in a container:

```css
.sapphire-icon {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}
.sapphire-icon svg {
  width: 100%;
  height: 100%;
}
.sapphire-icon--sm { width: var(--sapphire-semantic-size-icon-sm); height: var(--sapphire-semantic-size-icon-sm); } /* 1rem */
.sapphire-icon--md { width: var(--sapphire-semantic-size-icon-md); height: var(--sapphire-semantic-size-icon-md); } /* 1.25rem */
.sapphire-icon--lg { width: var(--sapphire-semantic-size-icon-lg); height: var(--sapphire-semantic-size-icon-lg); } /* 1.5rem */
.sapphire-icon--xl { width: var(--sapphire-semantic-size-icon-xl); height: var(--sapphire-semantic-size-icon-xl); } /* 2rem */
```

```html
<span class="sapphire-icon sapphire-icon--md">
  <svg width="32" height="32" viewBox="0 0 32 32" fill="none">
    <path d="..." fill="currentColor"/>
  </svg>
</span>
```

## Icon Sizing

| Size | Token | Value |
|------|-------|-------|
| sm | `--sapphire-semantic-size-icon-sm` | 1rem (16px) |
| md | `--sapphire-semantic-size-icon-md` | 1.25rem (20px) |
| lg | `--sapphire-semantic-size-icon-lg` | 1.5rem (24px) |
| xl | `--sapphire-semantic-size-icon-xl` | 2rem (32px) |

## Common Icons (SVG)

These are the most frequently used icons. All use `viewBox="0 0 32 32"` and `fill="currentColor"`.

### Navigation

**arrowRight**
```html
<svg width="32" height="32" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M18 6L16.57 7.393L24.15 15H4V17H24.15L16.57 24.573L18 26L28 16L18 6Z" fill="currentColor"/></svg>
```

**arrowLeft**
```html
<svg width="32" height="32" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M14 26L15.43 24.607L7.85 17H28V15H7.85L15.43 7.427L14 6L4 16L14 26Z" fill="currentColor"/></svg>
```

**chevronDown**
```html
<svg width="32" height="32" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M16 22L6 12L7.4 10.6L16 19.2L24.6 10.6L26 12L16 22Z" fill="currentColor"/></svg>
```

**chevronRight**
```html
<svg width="32" height="32" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M22 16L12 26L10.6 24.6L19.2 16L10.6 7.4L12 6L22 16Z" fill="currentColor"/></svg>
```

**chevronLeft**
```html
<svg width="32" height="32" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M10 16L20 6L21.4 7.4L12.8 16L21.4 24.6L20 26L10 16Z" fill="currentColor"/></svg>
```

### Actions

**close**
```html
<svg width="32" height="32" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M17.4141 16L24 9.4141L22.5859 8L16 14.5859L9.4143 8L8 9.4141L14.5859 16L8 22.5859L9.4143 24L16 17.4141L22.5859 24L24 22.5859L17.4141 16Z" fill="currentColor"/></svg>
```

**checkmark**
```html
<svg width="32" height="32" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M13 24.4141L4 15.414L5.414 14L13 21.5851L26.586 8L28 9.414L13 24.4141Z" fill="currentColor"/></svg>
```

**search**
```html
<svg width="32" height="32" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M29 27.5862L21.4478 20.034C23.2626 17.8554 24.1676 15.061 23.9744 12.2322C23.7814 9.4033 22.505 6.75782 20.411 4.846C18.3171 2.9342 15.5667 1.90327 12.732 1.96769C9.8973 2.0321 7.19656 3.1869 5.19162 5.19186C3.18666 7.1968 2.03186 9.89754 1.96745 12.7322C1.90303 15.5669 2.93396 18.3173 4.84576 20.4114C6.75758 22.5052 9.40306 23.7816 12.2319 23.9746C15.0608 24.1678 17.8552 23.2628 20.0338 21.4482L27.5858 29.0002L29 27.5862ZM4 13.0002C4 11.2202 4.52784 9.48014 5.51676 8.0001C6.5057 6.52006 7.9113 5.3665 9.55584 4.68532C11.2004 4.00414 13.01 3.8259 14.7558 4.17316C16.5016 4.52044 18.1053 5.3776 19.364 6.63628C20.6226 7.89494 21.4798 9.4986 21.827 11.2444C22.1744 12.9903 21.996 14.7999 21.315 16.4444C20.6338 18.0889 19.4802 19.4945 18.0001 20.4834C16.5201 21.4724 14.78 22.0002 13 22.0002C10.6139 21.9976 8.3262 21.0486 6.63896 19.3613C4.9517 17.674 4.00264 15.3864 4 13.0002Z" fill="currentColor"/></svg>
```

**add**
```html
<svg width="32" height="32" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M17 15V8H15V15H8V17H15V24H17V17H24V15H17Z" fill="currentColor"/></svg>
```

**edit**
```html
<svg width="32" height="32" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M2 26H30V28H2V26ZM25.4 9.00001C25.8 8.60001 25.8 8.00001 25.4 7.60001L22.4 4.60001C22.2 4.40001 21.9 4.30001 21.7 4.30001C21.5 4.30001 21.2 4.40001 21 4.60001L4 21.6V26H8.4L25.4 9.00001ZM21.7 6.70001L25.3 10.3L22.7 12.9L19.1 9.30001L21.7 6.70001ZM6 24V20.4L17.7 8.70001L21.3 12.3L9.6 24H6Z" fill="currentColor"/></svg>
```

**delete** (trash can)
```html
<svg width="32" height="32" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M12 12H14V24H12V12Z" fill="currentColor"/><path d="M18 12H20V24H18V12Z" fill="currentColor"/><path d="M4 6V8H6V28C6 28.5304 6.21071 29.0391 6.58579 29.4142C6.96086 29.7893 7.46957 30 8 30H24C24.5304 30 25.0391 29.7893 25.4142 29.4142C25.7893 29.0391 26 28.5304 26 28V8H28V6H4ZM8 28V8H24V28H8Z" fill="currentColor"/><path d="M12 2H20V4H12V2Z" fill="currentColor"/></svg>
```

### Status

**information**
```html
<svg width="32" height="32" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M17 22V14H13V16H15V22H12V24H20V22H17Z" fill="currentColor"/><path d="M16 8C15.7033 8 15.4133 8.088 15.1667 8.2528C14.92 8.4176 14.7277 8.6519 14.6142 8.926C14.5006 9.2001 14.4709 9.5017 14.5288 9.7926C14.5867 10.0836 14.7296 10.3509 14.9393 10.5607C15.1491 10.7704 15.4164 10.9133 15.7074 10.9712C15.9983 11.0291 16.2999 10.9994 16.574 10.8858C16.8481 10.7723 17.0824 10.58 17.2472 10.3334C17.412 10.0867 17.5 9.7967 17.5 9.5C17.5 9.1022 17.342 8.7206 17.0607 8.4393C16.7794 8.158 16.3978 8 16 8Z" fill="currentColor"/><path d="M16 30C13.2311 30 10.5243 29.1789 8.22202 27.6406C5.91973 26.1022 4.12532 23.9157 3.06569 21.3576C2.00607 18.7994 1.72882 15.9845 2.26901 13.2687C2.80921 10.553 4.14258 8.0584 6.10051 6.1005C8.05845 4.14258 10.553 2.8092 13.2687 2.269C15.9845 1.72882 18.7994 2.00606 21.3576 3.06569C23.9157 4.12532 26.1022 5.91973 27.6406 8.22202C29.1789 10.5243 30 13.2311 30 16C30 19.713 28.525 23.274 25.8995 25.8995C23.274 28.525 19.713 30 16 30ZM16 4C13.6266 4 11.3066 4.7038 9.33316 6.0224C7.35977 7.3409 5.8217 9.2151 4.91345 11.4078C4.0052 13.6005 3.76756 16.0133 4.23058 18.3411C4.69361 20.6689 5.83649 22.8071 7.51472 24.4853C9.19296 26.1635 11.3312 27.3064 13.6589 27.7694C15.9867 28.2324 18.3995 27.9948 20.5922 27.0866C22.7849 26.1783 24.6591 24.6402 25.9776 22.6668C27.2962 20.6935 28 18.3734 28 16C28 12.8174 26.7357 9.7652 24.4853 7.5147C22.2349 5.2643 19.1826 4 16 4Z" fill="currentColor"/></svg>
```

**warning**
```html
<svg width="32" height="32" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M16 2C8.3 2 2 8.3 2 16C2 23.7 8.3 30 16 30C23.7 30 30 23.7 30 16C30 8.3 23.7 2 16 2ZM16 28C9.4 28 4 22.6 4 16C4 9.4 9.4 4 16 4C22.6 4 28 9.4 28 16C28 22.6 22.6 28 16 28Z" fill="currentColor"/><path d="M15 8H17V19H15V8Z" fill="currentColor"/><path d="M16 22C15.7033 22 15.4133 22.088 15.1667 22.2528C14.92 22.4176 14.7277 22.652 14.6142 22.926C14.5007 23.2001 14.4709 23.5017 14.5288 23.7926C14.5867 24.0836 14.7296 24.3509 14.9393 24.5607C15.1491 24.7704 15.4164 24.9133 15.7074 24.9712C15.9983 25.0291 16.2999 24.9994 16.574 24.8858C16.8481 24.7723 17.0824 24.58 17.2472 24.3334C17.412 24.0867 17.5 23.7967 17.5 23.5C17.5 23.1022 17.342 22.7206 17.0607 22.4393C16.7794 22.158 16.3978 22 16 22Z" fill="currentColor"/></svg>
```

**error**
```html
<svg width="32" height="32" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M16 2C8.2 2 2 8.2 2 16C2 23.8 8.2 30 16 30C23.8 30 30 23.8 30 16C30 8.2 23.8 2 16 2ZM16 28C9.4 28 4 22.6 4 16C4 9.4 9.4 4 16 4C22.6 4 28 9.4 28 16C28 22.6 22.6 28 16 28Z" fill="currentColor"/><path d="M21.4141 23L16 17.5859L10.5859 23L9 21.4141L14.4141 16L9 10.5859L10.5859 9L16 14.4141L21.4141 9L23 10.5859L17.5859 16L23 21.4141L21.4141 23Z" fill="currentColor"/></svg>
```

### Common UI

**user**
```html
<svg width="32" height="32" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M16 4C13.7909 4 12 5.7909 12 8V11C12 13.2091 13.7909 15 16 15C18.2091 15 20 13.2091 20 11V8C20 5.7909 18.2091 4 16 4ZM14 8C14 6.8954 14.8954 6 16 6C17.1046 6 18 6.8954 18 8V11C18 12.1046 17.1046 13 16 13C14.8954 13 14 12.1046 14 11V8Z" fill="currentColor"/><path d="M26 30H24V25C24 23.9391 23.5786 22.9217 22.8284 22.1716C22.0783 21.4214 21.0609 21 20 21H12C10.9391 21 9.9217 21.4214 9.1716 22.1716C8.4214 22.9217 8 23.9391 8 25V30H6V25C6 23.4087 6.6321 21.8826 7.7574 20.7574C8.8826 19.6321 10.4087 19 12 19H20C21.5913 19 23.1174 19.6321 24.2426 20.7574C25.3679 21.8826 26 23.4087 26 25V30Z" fill="currentColor"/></svg>
```

**settings** (gear)
```html
<svg width="32" height="32" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M27 16.76V16V15.24L29.47 13.65C29.74 13.48 29.82 13.13 29.65 12.86L27.27 8.79C27.17 8.64 27.01 8.55 26.83 8.55C26.76 8.55 26.68 8.57 26.61 8.6L23.76 9.72C23.23 9.31 22.67 8.96 22.05 8.68L21.62 5.62C21.58 5.32 21.32 5.1 21.01 5.1H16.25C15.94 5.1 15.68 5.32 15.64 5.62L15.21 8.69C14.6 8.97 14.04 9.32 13.51 9.73L10.65 8.6C10.58 8.57 10.5 8.55 10.43 8.55C10.25 8.55 10.09 8.64 9.99 8.79L7.61 12.86C7.44 13.13 7.52 13.48 7.79 13.65L10.26 15.24V16V16.76L7.79 18.35C7.52 18.52 7.44 18.87 7.61 19.14L9.99 23.21C10.09 23.36 10.25 23.45 10.43 23.45C10.5 23.45 10.58 23.43 10.65 23.4L13.5 22.27C14.03 22.68 14.59 23.03 15.21 23.31L15.64 26.38C15.68 26.68 15.94 26.9 16.25 26.9H21.01C21.32 26.9 21.58 26.68 21.62 26.38L22.05 23.31C22.67 23.03 23.22 22.68 23.75 22.27L26.61 23.4C26.68 23.43 26.76 23.45 26.83 23.45C27.01 23.45 27.17 23.36 27.27 23.21L29.65 19.14C29.82 18.87 29.74 18.52 29.47 18.35L27 16.76ZM25.15 17.5L25.64 17.82L27.68 19.14L26.34 21.55L23.92 20.56L23.37 20.33L22.91 20.68C22.44 21.04 21.93 21.35 21.38 21.59L20.82 21.84L20.72 22.45L20.35 24.9H17.68L17.31 22.45L17.21 21.84L16.65 21.59C16.1 21.35 15.59 21.04 15.12 20.68L14.66 20.33L14.11 20.56L11.69 21.55L10.35 19.14L12.39 17.82L12.88 17.5L12.84 16.92C12.82 16.62 12.8 16.32 12.8 16C12.8 15.68 12.82 15.38 12.84 15.08L12.88 14.5L12.39 14.18L10.35 12.86L11.69 10.45L14.11 11.44L14.66 11.67L15.12 11.32C15.59 10.96 16.1 10.65 16.65 10.41L17.21 10.16L17.31 9.55L17.68 7.1H20.35L20.72 9.55L20.82 10.16L21.38 10.41C21.93 10.65 22.44 10.96 22.91 11.32L23.37 11.67L23.92 11.44L26.34 10.45L27.68 12.86L25.64 14.18L25.15 14.5L25.19 15.08C25.21 15.38 25.23 15.68 25.23 16C25.23 16.32 25.21 16.62 25.19 16.92L25.15 17.5Z" fill="currentColor"/><path d="M18.63 12C16.42 12 14.63 13.79 14.63 16C14.63 18.21 16.42 20 18.63 20C20.84 20 22.63 18.21 22.63 16C22.63 13.79 20.84 12 18.63 12ZM18.63 18C17.53 18 16.63 17.1 16.63 16C16.63 14.9 17.53 14 18.63 14C19.73 14 20.63 14.9 20.63 16C20.63 17.1 19.73 18 18.63 18Z" fill="currentColor"/></svg>
```

**notification** (bell)
```html
<svg width="32" height="32" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M28.7071 19.293L26 16.5859V13C25.9971 10.615 25.0691 8.3284 23.4154 6.6383C21.7617 4.9482 19.4965 3.9713 17.1133 3.918C14.73 3.8647 12.4252 4.7395 10.7015 6.3534C8.97776 7.9672 7.9707 10.1902 7.88 12.572L7 12.572V12.584L7 16.586L4.29297 19.293C4.10553 19.4805 4.00021 19.7348 4 20V23C4 23.2652 4.10536 23.5196 4.29289 23.7071C4.48043 23.8946 4.73478 24 5 24H11V24.777C10.9782 25.9405 11.3671 27.073 12.0975 27.9781C12.8279 28.8833 13.854 29.5028 14.9967 29.7264C16.1395 29.9499 17.3249 29.763 18.3397 29.1988C19.3545 28.6345 20.1323 27.7278 20.537 26.639C20.6359 26.39 20.6308 26.1132 20.523 25.8679C20.4151 25.6226 20.2131 25.4297 19.963 25.333C19.7129 25.2363 19.436 25.2435 19.1914 25.3534C18.9468 25.4632 18.7553 25.667 18.66 25.918C18.4469 26.4876 18.0393 26.9627 17.5076 27.2597C16.976 27.5568 16.3552 27.6566 15.7568 27.5419C15.1584 27.4272 14.6218 27.1049 14.2404 26.633C13.859 26.1611 13.6572 25.5698 13.672 24.964L13.682 24.573L13.682 24H27C27.2652 24 27.5196 23.8946 27.7071 23.7071C27.8946 23.5196 28 23.2652 28 23V20C28 19.7348 27.8946 19.4805 27.7071 19.293ZM26 22H6V20.414L8.70703 17.707C8.89447 17.5195 8.99979 17.2652 9 17V13C9 11.022 9.78203 9.1296 11.172 7.7398C12.562 6.35 14.454 5.568 16.432 5.568C18.41 5.5679 20.302 6.35 21.692 7.7398C23.082 9.1296 23.864 11.022 23.864 13L24 13V17C24 17.2652 24.1054 17.5196 24.293 17.707L26 19.414V22Z" fill="currentColor"/></svg>
```

**home**
```html
<svg width="32" height="32" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M16.6123 2.2138C16.4379 2.0769 16.222 2.0029 15.9998 2.0029C15.7775 2.0029 15.5616 2.0769 15.3873 2.2138L2 12.7098L3.2256 14.2901L5 12.8897V28.0001H13V18.0001H19V28.0001H27V12.8897L28.7744 14.2901L30 12.7098L16.6123 2.2138ZM25 26.0001H21V16.0001H11V26.0001H7V11.3091L16 4.2901L25 11.3091V26.0001Z" fill="currentColor"/></svg>
```

**calendar**
```html
<svg width="32" height="32" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M26 4H22V2H20V4H12V2H10V4H6C4.9 4 4 4.9 4 6V26C4 27.1 4.9 28 6 28H26C27.1 28 28 27.1 28 26V6C28 4.9 27.1 4 26 4ZM26 26H6V12H26V26ZM26 10H6V6H10V8H12V6H20V8H22V6H26V10Z" fill="currentColor"/></svg>
```

**download**
```html
<svg width="32" height="32" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M26 24V28H6V24H4V28C4 28.5304 4.21071 29.0391 4.58579 29.4142C4.96086 29.7893 5.46957 30 6 30H26C26.5304 30 27.0391 29.7893 27.4142 29.4142C27.7893 29.0391 28 28.5304 28 28V24H26Z" fill="currentColor"/><path d="M26 14L24.59 12.59L17 20.17V2H15V20.17L7.41 12.59L6 14L16 24L26 14Z" fill="currentColor"/></svg>
```

**filter**
```html
<svg width="32" height="32" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M18 28H14V18L4 6H28L18 18V28ZM7.10144 8L15.8994 18.3137L16 18.4386V26H16.0026L16.0906 18.4076L24.8986 8H7.10144Z" fill="currentColor"/></svg>
```

**copy**
```html
<svg width="32" height="32" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M28 10V28H10V10H28ZM28 8H10C9.46957 8 8.96086 8.21071 8.58579 8.58579C8.21071 8.96086 8 9.46957 8 10V28C8 28.5304 8.21071 29.0391 8.58579 29.4142C8.96086 29.7893 9.46957 30 10 30H28C28.5304 30 29.0391 29.7893 29.4142 29.4142C29.7893 29.0391 30 28.5304 30 28V10C30 9.46957 29.7893 8.96086 29.4142 8.58579C29.0391 8.21071 28.5304 8 28 8Z" fill="currentColor"/><path d="M4 18H2V4C2 3.46957 2.21071 2.96086 2.58579 2.58579C2.96086 2.21071 3.46957 2 4 2H18V4H4V18Z" fill="currentColor"/></svg>
```

## Complete Icon Catalog

Below is the full list of every icon name available. Use the naming convention to construct SVG file references or understand what's available:

### A
accessibility, activity, add, addAlt, addComment, addFilled, addLarge, agricultureAnalytics, airplay, airplayFilled, airport, alarm, alarmAdd, alarmSubtract, alignBoxBottomCenter, alignBoxBottomLeft, alignBoxBottomRight, alignBoxMiddleCenter, alignBoxMiddleLeft, alignBoxMiddleRight, alignBoxTopCenter, alignBoxTopLeft, alignBoxTopRight, alignHorizontalCenter, alignHorizontalLeft, alignHorizontalRight, alignVerticalBottom, alignVerticalCenter, alignVerticalTop, analytics, aperture, api, apple, apps, archive, arrival, arrowDown, arrowDownLeft, arrowDownRight, arrowLeft, arrowRight, arrowShiftDown, arrowUp, arrowUpLeft, arrowUpRight, arrowsHorizontal, arrowsVertical, asterisk, async, at, attachment, audioConsole

### B
badge, ban, bank, bar, barcode, basketball, bat, batteryCharging, batteryEmpty, batteryFull, batteryHalf, batteryLow, batteryQuarter, beta, bicycle, binoculars, blockchain, blog, bluetooth, bluetoothOff, book, bookmark, bookmarkAdd, bookmarkFilled, bookmarkMultiple, bookmarkOff, boot, borderBottom, borderFull, borderLeft, borderNone, borderRight, borderTop, bot, bottles, box, branch, breakingChange, briefcase, briefcaseOff, brightnessContrast, bringForward, bringToFront, building, bullhorn, buoy, bus, buttonCentered, buttonFlushLeft

### C
cafe, calculation, calculator, calculatorCheck, calendar, calendarHeatMap, camera, campsite, car, carFront, card, cardATM, cardOff, caretDown, caretLeft, caretRight, caretUp, carouselHorizontal, carouselVertical, catalog, categories, centerCircle, certificate, characterDecimal, characterFraction, characterInteger, characterLowercase, characterSentenceCase, characterUppercase, characterWholeNumber, chargingStation, chargingStationFilled, chartArea, chartAverage, chartBar, chartBubble, chartBullet, chartCandlestick, chartColumn, chartCombo, chartHistogram, chartLine, chartLineData, chartMultitype, chartParallel, chartPie, chartRadar, chartRadial, chartRing, chartRiver, chartVennDiagram, chat, chatBot, checkbox, checkboxChecked, checkboxCheckedFilled, checkboxIndeterminate, checkboxIndeterminateFilled, checkmark, checkmarkFilled, checkmarkOutline, chemistry, chevronDown, chevronDownOutline, chevronLeft, chevronRight, chevronUp, chevronUpOutline, chip, choices, circleFill, circleStroke, clean, clipboard, close, closeFilled, closeLarge, closeOutline, closedCaption, closedCaptionAlt, closedCaptionFilled, cloud, cloudDownload, cloudOffline, cloudUpload, co2, code, codeOff, cognitive, collaborate, colorPalette, colorSwitch, column, columnDelete, columnInsert, compare, compass, connectionSignal, connectionSignalOff, construction, continue, continueFilled, contrast, cookie, copy, copyFile, corn, corner, coronavirus, cough, course, credentials, crop, cropGrowth, crossReference, csv, currency, currencyBaht, currencyDollar, currencyEuro, currencyLira, currencyPound, currencyRuble, currencyRupee, currencyShekel, currencyWon, currencyYen, cursor, customer, customerService, cut, cutOut, cyclist

### D-E
dark, darkFilled, dashboard, dataAnalytics, dataDefinition, dataError, dataTable, dataView, database, debug, decisionTree, delete, delivery, deliveryParcel, deliveryTruck, demo, departure, deskAdjustable, development, devices, diagram, diamondFill, diamondOutline, distributeHorizontalCenter, distributeHorizontalLeft, distributeHorizontalRight, distributeVerticalBottom, distributeVerticalCenter, distributeVerticalTop, dna, doc, document, documentAdd, documentAudio, documentBlank, documentDownload, documentExport, documentImport, documentMultiple, documentPDF, documentProtected, documentSecurity, documentSentiment, documentSigned, documentSketch, documentSubtract, documentTasks, documentUnknown, documentUnprotected, documentVideo, documentView, documentWordProcessor, dogWalker, dotMark, downToBottom, download, downloadStudy, dragHorizontal, dragVertical, draggable, draw, drinks, drone, dropPhoto, dropPhotoFilled, drought, earth, earthAmericas, earthAmericasFilled, earthEuropeAfrica, earthEuropeAfricaFilled, earthFilled, earthSoutheastAsia, earthSoutheastAsiaFilled, earthquake, edit, editAlt, education, email, emailNew, energyRenewable, enterprise, equalizer, erase, error, errorFilled, errorOther, event, eventSchedule, events, exit, explore, export, eyedropper

### F-H
faceDissatisfied, faceDissatisfiedFilled, faceMask, faceNeutral, faceNeutralFilled, faceSatisfied, faceSatisfiedFilled, favorite, favoriteFilled, favoriteHalf, filter, filterEdit, filterRemove, filterReset, fingerprintRecognition, fire, fish, fishMultiple, flag, flagFilled, flash, flashFilled, flashOff, flashOffFilled, flood, floorplan, flow, fog, folder, folderAdd, folderDetails, folderMoveTo, folderMultiple, folderOff, folderShared, fork, forum, forward10, forward30, forward5, fragile, friendship, fruitBowl, functionMath, gameConsole, genderFemale, genderMale, generatePDF, gif, gift, globe, gradient, grid, group, groupObjects, groupObjectsNew, groupObjectsSave, hail, handCaringCross, harbor, hashtag, haze, headphones, headset, headstone, healthCross, hearing, heatMap, helicopter, help, helpDesk, helpFilled, home, horizontalView, hospital, hospitalBed, hotel, hourglass, houseFlatRoof, html, http, humidity

### I-L
idea, identification, image, imageCopy, imageMedical, imageSearch, importExport, inProgress, industry, infinitySymbol, information, informationFilled, informationOff, ip, jpg, json, keepDry, keyboard, keyboardOff, label, language, laptop, lasso, lassoPolygon, launch, layers, legend, letterAa-letterZz (full alphabet), license, licenseGlobal, licenseThirdParty, lifesaver, light, lightFilled, link, list, listBoxes, listBulleted, listChecked, listCheckedMirror, listNumbered, listNumberedMirror, location, locked, login, logout, loop

### M-P
macCommand, macOption, macShift, magicWand, magicWandFilled, mailAll, mailReply, maximize, mediaCast, mediaLibrary, mediaLibraryFilled, medication, medicationAlert, medicationReminder, menu, meter, microphone, microphoneFilled, microphoneOff, microphoneOffFilled, microscope, minimize, mobile, mobileAudio, mobileLandscape, mobileViewOrientation, money, monster, mountain, mov, move, movement, mp3, mp4, music, need, network, nextFilled, nextOutline, noImage, noTicket, nonCertified, noodleBowl, notSent, notSentFilled, notebook, notification, notificationFilled, notificationNew, notificationOff, notificationOffFilled, number0-number9, numberSmall0-numberSmall9, numpad, omega, opacity, openPanelBottom/Filled/Left/Right/Top, outage, overflowMenuHorizontal, overflowMenuVertical, pageBreak, pageFirst, pageLast, pageNumber, paintBrush, paintBrushAlt, palmTree, panelExpansion, paragraph, parameter, partlyCloudy, partlyCloudyNight, partnership, password, paste, pause, pauseFilled, pauseOutline, pauseOutlineFilled, pdf, pen, penFountain, percentage, percentageFilled, person, personChild, personFamily, pest, phone, phoneFilled, phoneIp, phoneOff, phoneOffFilled, phraseSentiment, piggyBank, piggyBankSlot, pills, pillsAdd, pillsSubtract, pin, pinFilled, pinFilledOff, pinOff, placeholder, plan, planeSea, play, playFilled, playFilledAlt, playOutline, playOutlineFilled, playlist, plug, plugFilled, png, police, policy, popup, power, ppt, presentationFile, previousFilled, previousOutline, printer, product

### Q-S
qrCode, query, queryQueue, quotes, radar, radio, radioButton, radioButtonChecked, rain, rainScattered, rainScatteredNight, receipt, recentlyViewed, recording, recordingFilled, recycle, redo, reflectHorizontal, reflectVertical, reminder, reminderMedical, renew, repeat, repeatOne, reply, replyAll, report, reportData, reset, restart, restaurant, result, resultDraft, resultNew, resultOld, retryFailed, return, review, rewind10, rewind30, rewind5, roadmap, rocket, rotate, rotateClockwise, rotateCounterclockwise, row, rowCollapse, rowDelete, rowExpand, rowInsert, rule, ruleCancelled, ruleFilled, ruleLocked, ruler, rulerAlt, running, sack, sailboat, salesOps, sankeyDiagram, satellite, satelliteRadar, save, scale, scales, scalesTipped, scalpel, scanAlt, scooter, screen, screenOff, script, sdk, search, security, seeing, select01, select02, send, sendBackward, sendFilled, sendToBack, serviceDesk, serviceLevels, settings, settingsAdjust, shapeExcept, shapeExclude, shapeIntersect, shapeJoin, shapeUnite, share, shield, shoppingBag, shoppingCart, shoppingCartArrowDown, shoppingCartArrowUp, shoppingCartClear, shoppingCartError, shoppingCartMinus, shoppingCartPlus, showDataCards, shuffle, shuttle, sidePanelClose, sidePanelCloseFilled, sidePanelOpen, sidePanelOpenFilled, sigma, signalStrength, simCard, skillLevel, skillLevelAdvanced, skillLevelBasic, skillLevelIntermediate, skipBack, skipForward, snow, soccer, sortAscending, sortDescending, sortRemove, speaking, spellCheck, splitScreen, sprayPaint, sprout, sql, squareOutline, stamp, star, starFilled, starHalf, stayInside, stethoscope, stop, stopFilled, stopFilledAlt, stopOutline, stopOutlineFilled, store, strawberry, stroller, subtract, subtractAlt, subtractFilled, subtractLarge, sustainability, svg, swim, switcher

### T-Z
table, tableOfContents, tableSplit, tablet, tabletLandscape, tag, tagEdit, tagMultiple, tagNone, task, taskComplete, taste, temperatureCelsius, temperatureFahrenheit, template, tennis, tennisBall, terminal, textAlignCenter, textAlignJustify, textAlignLeft, textAlignMixed, textAlignRight, textAllCaps, textBold, textClearFormat, textColor, textCreation, textFill, textFont, textFootnote, textHighlight, textIndent, textIndentLess, textIndentMore, textItalic, textKerning, textLeading, textLineSpacing, textLongParagraph, textNewLine, textScale, textSelection, textShortParagraph, textSmallCaps, textStrikethrough, textSubscript, textSuperscript, textTracking, textUnderline, textVerticalAlignment, textWrap, theater, thisSideUp, thumbsDown, thumbsDownFilled, thumbsUp, thumbsUpFilled, thunderstorm, ticket, tif, time, timeFilled, timer, toolBox, toolKit, toolsAlt, touch, touchFilled, trafficIncident, train, trainProfile, tram, transgender, translate, transmissionLte, trashCan, tray, tree, trendingDown, trendingUp, trolley, trophy, trophyFilled, tshirt, txt, umbrella, undo, ungroupObjects, unknown, unknownFilled, unlink, unlocked, unsaved, upToTop, updateNow, upgrade, upload, url, usb, user, userAccess, userAccessLocked, userAccessUnlocked, userActivity, userAdd, userAdmin, userAvatar, userAvatarFilled, userFeedback, userFilled, userMultiple, userSettings, userSpeaker, userXray, version, versionMajor, versionMinor, versionPatch, verticalView, video, videoFilled, videoOff, videoOffFilled, videoPlayer, videoPlayerMultiple, view, viewFilled, viewMode1, viewMode2, viewNext, viewOff, viewOffFilled, voicemail, volumeDown, volumeDownFilled, volumeMute, volumeMuteFilled, volumeUp, volumeUpFilled, vpn, wallet, warning, warningFilled, warningMultiple, watch, wheat, wifi, wifiOff, wikis, windPower, windy, wordCloud, workspace, wrench, xls, xml, zip, zoomArea, zoomFit, zoomIn, zoomOut

### Flags (200+)
All country flags are available with the prefix `flag_` followed by the country name in camelCase. Examples: `flag_denmark`, `flag_unitedStatesOfAmerica`, `flag_germany`, `flag_unitedKingdom`, `flag_norway`, `flag_sweden`, `flag_finland`, `flag_europeanUnion`.

### Brand Logos
logoAngular, logoAppStore, logoApple, logoDiscord, logoFacebook, logoFigma, logoGithub, logoGitlab, logoInstagram, logoLinkedin, logoLinux, logoNPM, logoPinterest, logoPython, logoReact, logoSlack, logoSnapchat, logoSvelte, logoTikTok, logoVisa, logoVue, logoX, logoYoutube, and more.
