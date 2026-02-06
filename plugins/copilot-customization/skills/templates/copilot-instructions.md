# Project Instructions for GitHub Copilot

<!-- TODO: Replace this template with your project-specific instructions -->
<!-- This file is automatically applied to ALL Copilot chat interactions in this workspace -->

## Project Overview

<!-- Describe your project in 2-3 sentences -->
This is a [framework] application using [language] that [purpose].

## Tech Stack

- **Language**: [e.g., TypeScript 5.x]
- **Framework**: [e.g., Next.js 14 with App Router]
- **Styling**: [e.g., Tailwind CSS]
- **Database**: [e.g., PostgreSQL with Drizzle ORM]
- **Testing**: [e.g., Vitest + React Testing Library]
- **Package Manager**: [e.g., pnpm]

## Code Standards

- [e.g., Use functional components with hooks, no class components]
- [e.g., Prefer `async/await` over `.then()` chains]
- [e.g., All exported functions must have JSDoc comments]
- [e.g., Use named exports, not default exports]
- [e.g., Maximum file length: 300 lines]

## Project Structure

```
src/
├── app/          # [describe]
├── components/   # [describe]
├── lib/          # [describe]
├── types/        # [describe]
└── __tests__/    # [describe]
```

## Naming Conventions

- **Files**: kebab-case (e.g., `user-profile.tsx`)
- **Components**: PascalCase (e.g., `UserProfile`)
- **Functions**: camelCase (e.g., `getUserProfile`)
- **Constants**: UPPER_SNAKE_CASE (e.g., `MAX_RETRY_COUNT`)
- **Types/Interfaces**: PascalCase with descriptive suffixes (e.g., `UserProfileProps`)

## Error Handling

<!-- Describe your error handling patterns -->

## Git Conventions

- **Commit format**: Conventional Commits (`type(scope): description`)
- **Branch naming**: `type/description` (e.g., `feat/user-auth`)
- **PR requirements**: [e.g., passing CI, one approval, no merge commits]

## Commands

```bash
# Development
[e.g., pnpm dev]

# Testing  
[e.g., pnpm test]

# Linting
[e.g., pnpm lint]

# Type checking
[e.g., pnpm typecheck]

# Build
[e.g., pnpm build]
```
