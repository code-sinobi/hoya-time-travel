import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import '../theme/galactic_colors.dart';

class TimeParticles extends StatelessWidget {
  final int count;

  const TimeParticles({super.key, this.count = 30});

  @override
  Widget build(BuildContext context) {
    return LoopAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 100.0),
      duration: const Duration(seconds: 20),
      builder: (context, value, child) {
        return CustomPaint(
          painter: ParticlePainter(time: value, count: count),
          child: Container(),
        );
      },
    );
  }
}

class ParticlePainter extends CustomPainter {
  final double time;
  final int count;
  final List<ParticleModel> particles = [];

  ParticlePainter({required this.time, required this.count}) {
    // Deterministic random for consistency
    for (int i = 0; i < count; i++) {
      // Simple pseudo-random using index
      final x = (i * 739391 + 123) % 1000 / 1000.0;
      final y = (i * 91293 + 456) % 1000 / 1000.0;
      final speed = 0.2 + ((i * 12312) % 100) / 200.0;
      particles.add(ParticleModel(x, y, speed));
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = GalacticColors.neonCyan.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    for (var particle in particles) {
      // Calculate position based on time
      // Move upwards
      var y = (particle.y - (time * particle.speed / 20.0)) % 1.0;
      if (y < 0) y += 1.0;

      var x = particle.x; // Static x for 'rising' effect, or animate sine wave

      canvas.drawCircle(
        Offset(x * size.width, y * size.height),
        2.0, // Fixed small size
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant ParticlePainter oldDelegate) => true;
}

class ParticleModel {
  final double x;
  final double y;
  final double speed;
  ParticleModel(this.x, this.y, this.speed);
}
