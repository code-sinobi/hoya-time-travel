# Riverpod State Management Rules
activation: always

Enforces Riverpod 2/3 patterns with code generation across all providers in hoya_app.

## Code Generation (Mandatory)

- **Always use `@riverpod` annotation** — never manually instantiate `Provider`, `FutureProvider`, `NotifierProvider`, etc.
- Run `dart run build_runner build -d` after any provider change.
- Keep `build_runner watch` active during development sessions.
- Never commit with stale `.g.dart` files (provider function signatures must match generated output).

```dart
// ✅ Correct — code-generated
@riverpod
Future<List<Story>> userStories(Ref ref) async {
  final repo = ref.watch(storyRepositoryProvider);
  return repo.fetchAll();
}

// ❌ Wrong — manual instantiation
final userStoriesProvider = FutureProvider<List<Story>>((ref) async { ... });
```

## Provider Types & When to Use

| Use case | Annotation pattern |
|---|---|
| Simple sync value | `@riverpod` on a plain function |
| Async data fetch | `@riverpod` on an `async` function → `AsyncValue<T>` |
| Mutable state | `@riverpod` on a `Notifier` subclass |
| Async mutable state | `@riverpod` on an `AsyncNotifier` subclass |
| Stream | `@riverpod` on a function returning `Stream<T>` |

**Legacy providers** (`StateNotifierProvider`, `ChangeNotifierProvider`, `StateProvider`) are banned in new code. Migrate on sight during refactors.

## Notifier Rules

```dart
// ✅ Correct Notifier pattern
@riverpod
class AuthSession extends _$AuthSession {
  @override
  Future<User?> build() async => _fetchCurrentUser();

  Future<void> signIn(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() =>
      ref.read(authRepositoryProvider).signIn(email, password),
    );
  }

  Future<void> signOut() async {
    // Always check mounted before updating state
    await ref.read(authRepositoryProvider).signOut();
    if (!ref.mounted) return;
    ref.invalidateSelf();
  }
}
```

- State mutations **only** inside Notifier methods — never from widgets.
- Use `AsyncValue.guard(() => ...)` to wrap async operations that can fail.
- Always check `if (!ref.mounted) return;` after any `await` before updating state.
- Do NOT trigger side effects (API writes) inside `build()` — `build()` is for deriving initial state only.

## ref.watch vs ref.read

| Situation | Use |
|---|---|
| Inside `build()` to react to changes | `ref.watch` |
| Inside event handlers / callbacks | `ref.read` |
| Inside `Notifier.build()` to compose state | `ref.watch` |
| Inside Notifier methods | `ref.read` |

- **Never call `ref.watch` inside a callback, gesture handler, or `initState`.**
- **Never call `ref.read` inside `build()` to derive display state.**

## Provider Composition

```dart
// ✅ Compose providers — keep each small
@riverpod
Future<List<Story>> filteredStories(Ref ref) async {
  final stories = await ref.watch(userStoriesProvider.future);
  final filter = ref.watch(storyFilterProvider);
  return stories.where((s) => s.era == filter).toList();
}
```

- Providers should be **small and composable** — one responsibility per provider.
- Avoid "god providers" that fetch, transform, and store multiple unrelated things.
- Prefer `ref.watch(xProvider.future)` over `ref.read` when you need the resolved value inside another provider.

## AsyncValue Handling in UI (Mandatory)

```dart
// ✅ Always handle all three states
ref.watch(userStoriesProvider).when(
  data: (stories) => StoriesList(stories: stories),
  loading: () => const StorySkeletonLoader(),
  error: (e, st) => ErrorView(message: e.toString()),
);
```

- **Never** use `.value!` (force-unwrap) on `AsyncValue` in UI — always `.when()` or `.maybeWhen()`.
- Loading and error states must be **visually handled** — no blank screens.
- Show skeleton/shimmer loaders, not generic `CircularProgressIndicator`, unless the design spec says otherwise.

## Auto-Dispose

- All providers created with `@riverpod` are **auto-disposing by default** — this is correct behavior.
- If a provider must persist across route changes (e.g., global auth state), annotate: `@Riverpod(keepAlive: true)`.
- Only use `keepAlive: true` for truly global state: auth session, user profile, app config.

## Anti-Patterns (Never Do)

- ❌ `ref.read(provider)` inside `build()` for reactive display values.
- ❌ Business logic inside widget `build()` methods.
- ❌ Creating providers inside widget constructors.
- ❌ Passing `WidgetRef` to repositories or domain services.
- ❌ `StateNotifier`, `ChangeNotifier`, or `StateProvider` in new code.
- ❌ Large monolithic providers handling multiple unrelated domains.
- ❌ Side effects in `build()` (API calls, navigation, analytics events).
