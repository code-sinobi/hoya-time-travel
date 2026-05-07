import 'dart:math' as math;
import 'package:flutter/material.dart';

class TemporalConduit extends StatefulWidget {
  const TemporalConduit({super.key});

  @override
  State<TemporalConduit> createState() => _TemporalConduitState();
}

class _TemporalConduitState extends State<TemporalConduit>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<ConduitParticle> _particles = [];
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    // Initialize particles
    for (int i = 0; i < 60; i++) {
      _particles.add(
        ConduitParticle(
          angle: _random.nextDouble() * 2 * math.pi,
          radius: 50 + _random.nextDouble() * 100, // Distance from center
          speed: 0.2 + _random.nextDouble() * 0.5,
          size: 1 + _random.nextDouble() * 2,
          opacity: 0.1 + _random.nextDouble() * 0.5,
        ),
      );
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
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: ConduitPainter(
            progress: _controller.value,
            particles: _particles,
          ),
          child: Container(),
        );
      },
    );
  }
}

class ConduitParticle {
  ConduitParticle({
    required this.angle,
    required this.radius,
    required this.speed,
    required this.size,
    required this.opacity,
  });
  double angle;
  double radius;
  double speed;
  double size;
  double opacity;
}

class ConduitPainter extends CustomPainter {
  ConduitPainter({required this.progress, required this.particles});
  final double progress;
  final List<ConduitParticle> particles;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()..style = PaintingStyle.fill;

    // Draw Central Core
    final coreGradient = RadialGradient(
      colors: [
        const Color(0xFF00FFFF).withValues(alpha: 0.2), // Cyan Core
        const Color(0xFF00FFFF).withValues(alpha: 0.0),
      ],
      stops: const [0.0, 0.7],
    );

    final rect = Rect.fromCircle(center: center, radius: 100);
    paint.shader = coreGradient.createShader(rect);
    canvas.drawCircle(center, 100, paint);
    paint.shader = null;

    // Draw Particles
    for (final particle in particles) {
      // Rotate particle based on speed and global progress
      final currentAngle =
          particle.angle + (progress * math.pi * 2 * particle.speed);

      // Calculate position
      final x = center.dx + math.cos(currentAngle) * particle.radius;
      final y = center.dy + math.sin(currentAngle) * particle.radius;

      // Vary opacity slightly with pulse
      final pulse =
          math.sin(progress * math.pi * 4 + particle.angle) * 0.2; // +/- 0.2
      paint.color = const Color(
        0xFF00FFFF,
      ).withValues(alpha: (particle.opacity + pulse).clamp(0.0, 1.0));

      canvas.drawCircle(Offset(x, y), particle.size, paint);
    }

    // Draw "Orbits" (Thin lines)
    final linePaint = Paint()
      ..color = const Color(0xFFD4A574).withValues(alpha: 0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawCircle(center, 80, linePaint);
    canvas.drawCircle(center, 120, linePaint);

    // Rotating Dashed Ring
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(-progress * math.pi); // Counter-rotate

    final dashPaint = Paint()
      ..color = const Color(0xFFD4A574).withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Simple dashed circle approximation (4 arcs)
    const double r = 140;
    const double gap = 0.2;
    for (int i = 0; i < 4; i++) {
      canvas.drawArc(
        Rect.fromCircle(center: Offset.zero, radius: r),
        (math.pi / 2 * i) + gap,
        (math.pi / 2) - (gap * 2),
        false,
        dashPaint,
      );
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant ConduitPainter old) => true;
}
