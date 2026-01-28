import 'package:flutter/material.dart';
import '../theme/galactic_colors.dart';
import 'star_field.dart';

class GalacticBackground extends StatefulWidget {
  final bool showStars;
  final bool animated;

  const GalacticBackground({
    super.key,
    this.showStars = true,
    this.animated = true,
  });

  @override
  State<GalacticBackground> createState() => _GalacticBackgroundState();
}

class _GalacticBackgroundState extends State<GalacticBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _pulse = Tween(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: _pulse.value,
              colors: [
                GalacticColors.wormholeBlue.withValues(alpha: 0.1),
                GalacticColors.deepNebula.withValues(alpha: 0.3),
                GalacticColors.spaceBlack,
              ],
              stops: const [0.1, 0.5, 1.0],
            ),
          ),
          child: widget.showStars ? const StarField() : null,
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
