import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/theme/priority_colors.dart';

/// A progress bar showing the destabilization level of an anomaly.
/// Uses gradient colors that become more intense as destabilization increases.
class DestabilizationBar extends StatelessWidget {
  const DestabilizationBar({
    required this.percent,
    super.key,
    this.color = PriorityColors.criticalBorder,
    this.animate = true,
    this.height = 6,
  });

  /// Current destabilization level (0.0 to 1.0)
  final double percent;

  /// Base color for the bar (based on severity)
  final Color color;

  /// Whether to animate the bar on first render
  final bool animate;

  /// Height of the progress bar
  final double height;

  @override
  Widget build(BuildContext context) {
    final clampedPercent = percent.clamp(0.0, 1.0);

    Widget bar = Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(height / 2),
      ),
      child: Stack(
        children: [
          // Background track
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: color.withValues(alpha: 0.2),
                width: 0.5,
              ),
              borderRadius: BorderRadius.circular(height / 2),
            ),
          ),

          // Filled portion
          FractionallySizedBox(
            widthFactor: clampedPercent,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    color.withValues(alpha: 0.7),
                    color,
                  ],
                ),
                borderRadius: BorderRadius.circular(height / 2),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.4),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    // Add pulsing effect when critical (>80%)
    if (clampedPercent > 0.8) {
      bar = bar
          .animate(onPlay: (controller) => controller.repeat(reverse: true))
          .custom(
            duration: const Duration(milliseconds: 1200),
            builder: (context, value, child) => Opacity(
              opacity: 0.7 + (value * 0.3),
              child: child,
            ),
          );
    }

    if (animate) {
      return bar.animate().scaleX(
            begin: 0.0,
            end: 1.0,
            alignment: Alignment.centerLeft,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutBack,
          );
    }

    return bar;
  }
}

/// Widget showing the destabilization percentage with label
class DestabilizationIndicator extends StatelessWidget {
  const DestabilizationIndicator({
    required this.percent,
    required this.color,
    super.key,
  });
  final double percent;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'DESTABILIZED',
              style: TextStyle(
                fontSize: 10,
                color: color.withValues(alpha: 0.7),
                letterSpacing: 1,
              ),
            ),
            Text(
              '${(percent * 100).toInt()}%',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        DestabilizationBar(
          percent: percent,
          color: color,
        ),
      ],
    );
  }
}
