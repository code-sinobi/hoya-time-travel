---
name: flutter-mobile-design
description: Create distinctive, production-grade Flutter mobile applications with Material Design 3. Use this skill when the user asks to build Flutter widgets, screens, pages, or complete mobile apps. Handles UI creation from scratch, design-to-code conversion (Figma/mockups), architecture patterns (Riverpod), and Flutter best practices. Generates beautiful, performant Flutter code that avoids generic aesthetics.
---

# Flutter Mobile Design Skill

Creates distinctive, production-grade Flutter mobile UI. Read this skill before building any screen, widget, or visual component in hoya_app.

## When to Use This Skill

- Building a new screen or page from scratch
- Implementing a widget, card, list, or modal
- Converting a Figma/mockup/description to Flutter code
- Polishing an existing screen's visual quality
- Implementing responsive or adaptive layouts
- Any time the output is visible UI

---

## Step 0: Design Thinking (Always Do This First)

Before writing a single line of code, commit to a clear design direction:

| Question | Answer before coding |
|---|---|
| **Purpose** | What problem does this screen solve? |
| **User** | Who interacts with it? What's their mental model? |
| **Tone** | Vibrant & playful / calm & professional / bold & expressive / minimal & clean / warm & organic |
| **Signature element** | What makes this screen memorable? |
| **Color direction** | Which part of the `ColorScheme` leads? |

hoya_app's design persona: **mythic, atmospheric, timeless** — think ancient manuscript meets modern interface. Every screen should feel like a window into a living world, not a generic data form.

---

## Color System

Use `ColorScheme` exclusively — never raw `Colors.*` constants (banned in `analysis_options.yaml`).

```dart
// Access in widgets
final colors = Theme.of(context).colorScheme;

// Semantic usage
colors.primary           // Key actions, FAB, active nav
colors.primaryContainer  // Tonal backgrounds behind key content
colors.secondary         // Supporting actions
colors.tertiary          // Contrasting accents (use sparingly)
colors.surface           // Card and sheet backgrounds
colors.surfaceContainerHighest // Elevated surface variant
colors.onSurface         // Body text on surface
colors.error             // Error states only
colors.outline           // Borders, dividers
```

### hoya_app Color Tokens (MythicColors)

```dart
// Always use project tokens — never hardcode hex
MythicColors.deepIndigo      // Primary — deep lapis blue
MythicColors.ancientGold     // Accent — warm burnished gold
MythicColors.obsidianBlack   // Dark surface
MythicColors.parchment       // Light warm background
MythicColors.ochreRed        // Error / destructive
MythicColors.bronze          // Tertiary warm tone
MythicColors.success         // Positive feedback
MythicColors.warning         // Caution states
```

---

## Typography

Define once in `lib/core/theme/app_text_theme.dart`. Use only via `Theme.of(context).textTheme`.

```dart
// ✅ Correct
final headline = Theme.of(context).textTheme.headlineMedium;
Text('The Awakening', style: headline)

// ❌ Wrong — inline font (banned)
Text('The Awakening', style: GoogleFonts.playfairDisplay(fontSize: 28))
```

### Type Scale Reference

| Role | Usage in hoya_app |
|---|---|
| `displayLarge` | Splash hero text, onboarding titles |
| `headlineLarge` | Primary screen titles |
| `headlineMedium` | Section headers, card feature titles |
| `titleLarge` | App bar titles, dialog headers |
| `titleMedium` | List section headers |
| `bodyLarge` | Primary readable content, story text |
| `bodyMedium` | Supporting content, descriptions |
| `labelLarge` | Button labels, tab labels |
| `labelSmall` | Timestamps, metadata, captions |

---

## M3 Component Usage

### Buttons — Always Choose Semantically

```dart
// Primary action (one per screen)
FilledButton(
  onPressed: onTap,
  child: const Text('Begin Journey'),
)

// Secondary / supporting action
FilledButton.tonal(
  onPressed: onTap,
  child: const Text('Save Draft'),
)

// Low-emphasis action
OutlinedButton(
  onPressed: onTap,
  child: const Text('Cancel'),
)

// Inline text link action
TextButton(
  onPressed: onTap,
  child: const Text('Learn more'),
)

// Destructive action — use error color
FilledButton(
  style: FilledButton.styleFrom(
    backgroundColor: colorScheme.error,
    foregroundColor: colorScheme.onError,
  ),
  onPressed: onDelete,
  child: const Text('Delete'),
)
```

### Cards

```dart
// Elevated card (default) — most content
Card(
  clipBehavior: Clip.antiAlias,
  child: InkWell(
    onTap: onTap,
    child: content,
  ),
)

// Filled card — subtle grouping
Card(
  elevation: 0,
  color: colorScheme.surfaceContainerHighest,
  child: content,
)

// Outlined card — borders-only, no elevation
Card(
  elevation: 0,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
    side: BorderSide(color: colorScheme.outline),
  ),
  child: content,
)
```

### Navigation

```dart
// Bottom navigation (compact / mobile)
NavigationBar(
  selectedIndex: currentIndex,
  onDestinationSelected: onTabSelected,
  destinations: const [
    NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
    NavigationDestination(icon: Icon(Icons.explore_outlined), selectedIcon: Icon(Icons.explore), label: 'Explore'),
    NavigationDestination(icon: Icon(Icons.book_outlined), selectedIcon: Icon(Icons.book), label: 'Library'),
  ],
)

// Side navigation (tablet / expanded)
NavigationRail(
  selectedIndex: currentIndex,
  onDestinationSelected: onTabSelected,
  destinations: const [...],
)
```

---

## Layout & Spacing

Use the M3 spacing scale (multiples of 4):

```dart
// Standard content padding
const contentPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 12);
const screenPadding = EdgeInsets.all(16);
const sectionSpacing = SizedBox(height: 24);
const itemSpacing = SizedBox(height: 8);

// Preferred spacing pattern
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text('Section Title', style: textTheme.titleMedium),
    const SizedBox(height: 8),
    ContentWidget(),
    const SizedBox(height: 24), // section gap
    Text('Next Section', style: textTheme.titleMedium),
  ],
)
```

### Responsive Breakpoints

```dart
// Mobile-first responsive layout
LayoutBuilder(
  builder: (context, constraints) {
    final isTablet = constraints.maxWidth >= 600;
    final isDesktop = constraints.maxWidth >= 840;

    if (isDesktop) return DesktopLayout();
    if (isTablet) return TabletLayout();
    return MobileLayout();
  },
)
```

---

## Motion & Animations

**Rule: All animations serve UX purpose. Duration max 550ms.**

```dart
// Entrance — standard pattern for cards / list items
Widget build() => ContentWidget()
  .animate()
  .fadeIn(duration: 280.ms, curve: Curves.easeOut)
  .slideY(begin: 0.06, end: 0, duration: 280.ms);

// Staggered list
ListView.builder(
  itemBuilder: (context, index) =>
    ItemCard(item: items[index])
      .animate(delay: (index * 55).ms)
      .fadeIn(duration: 250.ms),
)

// Implicit value animation
AnimatedContainer(
  duration: const Duration(milliseconds: 250),
  curve: Curves.easeOutCubic,
  decoration: BoxDecoration(
    color: isSelected ? colorScheme.primaryContainer : colorScheme.surface,
    borderRadius: BorderRadius.circular(12),
  ),
  child: content,
)

// Hero transition (shared element)
Hero(
  tag: 'story-image-${story.id}',
  child: StoryImage(story: story),
)
```

---

## The Craft: Making It Memorable

### Visual Hierarchy
Every screen must have **one clear focal point**. Use size, weight, and color contrast to create a visual pyramid — primary element → secondary elements → details.

### Micro-Details That Matter
```dart
// ✅ Clip images to card shape — no overflow artifacts
Card(
  clipBehavior: Clip.antiAlias,  // ← always on tappable cards with images
  child: InkWell(...),
)

// ✅ Ink splash feedback on all tappable surfaces
InkWell(
  borderRadius: BorderRadius.circular(12), // ← match the container shape
  onTap: onTap,
  child: content,
)

// ✅ Surface tint on elevated surfaces (M3 tonal elevation)
Material(
  elevation: 2,
  surfaceTintColor: colorScheme.primary, // ← tonal surface, not shadow-only
  borderRadius: BorderRadius.circular(16),
  child: content,
)

// ✅ Semantic labels for accessibility
Semantics(
  label: 'Story: ${story.title}, by ${story.author}',
  child: StoryCard(story: story),
)
```

### Empty States — Design Them Properly
```dart
// Never show a blank screen or bare "No data"
Center(
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Lottie.asset('assets/lottie/states/empty_scroll.json',
        width: 180, height: 180),
      const SizedBox(height: 16),
      Text('No Stories Yet',
        style: Theme.of(context).textTheme.titleMedium),
      const SizedBox(height: 8),
      Text('Your chronicles await.',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        )),
      const SizedBox(height: 24),
      FilledButton.icon(
        onPressed: onCreateFirst,
        icon: const Icon(Icons.add),
        label: const Text('Begin a Story'),
      ),
    ],
  ),
)
```

---

## Platform-Specific Conventions

### iOS
```dart
// Always wrap root content in SafeArea
SafeArea(child: screenContent)

// Support text scaling
Text(
  label,
  maxLines: 2,
  overflow: TextOverflow.ellipsis,
  // Never hardcode font sizes that override system text scale
)
```

### Android
```dart
// Edge-to-edge display
SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

// Material You dynamic color (when available)
// Handled automatically via ColorScheme.fromSeed in ThemeData
```

---

## Quality Checklist (Before Shipping Any Screen)

- [ ] `const` on every static widget — zero unnecessary rebuilds
- [ ] `clipBehavior: Clip.antiAlias` on all cards with images
- [ ] `SafeArea` wrapping screen content
- [ ] Loading state: skeleton/shimmer (not bare spinner)
- [ ] Empty state: designed, not a blank page
- [ ] Error state: friendly message + retry action
- [ ] Dark mode: all colors via `colorScheme`, no hardcoded hex
- [ ] Touch targets: min 48×48px for all interactive elements
- [ ] `Semantics` / `tooltip` on all icon-only buttons
- [ ] `ListView.builder` for all dynamic lists (never `Column` with map)
- [ ] `Key` on all list items and AnimatedSwitcher children
- [ ] Ink feedback on all tappable surfaces
- [ ] Hero tags unique per item (include item ID)
- [ ] `flutter analyze` clean — zero warnings

---

## Anti-Patterns — Never Do

- ❌ Generic purple gradient on white — hoya_app has a specific palette
- ❌ Inter/Roboto/Arial inline — fonts are defined in the theme
- ❌ `Colors.blue`, `Colors.red`, `Colors.green` — use `MythicColors` or `colorScheme`
- ❌ Hardcoded hex colors anywhere in widget files
- ❌ Blank loading state — always show skeleton
- ❌ Blank empty state — always design it
- ❌ `Column(children: items.map(...).toList())` for dynamic lists
- ❌ `Container` with only `padding` — use `Padding` directly
- ❌ `Container` with only `color` — use `ColoredBox`
- ❌ Missing `clipBehavior` on cards with image children
- ❌ Missing `Semantics` on icon-only interactive widgets
- ❌ Animations > 550ms duration
- ❌ Copying cookie-cutter social app / fintech app patterns — this is a mythic storytelling app
