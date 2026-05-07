import 'package:flutter/material.dart';

import '../../../core/theme/priority_colors.dart';

/// A custom painter that draws connection lines between cascading anomalies.
/// Used to visualize how anomalies affect each other.
class CascadeConnectorPainter extends CustomPainter {
  CascadeConnectorPainter({
    required this.sourceIndex,
    required this.targetIndices,
    this.cardHeight = 180,
    this.spacing = 16,
    this.lineColor = PriorityColors.criticalBorder,
    this.progress = 1.0,
  });

  /// Index of the source card (0-indexed)
  final int sourceIndex;

  /// Indices of connected cards
  final List<int> targetIndices;

  /// Height of each card (for calculating positions)
  final double cardHeight;

  /// Vertical spacing between cards
  final double spacing;

  /// Color of the connection lines
  final Color lineColor;

  /// Animation progress (0.0 - 1.0) for drawing the line
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    if (targetIndices.isEmpty) return;

    final paint = Paint()
      ..color = lineColor.withValues(alpha: 0.6 * progress)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final glowPaint = Paint()
      ..color = lineColor.withValues(alpha: 0.2 * progress)
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    // Calculate source position (right side of card, vertically centered)
    final sourceY = (sourceIndex * (cardHeight + spacing)) + (cardHeight / 2);
    const sourceX = 0.0; // Left side of the connector area

    for (final targetIndex in targetIndices) {
      // Calculate target position
      final targetY = (targetIndex * (cardHeight + spacing)) + (cardHeight / 2);

      // Create a curved path from source to target
      final path = Path();
      path.moveTo(sourceX, sourceY);

      // Control points for bezier curve
      final midX = size.width / 2;

      // Draw glow first
      path.quadraticBezierTo(
        midX,
        sourceY,
        midX,
        (sourceY + targetY) / 2,
      );
      path.quadraticBezierTo(
        midX,
        targetY,
        size.width,
        targetY,
      );

      canvas.drawPath(path, glowPaint);
      canvas.drawPath(path, paint);

      // Draw small circles at connection points
      canvas.drawCircle(
        Offset(sourceX, sourceY),
        4 * progress,
        Paint()..color = lineColor,
      );
      canvas.drawCircle(
        Offset(size.width, targetY),
        4 * progress,
        Paint()..color = lineColor.withValues(alpha: 0.7),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CascadeConnectorPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.sourceIndex != sourceIndex ||
        oldDelegate.targetIndices != targetIndices;
  }
}

/// Widget wrapper for the cascade connector painter
class CascadeConnector extends StatelessWidget {
  const CascadeConnector({
    required this.sourceIndex,
    required this.targetIndices,
    super.key,
    this.cardHeight = 180,
    this.spacing = 16,
    this.lineColor = PriorityColors.criticalBorder,
    this.width = 40,
  });
  final int sourceIndex;
  final List<int> targetIndices;
  final double cardHeight;
  final double spacing;
  final Color lineColor;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: CustomPaint(
        painter: CascadeConnectorPainter(
          sourceIndex: sourceIndex,
          targetIndices: targetIndices,
          cardHeight: cardHeight,
          spacing: spacing,
          lineColor: lineColor,
        ),
        size: Size(width, double.infinity),
      ),
    );
  }
}
