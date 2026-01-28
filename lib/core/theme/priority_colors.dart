import 'package:flutter/material.dart';

/// Priority-based color system for anomaly severity visualization
class PriorityColors {
  // Critical Priority - Timeline Desync Emergencies
  static const Color critical = Color(0xFFFF4757);
  static const Color criticalBorder = Color(0xFFFF4757);
  static const Color criticalBackground = Color(0xFF1E1010); // Dark red stone
  static const Color criticalText = Color(0xFFFF4757);

  // High Priority - Urgent Anomalies
  static const Color high = Color(0xFFFFA502);
  static const Color highBorder = Color(0xFFFFA502);
  static const Color highBackground = Color(0xFF2C241B); // Dark parchment
  static const Color highText = Color(0xFFFFA502);

  // Stable/Medium Priority - Use existing mythic colors
  static const Color stable = Color(0xFF2E3A59); // deepIndigo
  static const Color stableBorder = Color(0xFF2E3A59);
  static const Color stableBackground = Color(0xFF1A1A24); // Dark blue stone
  static const Color stableText = Color(0xFF7FA1C3);
}
