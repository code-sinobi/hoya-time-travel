import 'dart:math' as math;
import 'package:flutter/material.dart';

class FogOverlay extends StatelessWidget {
  final Set<String> exploredEras;

  const FogOverlay({super.key, required this.exploredEras});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        size: Size.infinite,
        painter: _FogPainter(exploredEras: exploredEras),
      ),
    );
  }
}

class _FogPainter extends CustomPainter {
  final Set<String> exploredEras;

  _FogPainter({required this.exploredEras});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width * 0.45;

    // Outer Fog (Radial)
    final outerPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.transparent,
          Colors.black.withValues(alpha: 0.2),
          Colors.black.withValues(alpha: 0.8),
        ],
        stops: const [0.7, 0.85, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius * 1.5));

    canvas.drawRect(Offset.zero & size, outerPaint);

    // Era-based Fog Arcs (Mock - Assume 3 sectors)
    final allEras = ['MYTHIC', 'ANCIENT', 'MODERN'];
    const sectorAngle = (math.pi * 2) / 3;

    final fogPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < allEras.length; i++) {
      if (!exploredEras.contains(allEras[i])) {
        // Draw foggy arc for unexplored era
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          (i * sectorAngle) - (math.pi / 2),
          sectorAngle,
          true,
          fogPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _FogPainter oldDelegate) {
    // Correctly check for content change
    if (exploredEras.length != oldDelegate.exploredEras.length) return true;
    for (final era in exploredEras) {
      if (!oldDelegate.exploredEras.contains(era)) return true;
    }
    return false;
  }
}
