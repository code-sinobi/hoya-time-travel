import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/theme/era_theme.dart';

class WisdomCompassChart extends StatefulWidget {
  const WisdomCompassChart({
    required this.traits,
    super.key,
    this.size = 200,
    this.animate = true,
  });
  final Map<String, int> traits;
  final double size;
  final bool animate;

  @override
  State<WisdomCompassChart> createState() => _WisdomCompassChartState();
}

class _WisdomCompassChartState extends State<WisdomCompassChart>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  int? _touchedIndex;
  Offset? _touchedPosition;

  // Fixed order of axes for consistency
  final List<String> axisOrder = [
    'wisdom',
    'empathy',
    'patience',
    'courage',
    'justice',
  ];
  final double maxTraitValue = 20.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    if (widget.animate) {
      _controller.forward();
    } else {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap(Offset localPosition) {
    final size = Size(widget.size, widget.size);
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;

    int? hitIndex;
    Offset? hitPosition;

    for (int j = 0; j < 5; j++) {
      final key = axisOrder[j];
      final value = widget.traits[key] ?? 0;
      final normalizedValue =
          (value / maxTraitValue).clamp(0.0, 1.0) * _animation.value;

      final r = radius * normalizedValue;
      final angle = (j * 2 * pi / 5) - (pi / 2);

      final point = Offset(
        center.dx + r * cos(angle),
        center.dy + r * sin(angle),
      );

      // Increased hit target size to 40 for mobile ease
      if ((localPosition - point).distance < 40) {
        hitIndex = j;
        hitPosition = point;
        break;
      }
    }

    setState(() {
      if (hitIndex == _touchedIndex) {
        _touchedIndex = null;
        _touchedPosition = null;
      } else {
        _touchedIndex = hitIndex;
        _touchedPosition = hitPosition;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Semantics(
          label: 'Wisdom compass chart. Tap on traits to view values.',
          button: true,
          child: GestureDetector(
            onTapDown: (details) => _handleTap(details.localPosition),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                CustomPaint(
                  size: Size(widget.size, widget.size),
                  painter: _CompassPainter(
                    traits: widget.traits,
                    progress: _animation.value,
                    axisOrder: axisOrder,
                    maxTraitValue: maxTraitValue,
                    touchedIndex: _touchedIndex,
                  ),
                ),
                if (_touchedIndex != null && _touchedPosition != null)
                  Positioned(
                    left: _touchedPosition!.dx - 40,
                    top: _touchedPosition!.dy - 40,
                    child: IgnorePointer(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: MythicColors.deepIndigo.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: MythicColors.temporalGold
                                .withValues(alpha: 0.5),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: MythicColors.temporalGold
                                  .withValues(alpha: 0.3),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Text(
                          '${axisOrder[_touchedIndex!].toUpperCase()}\n${widget.traits[axisOrder[_touchedIndex!]] ?? 0}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: MythicColors.parchment,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CompassPainter extends CustomPainter {
  _CompassPainter({
    required this.traits,
    required this.progress,
    required this.axisOrder,
    required this.maxTraitValue,
    this.touchedIndex,
  });
  final Map<String, int> traits;
  final double progress;
  final List<String> axisOrder;
  final double maxTraitValue;
  final int? touchedIndex;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;

    _drawGrid(canvas, center, radius);
    _drawData(canvas, center, radius);
    _drawLabels(canvas, center, radius);
  }

  void _drawGrid(Canvas canvas, Offset center, double radius) {
    final paint = Paint()
      ..color = MythicColors.stoneGray.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Draw concentric polygons (web)
    for (int i = 1; i <= 4; i++) {
      final r = radius * (i / 4);
      final path = Path();
      for (int j = 0; j < 5; j++) {
        final angle = (j * 2 * pi / 5) - (pi / 2); // Start at top
        final point = Offset(
          center.dx + r * cos(angle),
          center.dy + r * sin(angle),
        );
        if (j == 0) {
          path.moveTo(point.dx, point.dy);
        } else {
          path.lineTo(point.dx, point.dy);
        }
      }
      path.close();
      canvas.drawPath(path, paint);
    }

    // Draw axes
    for (int j = 0; j < 5; j++) {
      final angle = (j * 2 * pi / 5) - (pi / 2);
      final point = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );
      canvas.drawLine(center, point, paint);
    }
  }

  void _drawData(Canvas canvas, Offset center, double radius) {
    final path = Path();
    final paint = Paint()
      ..color = MythicColors.bronze.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = MythicColors.bronze
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final glowPaint = Paint()
      ..color = MythicColors.bronze.withValues(alpha: 0.6)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    for (int j = 0; j < 5; j++) {
      final key = axisOrder[j];
      final value = traits[key] ?? 0;
      final normalizedValue =
          (value / maxTraitValue).clamp(0.0, 1.0) * progress;

      final r = radius * normalizedValue;
      final angle = (j * 2 * pi / 5) - (pi / 2);

      final point = Offset(
        center.dx + r * cos(angle),
        center.dy + r * sin(angle),
      );

      if (j == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }

      // Draw point
      final isTouched = touchedIndex == j;
      canvas.drawCircle(
        point,
        isTouched ? 5 : 3,
        Paint()
          ..color =
              isTouched ? MythicColors.temporalGold : MythicColors.parchment
          ..maskFilter = MaskFilter.blur(BlurStyle.solid, isTouched ? 4 : 2),
      );
    }
    path.close();

    canvas.drawPath(
      path,
      Paint()..color = Colors.transparent,
    ); // Placeholder if needed
    canvas.drawPath(path, glowPaint);
    canvas.drawPath(path, paint);
    canvas.drawPath(path, strokePaint);
  }

  void _drawLabels(Canvas canvas, Offset center, double radius) {
    final textStyle = TextStyle(
      color: MythicColors.parchment.withValues(alpha: 0.8),
      fontSize: 10,
      fontFamily: 'Cinzel', // Assuming font is available per theme
    );

    for (int j = 0; j < 5; j++) {
      final angle = (j * 2 * pi / 5) - (pi / 2);
      final labelRadius = radius + 20;
      final labelPoint = Offset(
        center.dx + labelRadius * cos(angle),
        center.dy + labelRadius * sin(angle),
      );

      final label = axisOrder[j].toUpperCase();
      final textSpan = TextSpan(text: label, style: textStyle);
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      textPainter.paint(
        canvas,
        Offset(
          labelPoint.dx - textPainter.width / 2,
          labelPoint.dy - textPainter.height / 2,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CompassPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.traits != traits ||
        oldDelegate.touchedIndex != touchedIndex;
  }
}
