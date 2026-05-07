import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import '../../../core/theme/era_theme.dart';
import '../data/onboarding_content.dart';
import 'mythology_crawl.dart';

/// Reusable onboarding page with cinematic text crawl
class OnboardingPage extends StatelessWidget {
  const OnboardingPage({required this.data, super.key});
  final OnboardingPageData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<EraTheme>() ?? AncientEraTheme();

    return Stack(
      children: [
        // Lottie airship animation at top
        if (data.lottieAsset != null)
          Positioned(
            top: 60,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 200,
              child: Lottie.asset(
                data.lottieAsset!,
                fit: BoxFit.contain,
              ),
            )
                .animate()
                .scale(duration: 800.ms, curve: Curves.elasticOut)
                .fadeIn(duration: 600.ms),
          ),

        // Cinematic crawl text in middle
        if (data.crawlSections != null && data.crawlSections!.isNotEmpty)
          Positioned(
            top: 280,
            left: 0,
            right: 0,
            bottom: 0,
            child: MythologyCrawl(
              sections: data.crawlSections!,
              crawlDuration: const Duration(seconds: 22),
            ),
          )
        else
          // Fallback to static text if no crawl sections
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 280),
                    Text(
                      data.title,
                      style: theme.headlineStyle.copyWith(fontSize: 32),
                      textAlign: TextAlign.center,
                    )
                        .animate()
                        .fadeIn(delay: 200.ms, duration: 600.ms)
                        .slideY(begin: 0.3, end: 0, duration: 600.ms),
                    const SizedBox(height: 24),
                    Text(
                      data.description,
                      style: theme.bodyStyle.copyWith(
                        fontSize: 18,
                        height: 1.6,
                      ),
                      textAlign: TextAlign.center,
                    ).animate().fadeIn(delay: 400.ms, duration: 600.ms),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
