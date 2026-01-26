import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'era_theme.dart';
import 'galactic_colors.dart';
import 'galactic_theme.dart';

part 'app_theme.g.dart';

@riverpod
class CurrentEra extends _$CurrentEra {
  @override
  EraType build() => EraType.ancient;

  void setEra(EraType era) => state = era;
}

@riverpod
ThemeData appTheme(Ref ref) {
  // We can still watch currentEra if we want era-specific tweaks,
  // but the base theme is now Galactic.
  final currentEra = ref.watch(currentEraProvider);

  // Initialize GalacticTheme extension
  const galacticTheme = GalacticTheme(
    temporalEnergy: GalacticColors.temporalGold,
    portalGlow: GalacticColors.neonCyan,
    starField: GalacticColors.deepNebula,
    timelineFont: TextStyle(
      fontFamily: 'Orbitron',
    ), // Will be updated with GoogleFonts in main textTheme
    hudFont: TextStyle(fontFamily: 'Orbitron'),
  );

  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: GalacticColors.spaceBlack,
    primaryColor: GalacticColors.wormholeBlue,

    // Define the base color scheme
    colorScheme: ColorScheme.fromSeed(
      seedColor: GalacticColors.wormholeBlue,
      brightness: Brightness.dark,
      surface: GalacticColors.deepNebula,
      onSurface: GalacticColors.starWhite,
      primary: GalacticColors.neonCyan,
      secondary: GalacticColors.quantumPurple,
      tertiary: GalacticColors.temporalGold,
    ),

    // AppBar Icon Theme
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: GalacticColors.neonCyan),
    ),

    // Text Theme (Futuristic)
    textTheme: GoogleFonts.exo2TextTheme(ThemeData.dark().textTheme).copyWith(
      displayLarge: GoogleFonts.orbitron(
        fontSize: 32,
        fontWeight: FontWeight.w900,
        color: GalacticColors.neonCyan,
      ),
      displayMedium: GoogleFonts.orbitron(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      bodyLarge: GoogleFonts.exo2(
        fontSize: 16,
        color: GalacticColors.starWhite,
      ),
      bodyMedium: GoogleFonts.exo2(
        fontSize: 14,
        color: GalacticColors.starWhite.withOpacity(0.9),
      ),
      labelLarge: GoogleFonts.audiowide(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: GalacticColors.temporalGold,
      ),
    ),

    // Register Extensions
    extensions: [
      galacticTheme,
      // Keep EraTheme logic if needed, or replace/simplify
      if (currentEra == EraType.ancient)
        AncientEraTheme()
      else
        FutureEraTheme(),
    ],
  );
}
