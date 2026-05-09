# Performance Rules
activation: always

Enforces Flutter performance best practices in hoya_app to maintain 60fps+ on all targets.

## Widget Build Performance

### const Everything You Can
```dart
// ✅ Const widget — never rebuilt
const SizedBox(height: 16)
const Icon(Icons.star)
const Text('Static label')

// ❌ Non-const unnecessarily — rebuilt on every parent rebuild
SizedBox(height: 16)
```
- Use `const` on every widget that has no dynamic data.
- `prefer_const_constructors` is enforced by the linter — zero tolerance.

### Widget Decomposition
- Extract sub-widgets into separate `StatelessWidget` / `ConsumerWidget` classes to narrow rebuild scope.
- **Never** build a 200-line widget tree in a single `build()` method.
- A widget that rebuilds should only rebuild what needs to change, not its entire sibling tree.

### Rebuild Control with Riverpod
```dart
// ✅ Select only what you need — minimize rebuilds
final userName = ref.watch(userProfileProvider.select((u) => u.value?.name));

// ❌ Watches entire provider — rebuilds on any field change
final user = ref.watch(userProfileProvider).value;
```
- Use `ref.watch(provider.select(...))` whenever you only need a subset of a provider's state.
- Avoid watching high-frequency providers (e.g., position/scroll) in top-level widgets.

## List Performance

```dart
// ✅ Virtualized list — only builds visible items
ListView.builder(
  itemCount: stories.length,
  itemBuilder: (context, index) => StoryCard(story: stories[index]),
)

// ❌ Eagerly builds all children
Column(children: stories.map((s) => StoryCard(story: s)).toList())
```
- **Always** use `ListView.builder` or `GridView.builder` for dynamic lists — never `ListView(children: [...])` with more than ~10 items.
- Use `SliverList` / `SliverGrid` inside `CustomScrollView` for complex scrollable layouts.
- Assign stable `key: ValueKey(item.id)` to list items so Flutter can diff efficiently.

## Image Performance

- Use `CachedNetworkImage` (or Supabase storage signed URLs cached via `cached_network_image`) — never raw `Image.network`.
- Always specify `width` and `height` on network images to prevent layout shifts.
- Use `filterQuality: FilterQuality.medium` for resized images — `high` only when needed.
- Prefer WebP format for assets; compress PNGs/JPGs before bundling.
- For large lists of images, set `memCacheWidth` / `memCacheHeight` on `CachedNetworkImage`.

## Async & Futures

- Never `await` inside `build()` — async work belongs in providers.
- Use `FutureBuilder` only as a last resort — prefer Riverpod `AsyncValue` patterns.
- Debounce search/filter inputs that trigger provider re-evaluation (300ms debounce minimum).
- Cancel async operations on provider disposal (`ref.onDispose`).

## RepaintBoundary

```dart
// ✅ Isolate independently animating widgets
RepaintBoundary(
  child: AnimatedLottieWidget(),
)
```
- Wrap independently animating widgets (Lottie, progress indicators, live-updating counters) in `RepaintBoundary`.
- Do NOT wrap every widget — use only where subtrees paint independently.

## Memory Management

- Dispose `AnimationController`, `TextEditingController`, `ScrollController`, `FocusNode` in `dispose()`.
- With Riverpod, use `ref.onDispose` in providers for subscription/controller cleanup.
- Never hold a `BuildContext` beyond its frame in async callbacks — use `ref.mounted` check.
- Avoid storing large lists in `keepAlive: true` providers unnecessarily.

## Startup Performance

- `main()` must be minimal — defer non-critical initialization with `WidgetsBinding.instance.addPostFrameCallback`.
- Supabase initialization completes before `runApp` — use the splash screen to cover this.
- Never load large datasets synchronously on app start.
- Use lazy loading (`keepAlive: false` providers) for non-critical feature data.

## Profiling Gates

- Run `flutter run --profile` before any performance-sensitive PR.
- Use Flutter DevTools timeline to verify:
  - No jank (frame build time < 16ms for 60fps, < 8ms for 120fps).
  - No unnecessary rebuilds in `Widget Rebuild Stats`.
  - Memory not growing unboundedly in `Memory` tab.
- Performance-critical paths (story rendering, timeline scrolling) must maintain **60fps** minimum.

## Anti-Patterns (Never Do)

- ❌ `ListView(children: largeList.map(...).toList())` — use `.builder`.
- ❌ `setState` in a parent that triggers children to fully rebuild when only one child changed.
- ❌ `Image.network` without caching.
- ❌ `await` inside `build()`.
- ❌ Undisposed controllers causing memory leaks.
- ❌ `ref.watch` on a rapidly changing value in a top-level widget.
- ❌ Skipping `const` on static widgets.
