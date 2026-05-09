# Navigation & Routing Rules (go_router)
activation: always

Enforces go_router patterns and navigation conventions in hoya_app.

## Route Definition (Mandatory)

- **All routes** are defined centrally in `lib/core/router/` — never scattered across feature files.
- Use **named routes** via route `name` property — never use raw path strings in widget code.
- Prefer **declarative navigation** (`context.go`, `context.push`) over imperative Navigator pushes.
- Use `GoRoute` for leaf routes and `ShellRoute` / `StatefulShellRoute` for nested navigation with persistent shell (e.g., bottom nav).

```dart
// ✅ Correct — named route navigation
context.goNamed(AppRoute.home.name);
context.pushNamed(AppRoute.storyDetail.name, pathParameters: {'id': story.id});

// ❌ Wrong — hardcoded string and imperative Navigator
Navigator.of(context).pushNamed('/home');
context.go('/story/123');
```

## Route Naming Convention

- Routes defined as an `enum AppRoute` in `lib/core/router/app_route.dart`.
- Route enum values: `camelCase` (e.g., `AppRoute.storyDetail`).
- Path segments: `kebab-case` (e.g., `/story-detail/:id`).
- Path parameters for resource IDs: `:id`, `:storyId`, `:userId`.
- Query parameters for optional filters: `?era=ancient&sort=newest`.

## Auth Guards & Redirects

```dart
// ✅ Correct — redirect in router, not in widgets
redirect: (context, state) {
  final isAuthenticated = ref.read(authSessionProvider).valueOrNull != null;
  final isAuthRoute = state.matchedLocation.startsWith('/auth');
  if (!isAuthenticated && !isAuthRoute) return '/auth/login';
  if (isAuthenticated && isAuthRoute) return '/home';
  return null;
},
```

- All authentication redirect logic lives in the **router's `redirect` callback** — not in `build()` methods.
- The router **listens** to `authSessionProvider` via `refreshListenable` or `ref` to re-evaluate guards reactively.
- After a successful login/logout, do **not** call `context.go()` from providers — let the router redirect reactively.
- Never check auth state inside a widget's `build()` method to conditionally render routes.

## Route Parameters

| Parameter type | When to use | Example |
|---|---|---|
| Path parameter | Required, identifies a resource | `/story/:storyId` |
| Query parameter | Optional filter, pagination, tab state | `/explore?era=ancient` |
| Extra / state | Temporary in-memory data (not bookmarkable) | `context.push('/confirm', extra: payload)` |

- Path parameter extraction: use `GoRouterState.pathParameters['id']`.
- Extra data: type-cast safely with `state.extra as MyType?` — always null-check.
- Do not pass large objects via `extra` if the route must be deep-linked or bookmarked.

## Navigation API Usage

| Operation | Method |
|---|---|
| Replace current route (no back) | `context.go(...)` |
| Push onto stack (has back button) | `context.push(...)` |
| Replace top of stack | `context.replace(...)` |
| Pop back | `context.pop()` |
| Pop with result | `context.pop(result)` |
| Check can pop | `context.canPop()` |

## Shell Routes & Bottom Navigation

- Use `StatefulShellRoute.indexedStack` for bottom navigation to preserve each tab's scroll and navigation state.
- The bottom `NavigationBar` widget reads the current tab index from the shell — it does **not** manage its own `selectedIndex` in local state.
- Each shell branch has its own navigator key to isolate back-stack behavior.

## Transitions

- Use project-defined transitions from `lib/core/transitions/` — do not define ad-hoc `PageTransitionsTheme` per route.
- Default: M3-appropriate fade-through transition for top-level navigation, shared-axis for hierarchical pushes.
- Never use raw `MaterialPageRoute` — always use `GoRoute` with a `pageBuilder`.

## Anti-Patterns (Never Do)

- ❌ `Navigator.of(context).push(MaterialPageRoute(...))` — use go_router.
- ❌ Hardcoded route strings (`'/home'`) in widget files — use `AppRoute` enum.
- ❌ Auth check logic inside `build()` or `initState()`.
- ❌ Calling `context.go()` from inside a Riverpod provider or repository.
- ❌ Storing navigation state (current route, tab index) in a Riverpod provider — go_router owns this.
- ❌ Deep nesting `GoRoute` beyond 4 levels — flatten with shell routes.
