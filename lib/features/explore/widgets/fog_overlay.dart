import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../domain/era.dart';

/// Overlay widget that creates a fog-of-war effect over unexplored eras.
/// Unexplored sections of the radar appear obscured with animated fog.
class FogOverlay extends StatelessWidget {
  const FogOverlay({
    required this.exploredEras,
    required this.radius,
    super.key,
    this.fogColor = const Color(0xCC0A0A0F),
  });

  /// Set of eras that have been explored (no fog)
  final Set<Era> exploredEras;

  /// Radius matching the radar
  final double radius;

  /// Fog color (typically dark with opacity)
  final Color fogColor;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(radius * 2, radius * 2),
      painter: _FogPainter(
        exploredEras: exploredEras,
        radius: radius,
        fogColor: fogColor,
      ),
    );
  }
}

class _FogPainter extends CustomPainter {
  _FogPainter({
    required this.exploredEras,
    required this.radius,
    required this.fogColor,
  });
  final Set<Era> exploredEras;
  final double radius;
  final Color fogColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // For each unexplored era, draw a foggy arc
    for (final era in Era.values) {
      if (!exploredEras.contains(era)) {
        _drawFogSection(canvas, center, era);
      }
    }
  }

  void _drawFogSection(Canvas canvas, Offset center, Era era) {
    // Calculate the arc for this era (each era gets ~72 degrees = 1.256 radians)
    final regionSize = (2 * math.pi) / Era.values.length;
    final startAngle = era.radarAngle - (regionSize / 2);

    // Create gradient for fog effect
    final fogPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          fogColor.withValues(alpha: 0.9),
          fogColor.withValues(alpha: 0.6),
          fogColor.withValues(alpha: 0.3),
        ],
        stops: const [0.0, 0.6, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    // Draw the fog arc
    final path = Path()
      ..moveTo(center.dx, center.dy)
      ..arcTo(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        regionSize,
        false,
      )
      ..close();

    canvas.drawPath(path, fogPaint);

    // Add swirling fog texture lines
    _drawFogSwirls(canvas, center, startAngle, regionSize);
  }

  void _drawFogSwirls(
    Canvas canvas,
    Offset center,
    double startAngle,
    double regionSize,
  ) {
    final swirlPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Draw a few wavy lines to simulate fog movement
    for (var i = 0; i < 3; i++) {
      final swirlRadius = radius * (0.3 + (i * 0.25));
      final swirlAngle = startAngle + (regionSize * (0.2 + (i * 0.3)));

      final path = Path();
      for (var j = 0; j < 10; j++) {
        final t = j / 10.0;
        final angle = swirlAngle + (t * regionSize * 0.5);
        final r = swirlRadius + (math.sin(t * math.pi * 2) * 10);
        final x = center.dx + r * math.cos(angle);
        final y = center.dy + r * math.sin(angle);

        if (j == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }

      canvas.drawPath(path, swirlPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _FogPainter oldDelegate) {
    return !setEquals(oldDelegate.exploredEras, exploredEras);
  }
}
