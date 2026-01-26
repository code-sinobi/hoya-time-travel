import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum EraType {
  ancient,
  medieval,
  industrial,
  modern,
  future,
}

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

class AncientEraTheme extends EraTheme {
  AncientEraTheme()
      : super(
          primaryColor: const Color(0xFFC17E4C), // Terracotta
          secondaryColor: const Color(0xFFD4AF37), // Gold
          backgroundColor: const Color(0xFF2C241B), // Dark Earth
          surfaceColor: const Color(0xFF3E3226), // Rough Stone
          headlineStyle: GoogleFonts.cinzel(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFE8DCCA),
          ),
          bodyStyle: GoogleFonts.crimsonText(
            fontSize: 18,
            color: const Color(0xFFD8C8B8),
          ),
          buttonShape: BeveledRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundAsset: 'assets/eras/ancient_bg.json',
        );
}

class FutureEraTheme extends EraTheme {
  FutureEraTheme()
      : super(
          primaryColor: const Color(0xFF00F0FF), // Neon Cyan
          secondaryColor: const Color(0xFFFF003C), // Cyber Punk Red
          backgroundColor: const Color(0xFF050510), // Deep Void
          surfaceColor: const Color(0xFF0A0A1F).withValues(alpha: 0.8), // Glass
          headlineStyle: GoogleFonts.orbitron(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            shadows: [
              const BoxShadow(color: Color(0xFF00F0FF), blurRadius: 10)
            ],
          ),
          bodyStyle: GoogleFonts.exo2(
            fontSize: 16,
            color: const Color(0xFFAAAAAA),
          ),
          buttonShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Color(0xFF00F0FF), width: 2),
          ),
          backgroundAsset: 'assets/eras/future_bg.json',
        );
}
