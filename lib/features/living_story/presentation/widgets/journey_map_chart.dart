import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/era_theme.dart';
import '../../domain/user_traits.dart';

class JourneyMapChart extends ConsumerStatefulWidget {
  final List<TraitHistory> history;
  final bool animate;

  const JourneyMapChart({
    super.key,
    required this.history,
    this.animate = true,
  });

  @override
  ConsumerState<JourneyMapChart> createState() => _JourneyMapChartState();
}

class _JourneyMapChartState extends ConsumerState<JourneyMapChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progress;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _progress = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );

    if (widget.animate) {
      _controller.forward();
    } else {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(JourneyMapChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate && oldWidget.history != widget.history) {
      _controller.reset();
      _controller.forward();
    } else {
      setState(() {}); // Force repaint with new data
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _progress,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: _JourneyPainter(
            history: widget.history,
            progress: _progress.value,
          ),
        );
      },
    );
  }
}

class _JourneyPainter extends CustomPainter {
  final List<TraitHistory> history;
  final double progress;

  _JourneyPainter({required this.history, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    if (history.isEmpty) return;

    final paint = Paint()
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final w = size.width;
    final h = size.height;
    final padding = 40.0;
    final chartH = h - (padding * 2);
    final chartW = w - (padding * 2);

    // Draw grid/background
    _drawGrid(canvas, size, paint);

    // Group history by trait
    final traits = <String>{};
    for (var point in history) {
      traits.add(point.traitName);
    }

    // Draw lines per trait
    for (var trait in traits) {
      final traitPoints =
          history.where((p) => p.traitName == trait).toList()
            ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

      if (traitPoints.length < 2) continue;

      final path = Path();
      final color = _getColorForTrait(trait);
      paint.color = color.withValues(alpha: 0.8);

      for (int i = 0; i < traitPoints.length; i++) {
        final x = padding + (i / (traitPoints.length - 1)) * chartW;
        // Map 0-100 to chart height, 50 is middle
        final val = traitPoints[i].value;
        final y = h - padding - (val / 100.0) * chartH;

        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }

      // Progress animation
      final pathMetrics = path.computeMetrics().first;
      final extractPath = pathMetrics.extractPath(0.0, pathMetrics.length * progress);
      canvas.drawPath(extractPath, paint);

      // Draw end point blip
      if (progress > 0.9) {
        final lastPoint = traitPoints.last;
        final lx = padding + chartW;
        final ly = h - padding - (lastPoint.value / 100.0) * chartH;
        canvas.drawCircle(Offset(lx, ly), 4, Paint()..color = color);
      }
    }
  }

  void _drawGrid(Canvas canvas, Size size, Paint paint) {
    final w = size.width;
    final h = size.height;
    final padding = 40.0;
    final zeroY = h / 2;

    // Zero Line
    final zeroPaint = Paint()
      ..color = MythicColors.stoneGray.withValues(alpha: 0.3)
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(0, zeroY),
      Offset(w, zeroY),
      zeroPaint,
    );

    // Vertical era markers (Mock)
    final eraStyle = GoogleFonts.shareTechMono(
      color: MythicColors.stoneGray.withValues(alpha: 0.5),
      fontSize: 10,
    );

    final eras = ['ERA I', 'ERA II', 'ERA III'];
    for (int i = 0; i < eras.length; i++) {
      final x = padding + (i / (eras.length - 1)) * (w - padding * 2);
      canvas.drawLine(
        Offset(x, padding),
        Offset(x, h - padding),
        Paint()..color = Colors.white.withValues(alpha: 0.05),
      );
    }
  }

  Color _getColorForTrait(String trait) {
    switch (trait.toUpperCase()) {
      case 'ORDER':
        return const Color(0xFF4A90E2);
      case 'CHAOS':
        return const Color(0xFFD0021B);
      case 'HEROISM':
        return const Color(0xFFF5A623);
      case 'PRAGMATISM':
        return const Color(0xFF7ED321);
      default:
        return MythicColors.bronze;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
