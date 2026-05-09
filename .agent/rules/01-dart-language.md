# Dart Language Standards
activation: always

These rules apply to every `.dart` file in the project.

## Type Safety (Mandatory)

- **Never use `dynamic`** unless interacting with external untyped APIs (JSON parsing step only). Cast immediately after receipt.
- **Never use `var`** where the type is not instantly obvious from the right-hand side. Prefer explicit types or well-inferrable declarations.
- **Enable strict analysis** — the project `analysis_options.yaml` enforces `strict-casts`, `strict-inference`, `strict-raw-types`. Do not suppress these.
- Always declare return types on every function and method. `always_declare_return_types` is enforced.
- Use `final` for all local variables that are not reassigned. `prefer_final_locals` is enforced.
- Use `const` constructors wherever possible. `prefer_const_constructors` is enforced.

## Dart 3+ Language Features

- **Pattern matching**: Use `switch` expressions and patterns over nested `if-else` chains when handling sealed types or enums.
- **Records**: Use records `(Type, Type)` to return multiple values from a function instead of creating ad-hoc classes or `Map<String, dynamic>`.
- **Sealed classes**: When modeling state variants (e.g., `AuthState`, `LoadState`) use `sealed class` + pattern matching for compile-time exhaustiveness.
- **Dot shorthands**: Use `.value` shorthand notation when the type is unambiguous from context (e.g., `alignment: .center`).
- **Collection control flow**: Use `if` and `for` inside list/map literals instead of imperative loops that build lists.
- **Null safety**: Prefer non-nullable types. Avoid `!` force-unwrap except when you have proven non-null (document why with a comment).

## Naming Conventions

| Construct | Style | Example |
|---|---|---|
| Classes, enums, typedefs | `PascalCase` | `UserProfile`, `AuthState` |
| Variables, functions, params | `camelCase` | `currentUser`, `fetchData()` |
| Constants (`const`) | `camelCase` | `defaultTimeout` |
| File names | `snake_case` | `user_profile.dart` |
| Private members | `_camelCase` | `_sessionToken` |
| Riverpod providers | `camelCase + Provider` suffix | `authSessionProvider` |
| Notifiers | `PascalCase + Notifier` suffix | `AuthSessionNotifier` |

## Error Handling

- **Never silently swallow exceptions**. At minimum log to a structured logger. `avoid_print` is enforced — use `debugPrint` in debug builds or a logger service in production paths.
- Use typed exceptions (`AppException`, domain-specific errors) — avoid catching bare `Exception` or `Object` without re-throwing or logging.
- In async code, always handle `AsyncValue.error` states explicitly in the UI layer.
- Check `ref.mounted` before calling `ref.read` or updating state in async Notifier methods.

## Code Style

- **Single quotes** for string literals (`prefer_single_quotes` is enforced).
- **Trailing commas** on all multi-line function calls and widget trees (`require_trailing_commas` is enforced).
- Maximum line length: **120 characters** (dart formatter default: 80 — project uses 120 via `dart format --line-length 120`).
- No `print()` calls — use the project logger.
- No empty `catch` blocks (`no-empty-block` enforced).
- No commented-out dead code in committed files.

## Imports

- Always use relative imports within the same package.
- Group imports: dart → flutter → third-party → project, separated by blank lines.
- No wildcard imports (`import 'package:x/x.dart' as x` is acceptable for disambiguation).
- Never import `dart:io` in presentation or domain layers.

## Documentation

- Public API (classes, methods, top-level functions) must have `///` dartdoc comments.
- Non-obvious logic must have inline `//` comments explaining *why*, not *what*.
- Generated files (`*.g.dart`, `*.freezed.dart`) must never be manually edited or documented.
