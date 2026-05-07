import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

/// Splash screen shown on app startup
///
/// Displays Chrono branding while initializing app and checking auth state.
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
    // Router's redirect logic will automatically navigate based on auth/onboarding state
    // We just need to trigger a navigation away from splash screen
    // Using '/' as a generic target - router redirect will determine actual destination
    if (mounted) {
      context.go('/portal');
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

          // 3. CHRONO Text Overlay
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.15,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'CHRONO',
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
              ).animate().fadeIn(duration: 800.ms, delay: 500.ms).scale(
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
    _controller
      ..duration = composition.duration
      ..forward();

    // Timer for navigation based on animation duration
    Future<void>.delayed(composition.duration, _checkAuthAndNavigate);
  }
}
