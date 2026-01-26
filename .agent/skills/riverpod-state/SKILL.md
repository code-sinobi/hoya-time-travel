---
name: riverpod-state
description: Manages application state using Riverpod 3 with code generation. Use when creating providers, async logic, or stateful features.
---

# Riverpod State Management Skill

Follow Riverpod 3 best practices using generated providers.

## When to use this skill

- Adding new state
- Fetching async data
- Managing user/session state

## Conventions

- Prefer `@riverpod` generators
- Name providers by responsibility, not type
- Keep providers small and composable

## Patterns

### Async data
- Use `AsyncValue<T>`
- Handle loading/error in UI, not provider

### Side effects
- Perform mutations inside notifier methods
- Never mutate state directly in widgets

## File naming

- `*_provider.dart`
- `*_notifier.dart`

## Anti-patterns to avoid

- Reading providers inside constructors
- Large monolithic providers
- Business logic in widgets
