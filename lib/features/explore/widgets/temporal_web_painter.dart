import 'package:flutter/material.dart';
import '../../story/models/story_models.dart';

class TemporalWebPainter extends CustomPainter {
  final Color color;
  final String activeEra;
  final List<Story> nodes;
  final double animationValue; // For pulsing effects

  TemporalWebPainter({
    required this.color,
    required this.activeEra,
    required this.nodes,
    this.animationValue = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _drawGravityGrid(canvas, size);
    _drawCausalityLinks(canvas, size);
  }

  void _drawGravityGrid(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = color.withValues(alpha: 0.1)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final riftNodes = nodes.where((n) => n.isRift).toList();

    // Grid Setup
    const double step = 50.0;

    // Vertical Lines
    for (double i = 0; i <= size.width; i += step) {
      final path = Path();
      path.moveTo(i, 0);

      for (double j = 0; j <= size.height; j += step) {
        final point = _distortPoint(Offset(i, j), riftNodes, size);
        path.lineTo(point.dx, point.dy);
      }
      canvas.drawPath(path, gridPaint);
    }

    // Horizontal Lines
    for (double j = 0; j <= size.height; j += step) {
      final path = Path();
      path.moveTo(0, j);

      for (double i = 0; i <= size.width; i += step) {
        final point = _distortPoint(Offset(i, j), riftNodes, size);
        path.lineTo(point.dx, point.dy);
      }
      canvas.drawPath(path, gridPaint);
    }
  }

  Offset _distortPoint(Offset original, List<Story> rifts, Size size) {
    double dx = 0;
    double dy = 0;

    for (var rift in rifts) {
      final riftPos = Offset(
        rift.xCoordinate * size.width,
        rift.yCoordinate * size.height,
      );

      final distance = (original - riftPos).distance;
      const double radius = 150.0; // Radius of gravity well

      if (distance < radius) {
        // Calculate pull factor (stronger closer to center)
        final factor = (1 - (distance / radius)) * 0.3; // 30% pull strength
        final pull = (riftPos - original) * factor;
        dx += pull.dx;
        dy += pull.dy;
      }
    }

    return original + Offset(dx, dy);
  }

  void _drawCausalityLinks(Canvas canvas, Size size) {
    final linkPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // determine style based on Era
    if (activeEra == 'MYTHIC') {
      linkPaint.color = color.withValues(alpha: 0.3);
      // Constellation style: Straight lines
      _drawConstellationLinks(canvas, size, linkPaint);
    } else if (activeEra == 'MODERN' || activeEra == 'INDUSTRIAL') {
      linkPaint.color = Colors.cyan.withValues(alpha: 0.4);
      // Circuit style: 90 degree bends
      _drawCircuitLinks(canvas, size, linkPaint);
    } else {
      // Default / Future: Curved Beziers
      linkPaint.color = color.withValues(alpha: 0.2);
      _drawBezierLinks(canvas, size, linkPaint);
    }
  }

  void _drawConstellationLinks(Canvas canvas, Size size, Paint paint) {
    // Connect fairly close nodes to form shapes
    for (int i = 0; i < nodes.length; i++) {
      for (int j = i + 1; j < nodes.length; j++) {
        final p1 = Offset(
          nodes[i].xCoordinate * size.width,
          nodes[i].yCoordinate * size.height,
        );
        final p2 = Offset(
          nodes[j].xCoordinate * size.width,
          nodes[j].yCoordinate * size.height,
        );

        if ((p1 - p2).distance < 300) {
          canvas.drawLine(p1, p2, paint);
        }
      }
    }
  }

  void _drawCircuitLinks(Canvas canvas, Size size, Paint paint) {
    for (int i = 0; i < nodes.length; i++) {
      // Just connect to the next one for a "circuit" loop effect
      final nextIndex = (i + 1) % nodes.length;

      final p1 = Offset(
        nodes[i].xCoordinate * size.width,
        nodes[i].yCoordinate * size.height,
      );
      final p2 = Offset(
        nodes[nextIndex].xCoordinate * size.width,
        nodes[nextIndex].yCoordinate * size.height,
      );

      if ((p1 - p2).distance > 500) continue; // Don't bridge huge gaps

      final path = Path();
      path.moveTo(p1.dx, p1.dy);
      // Midpoint turn
      final midX = (p1.dx + p2.dx) / 2;
      path.lineTo(midX, p1.dy);
      path.lineTo(midX, p2.dy);
      path.lineTo(p2.dx, p2.dy);

      canvas.drawPath(path, paint);
    }
  }

  void _drawBezierLinks(Canvas canvas, Size size, Paint paint) {
    for (int i = 0; i < nodes.length; i++) {
      // Connect eras?
      final start = nodes[i];

      // Find links
      final targets = nodes
          .where((n) => n.id != start.id && (n.eraId != start.eraId))
          .take(1);

      for (var end in targets) {
        final p1 = Offset(
          start.xCoordinate * size.width,
          start.yCoordinate * size.height,
        );
        final p2 = Offset(
          end.xCoordinate * size.width,
          end.yCoordinate * size.height,
        );

        final path = Path();
        path.moveTo(p1.dx, p1.dy);

        // Quadratic bezier control point
        final control = Offset((p1.dx + p2.dx) / 2, (p1.dy + p2.dy) / 2 - 100);
        path.quadraticBezierTo(control.dx, control.dy, p2.dx, p2.dy);

        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant TemporalWebPainter old) {
    return old.activeEra != activeEra ||
        old.nodes != nodes ||
        old.animationValue != animationValue;
  }
}
