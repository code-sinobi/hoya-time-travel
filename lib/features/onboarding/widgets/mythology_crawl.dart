import 'package:flutter/material.dart';
import 'dart:math' show pi, Random, sin;

/// Data model for a section of crawl text
class CrawlSection {
  final String title;
  final String? subtitle;
  final String body;
  final TextStyle? titleStyle;
  final TextStyle? bodyStyle;

  const CrawlSection({
    required this.title,
    this.subtitle,
    required this.body,
    this.titleStyle,
    this.bodyStyle,
  });
}

/// Cinematic Star Wars-style text crawl with 3D perspective
class MythologyCrawl extends StatefulWidget {
  final List<CrawlSection> sections;
  final Duration crawlDuration;
  final VoidCallback? onComplete;
  final bool enableParallax;

  const MythologyCrawl({
    super.key,
    required this.sections,
    this.crawlDuration = const Duration(seconds: 25),
    this.onComplete,
    this.enableParallax = true,
  });

  @override
  State<MythologyCrawl> createState() => _MythologyCrawlState();
}

class _MythologyCrawlState extends State<MythologyCrawl>
    with TickerProviderStateMixin {
  late AnimationController _scrollController;
  late AnimationController _parallaxController;
  late Animation<double> _scrollAnimation;
  late Animation<double> _fadeAnimation;

  bool _isPaused = false;
  double _speedMultiplier = 1.0;

  // Parallax layers
  final List<ParallaxLayer> _parallaxLayers = [];

  @override
  void initState() {
    super.initState();
    _initParallaxLayers();
    _initAnimations();
  }

  void _initParallaxLayers() {
    if (!widget.enableParallax) return;

    final random = Random();
    // Create depth layers: distant stars, mid dust, near particles
    _parallaxLayers.addAll([
      ParallaxLayer(
        speed: 0.2,
        particleCount: 50,
        sizeRange: const RangeValues(0.5, 1.5),
        opacityRange: const RangeValues(0.2, 0.4),
        color: const Color(0xFFE8DCC4),
        random: random,
      ),
      ParallaxLayer(
        speed: 0.5,
        particleCount: 30,
        sizeRange: const RangeValues(1.0, 2.5),
        opacityRange: const RangeValues(0.3, 0.5),
        color: const Color(0xFFD4A574),
        random: random,
      ),
      ParallaxLayer(
        speed: 0.8,
        particleCount: 15,
        sizeRange: const RangeValues(2.0, 4.0),
        opacityRange: const RangeValues(0.4, 0.6),
        color: const Color(0xFFE8DCC4),
        random: random,
      ),
    ]);
  }

  void _initAnimations() {
    _scrollController = AnimationController(
      duration: widget.crawlDuration,
      vsync: this,
    );

    _parallaxController = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    )..repeat();

    _updateScrollAnimation();

    // Fade in/out sequence
    _fadeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 1.0), weight: 8),
      TweenSequenceItem(tween: ConstantTween<double>(1.0), weight: 79),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.0), weight: 13),
    ]).animate(_scrollController);

    _scrollController.forward().then((_) {
      if (widget.onComplete != null && mounted) {
        widget.onComplete!();
      }
    });
  }

  void _updateScrollAnimation() {
    final adjustedDuration = Duration(
      milliseconds:
          (widget.crawlDuration.inMilliseconds / _speedMultiplier).round(),
    );

    _scrollController.duration = adjustedDuration;

    _scrollAnimation = Tween<double>(
      begin: 1.0,
      end: -0.8,
    ).animate(CurvedAnimation(parent: _scrollController, curve: Curves.linear));
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
      if (_isPaused) {
        _scrollController.stop();
        _parallaxController.stop();
      } else {
        _scrollController.forward();
        _parallaxController.repeat();
      }
    });
  }

  void _changeSpeed(double delta) {
    setState(() {
      _speedMultiplier = (_speedMultiplier + delta).clamp(0.5, 3.0);
      final wasPlaying = !_isPaused;

      // Preserve current progress
      final progress = _scrollController.value;
      _updateScrollAnimation();
      _scrollController.value = progress;

      if (wasPlaying) {
        _scrollController.forward();
      }
    });
  }

  void _resetAnimation() {
    _scrollController.reset();
    _scrollController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _togglePause,
      onDoubleTap: _resetAnimation,
      onVerticalDragUpdate: (details) {
        // Swipe up to speed up, down to slow down
        if (details.delta.dy < -5) {
          _changeSpeed(0.2);
        } else if (details.delta.dy > 5) {
          _changeSpeed(-0.2);
        }
      },
      child: Stack(
        children: [
          // Parallax background layers
          if (widget.enableParallax) ..._buildParallaxLayers(),

          // Main content with gradient mask
          ClipRect(
            child: Container(
              foregroundDecoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF0D0D0D),
                    Colors.transparent,
                    Colors.transparent,
                    Color(0xFF0D0D0D),
                  ],
                  stops: [0.0, 0.12, 0.88, 1.0],
                ),
              ),
              child: AnimatedBuilder(
                animation: _scrollController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.0012)
                        ..rotateX(0.25)
                        ..setTranslationRaw(
                          0.0,
                          _scrollAnimation.value * 500,
                          0.0,
                        ),
                      child: child,
                    ),
                  );
                },
                child: _buildContent(),
              ),
            ),
          ),

          // Control overlay
          _buildControls(),
        ],
      ),
    );
  }

  List<Widget> _buildParallaxLayers() {
    return _parallaxLayers.map((layer) {
      return AnimatedBuilder(
        animation: _parallaxController,
        builder: (context, child) {
          return CustomPaint(
            size: Size.infinite,
            painter: ParallaxPainter(
              layer: layer,
              progress: _parallaxController.value,
              isPaused: _isPaused,
            ),
          );
        },
      );
    }).toList();
  }

  Widget _buildContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 400),
        ...widget.sections.expand(
          (section) => [
            _buildTitle(section.title),
            if (section.subtitle != null) ...[
              const SizedBox(height: 12),
              _buildSubtitle(section.subtitle!),
            ],
            const SizedBox(height: 40),
            _buildBody(section.body),
            const SizedBox(height: 100),
          ],
        ),
        const SizedBox(height: 600),
      ],
    );
  }

  Widget _buildTitle(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontFamily: 'Cinzel',
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Color(0xFFE8DCC4),
        letterSpacing: 3,
        height: 1.3,
        shadows: [
          Shadow(
            color: Color(0x60D4A574),
            blurRadius: 30,
            offset: Offset(0, 6),
          ),
          Shadow(
            color: Color(0x40D4A574),
            blurRadius: 60,
            offset: Offset(0, 12),
          ),
        ],
      ),
    );
  }

  Widget _buildSubtitle(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontFamily: 'Cinzel',
        fontSize: 20,
        color: Color(0xFFD4A574),
        letterSpacing: 4,
      ),
    );
  }

  Widget _buildBody(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Text(
        text,
        textAlign: TextAlign.justify,
        style: const TextStyle(
          fontFamily: 'Lora',
          fontSize: 18,
          height: 1.9,
          color: Color(0xFFE8DCC4),
        ),
      ),
    );
  }

  Widget _buildControls() {
    return Positioned(
      bottom: 20,
      left: 0,
      right: 0,
      child: AnimatedOpacity(
        opacity: _isPaused ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 40),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          decoration: BoxDecoration(
            color: const Color(0xCC0D0D0D),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0x40D4A574)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.replay, color: Color(0xFFD4A574)),
                    onPressed: _resetAnimation,
                    tooltip: 'Restart',
                  ),
                  const SizedBox(width: 20),
                  Icon(
                    _isPaused ? Icons.play_arrow : Icons.pause,
                    color: const Color(0xFFD4A574),
                    size: 32,
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    icon: const Icon(Icons.speed, color: Color(0xFFD4A574)),
                    onPressed: () => _changeSpeed(0.5),
                    tooltip: 'Speed up',
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${_speedMultiplier.toStringAsFixed(1)}x speed',
                style: const TextStyle(color: Color(0xFFE8DCC4), fontSize: 12),
              ),
              const SizedBox(height: 4),
              const Text(
                'Tap to pause • Swipe to adjust speed • Double-tap to restart',
                style: TextStyle(color: Color(0x80E8DCC4), fontSize: 10),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _parallaxController.dispose();
    super.dispose();
  }
}

// Parallax Data Models
class ParallaxLayer {
  final double speed;
  final int particleCount;
  final RangeValues sizeRange;
  final RangeValues opacityRange;
  final Color color;
  final List<Particle> particles;

  ParallaxLayer({
    required this.speed,
    required this.particleCount,
    required this.sizeRange,
    required this.opacityRange,
    required this.color,
    required Random random,
  }) : particles = List.generate(
          particleCount,
          (_) => Particle.random(random, sizeRange, opacityRange),
        );
}

class Particle {
  final double x;
  final double y;
  final double size;
  final double opacity;
  final double twinkleSpeed;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.opacity,
    required this.twinkleSpeed,
  });

  factory Particle.random(
    Random random,
    RangeValues sizeRange,
    RangeValues opacityRange,
  ) {
    return Particle(
      x: random.nextDouble(),
      y: random.nextDouble(),
      size: sizeRange.start +
          random.nextDouble() * (sizeRange.end - sizeRange.start),
      opacity: opacityRange.start +
          random.nextDouble() * (opacityRange.end - opacityRange.start),
      twinkleSpeed: 0.5 + random.nextDouble() * 2.0,
    );
  }
}

// Custom Painter for Parallax Effect
class ParallaxPainter extends CustomPainter {
  final ParallaxLayer layer;
  final double progress;
  final bool isPaused;

  ParallaxPainter({
    required this.layer,
    required this.progress,
    required this.isPaused,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = layer.color;

    for (final particle in layer.particles) {
      // Calculate parallax position
      final yOffset = (particle.y + progress * layer.speed) % 1.0;
      final x = particle.x * size.width;
      final y = yOffset * size.height;

      // Twinkle effect
      final twinkle = isPaused
          ? 1.0
          : 0.7 +
              0.3 *
                  ((progress * particle.twinkleSpeed * 10) % (2 * pi))
                      .sinValue();
      final currentOpacity = particle.opacity * twinkle;

      paint.color = layer.color.withValues(alpha: currentOpacity);

      // Draw glow for larger particles
      if (particle.size > 2.0) {
        canvas.drawCircle(
          Offset(x, y),
          particle.size * 2,
          paint..color = layer.color.withValues(alpha: currentOpacity * 0.3),
        );
      }

      // Draw core
      canvas.drawCircle(
        Offset(x, y),
        particle.size,
        paint..color = layer.color.withValues(alpha: currentOpacity),
      );
    }
  }

  @override
  bool shouldRepaint(covariant ParallaxPainter oldDelegate) => true;
}

extension on double {
  double sinValue() => sin(this);
}
