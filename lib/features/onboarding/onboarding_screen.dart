import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import 'data/onboarding_content.dart';
import 'providers/onboarding_provider.dart';
import 'widgets/device_onboarding.dart';

/// Onboarding screen with Chrono-Lens interface
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  Future<void> _completeOnboarding() async {
    // Mark onboarding as complete via provider
    await ref.read(onboardingNotifierProvider.notifier).completeOnboarding();

    // Navigate to auth
    if (mounted) {
      context.go(AppRoutes.auth);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DeviceOnboarding(
      pages: onboardingPages,
      onComplete: _completeOnboarding,
    );
  }
}
