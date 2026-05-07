import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/era_theme.dart';
import '../domain/era.dart';

/// Circular wheel showing era labels around the radar.
/// Handles tap interactions for era navigation.
class EraWheel extends StatelessWidget {
  const EraWheel({
    required this.radius,
    super.key,
    this.selectedEra,
    this.exploredEras = const {},
    this.onEraTapped,
  });

  /// Currently selected era
  final Era? selectedEra;

  /// Set of eras the user has explored
  final Set<Era> exploredEras;

  /// Callback when an era is tapped
  final ValueChanged<Era>? onEraTapped;

  /// Radius of the wheel (matches radar size)
  final double radius;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: radius * 2 + 80,
      height: radius * 2 + 80,
      child: Stack(
        alignment: Alignment.center,
        children: Era.values.map(_buildEraLabel).toList(),
      ),
    );
  }

  Widget _buildEraLabel(Era era) {
    final isExplored = exploredEras.contains(era);
    final isSelected = selectedEra == era;
    final angle = era.radarAngle;

    // Position label outside the radar circle
    final labelRadius = radius + 45;
    final dx = labelRadius * math.cos(angle);
    final dy = labelRadius * math.sin(angle);

    final eraColor = Color(era.colorValue);

    Widget label = GestureDetector(
      onTap: isExplored ? () => onEraTapped?.call(era) : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? eraColor.withValues(alpha: 0.3)
              : Colors.black.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? eraColor
                : (isExplored
                    ? eraColor.withValues(alpha: 0.5)
                    : MythicColors.stoneGray.withValues(alpha: 0.3)),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: eraColor.withValues(alpha: 0.4),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isExplored)
              Icon(
                Icons.lock_outline,
                size: 12,
                color: MythicColors.stoneGray.withValues(alpha: 0.5),
              ),
            if (!isExplored) const SizedBox(width: 4),
            Text(
              era.label,
              style: GoogleFonts.orbitron(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isExplored
                    ? (isSelected ? eraColor : Colors.white70)
                    : MythicColors.stoneGray.withValues(alpha: 0.5),
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );

    // Add glow animation for selected era
    if (isSelected) {
      label = label.animate(onPlay: (c) => c.repeat(reverse: true)).custom(
            duration: const Duration(milliseconds: 1500),
            builder: (context, value, child) => Opacity(
              opacity: 0.8 + (value * 0.2),
              child: child,
            ),
          );
    }

    return Transform.translate(
      offset: Offset(dx, dy),
      child: label,
    );
  }
}
