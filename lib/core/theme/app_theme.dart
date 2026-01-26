import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  EraTheme eraTheme;
  switch (currentEra) {
    case EraType.ancient:
      eraTheme = AncientEraTheme();
      break;
    case EraType.future:
      eraTheme = FutureEraTheme();
      break;
    default:
      eraTheme = AncientEraTheme(); // Default fallback
  }

  return ThemeData(
    useMaterial3: true,
    colorScheme:
        ColorScheme.fromSeed(
          seedColor: eraTheme.primaryColor,
          brightness: Brightness.dark,
          // Deprecated usage fixed below
          surface: eraTheme.surfaceColor,
        ).copyWith(
          // Ensure background is consistent with scaffoldBackgroundColor if needed,
          // though scaffoldBackgroundColor is set explicitly below.
          surface: eraTheme.surfaceColor,
        ),
    extensions: [eraTheme],
    scaffoldBackgroundColor: eraTheme.backgroundColor,
    textTheme: TextTheme(
      displayLarge: eraTheme.headlineStyle,
      bodyLarge: eraTheme.bodyStyle,
    ),
  );
}
