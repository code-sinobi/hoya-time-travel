# Testing & Quality Assurance Rules
activation: always

Enforces testing standards and quality gates in hoya_app.

## Testing Philosophy

**Confidence over coverage.** The goal is to catch real bugs, not hit a coverage number.
Write tests that would actually fail if the feature broke — not tests that verify Flutter renders a `Text` widget.

## Test Priority (In Order)

1. **Provider / Notifier unit tests** — all state transitions and async logic.
2. **Repository unit tests** — data mapping, error handling, edge cases.
3. **Widget tests** — only for logic-heavy widgets or complex state-driven UI.
4. **Integration tests** — critical user paths (auth flow, core create/read flows).

## What to Always Test

- Every `Notifier` method that changes state.
- Every repository method's success and failure paths.
- Auth state transitions (login, logout, session expiry).
- Navigation redirects (authenticated vs unauthenticated).
- Model `fromJson` / `toJson` round-trips.
- Error state UI (empty state, error message display).

## What NOT to Over-Test

- Generated code (`*.g.dart`, `*.freezed.dart`).
- Simple layout widgets with no logic.
- One-liner getters that just return a field.
- Theme colors or font sizes.
- Supabase internals (mock the repository, not Supabase).

## Test File Location

```
test/
  features/
    <feature>/
      data/
        <feature>_repository_test.dart
      domain/
        <feature>_model_test.dart
      presentation/
        <feature>_provider_test.dart
        <feature>_screen_test.dart      # only if logic-heavy
  core/
    router/
      router_test.dart
    utils/
      <utility>_test.dart
```

- Mirror `lib/` structure under `test/`.
- Test file name: `<source_file>_test.dart`.
- One test file per source file (not one mega-test file per feature).

## Provider Testing Pattern

```dart
// ✅ Correct — test Notifier with ProviderContainer
void main() {
  group('AuthSessionNotifier', () {
    late ProviderContainer container;
    late MockAuthRepository mockRepo;

    setUp(() {
      mockRepo = MockAuthRepository();
      container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockRepo),
        ],
      );
      addTearDown(container.dispose);
    });

    test('signIn updates state to authenticated user', () async {
      when(() => mockRepo.signIn(any(), any())).thenAnswer(
        (_) async => fakeUser,
      );
      await container.read(authSessionProvider.notifier).signIn('a@b.com', 'pass');
      expect(
        container.read(authSessionProvider).value,
        equals(fakeUser),
      );
    });
  });
}
```

- Use `ProviderContainer` for unit-testing providers — not `WidgetTester`.
- Mock repositories with `mocktail` — never mock Supabase directly.
- Always `addTearDown(container.dispose)`.
- Use `AsyncValue.guard` outputs to test error paths.

## Widget Testing Pattern

```dart
// ✅ Widget test with provider override
testWidgets('shows error message on auth failure', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authSessionProvider.overrideWith(() => MockAuthSessionNotifier()),
      ],
      child: const MaterialApp(home: AuthScreen()),
    ),
  );
  await tester.tap(find.byKey(const Key('login_button')));
  await tester.pumpAndSettle();
  expect(find.text('Invalid credentials'), findsOneWidget);
});
```

- Every interactive widget must have a `Key` for testability.
- Use `ProviderScope` with overrides — never test against live Supabase.
- `pumpAndSettle()` for async UI updates; `pump(Duration)` when you need precise control.

## Static Analysis Gate

Before any commit or PR:
```bash
flutter analyze --fatal-infos
```
- Zero warnings, zero infos allowed in committed code.
- Use `dart fix --apply` to resolve auto-fixable issues.
- Never use `// ignore:` suppression without a comment explaining why.

## Code Generation Gate

Before any commit:
```bash
dart run build_runner build --delete-conflicting-outputs
```
- No pending generated file changes should exist in the working tree.
- Generated files (`*.g.dart`, `*.freezed.dart`) must be committed alongside their source.

## Sanity Checks (Before Every PR)

- [ ] All `AsyncValue` states handled (loading, error, data)?
- [ ] Empty states intentional and visually handled?
- [ ] New Supabase tables have RLS enabled?
- [ ] New providers have corresponding unit tests?
- [ ] `flutter analyze` passes clean?
- [ ] `build_runner` output is up to date?
- [ ] No `print()` statements in committed code?
- [ ] Navigation uses named routes via `AppRoute` enum?

## Anti-Patterns (Never Do)

- ❌ Testing against live Supabase in unit or widget tests.
- ❌ `// ignore:` without explanation.
- ❌ Skipping tests with `skip: true` without a tracking issue.
- ❌ `expect(find.byType(Text), findsWidgets)` — too broad, tests nothing meaningful.
- ❌ Committing with failing tests.
- ❌ Tests with no assertions (`expect` calls).
