/// AppTypography — Canonical Text Style Definitions for Chrono
///
/// ══════════════════════════════════════════════════════════════════
/// ██  MANDATORY RULES  ████████████████████████████████████████████
/// ══════════════════════════════════════════════════════════════════
///
/// ❌ FORBIDDEN:
///   • Inline TextStyle() definitions inside widgets
///   • GoogleFonts.xxx() called directly inside build() methods
///   • Raw fontSize numbers (e.g., fontSize: 14) without AppSpacing.FontSize
///   • Raw fontWeight values without the FontWeight constants below
///   • Hardcoded color in TextStyle — always use MythicColors or EraTheme
///
/// ✅ ALLOWED:
///   • AppTypography.headlineXl, .body, .caption, etc.
///   • style.copyWith(color: ...) to override color contextually
///   • EraTheme.headlineStyle / .bodyStyle / .captionStyle for era-aware text
///
/// Font assignments:
///   • Cinzel Decorative  → App branding / hero titles
///   • Cinzel             → Section headings, labels, UI chrome
///   • Cormorant Garamond → Story body text (narrative)
///   • Orbitron           → Nav bar labels, HUD counters
///   • Space Mono         → IDs, codes, monospaced data
///   • Exo 2              → General UI body / subheadings
///
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_spacing.dart';
import 'mythic_colors.dart';

abstract final class AppTypography {
  // ── Brand / Hero ───────────────────────────────────────────────
  static TextStyle get heroDisplay => GoogleFonts.cinzelDecorative(
        fontSize: FontSize.hero,
        fontWeight: FontWeight.bold,
        color: MythicColors.parchment,
        letterSpacing: LetterSpacing.wide,
        shadows: const [
          Shadow(color: Color(0x80000000), blurRadius: 8),
        ],
      );

  static TextStyle get headlineXl => GoogleFonts.cinzelDecorative(
        fontSize: FontSize.display,
        fontWeight: FontWeight.bold,
        color: MythicColors.parchment,
        letterSpacing: LetterSpacing.wide,
      );

  // ── Section / UI Headings (Cinzel) ─────────────────────────────
  static TextStyle get headingLg => GoogleFonts.cinzel(
        fontSize: FontSize.heading,
        fontWeight: FontWeight.bold,
        color: MythicColors.parchment,
        letterSpacing: LetterSpacing.wider,
      );

  static TextStyle get headingMd => GoogleFonts.cinzel(
        fontSize: FontSize.title,
        fontWeight: FontWeight.bold,
        color: MythicColors.parchment,
        letterSpacing: LetterSpacing.wide,
      );

  static TextStyle get headingSm => GoogleFonts.cinzel(
        fontSize: FontSize.body,
        fontWeight: FontWeight.bold,
        color: MythicColors.bronze,
        letterSpacing: LetterSpacing.wider,
      );

  static TextStyle get label => GoogleFonts.cinzel(
        fontSize: FontSize.caption,
        fontWeight: FontWeight.w600,
        color: MythicColors.bronze,
        letterSpacing: LetterSpacing.widest,
      );

  // ── Narrative / Story Text (Cormorant Garamond) ────────────────
  static TextStyle get storyBodyLg => GoogleFonts.cormorantGaramond(
        fontSize: FontSize.bodyLg,
        fontWeight: FontWeight.w500,
        color: MythicColors.parchment,
        height: LineHeight.relaxed,
      );

  static TextStyle get storyBody => GoogleFonts.cormorantGaramond(
        fontSize: FontSize.body,
        color: MythicColors.parchment,
        height: LineHeight.relaxed,
      );

  static TextStyle get storyCaption => GoogleFonts.cormorantGaramond(
        fontSize: FontSize.caption,
        color: MythicColors.stoneGray,
        height: LineHeight.standard,
      );

  // ── HUD / Navigation (Orbitron) ────────────────────────────────
  static TextStyle get hudLabel => GoogleFonts.orbitron(
        fontSize: FontSize.micro,
        fontWeight: FontWeight.bold,
        color: MythicColors.bronze,
        letterSpacing: LetterSpacing.wider,
      );

  static TextStyle get hudValue => GoogleFonts.orbitron(
        fontSize: FontSize.caption,
        fontWeight: FontWeight.w500,
        color: MythicColors.parchment,
      );

  static TextStyle get navLabel => GoogleFonts.orbitron(
        fontSize: FontSize.micro,
        fontWeight: FontWeight.w500,
        letterSpacing: LetterSpacing.wide,
      );

  // ── Code / ID (Space Mono) ─────────────────────────────────────
  static TextStyle get code => GoogleFonts.spaceMono(
        fontSize: FontSize.caption,
        color: MythicColors.bronze,
        letterSpacing: LetterSpacing.wide,
      );

  // ── General UI Body (Exo 2) ────────────────────────────────────
  static TextStyle get uiBody => GoogleFonts.exo2(
        fontSize: FontSize.body,
        color: MythicColors.parchment,
        height: LineHeight.standard,
      );

  static TextStyle get uiBodySm => GoogleFonts.exo2(
        fontSize: FontSize.caption,
        color: MythicColors.stoneGray,
      );

  static TextStyle get uiButton => GoogleFonts.cinzel(
        fontSize: FontSize.caption + 2,
        fontWeight: FontWeight.bold,
        letterSpacing: LetterSpacing.wider,
      );

  // ── Utility helpers ────────────────────────────────────────────
  /// Applies MythicColors.disabled to any style
  static TextStyle disabled(TextStyle base) =>
      base.copyWith(color: MythicColors.disabled);

  /// Applies error color to any style
  static TextStyle error(TextStyle base) =>
      base.copyWith(color: MythicColors.error);

  /// Applies success color to any style
  static TextStyle success(TextStyle base) =>
      base.copyWith(color: MythicColors.success);
}
