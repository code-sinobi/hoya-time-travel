import 'package:flutter/material.dart';

class GalacticColors {
  // Core Galactic Palette
  static const Color spaceBlack = Color(0xFF0A0E17);
  static const Color deepNebula = Color(0xFF1A1F3B);
  static const Color wormholeBlue = Color(0xFF2A6BDB);
  static const Color quantumPurple = Color(0xFF9D4EDD);
  static const Color temporalGold = Color(0xFFFFD700);
  static const Color etherealCyan = Color(0xFF00D4FF);
  static const Color singularityBlack = Color(0xFF000814);
  static const Color starWhite = Color(0xFFF0F8FF);

  // Glowing effects
  static const List<BoxShadow> glowCyan = [
    BoxShadow(color: Color(0x4000D4FF), blurRadius: 20, spreadRadius: 2),
  ];

  static const List<BoxShadow> glowGold = [
    BoxShadow(color: Color(0x40FFD700), blurRadius: 15, spreadRadius: 1),
  ];

  // Era-specific palettes
  static Map<String, List<Color>> eraGradients = {
    'mythic': [
      const Color(0xFF8B0000),
      const Color(0xFFD4AF37),
    ], // Blood red to gold
    'ancient': [
      const Color(0xFF8B4513),
      const Color(0xFFD2691E),
    ], // Earth tones
    'medieval': [
      const Color(0xFF2F4F4F),
      const Color(0xFF696969),
    ], // Stone grays
    'renaissance': [
      const Color(0xFF4B0082),
      const Color(0xFF9400D3),
    ], // Royal purples
    'futuristic': [etherealCyan, wormholeBlue], // Mystical blues
  };
}
