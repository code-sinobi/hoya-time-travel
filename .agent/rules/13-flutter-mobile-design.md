# Flutter Mobile Design Enforcement Rules
activation: always

Enforces distinctive, production-grade UI standards across all Flutter screens and widgets in hoya_app. Works in conjunction with the `flutter-mobile-design` skill.

## Design Thinking Before Coding (Mandatory)

Before implementing any new screen or significant widget:
1. Identify the **single focal point** of the screen — what draws the eye first?
2. Confirm which `colorScheme` role leads (primary, secondary, or surface family).
3. Choose a motion personality consistent with hoya_app's mythic tone.
4. Verify there is a designed loading state, empty state, and error state.

**No screen ships without all three states implemented.**

## hoya_app Visual Identity (Non-Negotiable)

hoya_app's design persona is **mythic, atmospheric, timeless**.
- Feels like a living manuscript, not a SaaS dashboard or social feed.
- Warmth from `MythicColors.ancientGold` accents against deep surfaces.
- Typography uses display fonts for narrative moments, clean fonts for functional UI.
- Motion is deliberate and atmospheric — never jittery or performative.

The following aesthetics are **explicitly banned**:
- Purple gradient on white/light background (the cliché AI/startup look)
- Generic card-list-fab layouts with no character
- Bright primary blue as the dominant color
- Cookie-cutter social app / fintech app patterns
- Inter or Roboto as the display/headline font

## Color Rules (Enforced)

```dart
// ✅ All color from semantic roles
final colors = Theme.of(context).colorScheme;
colors.primary, colors.surface, colors.error...

// ✅ Project-specific tokens
MythicColors.ancientGold, MythicColors.deepIndigo...

// ❌ Banned — raw Flutter color constants
Colors.blue, Colors.red, Colors.green, Colors.purple,
Colors.orange, Colors.yellow, Colors.cyan  // all banned via analysis_options.yaml
```

## Typography Rules (Enforced)

```dart
// ✅ Always via TextTheme
Theme.of(context).textTheme.headlineMedium
Theme.of(context).textTheme.bodyLarge

// ❌ Never inline
GoogleFonts.playfairDisplay(fontSize: 28) // in widget build()
TextStyle(fontFamily: 'Inter', fontSize: 16) // hardcoded
```

All font definitions live in `lib/core/theme/app_text_theme.dart` — never inline.

## Required Widget Patterns

### Every Card With an Image
```dart
Card(
  clipBehavior: Clip.antiAlias, // ← REQUIRED, not optional
  child: InkWell(
    borderRadius: BorderRadius.circular(12),
    onTap: onTap,
    child: content,
  ),
)
```

### Every Dynamic List
```dart
// ✅ Required — virtualized
ListView.builder(itemBuilder: ..., itemCount: ...)
GridView.builder(itemBuilder: ..., gridDelegate: ...)

// ❌ Banned for any list > 5 items
Column(children: items.map((i) => Widget(i)).toList())
```

### Every Icon-Only Button
```dart
// ✅ Must have tooltip or Semantics label
IconButton(
  tooltip: 'Save story', // ← REQUIRED
  icon: const Icon(Icons.bookmark_outline),
  onPressed: onSave,
)
```

### Every Tappable Surface
```dart
// ✅ Always InkWell or InkResponse — never bare GestureDetector on opaque surfaces
InkWell(
  borderRadius: BorderRadius.circular(12), // match container shape
  onTap: onTap,
  child: content,
)
```

## Mandatory Screen States

Every screen that fetches async data **must** implement all three:

### Loading State
```dart
// ✅ Skeleton that matches real content layout
if (isLoading) return StorySkeletonLoader();

// ❌ Banned as a primary loading state for full screens
if (isLoading) return const Center(child: CircularProgressIndicator());
```

### Empty State
```dart
// ✅ Designed empty state with call-to-action
Center(
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      // Lottie or illustration
      const SizedBox(height: 16),
      Text('Title', style: textTheme.titleMedium),
      Text('Supporting copy.', style: textTheme.bodyMedium),
      const SizedBox(height: 24),
      FilledButton(onPressed: onAction, child: const Text('Action')),
    ],
  ),
)

// ❌ Banned
Text('No items found.')
const SizedBox.shrink() // invisible empty state
```

### Error State
```dart
// ✅ Friendly message + retry
Column(
  mainAxisSize: MainAxisSize.min,
  children: [
    Icon(Icons.cloud_off_outlined, color: colorScheme.error, size: 48),
    const SizedBox(height: 12),
    Text('Could not load content', style: textTheme.titleMedium),
    const SizedBox(height: 8),
    FilledButton.tonal(onPressed: onRetry, child: const Text('Try Again')),
  ],
)

// ❌ Banned — raw exception message to users
Text(exception.toString())
```

## Accessibility Minimums (Non-Negotiable)

- Touch targets: **minimum 48×48 logical pixels** for all interactive elements.
- Color contrast: use `colorScheme` — it guarantees WCAG AA compliance automatically.
- `Semantics` label or `tooltip` on every icon-only action.
- `SafeArea` wraps all screen root content.
- Text must respect system `textScaleFactor` — never override with `MediaQuery.textScaler`.

## Performance Requirements

```dart
// ✅ const on every static widget
const SizedBox(height: 16)
const Icon(Icons.star)
const Padding(padding: EdgeInsets.all(8), child: ...)

// ✅ RepaintBoundary on animated sub-trees
RepaintBoundary(child: AnimatingWidget())

// ✅ Unique keys on list items
ListView.builder(
  itemBuilder: (ctx, i) => StoryCard(key: ValueKey(stories[i].id), ...)
)
```

## Screen-Level Checklist

The agent must verify this before considering any screen implementation complete:

- [ ] Loading skeleton implemented (not bare spinner)
- [ ] Empty state designed with CTA
- [ ] Error state with retry action
- [ ] All colors from `colorScheme` or `MythicColors`
- [ ] All text from `Theme.of(context).textTheme`
- [ ] `const` on all static widgets
- [ ] `clipBehavior: Clip.antiAlias` on image-bearing cards
- [ ] `SafeArea` wrapping screen body
- [ ] `ListView.builder` for all dynamic lists
- [ ] Touch targets ≥ 48×48px
- [ ] Tooltips/Semantics on icon-only buttons
- [ ] Dark mode works (all colors via `colorScheme`)
- [ ] `flutter analyze` passes clean

## Anti-Patterns — Never Do

- ❌ Generic aesthetics (purple gradient, blue primary on white, fintech layout)
- ❌ Hardcoded hex or `Colors.*` constants
- ❌ Inline `GoogleFonts.*` in widget files
- ❌ Blank loading state
- ❌ Bare "No data" or empty `SizedBox` for empty states
- ❌ Raw exception `.toString()` in user-facing error messages
- ❌ `Column` for dynamic lists > 5 items
- ❌ Missing `clipBehavior` on image cards
- ❌ `GestureDetector` instead of `InkWell` on opaque surfaces
- ❌ Missing touch target size on interactive elements
- ❌ Animations > 550ms duration
