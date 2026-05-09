# Data Models & Serialization Rules
activation: always

Enforces immutable model patterns with `freezed` and `json_serializable` in hoya_app.

## Model Anatomy (Mandatory)

All domain models must use `@freezed` annotation. Never write manual `copyWith`, `==`, `hashCode`, or `toString`.

```dart
// ✅ Canonical model structure
import 'package:freezed_annotation/freezed_annotation.dart';

part 'story_model.freezed.dart';
part 'story_model.g.dart';

@freezed
class Story with _$Story {
  const factory Story({
    required String id,
    required String title,
    required String authorId,
    @Default('') String summary,
    @Default([]) List<String> tags,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _Story;

  factory Story.fromJson(Map<String, dynamic> json) => _$StoryFromJson(json);
}
```

## Naming Conventions

| Type | Pattern | Example |
|---|---|---|
| Domain model | `PascalCase` (no suffix needed) | `Story`, `UserProfile` |
| DTO (data transfer) | `PascalCaseDto` | `StoryDto` |
| State model | `PascalCaseState` | `AuthState` |
| Union/sealed state | Freezed union variants | `AuthState.loading()`, `AuthState.authenticated(user)` |
| File | `snake_case_model.dart` | `story_model.dart` |

## Freezed Rules

- Annotate with `@freezed` — not `@Freezed()` unless you need custom configuration.
- Use `required` for mandatory fields, `@Default(value)` for optional fields with defaults.
- Prefer `@Default([])` over nullable `List?` for list fields.
- Prefer `@Default('')` over nullable `String?` when empty string is a valid default.
- Use nullable types (`String?`) only when `null` is semantically meaningful (e.g., "not yet set").
- **Never** have mutable fields — all properties must be `final` (freezed enforces this).
- Implement `fromJson` if the model will ever be deserialized (from Supabase, API, or local cache).

## JSON Serialization

- `@JsonKey(name: 'snake_case_name')` is required when the Dart field name differs from the JSON key.
- Supabase returns `snake_case` column names — map to `camelCase` Dart properties using `@JsonKey`.
- For custom type conversion (e.g., `DateTime` ↔ ISO string): use `@JsonKey(fromJson: ..., toJson: ...)` or a `JsonConverter`.
- Enums: use `@JsonEnum(valueField: 'value')` or a `JsonConverter` — never rely on implicit enum index serialization.

```dart
// ✅ Enum serialization
@JsonEnum(valueField: 'value')
enum StoryEra {
  ancient('ancient'),
  medieval('medieval'),
  modern('modern');

  const StoryEra(this.value);
  final String value;
}
```

## Union Types (Sealed State Models)

Use Freezed unions for state variants — preferred over `sealed class` + manual subclasses:

```dart
@freezed
sealed class UploadState with _$UploadState {
  const factory UploadState.idle() = _Idle;
  const factory UploadState.uploading(double progress) = _Uploading;
  const factory UploadState.success(String url) = _Success;
  const factory UploadState.failure(String message) = _Failure;
}

// In UI — exhaustive switch
switch (uploadState) {
  case _Idle(): // show button
  case _Uploading(:final progress): // show progress
  case _Success(:final url): // show preview
  case _Failure(:final message): // show error
}
```

## Code Generation Workflow

1. Create/modify the model file.
2. Add `part` directives for generated files.
3. Run: `dart run build_runner build --delete-conflicting-outputs`
4. Commit both the model file **and** generated files (`*.freezed.dart`, `*.g.dart`).
5. **Never manually edit** `*.freezed.dart` or `*.g.dart` files.

## File Organization

```
<feature>/domain/
  story_model.dart          # Source of truth
  story_model.freezed.dart  # Generated — commit, never edit
  story_model.g.dart        # Generated — commit, never edit
```

- Keep model files in `domain/` (for domain models) or alongside their usage (for UI state models).
- One model class per file — no multiple unrelated models in a single file.

## Immutability Rules

- Domain models are **always immutable** — use `copyWith` to produce new instances.
- Never make a model field mutable (`var` or non-`final`).
- Never implement setters on models.
- UI state stored in Riverpod `Notifier.state` — mutate state by replacing with `copyWith`, not by modifying fields.

## Anti-Patterns (Never Do)

- ❌ `Map<String, dynamic>` passed around the app as a "model" — always map to a typed class.
- ❌ Manual `==`, `hashCode`, `copyWith` implementations — use `@freezed`.
- ❌ Mutable model properties.
- ❌ `dynamic` typed fields in models.
- ❌ Editing generated `*.g.dart` or `*.freezed.dart` files.
- ❌ `json['key'] as String` force-casts in application code — `json_serializable` handles this.
- ❌ Models in the `data/` layer that leak Supabase types — always convert to domain models.
