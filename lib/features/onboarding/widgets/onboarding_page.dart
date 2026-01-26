import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/era_theme.dart';
import '../data/onboarding_content.dart';

/// Reusable onboarding page template
class OnboardingPage extends StatelessWidget {
  final OnboardingPageData data;

  const OnboardingPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<EraTheme>() ?? AncientEraTheme();

    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(data.icon, size: 60, color: theme.primaryColor),
                  )
                  .animate()
                  .scale(duration: 600.ms, curve: Curves.elasticOut)
                  .then()
                  .shimmer(
                    duration: 2000.ms,
                    color: theme.secondaryColor.withValues(alpha: 0.3),
                  ),

              const SizedBox(height: 60),

              // Title
              Text(
                    data.title,
                    style: theme.headlineStyle.copyWith(fontSize: 32),
                    textAlign: TextAlign.center,
                  )
                  .animate()
                  .fadeIn(delay: 200.ms, duration: 600.ms)
                  .slideY(begin: 0.3, end: 0, duration: 600.ms),

              const SizedBox(height: 24),

              // Description
              Text(
                data.description,
                style: theme.bodyStyle.copyWith(fontSize: 18, height: 1.6),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 400.ms, duration: 600.ms),
            ],
          ),
        ),
      ),
    );
  }
}
