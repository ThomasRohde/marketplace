# Custom Instructions Reference

Custom instructions define coding standards and project context that Copilot applies
automatically. They are the foundation of Copilot customization.

## Types of Instructions

### 1. Always-On Workspace Instructions
**File:** `.github/copilot-instructions.md`

Applied automatically to every chat request in the workspace. Use for:
- Project overview and architecture description
- Coding standards and conventions
- Framework-specific guidelines
- Commit message format
- Naming conventions

```markdown
# Project Instructions

This is a Next.js 14 application using TypeScript and Tailwind CSS.

## Code Standards
- Use functional components with hooks
- Prefer `async/await` over `.then()` chains
- All components must have TypeScript interfaces for props
- Use named exports, not default exports

## Project Structure
- `src/app/` — Next.js App Router pages
- `src/components/` — Reusable UI components
- `src/lib/` — Utility functions and shared logic
- `src/types/` — TypeScript type definitions

## Testing
- Write tests with Vitest and React Testing Library
- Test files go in `__tests__/` directories alongside source
- Minimum 80% coverage for new code
```

### 2. File-Scoped Instructions
**Files:** `.github/instructions/*.instructions.md`

Apply only when working with files matching a glob pattern. Use the `applyTo` frontmatter.

```yaml
---
applyTo: '**/*.tsx'
---
# React Component Guidelines

- Use `React.FC` type for components
- Extract complex logic into custom hooks
- Prefer composition over prop drilling
- Always include aria-labels on interactive elements
```

**Common `applyTo` patterns:**
| Pattern | Matches |
|---------|---------|
| `**/*.ts` | All TypeScript files |
| `**/*.test.*` | All test files |
| `src/api/**` | All files in the API directory |
| `**/*.{css,scss}` | All stylesheet files |
| `Dockerfile*` | All Dockerfiles |
| `*.md` | Markdown files in root only |

### 3. User-Level Instructions
Stored in your VS Code profile, applied across all workspaces. Configure via:
- Command Palette → "Chat: Configure Instructions"
- Settings Sync can share these across devices

Use for personal preferences like:
- Preferred comment style
- Language preferences
- Editor behavior preferences

### 4. Organization-Level Instructions
Defined in the `.github-private` repository at the organization level.
Automatically applied to all repos in the organization.

## Best Practices

1. **Keep it concise** — Copilot has limited context. Prioritize high-impact instructions.
2. **Be specific** — "Use TypeScript strict mode" beats "Write type-safe code"
3. **Include examples** — One code snippet > three paragraphs of description
4. **Structure with headings** — Copilot can find relevant sections faster
5. **Avoid conflicts** — Don't put language-specific rules in the global instructions file
6. **Use file-scoped instructions** for technology-specific rules
7. **Reference other files** with Markdown links: `[API patterns](../docs/api-patterns.md)`

## Special Instruction Contexts

Copilot supports specialized instruction settings for specific actions:

```jsonc
// .vscode/settings.json
{
  // Commit message generation
  "github.copilot.chat.commitMessageGeneration.instructions": [
    { "text": "Use conventional commit format: type(scope): description" },
    { "text": "Use imperative mood: 'Add feature' not 'Added feature'" }
  ],

  // Code review instructions
  "github.copilot.chat.codeGeneration.instructions": [
    { "text": "Always include error handling" },
    { "text": "Add JSDoc comments to public functions" }
  ],

  // Test generation instructions
  "github.copilot.chat.testGeneration.instructions": [
    { "text": "Use describe/it blocks with meaningful names" },
    { "text": "Include edge cases and error scenarios" }
  ]
}
```

## Debugging Instructions

1. Open Chat Debug View: `Ctrl+Shift+P` → "Chat: Open Debug View"
2. Send a chat message
3. Check which instruction files were included in the request
4. Verify `applyTo` patterns match the files you're working with

If instructions are not loading:
- Ensure the file is in the correct location
- Check that `applyTo` glob patterns are correct
- Verify the setting `github.copilot.chat.codeGeneration.useInstructionFiles` is enabled
- Try nudging the LLM: "Don't forget to follow the project instructions"
