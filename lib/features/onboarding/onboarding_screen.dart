import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/router/routes.dart';
import '../../core/theme/era_theme.dart';
import '../../core/providers/shared_preferences_provider.dart';
import 'data/onboarding_content.dart';
import 'widgets/onboarding_page.dart';
import 'widgets/page_indicator.dart';

/// Onboarding screen with 3 swipeable pages
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _skip() {
    _completeOnboarding();
  }

  void _next() {
    if (_currentPage < onboardingPages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _completeOnboarding() {
    // Mark onboarding as complete
    final prefs = ref.read(sharedPreferencesProvider);
    prefs.setBool('onboarding_complete', true);

    // Navigate to auth
    if (mounted) {
      context.go(AppRoutes.auth);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<EraTheme>() ?? AncientEraTheme();
    final isLastPage = _currentPage == onboardingPages.length - 1;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [theme.backgroundColor, theme.surfaceColor],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top bar with Skip button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 80), // Spacer for centering
                    const Spacer(),
                    TextButton(
                      onPressed: _skip,
                      child: Text(
                        'SKIP',
                        style: theme.bodyStyle.copyWith(
                          color: theme.secondaryColor,
                          fontSize: 14,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // PageView
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemCount: onboardingPages.length,
                  itemBuilder: (context, index) {
                    return OnboardingPage(data: onboardingPages[index]);
                  },
                ),
              ),

              // Bottom section with indicator and button
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  children: [
                    // Page indicator
                    PageIndicator(
                      currentPage: _currentPage,
                      pageCount: onboardingPages.length,
                      activeColor: theme.primaryColor,
                      inactiveColor: theme.primaryColor.withValues(alpha: 0.3),
                    ),

                    const SizedBox(height: 40),

                    // Next/Done button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _next,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.primaryColor,
                          foregroundColor: theme.backgroundColor,
                          shape: theme.buttonShape,
                        ),
                        child: Text(
                          isLastPage ? 'GET STARTED' : 'NEXT',
                          style: theme.headlineStyle.copyWith(
                            fontSize: 16,
                            color: theme.backgroundColor,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ).animate().fadeIn(delay: 600.ms),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
