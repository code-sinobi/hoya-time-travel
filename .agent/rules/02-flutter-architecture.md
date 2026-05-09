# Flutter Architecture Rules
activation: always

Enforces the feature-first clean architecture used throughout hoya_app.

## Project Structure (Mandatory)

All feature code lives under `lib/features/<feature_name>/` with three layers:

```
lib/
  features/
    <feature>/
      data/
        <feature>_repository.dart       # Supabase queries, DTOs, mapping
      domain/
        <feature>_model.dart            # Immutable domain models (no Flutter)
      presentation/
        <feature>_screen.dart           # Root screen widget
        <feature>_provider.dart         # Riverpod providers / notifiers
        widgets/                        # Feature-local widgets
  core/
    router/                             # go_router config only
    theme/                              # ThemeData, ColorScheme, TextTheme
    widgets/                            # Truly shared, reusable widgets
    utils/                              # Pure Dart utility functions
    constants/                          # App-wide constants
    errors/                             # Typed exception hierarchy
    providers/                          # Cross-feature global providers
    config/                             # Env / app config
    ai/                                 # AI service integrations
    transitions/                        # Shared route transitions
```

## Layer Responsibilities & Boundaries (Hard Rules)

### Presentation Layer
- Widgets and screens **only** — no business logic, no Supabase calls.
- Reads state exclusively from Riverpod providers via `ref.watch`.
- Triggers actions via `ref.read(provider.notifier).method()`.
- Handles `AsyncValue` states: always provide `loading`, `error`, and `data` branches.
- Uses `ConsumerWidget` or `ConsumerStatefulWidget` — never plain `StatelessWidget` if it reads a provider.

### Domain Layer
- **Zero Flutter imports** — pure Dart only.
- Immutable models annotated with `@freezed` + `@JsonSerializable`.
- Contains interfaces/abstract classes that repositories implement.
- No Supabase types, no `BuildContext`, no `WidgetRef`.

### Data Layer
- **Only layer** that imports `supabase_flutter`.
- Implements domain repository interfaces.
- Maps raw Supabase responses → domain models immediately.
- Handles network errors and wraps them in typed `AppException` variants.
- One repository file per Supabase table/domain.

### Core Layer
- Shared utilities that have **no feature dependency**.
- `core/widgets/` — only truly reusable across ≥2 features.
- `core/providers/` — cross-cutting providers (auth session, theme, connectivity).

## Anti-Patterns (Never Do)

- ❌ Widget calling `Supabase.instance` directly.
- ❌ Repository containing `BuildContext` or `WidgetRef`.
- ❌ Domain model importing `package:flutter/...` or `package:supabase_flutter/...`.
- ❌ Feature-specific widget placed in `core/widgets/`.
- ❌ Business logic inside a `build()` method.
- ❌ Navigator/routing logic inside a provider or repository.
- ❌ Two features importing each other's non-domain code directly — share via `core/`.

## File Naming

| File type | Pattern | Example |
|---|---|---|
| Screen | `<feature>_screen.dart` | `auth_screen.dart` |
| Provider | `<feature>_provider.dart` | `auth_provider.dart` |
| Notifier | `<feature>_notifier.dart` | `auth_notifier.dart` |
| Repository | `<feature>_repository.dart` | `auth_repository.dart` |
| Model | `<feature>_model.dart` | `user_model.dart` |
| Widget | `<name>_widget.dart` | `story_card_widget.dart` |
| Generated | `*.g.dart`, `*.freezed.dart` | auto |

## Dependency Direction

```
Presentation → Domain ← Data
     ↓              ↑
   Core ────────────┘
```

Dependencies always point **inward**. Domain has no outward dependencies.

## Widget Decomposition Rules

- A `build()` method exceeding **80 lines** must be decomposed into sub-widgets.
- Sub-widgets with complex logic get their own file; purely layout helpers may be private methods.
- Prefer `const` widgets at every leaf node.
- Pass only what a widget needs — avoid passing entire models when only one field is used.
