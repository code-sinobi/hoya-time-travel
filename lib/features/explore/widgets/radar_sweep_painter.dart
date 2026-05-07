import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Custom painter that draws the radar sweep effect.
/// Creates a rotating line with a fading gradient trail.
class RadarSweepPainter extends CustomPainter {
  RadarSweepPainter({
    required this.sweepAngle,
    this.sweepColor = const Color(0xFF00FFFF), // Cyan
    this.ringCount = 4,
  });

  /// Current sweep angle in radians (0 = right, increases counter-clockwise)
  final double sweepAngle;

  /// Color of the sweep line
  final Color sweepColor;

  /// Number of concentric circles to draw
  final int ringCount;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 20;

    // Draw concentric rings
    _drawRings(canvas, center, radius);

    // Draw crosshairs
    _drawCrosshairs(canvas, center, radius);

    // Draw the sweep gradient trail
    _drawSweepTrail(canvas, center, radius);

    // Draw the sweep line
    _drawSweepLine(canvas, center, radius);

    // Draw center dot
    _drawCenterDot(canvas, center);
  }

  void _drawRings(Canvas canvas, Offset center, double radius) {
    final ringPaint = Paint()
      ..color = sweepColor.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (var i = 1; i <= ringCount; i++) {
      canvas.drawCircle(
        center,
        radius * (i / ringCount),
        ringPaint,
      );
    }

    // Draw outer ring slightly brighter
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = sweepColor.withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  void _drawCrosshairs(Canvas canvas, Offset center, double radius) {
    final crosshairPaint = Paint()
      ..color = sweepColor.withValues(alpha: 0.1)
      ..strokeWidth = 1;

    // Horizontal line
    canvas.drawLine(
      Offset(center.dx - radius, center.dy),
      Offset(center.dx + radius, center.dy),
      crosshairPaint,
    );

    // Vertical line
    canvas.drawLine(
      Offset(center.dx, center.dy - radius),
      Offset(center.dx, center.dy + radius),
      crosshairPaint,
    );
  }

  void _drawSweepTrail(Canvas canvas, Offset center, double radius) {
    // Create a gradient arc behind the sweep line
    const trailLength = 0.5; // radians

    for (var i = 0; i < 20; i++) {
      final trailAngle = sweepAngle - (i * trailLength / 20);
      final alpha = (1 - (i / 20)) * 0.15;

      final endX = center.dx + radius * math.cos(trailAngle);
      final endY = center.dy + radius * math.sin(trailAngle);

      canvas.drawLine(
        center,
        Offset(endX, endY),
        Paint()
          ..color = sweepColor.withValues(alpha: alpha)
          ..strokeWidth = 2,
      );
    }
  }

  void _drawSweepLine(Canvas canvas, Offset center, double radius) {
    final endX = center.dx + radius * math.cos(sweepAngle);
    final endY = center.dy + radius * math.sin(sweepAngle);

    // Glow effect
    canvas.drawLine(
      center,
      Offset(endX, endY),
      Paint()
        ..color = sweepColor.withValues(alpha: 0.3)
        ..strokeWidth = 6
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );

    // Main line
    canvas.drawLine(
      center,
      Offset(endX, endY),
      Paint()
        ..color = sweepColor
        ..strokeWidth = 2,
    );
  }

  void _drawCenterDot(Canvas canvas, Offset center) {
    // Outer glow
    canvas.drawCircle(
      center,
      8,
      Paint()
        ..color = sweepColor.withValues(alpha: 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );

    // Inner dot
    canvas.drawCircle(
      center,
      4,
      Paint()..color = sweepColor,
    );
  }

  @override
  bool shouldRepaint(covariant RadarSweepPainter oldDelegate) {
    return oldDelegate.sweepAngle != sweepAngle;
  }
}
