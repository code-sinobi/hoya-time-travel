# UI Motion Design Rules
activation: always

Enforces tasteful, performant animations using `flutter_animate`, Lottie, and Google Fonts in hoya_app.

## Animation Philosophy

Animations in hoya_app must feel **purposeful and premium** — not decorative noise.
Every animation must serve a UX function: guide attention, communicate state, or reward interaction.

## Library Priority

| Use case | Library |
|---|---|
| Widget entrance / exit | `flutter_animate` |
| Micro-interactions (button, chip) | `flutter_animate` |
| Illustrative / hero animations | Lottie |
| State transitions between screens | go_router page transitions |
| Physics-based gestures | Flutter's `AnimationController` + `CurvedAnimation` |
| Implicit value changes | `AnimatedContainer`, `AnimatedOpacity`, `TweenAnimationBuilder` |

- Prefer **implicit animations** over explicit `AnimationController` when the value change is the trigger.
- Prefer **`flutter_animate`** over manual `AnimatedBuilder` for entrance sequences.

## flutter_animate Rules

```dart
// ✅ Correct — entrance animation with flutter_animate
StoryCard(story: story)
  .animate()
  .fadeIn(duration: 300.ms, curve: Curves.easeOut)
  .slideY(begin: 0.1, end: 0, duration: 300.ms);

// ✅ Staggered list items
ListView.builder(
  itemBuilder: (context, index) => StoryCard(story: stories[index])
    .animate(delay: (index * 60).ms)
    .fadeIn(duration: 250.ms),
);
```

- **Duration guidelines**:
  - Micro-interactions (button press, chip toggle): 100–150ms
  - Element entrance: 200–350ms
  - Screen-level transitions: 300–400ms
  - Maximum: 600ms (longer feels sluggish)
- **Curves**: Prefer `Curves.easeOut` for entrances, `Curves.easeIn` for exits, `Curves.easeInOut` for state changes.
- **No looping animations** on non-loading UI — only loading indicators and deliberate ambient effects.
- Do not animate layout size changes aggressively (`shimmy`, `shake` with scale > 1.05 is excessive).

## Lottie Rules

- Store Lottie JSON files in `assets/lottie/<feature>/filename.json`.
- Maximum Lottie file size: **150 KB** — optimize via LottieFiles before committing.
- Use `Lottie.asset()` not `Lottie.network()` — bundle the file.
- Always specify explicit `width` and `height` — never rely on intrinsic size.
- Use `controller` to control playback — do not leave complex Lotties on infinite loop in lists.
- Provide a static fallback (`Image.asset` or `Icon`) when Lottie is decorative only.

```dart
// ✅ Controlled Lottie
Lottie.asset(
  'assets/lottie/onboarding/time_travel.json',
  controller: _controller,
  width: 200,
  height: 200,
  fit: BoxFit.contain,
)
```

## Typography & Google Fonts

- Font declarations live **only** in `lib/core/theme/app_text_theme.dart` — no inline `GoogleFonts.*` calls in widgets.
- Apply fonts through `Theme.of(context).textTheme` in all widgets.
- The font stack (primary + fallback) is set once in `ThemeData.textTheme`.
- **Never** mix font families within a single screen unless the design spec explicitly calls for it.

```dart
// ✅ Correct
Text('Story Title', style: Theme.of(context).textTheme.headlineMedium)

// ❌ Wrong — inline font
Text('Story Title', style: GoogleFonts.playfairDisplay(fontSize: 24))
```

## Transitions Between Screens

- Use project-defined page transitions from `lib/core/transitions/`.
- Standard transitions:
  - **Top-level tab switch**: Fade-through (M3 spec)
  - **Push/drill-down**: Shared axis horizontal (M3 spec)
  - **Bottom sheet, dialog**: M3 default (scale + fade)
  - **Full-screen overlay**: Vertical slide from bottom
- Custom hero animations require explicit design approval before implementation.

## Performance Rules

- **Avoid animating opacity on large widget trees** — use `AnimatedOpacity` only on small sub-trees.
- **Never animate inside `ListView` without `key`** — widgets must be keyed to prevent animation resets on rebuilds.
- Use `RepaintBoundary` around independently animated widgets to isolate paint layers.
- Profile animations in **profile mode** (`flutter run --profile`) — target 60fps / 120fps on supported devices.
- Do not run animations during heavy async operations — pause or defer until data loads.

## Loading States

- Use **skeleton/shimmer loaders** (`Shimmer` package or custom) for content-loading states — not bare `CircularProgressIndicator`.
- `CircularProgressIndicator.adaptive()` is acceptable only for small inline loaders (buttons, overlays).
- Lottie loading animations reserved for full-screen loading states (splash, onboarding transitions).

## Anti-Patterns (Never Do)

- ❌ Infinite looping animations on visible content (non-loading) screens.
- ❌ Animations exceeding 600ms duration.
- ❌ Inline `GoogleFonts.*` calls in widget files.
- ❌ `Lottie.network()` — all assets must be bundled.
- ❌ `AnimationController` without `vsync` properly configured.
- ❌ Overlapping animations on the same widget that fight for opacity/position.
- ❌ Animating during `build()` without a proper animation framework wrapper.
