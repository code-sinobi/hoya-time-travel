import 'package:flutter/material.dart';

/// MythicColors — The Canonical Color System for Chrono
///
/// ══════════════════════════════════════════════════════════════════
/// ██  MANDATORY RULES — ZERO EXCEPTIONS  ████████████████████████
/// ══════════════════════════════════════════════════════════════════
///
/// ❌ FORBIDDEN — will fail CI:
///   • Colors.red / .blue / .green / .yellow / .purple / .orange / .cyan
///   • Colors.white / Colors.black  (use the named tokens below)
///   • Colors.transparent           (use Color(0x00000000) or named token)
///   • Raw Color(0xFFxxxxxx) literals anywhere outside THIS file and
///     era_theme.dart
///   • Colors.amber / Colors.purpleAccent / Colors.cyanAccent
///
/// ✅ ALLOWED:
///   • Any static const from MythicColors
///   • Any static const from GalacticColors (for sci-fi/future sections)
///   • EraTheme.primaryColor / .surfaceColor / etc. (via context)
///   • Color.lerp() with tokens as arguments
///   • token.withValues(alpha: x) — withOpacity is deprecated, use withValues
///
/// ══════════════════════════════════════════════════════════════════
abstract final class MythicColors {
  // ── Core Brand Palette ─────────────────────────────────────────
  /// The signature warm gold — primary CTAs, highlights, nav selection
  static const Color bronze = Color(0xFFD4A574);

  /// Aged paper — primary text on dark backgrounds
  static const Color parchment = Color(0xFFE8DCC4);

  /// Deep night-sky indigo — secondary surfaces, card fills
  static const Color deepIndigo = Color(0xFF2E3A59);

  /// Void — the app's true background black
  static const Color voidBackground = Color(0xFF0A0A0F);

  /// Stone — disabled states, placeholder text, inactive icons
  static const Color stoneGray = Color(0xFF6B6B6B);

  // ── Semantic / Functional ──────────────────────────────────────
  /// Error states, destructive actions
  static const Color error = Color(0xFFB85450); // ochreRed

  /// Warning states, energy-cost indicators
  static const Color warning = Color(0xFFC9A227); // ancient gold

  /// Success, completed states, positive feedback
  static const Color success = Color(0xFF4E8D7C); // aged patina green

  /// Information / neutral highlights
  static const Color info = Color(0xFF3A6EA5);

  // ── Aliased names (backward compat) ───────────────────────────
  static const Color ochreRed = error;
  static const Color ancientGold = warning;

  // ── Sci-Fi / Future Accents (use only in future-era screens) ──
  static const Color wormholeBlue = Color(0xFF2A6BDB);
  static const Color temporalGold = Color(0xFFFFD700);
  static const Color fluxCyan = Color(0xFF00D4FF);
  static const Color quantumPurple = Color(0xFF9D4EDD);

  // ── Surface hierarchy ─────────────────────────────────────────
  /// Elevation level 0 — true background
  static const Color surface0 = voidBackground;

  /// Elevation level 1 — cards, bottom sheets
  static const Color surface1 = Color(0xFF111118);

  /// Elevation level 2 — modal dialogs, overlays
  static const Color surface2 = Color(0xFF1A1A24);

  /// Elevation level 3 — tooltips, popovers
  static const Color surface3 = Color(0xFF1E1E2C);

  // ── Near-neutral ──────────────────────────────────────────────
  /// Pure white equivalent — NEVER use Colors.white
  static const Color white = Color(0xFFF0F0F0);

  /// Pure black equivalent — NEVER use Colors.black
  static const Color black = Color(0xFF000000);

  /// Fully transparent — NEVER use Colors.transparent
  static const Color transparent = Color(0x00000000);

  // ── State overlays (use withValues(alpha:) on the base) ───────
  /// Hover / pressed overlay on bronze
  static Color bronzeHover = bronze.withValues(alpha: 0.15);
  static Color bronzeBorder = bronze.withValues(alpha: 0.30);
  static Color bronzeGlow = bronze.withValues(alpha: 0.50);

  /// Disabled content — applies to text and icons
  static Color disabled = stoneGray.withValues(alpha: 0.50);

  /// Scrim — covers background during modal
  static Color scrim = black.withValues(alpha: 0.60);

  // ── Gradient presets ──────────────────────────────────────────
  static const Gradient portalGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [voidBackground, deepIndigo],
  );

  static const Gradient bronzeGradient = LinearGradient(
    colors: [Color(0xFFD4A574), Color(0xFF8B6914)],
  );

  static const Gradient ancientGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF8B4513), Color(0xFFD2691E)],
  );

  static const Gradient mythicGradient = LinearGradient(
    colors: [Color(0xFF8B0000), Color(0xFFD4AF37)],
  );

  static const Gradient futureGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2A6BDB), Color(0xFF00D4FF)],
  );

  // ── BoxShadow presets ─────────────────────────────────────────
  static const List<BoxShadow> glowBronze = [
    BoxShadow(color: Color(0x50D4A574), blurRadius: 15, spreadRadius: 1),
  ];

  static const List<BoxShadow> glowError = [
    BoxShadow(color: Color(0x50B85450), blurRadius: 12, spreadRadius: 1),
  ];

  static const List<BoxShadow> cardShadow = [
    BoxShadow(color: Color(0x80000000), blurRadius: 10, offset: Offset(0, 4)),
  ];

  static const List<BoxShadow> modalShadow = [
    BoxShadow(color: Color(0xA0000000), blurRadius: 20, offset: Offset(0, 8)),
  ];

  // ── Era-specific accent look-up ───────────────────────────────
  /// Returns the accent color for a given era string.
  /// Used for story card borders and labels.
  static Color forEra(String era) {
    switch (era.toLowerCase()) {
      case 'mythic':
        return const Color(0xFFD4AF37);
      case 'ancient':
        return bronze;
      case 'medieval':
        return const Color(0xFF708090);
      case 'industrial':
        return const Color(0xFF8B7355);
      case 'modern':
        return const Color(0xFF607D8B);
      case 'future':
        return fluxCyan;
      default:
        return stoneGray;
    }
  }
}
