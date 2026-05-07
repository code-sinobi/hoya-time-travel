import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/era_theme.dart';
import '../../domain/user_traits.dart';

class JourneyMapChart extends StatefulWidget {
  const JourneyMapChart({
    required this.history,
    super.key,
    this.height = 200,
    this.animate = true,
  });
  final List<TraitChange> history;
  final double height;
  final bool animate;

  @override
  State<JourneyMapChart> createState() => _JourneyMapChartState();
}

class _JourneyMapChartState extends State<JourneyMapChart>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final CurvedAnimation _animation;

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
    // 1. Sort history by date
    final sortedHistory = List<TraitChange>.from(widget.history)
      ..sort((a, b) => a.changedAt.compareTo(b.changedAt));

    // 2. Build cumulative timeline
    // Start with all 0
    final Map<String, int> current = {
      'wisdom': 0,
      'courage': 0,
      'empathy': 0,
      'justice': 0,
      'patience': 0,
    };

    _timelineData = [Map.from(current)]; // Initial point

    for (final change in sortedHistory) {
      final trait = change.trait.toLowerCase();
      if (current.containsKey(trait)) {
        current[trait] = (current[trait] ?? 0) + change.delta;
        _timelineData.add(Map.from(current));
      }
    }

    // Ensure we have at least 2 points for a line
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
      } else {
        setState(() {}); // Force repaint with new data
      }
    }
  }

  @override
  void dispose() {
    _animation.dispose();
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
  _JourneyPainter({
    required this.data,
    required this.traitColors,
    required this.progress,
  });
  final List<Map<String, int>> data;
  final Map<String, Color> traitColors;
  final double progress;

  // Cached drawing objects to avoid per-frame allocations
  final _path = Path();
  final Map<String, Paint> _bloomPaints = {};
  final Map<String, Paint> _overlayPaints = {};

  Paint _getBloomPaint(String trait, Color color) {
    return _bloomPaints.putIfAbsent(
      trait,
      () => Paint()
        ..color = color.withValues(alpha: 0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );
  }

  Paint _getOverlayPaint(String trait, Color color) {
    return _overlayPaints.putIfAbsent(
      trait,
      () => Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final double w = size.width;
    final double h = size.height;

    // 1. Determine ranges
    int maxVal = 0;
    int minVal = 0;

    for (final point in data) {
      for (final val in point.values) {
        maxVal = max(maxVal, val);
        minVal = min(minVal, val);
      }
    }

    // Add some padding to Y range
    final int yRange = (maxVal - minVal) == 0 ? 10 : (maxVal - minVal);
    final double yStep = h / (yRange + 4); // +4 for padding top/bottom
    final double zeroY = h - ((-minVal + 2) * yStep); // Baseline

    // 2. Draw Grid
    _drawGrid(canvas, w, h, zeroY, yStep);

    // 3. Draw Lines
    // Render only up to 'progress' percent of the WIDTH
    final double currentWidth = w * progress;
    final double xStep = w / (data.length - 1);

    traitColors.forEach((trait, color) {
      _path.reset();

      for (int i = 0; i < data.length; i++) {
        final double x = i * xStep;
        if (x > currentWidth) break; // Animation cutoff

        final int val = data[i][trait] ?? 0;
        // Flip Y because canvas 0 is top
        final double y = h - ((val - minVal + 2) * yStep);

        if (i == 0) {
          _path.moveTo(x, y);
        } else {
          _path.lineTo(x, y);
        }
      }

      // Draw shadow
      canvas.drawPath(_path, _getBloomPaint(trait, color));

      // Draw line
      canvas.drawPath(_path, _getOverlayPaint(trait, color));
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

    // Draw zero line with distinct paint to avoid mutating shared instance
    final zeroPaint = Paint()
      ..color = MythicColors.stoneGray.withValues(alpha: 0.3)
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(0, zeroY),
      Offset(w, zeroY),
      zeroPaint,
    );

    // Draw frames
    canvas.drawLine(Offset.zero, Offset(0, h), paint);
    canvas.drawLine(Offset(0, h), Offset(w, h), paint);
  }

  @override
  bool shouldRepaint(covariant _JourneyPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.data != data;
  }
}
