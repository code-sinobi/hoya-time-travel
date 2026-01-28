import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'era_theme.dart';

part 'app_theme.g.dart';

@riverpod
class CurrentEra extends _$CurrentEra {
  @override
  EraType build() => EraType.ancient;

  void setEra(EraType era) => state = era;
}

@riverpod
ThemeData appTheme(Ref ref) {
  final currentEra = ref.watch(currentEraProvider);

  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: MythicColors.voidBackground,
    primaryColor: MythicColors.bronze,

    // Define the base color scheme
    colorScheme: ColorScheme.fromSeed(
      seedColor: MythicColors.bronze,
      brightness: Brightness.dark,
      surface: MythicColors.deepIndigo,
      onSurface: MythicColors.parchment,
      primary: MythicColors.bronze,
      secondary: MythicColors.parchment,
      tertiary: MythicColors.ochreRed,
      error: MythicColors.ochreRed,
    ),

    // AppBar Icon Theme
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: MythicColors.bronze),
    ),

    // Text Theme (Mythic)
    textTheme:
        GoogleFonts.cormorantGaramondTextTheme(
          ThemeData.dark().textTheme,
        ).copyWith(
          displayLarge: GoogleFonts.cinzelDecorative(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: MythicColors.parchment,
            shadows: [
              const BoxShadow(
                color: Colors.black,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          displayMedium: GoogleFonts.cinzelDecorative(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: MythicColors.bronze,
          ),
          bodyLarge: GoogleFonts.cormorantGaramond(
            fontSize: 18,
            color: MythicColors.parchment,
            height: 1.4,
          ),
          bodyMedium: GoogleFonts.cormorantGaramond(
            fontSize: 16,
            color: MythicColors.parchment.withValues(alpha: 0.9),
          ),
          labelLarge: GoogleFonts.cinzel(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
            color: MythicColors.bronze,
          ),
        ),

    // Register Extensions
    extensions: [
      if (currentEra == EraType.ancient)
        AncientEraTheme()
      else
        FutureEraTheme(), // Now adapted to mythic style
    ],
  );
}
