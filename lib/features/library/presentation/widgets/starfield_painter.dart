import 'dart:math';
import 'package:flutter/material.dart';

import '../../../../core/theme/mythic_colors.dart';

class StarfieldPainter extends CustomPainter {
  StarfieldPainter({this.seed = 42});

  final int seed;
  static const double gridSize = 100.0;

  Random? _cachedRandom;
  int? _cachedSeed;

  Random _getRandom() {
    if (_cachedRandom == null || _cachedSeed != seed) {
      _cachedRandom = Random(seed);
      _cachedSeed = seed;
    }
    return _cachedRandom!;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final random = _getRandom();
    final paint = Paint()..style = PaintingStyle.fill;

    // Background gradient
    final Rect rect = Offset.zero & size;
    final gradient = RadialGradient(
      colors: [
        MythicColors.deepIndigo.withValues(alpha: 0.8),
        MythicColors.voidBackground,
      ],
      radius: 1.2,
      center: Alignment.center,
    );
    canvas.drawRect(rect, Paint()..shader = gradient.createShader(rect));

    // Draw small distant stars
    for (int i = 0; i < 300; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 1.5;
      final opacity = random.nextDouble() * 0.8 + 0.2;

      paint.color = Colors.white.withValues(alpha: opacity);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }

    // Draw larger twinkling stars/nebula dust
    for (int i = 0; i < 50; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 3.0 + 1.0;
      final opacity = random.nextDouble() * 0.4 + 0.1;

      final colorVal = random.nextDouble();
      Color starColor = MythicColors.fluxCyan;
      if (colorVal > 0.6) starColor = MythicColors.temporalGold;
      if (colorVal > 0.8) starColor = MythicColors.bronze;

      paint.color = starColor.withValues(alpha: opacity);

      // Draw cross shape for flare
      canvas.drawCircle(Offset(x, y), radius, paint);
      canvas.drawRect(
        Rect.fromCenter(
            center: Offset(x, y), width: radius * 6, height: radius * 0.5,),
        paint,
      );
      canvas.drawRect(
        Rect.fromCenter(
            center: Offset(x, y), width: radius * 0.5, height: radius * 6,),
        paint,
      );
    }

    // Draw subtle grid lines for "scanner" feel
    final gridPaint = Paint()
      ..color = MythicColors.fluxCyan.withValues(alpha: 0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (double i = 0; i < size.width; i += gridSize) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), gridPaint);
    }
    for (double i = 0; i < size.height; i += gridSize) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), gridPaint);
    }
  }

  @override
  bool shouldRepaint(covariant StarfieldPainter oldDelegate) {
    return oldDelegate.seed != seed;
  }
}
