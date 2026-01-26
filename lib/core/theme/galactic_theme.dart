import 'package:flutter/material.dart';

class GalacticTheme extends ThemeExtension<GalacticTheme> {
  final Color temporalEnergy;
  final Color portalGlow;
  final Color starField;
  final TextStyle timelineFont;
  final TextStyle hudFont;

  const GalacticTheme({
    required this.temporalEnergy,
    required this.portalGlow,
    required this.starField,
    required this.timelineFont,
    required this.hudFont,
  });

  @override
  GalacticTheme copyWith({
    Color? temporalEnergy,
    Color? portalGlow,
    Color? starField,
    TextStyle? timelineFont,
    TextStyle? hudFont,
  }) {
    return GalacticTheme(
      temporalEnergy: temporalEnergy ?? this.temporalEnergy,
      portalGlow: portalGlow ?? this.portalGlow,
      starField: starField ?? this.starField,
      timelineFont: timelineFont ?? this.timelineFont,
      hudFont: hudFont ?? this.hudFont,
    );
  }

  @override
  GalacticTheme lerp(ThemeExtension<GalacticTheme>? other, double t) {
    if (other is! GalacticTheme) return this;
    return GalacticTheme(
      temporalEnergy: Color.lerp(temporalEnergy, other.temporalEnergy, t)!,
      portalGlow: Color.lerp(portalGlow, other.portalGlow, t)!,
      starField: Color.lerp(starField, other.starField, t)!,
      timelineFont: TextStyle.lerp(timelineFont, other.timelineFont, t)!,
      hudFont: TextStyle.lerp(hudFont, other.hudFont, t)!,
    );
  }
}
