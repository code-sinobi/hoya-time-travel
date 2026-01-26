---
name: flutter-feature-scaffold
description: Scaffolds a new Flutter feature using the project's architecture (Riverpod, go_router, Supabase). Use when creating a new feature or screen.
---

# Flutter Feature Scaffolding Skill

This skill creates a new feature following hoya_app conventions.

## When to use this skill

- Starting a new feature (e.g. profile, onboarding, settings)
- Adding a new screen with state and data
- Unsure how to wire UI, state, and backend together

## Feature folder layout

Create a folder under `lib/features/<feature_name>/`:

```
<feature_name>/
  data/
    <feature>_repository.dart
  domain/
    <feature>_model.dart
  presentation/
    <feature>_screen.dart
    <feature>_provider.dart
```

## Step-by-step scaffolding

1. **Domain**
   - Define immutable models
   - No Flutter or Supabase imports

2. **Data**
   - Create a repository that talks to Supabase
   - Map responses → domain models
   - Expose only clean methods (no UI concerns)

3. **State**
   - Use `@riverpod` for providers
   - Async logic lives here, not in UI

4. **Presentation**
   - Screen widgets read providers
   - UI reacts to `AsyncValue`

## Naming conventions

- Feature folders: `snake_case`
- Classes: `PascalCase`
- Providers: `<feature>Provider`

## Non-goals

- Do NOT fully implement UI polish
- Do NOT optimize prematurely
- Focus on correctness and clarity first
