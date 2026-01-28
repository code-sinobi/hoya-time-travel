import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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
  final eraTheme =
      currentEra == EraType.ancient ? AncientEraTheme() : FutureEraTheme();

  return ThemeData(
    useMaterial3: true,
    primaryColor: eraTheme.primaryColor,
    scaffoldBackgroundColor: eraTheme.backgroundColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: eraTheme.primaryColor,
      primary: eraTheme.primaryColor,
      brightness: Brightness.dark,
      surface: eraTheme.surfaceColor,
    ).copyWith(
      surface: eraTheme.surfaceColor,
    ),
    extensions: [eraTheme],
    textTheme: TextTheme(
      displayLarge: eraTheme.headlineStyle,
      displayMedium: eraTheme.headlineStyle,
      displaySmall: eraTheme.headlineStyle,
      headlineLarge: eraTheme.headlineStyle,
      headlineMedium: eraTheme.headlineStyle,
      headlineSmall: eraTheme.headlineStyle,
      bodyLarge: eraTheme.bodyStyle,
      bodyMedium: eraTheme.bodyStyle,
      bodySmall: eraTheme.bodyStyle,
    ),
  );
}
