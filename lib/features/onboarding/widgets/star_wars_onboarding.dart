import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../data/onboarding_content.dart';

class StarWarsOnboarding extends StatefulWidget {
  const StarWarsOnboarding({
    required this.pages,
    required this.onComplete,
    super.key,
  });
  final List<OnboardingPageData> pages;
  final VoidCallback onComplete;

  @override
  State<StarWarsOnboarding> createState() => _StarWarsOnboardingState();
}

class _StarWarsOnboardingState extends State<StarWarsOnboarding>
    with TickerProviderStateMixin {
  late AnimationController _crawlController;
  late AnimationController _fadeController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();

    // Main crawl animation - continuous loop
    _crawlController = AnimationController(
      duration: const Duration(seconds: 15), // Adjust speed here
      vsync: this,
    )..repeat();

    // Fade controller for smooth transitions between pages
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..value = 1.0;
  }

  void _nextPage() {
    if (_currentPage < widget.pages.length - 1) {
      // Fade out, change page, fade in
      _fadeController.reverse().then((_) {
        setState(() => _currentPage++);
        _fadeController.forward();
      });
    } else {
      widget.onComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentData = widget.pages[_currentPage];

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Static Background (stars)
          _buildStarfield(),

          // 2. The Crawl Container (middle layer)
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _fadeController,
              builder: (context, child) {
                return Opacity(opacity: _fadeController.value, child: child);
              },
              child: _buildCrawlLayer(currentData),
            ),
          ),

          // 3. Fixed Top Controls
          Positioned(
            top: 40,
            right: 24,
            child: TextButton(
              onPressed: widget.onComplete,
              child: Text(
                'SKIP',
                style: GoogleFonts.cinzel(
                  fontSize: 14,
                  color: const Color(0xFFD4A574),
                  letterSpacing: 2,
                ),
              ),
            ),
          ),

          // 4. Fixed Bottom Controls (Indicators + Button)
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Page Indicators
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    widget.pages.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: index == _currentPage ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: index == _currentPage
                            ? const Color(0xFFD4A574)
                            : const Color(0x40D4A574),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Next Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: GestureDetector(
                    onTap: _nextPage,
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD4A574),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          _currentPage < widget.pages.length - 1
                              ? 'NEXT'
                              : 'GET STARTED',
                          style: GoogleFonts.cinzel(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF0D0D0D),
                            letterSpacing: 3,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStarfield() {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topCenter,
          radius: 1.2,
          colors: [Color(0xFF1a1510), Color(0xFF0D0D0D)],
        ),
      ),
      child: CustomPaint(painter: StarfieldPainter()),
    );
  }

  Widget _buildCrawlLayer(OnboardingPageData data) {
    return ClipRect(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return AnimatedBuilder(
            animation: _crawlController,
            builder: (context, child) {
              // Calculate scroll position
              final scrollY =
                  _crawlController.value * constraints.maxHeight * 1.5;

              return Stack(
                children: [
                  // First copy of content
                  _buildCrawlContent(
                    data: data,
                    offset: scrollY,
                    screenHeight: constraints.maxHeight,
                  ),

                  // Second copy (for seamless loop)
                  _buildCrawlContent(
                    data: data,
                    // Offset by full cycle
                    offset: scrollY - constraints.maxHeight * 1.5,
                    screenHeight: constraints.maxHeight,
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildCrawlContent({
    required OnboardingPageData data,
    required double offset,
    required double screenHeight,
  }) {
    // Start from below screen (positive offset), move to above (negative)
    final startY = screenHeight * 0.8; // Start near bottom
    // final endY = -screenHeight * 0.5; // End above screen
    final currentY = startY - (offset % (screenHeight * 1.5));

    // Calculate opacity based on position (fade in at bottom, fade out at top)
    double opacity = 1.0;
    if (currentY > screenHeight * 0.6) {
      opacity = 1.0 - ((currentY - screenHeight * 0.6) / (screenHeight * 0.2));
    } else if (currentY < screenHeight * 0.2) {
      opacity = currentY / (screenHeight * 0.2);
    }
    opacity = opacity.clamp(0.0, 1.0);

    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        // 3D Perspective (Star Wars effect)
        ..setEntry(3, 2, 0.001) // Perspective depth
        ..rotateX(0.25) // Tilt backward 25 degrees
        ..multiply(Matrix4.translationValues(0.0, currentY, 0.0)),
      child: Opacity(
        opacity: opacity,
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Lottie Animation (original size)
                if (data.lottieAsset != null)
                  Lottie.asset(
                    data.lottieAsset!,
                    height: 200, // Keep original size
                    fit: BoxFit.contain,
                    repeat: true,
                  ),

                const SizedBox(height: 40),

                // Title (original text size)
                Text(
                  data.title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cinzel(
                    fontSize: 28, // Original size maintained
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFE8DCC4),
                    letterSpacing: 2,
                    height: 1.3,
                  ),
                ),

                const SizedBox(height: 20),

                // Description (original text size)
                Text(
                  data.description,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lora(
                    fontSize: 16, // Original size maintained
                    height: 1.6,
                    color: const Color(0xFFE8DCC4),
                  ),
                ),

                // Extra space to ensure clean exit
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _crawlController.dispose();
    _fadeController.dispose();
    super.dispose();
  }
}

// Simple starfield background painter
class StarfieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;

    // Draw static stars
    for (int i = 0; i < 100; i++) {
      final x = (i * 137.5) % size.width;
      final y = (i * 71.3) % size.height;
      final radius = (i % 3) + 0.5;
      final opacity = (i % 5) / 10 + 0.1;

      paint.color = Colors.white.withValues(alpha: opacity);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
