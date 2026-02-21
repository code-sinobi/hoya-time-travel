import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/era_theme.dart';
import '../../domain/user_traits.dart';

class JourneyMapChart extends StatefulWidget {
  final List<TraitChange> history;
  final double height;
  final bool animate;

  const JourneyMapChart({
    super.key,
    required this.history,
    this.height = 200,
    this.animate = true,
  });

  @override
  State<JourneyMapChart> createState() => _JourneyMapChartState();
}

class _JourneyMapChartState extends State<JourneyMapChart>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  // Pre-calculated data points (Timeline of snapshots)
  List<Map<String, int>> _timelineData = [];

  final Map<String, Color> _traitColors = {
    'wisdom': const Color(0xFF9C27B0), // Purple
    'courage': const Color(0xFFD32F2F), // Red
    'empathy': const Color(0xFF388E3C), // Green
    'justice': const Color(0xFFE0E0E0), // Silver/White
    'patience': const Color(0xFFFFA000), // Amber
  };

  @override
  void initState() {
    super.initState();
    _processData();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutQuart,
    );

    if (widget.animate) {
      _controller.forward();
    } else {
      _controller.value = 1.0;
    }
  }

  void _processData() {
    final sortedHistory = List<TraitChange>.from(widget.history)
      ..sort((a, b) => a.changedAt.compareTo(b.changedAt));

    final Map<String, int> current = {
      'wisdom': 0,
      'courage': 0,
      'empathy': 0,
      'justice': 0,
      'patience': 0,
    };

    _timelineData = [Map.from(current)];

    for (final change in sortedHistory) {
      final trait = change.trait.toLowerCase();
      if (current.containsKey(trait)) {
        current[trait] = (current[trait] ?? 0) + change.delta;
        _timelineData.add(Map.from(current));
      }
    }

    if (_timelineData.length == 1) {
      _timelineData.add(Map.from(current));
    }
  }

  @override
  void didUpdateWidget(covariant JourneyMapChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.history != widget.history) {
      _processData();
      if (widget.animate) {
        _controller.reset();
        _controller.forward();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.history.isEmpty) {
      return Container(
        height: widget.height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border:
              Border.all(color: MythicColors.stoneGray.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          'NO JOURNEY RECORDED',
          style: GoogleFonts.cinzel(color: MythicColors.stoneGray),
        ),
      );
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          height: widget.height,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A24).withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(16),
            border:
                Border.all(color: MythicColors.bronze.withValues(alpha: 0.2)),
          ),
          child: CustomPaint(
            painter: _JourneyPainter(
              data: _timelineData,
              traitColors: _traitColors,
              progress: _animation.value,
            ),
            size: Size.infinite,
          ),
        );
      },
    );
  }
}

class _JourneyPainter extends CustomPainter {
  final List<Map<String, int>> data;
  final Map<String, Color> traitColors;
  final double progress;

  _JourneyPainter({
    required this.data,
    required this.traitColors,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final double w = size.width;
    final double h = size.height;

    int maxVal = 0;
    int minVal = 0;

    for (final point in data) {
      for (final val in point.values) {
        maxVal = max(maxVal, val);
        minVal = min(minVal, val);
      }
    }

    final int yRange = (maxVal - minVal) == 0 ? 10 : (maxVal - minVal);
    final double yStep = h / (yRange + 4);
    final double zeroY = h - ((-minVal + 2) * yStep);

    _drawGrid(canvas, w, h, zeroY, yStep);

    final double currentWidth = w * progress;
    final double xStep = w / (data.length - 1);

    traitColors.forEach((trait, color) {
      final path = Path();

      for (int i = 0; i < data.length; i++) {
        final double x = i * xStep;
        if (x > currentWidth) break;

        final int val = data[i][trait] ?? 0;
        final double y = h - ((val - minVal + 2) * yStep);

        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }

      canvas.drawPath(
        path,
        Paint()
          ..color = color.withValues(alpha: 0.2)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
      );

      canvas.drawPath(
        path,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    });
  }

  void _drawGrid(
    Canvas canvas,
    double w,
    double h,
    double zeroY,
    double yStep,
  ) {
    final paint = Paint()
      ..color = MythicColors.stoneGray.withValues(alpha: 0.1)
      ..strokeWidth = 1;

    canvas.drawLine(
      Offset(0, zeroY),
      Offset(w, zeroY),
      paint..color = MythicColors.stoneGray.withValues(alpha: 0.3),
    );

    canvas.drawLine(const Offset(0, 0), Offset(0, h), paint);
    canvas.drawLine(Offset(0, h), Offset(w, h), paint);
  }

  @override
  bool shouldRepaint(covariant _JourneyPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.data != data;
  }
}
