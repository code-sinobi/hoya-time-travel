import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../core/theme/app_typography.dart';
import '../../core/theme/mythic_colors.dart';
import '../../core/utils/app_haptics.dart';

/// Splash screen shown on app startup
///
/// Displays Chrono branding while initializing app and checking auth state.
/// Minimum duration: 2 seconds for branding.
/// Features a "Living Constellation" interactive background.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _lottieController;
  late final Ticker _particleTicker;

  final List<_Star> _stars = [];
  Offset? _touchPosition;
  Size _screenSize = Size.zero;

  @override
  void initState() {
    super.initState();
    _lottieController = AnimationController(vsync: this);

    // Setup particle ticker for 60fps update
    _particleTicker = createTicker((elapsed) {
      _updateParticles();
    });
    _particleTicker.start();

    // Initialize stars (we'll distribute them once we have a size, or loosely bound them to a large area)
    final rand = math.Random();
    for (int i = 0; i < 80; i++) {
      _stars.add(
        _Star(
          position: Offset(
            rand.nextDouble() * 1000,
            rand.nextDouble() * 2000,
          ), // arbitrary large initial area
          velocity: Offset(
            (rand.nextDouble() - 0.5) * 0.5,
            (rand.nextDouble() - 0.5) * 0.5,
          ),
          radius: rand.nextDouble() * 1.5 + 0.5,
          baseAlpha: rand.nextDouble() * 0.6 + 0.2,
        ),
      );
    }
  }

  @override
  void dispose() {
    _lottieController.dispose();
    _particleTicker.dispose();
    super.dispose();
  }

  Future<void> _checkAuthAndNavigate() async {
    // Router's redirect logic will automatically navigate based on auth/onboarding state
    if (mounted) {
      context.go('/portal');
    }
  }

  void _updateParticles() {
    if (_screenSize == Size.zero) return;

    bool needsRepaint = false;
    for (var star in _stars) {
      star.position += star.velocity;

      // Wrap around edges to keep them flowing
      if (star.position.dx < 0) {
        star.position = Offset(_screenSize.width, star.position.dy);
      }
      if (star.position.dx > _screenSize.width) {
        star.position = Offset(0, star.position.dy);
      }
      if (star.position.dy < 0) {
        star.position = Offset(star.position.dx, _screenSize.height);
      }
      if (star.position.dy > _screenSize.height) {
        star.position = Offset(star.position.dx, 0);
      }

      // React to touch
      if (_touchPosition != null) {
        final double dx = _touchPosition!.dx - star.position.dx;
        final double dy = _touchPosition!.dy - star.position.dy;
        final double distance = math.sqrt(dx * dx + dy * dy);

        if (distance < 150) {
          // Slight pull towards touch
          star.position += Offset(dx * 0.01, dy * 0.01);
          star.currentAlpha =
              math.min(1.0, star.baseAlpha + (150 - distance) / 150);
        } else {
          star.currentAlpha = star.baseAlpha;
        }
      } else {
        star.currentAlpha = star.baseAlpha;
      }
      needsRepaint = true;
    }

    if (needsRepaint && mounted) {
      setState(() {});
    }
  }

  void _handleTouchDown(Offset position) {
    setState(() => _touchPosition = position);
    AppHaptics.selection();
  }

  void _handleTouchUpdate(Offset position) {
    setState(() => _touchPosition = position);
    // Occasional haptic feedback while dragging
    if (math.Random().nextDouble() > 0.9) {
      AppHaptics.selection();
    }
  }

  void _handleTouchUp() {
    setState(() => _touchPosition = null);
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: MythicColors.voidBackground,
      body: GestureDetector(
        onPanDown: (details) => _handleTouchDown(details.localPosition),
        onPanUpdate: (details) => _handleTouchUpdate(details.localPosition),
        onPanEnd: (_) => _handleTouchUp(),
        onPanCancel: () => _handleTouchUp(),
        behavior: HitTestBehavior.opaque,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 1. Full-Screen Lottie Background (Fixes top coverage issue)
            SizedBox.expand(
              child: Lottie.asset(
                'assets/lottie/splash.json',
                controller: _lottieController,
                onLoaded: _onAnimationLoaded,
                fit: BoxFit
                    .contain, // Ensures the entire animation is visible without cropping
                errorBuilder: (context, error, stacktrace) {
                  WidgetsBinding.instance.addPostFrameCallback(
                    (_) => _checkAuthAndNavigate(),
                  );
                  return const SizedBox.shrink();
                },
              ),
            ),

            // 2. Dark Gradient Overlay to ensure text readability and deep space feel
            Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.5,
                  colors: [
                    MythicColors.voidBackground.withValues(alpha: 0.3),
                    MythicColors.deepIndigo.withValues(alpha: 0.7),
                    MythicColors.voidBackground.withValues(alpha: 0.95),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),

            // 3. Interactive Constellation Layer
            CustomPaint(
              painter: _ConstellationPainter(
                stars: _stars,
                touchPosition: _touchPosition,
                lineColor: MythicColors.ancientGold,
              ),
            ),

            // 4. Liquid Bronze CHRONO Text
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.15,
              left: 0,
              right: 0,
              child: IgnorePointer(
                child: Center(
                  child: ShaderMask(
                    shaderCallback: (bounds) {
                      return const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          MythicColors.ancientGold,
                          MythicColors.parchment,
                          MythicColors.bronze,
                          MythicColors.ancientGold,
                        ],
                        stops: [0.0, 0.4, 0.7, 1.0],
                      ).createShader(bounds);
                    },
                    blendMode: BlendMode.srcATop,
                    child: Text(
                      'CHRONO',
                      style: AppTypography.heroDisplay.copyWith(
                        color: Colors.white, // Overridden by ShaderMask
                        letterSpacing: 14,
                        shadows: [
                          BoxShadow(
                            color:
                                MythicColors.ancientGold.withValues(alpha: 0.3),
                            blurRadius: 25,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  )
                      .animate() // Entrance animation
                      .fadeIn(duration: 1200.ms, curve: Curves.easeOut)
                      .slideY(
                        begin: 0.1,
                        end: 0,
                        duration: 1200.ms,
                        curve: Curves.easeOutCubic,
                      )
                      .shimmer(
                        delay: 1000.ms,
                        duration: 3000.ms,
                        color: MythicColors.parchment.withValues(alpha: 0.5),
                        blendMode: BlendMode.overlay,
                      )
                      .animate(
                        onPlay: (controller) =>
                            controller.repeat(reverse: true),
                      )
                      .scale(
                        begin: const Offset(0.98, 0.98),
                        end: const Offset(1.02, 1.02),
                        duration: 4.seconds,
                        curve: Curves.easeInOutSine,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onAnimationLoaded(LottieComposition composition) {
    _lottieController
      ..duration = composition.duration
      ..forward();

    // Timer for navigation based on animation duration
    Future<void>.delayed(composition.duration, _checkAuthAndNavigate);
  }
}

class _Star {
  Offset position;
  Offset velocity;
  final double radius;
  final double baseAlpha;
  double currentAlpha;

  _Star({
    required this.position,
    required this.velocity,
    required this.radius,
    required this.baseAlpha,
  }) : currentAlpha = baseAlpha;
}

class _ConstellationPainter extends CustomPainter {
  final List<_Star> stars;
  final Offset? touchPosition;
  final Color lineColor;

  _ConstellationPainter({
    required this.stars,
    required this.touchPosition,
    required this.lineColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint starPaint = Paint()..style = PaintingStyle.fill;
    final Paint linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Draw lines connecting stars if they are close
    for (int i = 0; i < stars.length; i++) {
      final star1 = stars[i];

      // Draw line to touch position if very close
      if (touchPosition != null) {
        final double distanceToTouch =
            (star1.position - touchPosition!).distance;
        if (distanceToTouch < 120) {
          linePaint.color = lineColor.withValues(
            alpha: (1.0 - (distanceToTouch / 120)) * 0.5,
          );
          canvas.drawLine(star1.position, touchPosition!, linePaint);
        }
      }

      // Draw lines between stars
      for (int j = i + 1; j < stars.length; j++) {
        final star2 = stars[j];
        final double distance = (star1.position - star2.position).distance;

        if (distance < 80) {
          linePaint.color = lineColor.withValues(
            alpha: (1.0 - (distance / 80)) * 0.2,
          );
          canvas.drawLine(star1.position, star2.position, linePaint);
        }
      }
    }

    // Draw stars
    for (var star in stars) {
      starPaint.color =
          MythicColors.parchment.withValues(alpha: star.currentAlpha);

      // Draw glow
      if (star.currentAlpha > star.baseAlpha) {
        final glowPaint = Paint()
          ..style = PaintingStyle.fill
          ..color = lineColor.withValues(
            alpha: (star.currentAlpha - star.baseAlpha) * 0.3,
          )
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0);
        canvas.drawCircle(star.position, star.radius * 3, glowPaint);
      }

      canvas.drawCircle(star.position, star.radius, starPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ConstellationPainter oldDelegate) =>
      true; // Always repaint when animated
}
