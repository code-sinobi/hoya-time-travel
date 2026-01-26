import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/router/routes.dart';
import '../../core/theme/era_theme.dart';
import '../auth/services/auth_service.dart';

/// Splash screen shown on app startup
///
/// Displays Hoya branding while initializing app and checking auth state.
/// Minimum duration: 2 seconds for branding
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Minimum splash duration for branding
    final minimumDuration = Future.delayed(const Duration(milliseconds: 2000));

    // Wait for auth state to be ready
    final authStateFuture = ref.read(authStateChangesProvider.future);

    // Wait for both
    await Future.wait([minimumDuration, authStateFuture]);

    if (mounted) {
      // Router will handle redirect to onboarding or auth based on state
      context.go(AppRoutes.onboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<EraTheme>() ?? AncientEraTheme();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [theme.backgroundColor, theme.surfaceColor],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Hourglass Icon
              Icon(Icons.hourglass_empty, size: 100, color: theme.primaryColor)
                  .animate(onPlay: (controller) => controller.repeat())
                  .rotate(duration: 2000.ms, curve: Curves.easeInOut)
                  .then()
                  .rotate(
                    begin: 1,
                    end: 0,
                    duration: 2000.ms,
                    curve: Curves.easeInOut,
                  ),

              const SizedBox(height: 40),

              // HOYA Text
              Text(
                    'HOYA',
                    style: theme.headlineStyle.copyWith(
                      fontSize: 56,
                      letterSpacing: 12,
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 600.ms)
                  .scale(
                    begin: const Offset(0.8, 0.8),
                    end: const Offset(1.0, 1.0),
                    duration: 600.ms,
                    curve: Curves.elasticOut,
                  ),

              const SizedBox(height: 16),

              // Subtitle
              Text(
                'Loading your journey...',
                style: theme.bodyStyle.copyWith(
                  fontSize: 16,
                  color: theme.secondaryColor,
                  letterSpacing: 2,
                ),
              ).animate(delay: 400.ms).fadeIn(duration: 400.ms),

              const SizedBox(height: 40),

              // Loading indicator
              SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.primaryColor.withValues(alpha: 0.6),
                  ),
                ),
              ).animate(delay: 800.ms).fadeIn(),
            ],
          ),
        ),
      ),
    );
  }
}
