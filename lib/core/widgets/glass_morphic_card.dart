import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/galactic_colors.dart';

class GlassMorphicCard extends StatelessWidget {
  const GlassMorphicCard({
    required this.child,
    super.key,
    this.blur = 10,
    this.opacity = 0.1,
  });
  final Widget child;
  final double blur;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: GalacticColors.deepNebula.withValues(alpha: opacity),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.1),
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.1),
                Colors.white.withValues(alpha: 0.05),
              ],
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
