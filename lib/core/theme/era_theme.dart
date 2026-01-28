import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum EraType { ancient, medieval, industrial, modern, future }

abstract class EraTheme extends ThemeExtension<EraTheme> {
  final Color primaryColor;
  final Color secondaryColor;
  final Color backgroundColor;
  final Color surfaceColor;
  final TextStyle headlineStyle;
  final TextStyle bodyStyle;
  final OutlinedBorder buttonShape;
  final String backgroundAsset;

  const EraTheme({
    required this.primaryColor,
    required this.secondaryColor,
    required this.backgroundColor,
    required this.surfaceColor,
    required this.headlineStyle,
    required this.bodyStyle,
    required this.buttonShape,
    required this.backgroundAsset,
  });

  @override
  ThemeExtension<EraTheme> copyWith() => this;

  @override
  ThemeExtension<EraTheme> lerp(ThemeExtension<EraTheme>? other, double t) {
    if (other is! EraTheme) return this;
    return GenericEraTheme(
      primaryColor: Color.lerp(primaryColor, other.primaryColor, t)!,
      secondaryColor: Color.lerp(secondaryColor, other.secondaryColor, t)!,
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
      surfaceColor: Color.lerp(surfaceColor, other.surfaceColor, t)!,
      headlineStyle: TextStyle.lerp(headlineStyle, other.headlineStyle, t)!,
      bodyStyle: TextStyle.lerp(bodyStyle, other.bodyStyle, t)!,
      buttonShape: OutlinedBorder.lerp(buttonShape, other.buttonShape, t)!,
      backgroundAsset: t < 0.5 ? backgroundAsset : other.backgroundAsset,
    );
  }
}

class GenericEraTheme extends EraTheme {
  const GenericEraTheme({
    required super.primaryColor,
    required super.secondaryColor,
    required super.backgroundColor,
    required super.surfaceColor,
    required super.headlineStyle,
    required super.bodyStyle,
    required super.buttonShape,
    required super.backgroundAsset,
  });
}

// Mythic Color Palette
class MythicColors {
  static const bronze = Color(0xFFD4A574);
  static const parchment = Color(0xFFE8DCC4);
  static const deepIndigo = Color(0xFF2E3A59);
  static const ochreRed = Color(0xFFB85450); // Error/Danger
  static const stoneGray = Color(0xFF6B6B6B);
  static const voidBackground = Color(0xFF0A0A0F);

  // Semantic Aliases
  static const error = ochreRed;
  static const warning = Color(0xFFC9A227); // Ancient Gold for warning
  static const success = Color(0xFF4E8D7C); // Aged Patina Green

  // Sci-Fi Additions
  static const wormholeBlue = Color(0xFF2A6BDB);
  static const temporalGold = Color(0xFFFFD700);
  static const fluxCyan = Color(0xFF00D4FF);
}

class AncientEraTheme extends EraTheme {
  AncientEraTheme()
    : super(
        primaryColor: MythicColors.bronze,
        secondaryColor: MythicColors.parchment,
        backgroundColor: MythicColors.voidBackground,
        surfaceColor: MythicColors.deepIndigo.withValues(alpha: 0.3),
        headlineStyle: GoogleFonts.cinzelDecorative(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: MythicColors.parchment,
          shadows: [
            const BoxShadow(
              color: Colors.black,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        bodyStyle: GoogleFonts.cormorantGaramond(
          fontSize: 18,
          color: MythicColors.parchment.withValues(alpha: 0.9),
          fontWeight: FontWeight.w500,
        ),
        buttonShape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: MythicColors.bronze, width: 1),
        ),
        backgroundAsset: 'assets/eras/ancient_bg.json',
      );
}

// "Future" is now just another chapter in the Archive, using mystical aesthetics
class FutureEraTheme extends EraTheme {
  FutureEraTheme()
    : super(
        primaryColor: MythicColors.bronze,
        secondaryColor: const Color(
          0xFF7B2CBF,
        ), // Mystical Purple instead of bright colors
        backgroundColor: MythicColors.voidBackground,
        surfaceColor: const Color(0xFF1A1A2E).withValues(alpha: 0.8),
        headlineStyle: GoogleFonts.cinzelDecorative(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        bodyStyle: GoogleFonts.cormorantGaramond(
          fontSize: 18,
          color: const Color(0xFFD0D0FF),
        ),
        buttonShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: MythicColors.bronze, width: 1),
        ),
        backgroundAsset: 'assets/eras/future_bg.json',
      );
}
