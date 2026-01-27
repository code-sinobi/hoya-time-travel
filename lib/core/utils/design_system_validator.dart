import 'package:flutter/material.dart';
import '../../core/theme/era_theme.dart';

class DesignSystemValidator {
  /// Validates that the current theme adhere's to Hoya's Mythic Design System.
  /// This should be called in `main.dart` during debug mode.
  static void validateTheme(ThemeData theme) {
    // 1. Check Primary Color (Mythic Bronze)
    if (theme.primaryColor.toARGB32() != MythicColors.bronze.toARGB32()) {
      debugPrint(
        '⚠️ DESIGN VIOLATION: Primary color must be Mythic Bronze (${MythicColors.bronze.toHex()}). Found: ${theme.primaryColor.toARGB32().toRadixString(16)}',
      );
    }

    // 2. Check Background Color (Void/Indigo)
    if (theme.scaffoldBackgroundColor.toARGB32() !=
            MythicColors.voidBackground.toARGB32() &&
        theme.scaffoldBackgroundColor.toARGB32() !=
            MythicColors.deepIndigo.toARGB32()) {
      debugPrint(
        '⚠️ DESIGN VIOLATION: Background must be Void or Deep Indigo.',
      );
    }

    // 3. Check Typography (Cinzel for Headlines)
    final headlineFont = theme.textTheme.headlineLarge?.fontFamily;
    // Note: GoogleFonts might return null or a specific family name.
    // We check if it contains "Cinzel" loosely or if it's null (default).
    if (headlineFont != null && !headlineFont.contains('Cinzel')) {
      debugPrint(
        '⚠️ DESIGN VIOLATION: Headlines must use Cinzel font. Found: $headlineFont',
      );
    }
  }
}

extension HexColor on Color {
  String toHex() =>
      '#${toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase()}';
}
