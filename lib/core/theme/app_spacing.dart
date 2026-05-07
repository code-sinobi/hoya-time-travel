import 'package:flutter/material.dart';

/// AppSpacing — The Single Source of Truth for All Layout Values
///
/// RULES:
/// ❌ NEVER use raw numbers like `EdgeInsets.all(12)` or `SizedBox(height: 20)`
/// ✅ ALWAYS use a named constant from this file
///
/// Spacing scale follows an 8-point grid system (4pt base unit).
/// Every value is a multiple of 4.
abstract final class AppSpacing {
  // ── Base unit ──────────────────────────────────────────────────────
  static const double unit = 4.0;

  // ── Spatial scale ─────────────────────────────────────────────────
  static const double xxs = 4.0; // unit × 1
  static const double xs = 8.0; // unit × 2
  static const double sm = 12.0; // unit × 3
  static const double md = 16.0; // unit × 4  ← default content padding
  static const double lg = 24.0; // unit × 6  ← section gaps
  static const double xl = 32.0; // unit × 8
  static const double xxl = 48.0; // unit × 12 ← screen-level padding
  static const double x3l = 64.0; // unit × 16
  static const double x4l = 80.0; // unit × 20 ← bottom nav clearance

  // ── Screen-edge padding ───────────────────────────────────────────
  static const double screenHorizontal = md; // 16
  static const double screenVertical = lg; // 24
  static const double cardPadding = lg; // 24

  // ── Common EdgeInsets shorthands ──────────────────────────────────
  static const allXxs = EdgeInsets.all(xxs);
  static const allXs = EdgeInsets.all(xs);
  static const allSm = EdgeInsets.all(sm);
  static const allMd = EdgeInsets.all(md);
  static const allLg = EdgeInsets.all(lg);
  static const allXl = EdgeInsets.all(xl);

  static const horizontalMd = EdgeInsets.symmetric(horizontal: md);
  static const horizontalLg = EdgeInsets.symmetric(horizontal: lg);
  static const verticalXs = EdgeInsets.symmetric(vertical: xs);
  static const verticalSm = EdgeInsets.symmetric(vertical: sm);
  static const verticalMd = EdgeInsets.symmetric(vertical: md);

  static const screenPadding = EdgeInsets.symmetric(
    horizontal: screenHorizontal,
    vertical: screenVertical,
  );
  static const cardInsets = EdgeInsets.all(cardPadding);
}

// ── Border radii ──────────────────────────────────────────────────
abstract final class AppRadius {
  static const double none = 0.0;
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double pill = 100.0; // fully rounded
  static const double circle = 999.0;
}

// ── Icon sizes ────────────────────────────────────────────────────
abstract final class AppIconSize {
  static const double xs = 16.0;
  static const double sm = 20.0;
  static const double md = 24.0; // Material default
  static const double lg = 32.0;
  static const double xl = 48.0;
  static const double xxl = 60.0;
}

// ── Minimum touch targets (WCAG 2.5.8 / Material 3) ──────────────
abstract final class AppTouch {
  /// Absolute minimum — WCAG 2.5.8
  static const double min = 24.0;

  /// Material 3 recommended minimum
  static const double recommended = 48.0;

  /// iOS HIG recommended minimum
  static const double ios = 44.0;
}

// ── Elevation / shadow spreads ────────────────────────────────────
abstract final class AppElevation {
  static const double none = 0.0;
  static const double low = 2.0;
  static const double medium = 8.0;
  static const double high = 16.0;
  static const double modal = 24.0;
}

// ── Animation durations ───────────────────────────────────────────
abstract final class AppDuration {
  static const Duration instant = Duration(milliseconds: 100);
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration standard = Duration(milliseconds: 350);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration crawl = Duration(milliseconds: 800);
  static const Duration ambient = Duration(seconds: 2);
}

// ── Typography scale ──────────────────────────────────────────────
abstract final class FontSize {
  static const double micro = 10.0;
  static const double caption = 12.0;
  static const double body = 16.0;
  static const double bodyLg = 18.0;
  static const double title = 20.0;
  static const double heading = 24.0;
  static const double display = 32.0;
  static const double hero = 48.0;
}

// ── Line heights ──────────────────────────────────────────────────
abstract final class LineHeight {
  static const double tight = 1.2;
  static const double standard = 1.5;
  static const double relaxed = 1.6;
  static const double loose = 1.8;
}

// ── Letter spacing ────────────────────────────────────────────────
abstract final class LetterSpacing {
  static const double tight = -0.5;
  static const double normal = 0.0;
  static const double wide = 0.5;
  static const double wider = 1.0;
  static const double widest = 2.0;
  static const double ultraWide = 4.0;
}
