import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/galactic_colors.dart';

class StarField extends StatelessWidget {
  const StarField({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          painter: StarPainter(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
          ),
        );
      },
    );
  }
}

class StarPainter extends CustomPainter {
  StarPainter({required this.width, required this.height});
  final double width;
  final double height;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = GalacticColors.starWhite
      ..style = PaintingStyle.fill;

    final random = Random(42); // Fixed seed for consistent stars
    const starCount = 150;

    for (var i = 0; i < starCount; i++) {
      final x = random.nextDouble() * width;
      final y = random.nextDouble() * height;
      final radius = random.nextDouble() * 1.5;
      final alpha = random.nextInt(150) + 50;

      paint.color = GalacticColors.starWhite.withAlpha(alpha);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
