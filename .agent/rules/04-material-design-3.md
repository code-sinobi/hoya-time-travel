# Material Design 3 (M3) UI Rules
activation: always

Enforces Material Design 3 compliance and the hoya_app design system across all UI code.

## ThemeData Configuration (Mandatory)

- `useMaterial3: true` is always set in `ThemeData` — never disable.
- All colors come from `ColorScheme` generated via `ColorScheme.fromSeed()` — never hardcode hex values inline.
- The project's `EraTheme` / `MythicColors` palette is the **only** approved color source. Do not use `Colors.*` constants directly (banned via `analysis_options.yaml`).
- Text styles come from the app's `TextTheme` (via `GoogleFonts`). Never set `TextStyle` inline unless overriding a single property in a local context.

```dart
// ✅ Correct — uses theme
Text('Hello', style: Theme.of(context).textTheme.headlineMedium)

// ❌ Wrong — hardcoded styling
Text('Hello', style: TextStyle(fontSize: 24, color: Colors.blue))
```

## Color Usage Rules

| Semantic role | Use |
|---|---|
| Primary actions | `colorScheme.primary` |
| Primary container/background | `colorScheme.primaryContainer` |
| Surface & backgrounds | `colorScheme.surface`, `colorScheme.surfaceContainerHighest` |
| Error states | `colorScheme.error` / `MythicColors.error` |
| On-surface text | `colorScheme.onSurface` |
| Disabled states | `colorScheme.onSurface.withOpacity(0.38)` |

- **Banned raw colors** (enforced by `analysis_options.yaml`):  
  `Colors.red`, `Colors.blue`, `Colors.green`, `Colors.yellow`, `Colors.cyan`, `Colors.purple`, `Colors.orange`
- Use `MythicColors.*` or `colorScheme.*` for every color value.

## M3 Component Selection

Always prefer M3 Flutter widgets over custom implementations:

| Need | Use |
|---|---|
| Primary action button | `FilledButton` |
| Secondary action | `OutlinedButton` or `FilledButton.tonal` |
| Tertiary / low-emphasis | `TextButton` |
| Destructive action | `FilledButton` with `colorScheme.error` |
| Card container | `Card` (Elevated / Filled / Outlined variants) |
| Bottom navigation | `NavigationBar` (not `BottomNavigationBar`) |
| Side navigation | `NavigationRail` (tablet) or `NavigationDrawer` (large) |
| Top bar | `AppBar` with M3 `scrolledUnderElevation` behavior |
| Dialogs | `AlertDialog` or `showDialog` — M3 styled |
| Snackbar feedback | `ScaffoldMessenger.of(context).showSnackBar` |
| Text input | `TextField` with `InputDecoration` using M3 filled/outlined style |
| Toggle | `SegmentedButton` (not `ToggleButtons`) |
| Chips | `FilterChip`, `ActionChip`, `InputChip` as appropriate |
| Progress | `LinearProgressIndicator` or `CircularProgressIndicator` with M3 |

## Typography Rules

- Font family: **Google Fonts** via `GoogleFonts.*` — defined in `core/theme/`.
- Always reference `Theme.of(context).textTheme.<style>` for display, headline, title, body, label scales.
- M3 type scale roles:

| Role | Use |
|---|---|
| `displayLarge/Medium/Small` | Hero text, splash branding |
| `headlineLarge/Medium/Small` | Screen titles |
| `titleLarge/Medium/Small` | Card headers, dialog titles |
| `bodyLarge/Medium/Small` | Main readable content |
| `labelLarge/Medium/Small` | Buttons, chips, navigation labels |

- **Never** use `TextStyle(fontWeight: FontWeight.bold)` alone — pair with appropriate type scale.

## Spacing & Layout

- Use `SizedBox` for fixed whitespace, not `Padding` with a single child.
- Use `Padding` with `EdgeInsets.symmetric` or `EdgeInsets.all` — avoid asymmetric padding unless the design explicitly requires it.
- Standard spacing scale (follow M3 spacing tokens):

| Token | Value |
|---|---|
| `xs` | 4px |
| `sm` | 8px |
| `md` | 16px |
| `lg` | 24px |
| `xl` | 32px |
| `xxl` | 48px |

- Use `const EdgeInsets` wherever possible.
- Avoid `MediaQuery.of(context).size` for simple spacing — use `LayoutBuilder` or `AdaptiveLayout` for responsive design.

## Responsive & Adaptive Layout

- Mobile-first: design for phone screen, then adapt up.
- Use `NavigationBar` for compact (phone) and `NavigationRail` for medium (tablet) breakpoints.
- Breakpoints (M3 canonical):
  - **Compact**: < 600px width → single-column
  - **Medium**: 600–839px → NavigationRail, 2-column where sensible
  - **Expanded**: ≥ 840px → NavigationDrawer, multi-column
- Never hardcode pixel widths for content — use `Expanded`, `Flexible`, and `constraints`.

## Elevation & Shape

- Use M3 tonal elevation (surface tint) not shadow-only elevation.
- Standard border radius follows M3 shape scale:
  - Extra small: 4px
  - Small: 8px
  - Medium: 12px
  - Large: 16px
  - Extra large: 28px
  - Full: circular
- `Card`, `Dialog`, `BottomSheet` use `shape: RoundedRectangleBorder(borderRadius: ...)` from the theme — do not override per-instance unless the design spec requires it.

## Dark Mode

- All colors must work in both light and dark mode through `colorScheme` — test both.
- Never use fixed `Colors.white` or `Colors.black` for text or backgrounds.
- Use `colorScheme.surface` and `colorScheme.onSurface` for backgrounds/text in dark mode compatibility.

## Accessibility (Non-Negotiable)

- Every interactive widget must have a `Semantics` label or use a widget that provides one (e.g., `IconButton` with `tooltip`).
- Minimum touch target size: **48×48 logical pixels** (M3 requirement).
- Color contrast must meet **WCAG AA** (4.5:1 normal text, 3:1 large text) — `ColorScheme.fromSeed` ensures this automatically.
- Support `MediaQuery.textScaleFactor` — never hardcode font sizes that would prevent scaling.
