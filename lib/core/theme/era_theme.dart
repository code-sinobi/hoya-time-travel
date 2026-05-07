import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum EraType { ancient, medieval, industrial, modern, future }

abstract class EraTheme extends ThemeExtension<EraTheme> {
  const EraTheme({
    required this.primaryColor,
    required this.secondaryColor,
    required this.backgroundColor,
    required this.surfaceColor,
    required this.textColor,
    required this.headlineStyle,
    required this.bodyStyle,
    required this.captionStyle,
    required this.buttonShape,
    required this.backgroundAsset,
  });
  final Color primaryColor;
  final Color secondaryColor;
  final Color backgroundColor;
  final Color surfaceColor;
  final Color textColor;
  final TextStyle headlineStyle;
  final TextStyle bodyStyle;
  final TextStyle captionStyle;
  final OutlinedBorder buttonShape;
  final String backgroundAsset;

  @override
  ThemeExtension<EraTheme> copyWith({
    Color? primaryColor,
    Color? secondaryColor,
    Color? backgroundColor,
    Color? surfaceColor,
    Color? textColor,
    TextStyle? headlineStyle,
    TextStyle? bodyStyle,
    TextStyle? captionStyle,
    OutlinedBorder? buttonShape,
    String? backgroundAsset,
  }) {
    return GenericEraTheme(
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      surfaceColor: surfaceColor ?? this.surfaceColor,
      textColor: textColor ?? this.textColor,
      headlineStyle: headlineStyle ?? this.headlineStyle,
      bodyStyle: bodyStyle ?? this.bodyStyle,
      captionStyle: captionStyle ?? this.captionStyle,
      buttonShape: buttonShape ?? this.buttonShape,
      backgroundAsset: backgroundAsset ?? this.backgroundAsset,
    );
  }

  @override
  ThemeExtension<EraTheme> lerp(ThemeExtension<EraTheme>? other, double t) {
    if (other is! EraTheme) return this;
    return GenericEraTheme(
      primaryColor: Color.lerp(primaryColor, other.primaryColor, t)!,
      secondaryColor: Color.lerp(secondaryColor, other.secondaryColor, t)!,
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
      surfaceColor: Color.lerp(surfaceColor, other.surfaceColor, t)!,
      textColor: Color.lerp(textColor, other.textColor, t)!,
      headlineStyle: TextStyle.lerp(headlineStyle, other.headlineStyle, t)!,
      bodyStyle: TextStyle.lerp(bodyStyle, other.bodyStyle, t)!,
      captionStyle: TextStyle.lerp(captionStyle, other.captionStyle, t)!,
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
    required super.textColor,
    required super.headlineStyle,
    required super.bodyStyle,
    required super.captionStyle,
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
          textColor: MythicColors.parchment,
          headlineStyle: GoogleFonts.cinzelDecorative(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: MythicColors.parchment,
            shadows: [
              const BoxShadow(
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
          captionStyle: GoogleFonts.cormorantGaramond(
            fontSize: 12,
            color: MythicColors.stoneGray,
          ),
          buttonShape: BeveledRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: MythicColors.bronze),
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
          textColor: Colors.white,
          headlineStyle: GoogleFonts.cinzelDecorative(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          bodyStyle: GoogleFonts.cormorantGaramond(
            fontSize: 18,
            color: const Color(0xFFD0D0FF),
          ),
          captionStyle: GoogleFonts.cormorantGaramond(
            fontSize: 12,
            color: const Color(0xFFD0D0FF).withValues(alpha: 0.7),
          ),
          buttonShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: MythicColors.bronze),
          ),
          backgroundAsset: 'assets/eras/future_bg.json',
        );
}

class MedievalEraTheme extends EraTheme {
  MedievalEraTheme()
      : super(
          primaryColor: MythicColors.stoneGray,
          secondaryColor: MythicColors.bronze,
          backgroundColor: MythicColors.voidBackground,
          surfaceColor: MythicColors.deepIndigo.withValues(alpha: 0.4),
          textColor: MythicColors.parchment,
          headlineStyle: GoogleFonts.cinzelDecorative(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: MythicColors.parchment,
          ),
          bodyStyle: GoogleFonts.cormorantGaramond(
            fontSize: 18,
            color: MythicColors.parchment.withValues(alpha: 0.9),
            fontWeight: FontWeight.w500,
          ),
          captionStyle: GoogleFonts.cormorantGaramond(
            fontSize: 12,
            color: MythicColors.stoneGray,
          ),
          buttonShape: BeveledRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: MythicColors.stoneGray, width: 2),
          ),
          backgroundAsset: 'assets/eras/medieval_bg.json',
        );
}

class IndustrialEraTheme extends EraTheme {
  IndustrialEraTheme()
      : super(
          primaryColor: MythicColors.warning, // Gold/Brass
          secondaryColor: MythicColors.stoneGray,
          backgroundColor: MythicColors.voidBackground,
          surfaceColor: MythicColors.deepIndigo.withValues(alpha: 0.5),
          textColor: MythicColors.parchment,
          headlineStyle: GoogleFonts.cinzelDecorative(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: MythicColors.warning,
          ),
          bodyStyle: GoogleFonts.cormorantGaramond(
            fontSize: 18,
            color: MythicColors.parchment.withValues(alpha: 0.9),
          ),
          captionStyle: GoogleFonts.cormorantGaramond(
            fontSize: 12,
            color: MythicColors.stoneGray,
          ),
          buttonShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
            side: const BorderSide(color: MythicColors.warning),
          ),
          backgroundAsset: 'assets/eras/industrial_bg.json',
        );
}

class ModernEraTheme extends EraTheme {
  ModernEraTheme()
      : super(
          primaryColor: MythicColors.wormholeBlue,
          secondaryColor: MythicColors.parchment,
          backgroundColor: MythicColors.voidBackground,
          surfaceColor: MythicColors.deepIndigo.withValues(alpha: 0.6),
          textColor: Colors.white,
          headlineStyle: GoogleFonts.cinzelDecorative(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          bodyStyle: GoogleFonts.cormorantGaramond(
            fontSize: 18,
            color: Colors.white.withValues(alpha: 0.9),
          ),
          captionStyle: GoogleFonts.cormorantGaramond(
            fontSize: 12,
            color: MythicColors.stoneGray,
          ),
          buttonShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: MythicColors.wormholeBlue),
          ),
          backgroundAsset: 'assets/eras/modern_bg.json',
        );
}
