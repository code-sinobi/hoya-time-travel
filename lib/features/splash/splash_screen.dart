import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/router/routes.dart';

/// Splash screen shown on app startup
///
/// Displays Hoya branding while initializing app and checking auth state.
/// Minimum duration: 2 seconds for branding
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _checkAuthAndNavigate() async {
    // Ensure at least some time has passed if animation is super short,
    // but usually Lottie drives it.

    // Check auth state
    // final authState = await ref.read(authStateChangesProvider.future);
    // (Optional: pre-fetch auth state here if strictly needed, but router handles it mostly)

    if (mounted) {
      // Centralize logic in router by attempting to go to Portal.
      // The router's redirect will push us to Onboarding or Auth if needed.
      context.go(AppRoutes.portal);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Fallback
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Design Concept Background (Galactic)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF0A0A0F), Color(0xFF1A1A2E)], // Deep Space
              ),
            ),
          ),

          // 2. Lottie Animation
          Center(
            child: Lottie.asset(
              'assets/lottie/splash.json',
              controller: _controller,
              onLoaded: _onAnimationLoaded,
              fit: BoxFit.contain, // Contain to avoid cropping on branding
              width: MediaQuery.of(context).size.width * 0.8,
              errorBuilder: (context, error, stacktrace) {
                WidgetsBinding.instance.addPostFrameCallback(
                  (_) => _checkAuthAndNavigate(),
                );
                return const SizedBox.shrink();
              },
            ),
          ),

          // 3. HOYA Text Overlay
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.15,
            left: 0,
            right: 0,
            child: Center(
              child:
                  Text(
                        'HOYA',
                        style: GoogleFonts.orbitron(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFD4A574), // Bronze
                          letterSpacing: 12,
                          shadows: [
                            BoxShadow(
                              color: const Color(
                                0xFFD4A574,
                              ).withValues(alpha: 0.5),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      )
                      .animate()
                      .fadeIn(duration: 800.ms, delay: 500.ms)
                      .scale(
                        begin: const Offset(0.9, 0.9),
                        end: const Offset(1.0, 1.0),
                        duration: 1.seconds,
                        curve: Curves.easeOut,
                      ),
            ),
          ),
        ],
      ),
    );
  }

  void _onAnimationLoaded(LottieComposition composition) {
    // Force 5 seconds duration regardless of Lottie native duration
    // If native is shorter, we can loop or just slow it down
    // If native is longer, we cut it? Or we just speed it up?
    // User said "splash screen should last for 5 seconds".
    // We will play the animation normally but wait 5 seconds before navigating.

    _controller
      ..duration = composition.duration
      ..forward(); // Just play it once or loop? Usually branding plays once.

    // Timer for navigation
    Future.delayed(const Duration(seconds: 5), () {
      _checkAuthAndNavigate();
    });
  }
}
