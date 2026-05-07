import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../../../core/widgets/galactic_background.dart';
import '../data/onboarding_content.dart';

class DeviceOnboarding extends StatefulWidget {
  const DeviceOnboarding({
    required this.pages,
    required this.onComplete,
    super.key,
  });
  final List<OnboardingPageData> pages;
  final VoidCallback onComplete;

  @override
  State<DeviceOnboarding> createState() => _DeviceOnboardingState();
}

class _DeviceOnboardingState extends State<DeviceOnboarding>
    with TickerProviderStateMixin {
  int _currentPage = 0;

  late AnimationController _transitionController;
  late AnimationController _particleController;

  @override
  void initState() {
    super.initState();
    _transitionController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _particleController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  void _nextPage() {
    if (_currentPage < widget.pages.length - 1) {
      _transitionController.forward().then((_) {
        if (mounted) {
          setState(() => _currentPage++);
          _transitionController.reverse();
        }
      });
    } else {
      widget.onComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Guard against empty pages or invalid index
    if (widget.pages.isEmpty) {
      return const SizedBox.shrink();
    }

    // Clamp _currentPage to valid range
    final safeCurrentPage = _currentPage.clamp(0, widget.pages.length - 1);
    final currentData = widget.pages[safeCurrentPage];
    // Use safe index for data access but still rely on _currentPage for some state if needed,
    // though ideally everything should use the safe index if the list can shrink.
    // However, the CodeRabbit suggestion specifically asked to use safeCurrentPage for:
    // ValueKey, ControlDeck.currentPage, and isLastPage.

    // We already have 'currentData' using safeCurrentPage.

    return AnimatedBuilder(
      animation: _transitionController,
      builder: (context, child) {
        final transitionValue = _transitionController.value;
        final opacity = 1.0 - transitionValue;

        return Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              // LAYER 1: Background
              const GalacticBackground(),

              // LAYER 2: Data Stream (Background Overlay)
              // Constrained to middle area to visually connect Relic and Lens
              Positioned(
                top: MediaQuery.of(context).size.height * 0.25,
                bottom: MediaQuery.of(context).size.height * 0.25,
                left: 0,
                right: 0,
                child: Opacity(
                  opacity: opacity * 0.5,
                  child: DataStream(controller: _particleController),
                ),
              ),

              // LAYER 3: Main Responsive Layout
              SafeArea(
                child: Column(
                  children: [
                    // TOP: Relic Chamber (Flexible)
                    Expanded(
                      flex: 5,
                      child: Opacity(
                        opacity: opacity,
                        child: Center(
                          child: RelicChamber(
                            lottieAsset: currentData.lottieAsset,
                          ),
                        ),
                      ),
                    ),

                    // MIDDLE: Chrono-Lens (Flexible Container)
                    Expanded(
                      flex: 4,
                      child: Center(
                        child: Opacity(
                          opacity: opacity,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxHeight: 180, // Target height
                              minHeight: 120, // Shrinkable
                            ),
                            child: ChronoLens(
                              title: currentData.title,
                              description: currentData.description,
                              key: ValueKey(safeCurrentPage),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // BOTTOM: Control Deck (Natural Size)
                    ControlDeck(
                      currentPage: safeCurrentPage,
                      totalPages: widget.pages.length,
                      onNext: _nextPage,
                      isLastPage: safeCurrentPage == widget.pages.length - 1,
                    ),
                  ],
                ),
              ),

              // Global Skip Button at top right
              Positioned(
                top: MediaQuery.of(context).padding.top + 16,
                right: 24,
                child: TextButton(
                  onPressed: widget.onComplete,
                  child: Text(
                    'SKIP SYSTEM',
                    style: GoogleFonts.orbitron(
                      color: const Color(0xFFD4A574).withValues(alpha: 0.8),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _transitionController.dispose();
    _particleController.dispose();
    super.dispose();
  }
}

// ---------------------------------------------------------------------------
// SUB-COMPONENTS
// ---------------------------------------------------------------------------

class RelicChamber extends StatelessWidget {
  const RelicChamber({required this.lottieAsset, super.key});
  final String? lottieAsset;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Dynamic sizing based on available space
        final size =
            math.min(constraints.maxWidth, constraints.maxHeight) * 0.8;
        return SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              const PulseRing(),
              Container(
                width: size * 0.9,
                height: size * 0.9,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFD4A574).withValues(alpha: 0.3),
                  ),
                ),
              ),
              if (lottieAsset != null)
                Transform.translate(
                  offset: const Offset(0, 10),
                  child: Lottie.asset(
                    lottieAsset!,
                    height: size * 0.6,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.auto_awesome,
                        size: size * 0.4,
                        color: const Color(0xFFD4A574),
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class PulseRing extends StatefulWidget {
  const PulseRing({super.key});
  @override
  State<PulseRing> createState() => _PulseRingState();
}

class _PulseRingState extends State<PulseRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final maxSz = constraints.maxWidth;
            final val = _controller.value;
            // Pulse expands from 70% to 100% of container
            final currentSz = (maxSz * 0.7) + (val * (maxSz * 0.3));
            return Container(
              width: currentSz,
              height: currentSz,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(
                    0xFFD4A574,
                  ).withValues(alpha: (1 - val).clamp(0.0, 1.0)),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class DataStream extends StatelessWidget {
  const DataStream({required this.controller, super.key});
  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return CustomPaint(
          painter: ParticleStreamPainter(progress: controller.value),
        );
      },
    );
  }
}

class ParticleStreamPainter extends CustomPainter {
  ParticleStreamPainter({required this.progress});
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..strokeWidth = 1.5;
    final startX = size.width / 2;
    for (int i = 0; i < 8; i++) {
      final t = (progress + (i / 8)) % 1.0;
      final y = size.height * t;
      final x = startX + math.sin((t * math.pi * 4) + (i * 1.5)) * 15;
      final opacity = 1.0 - (2 * (t - 0.5)).abs();
      paint.color = const Color(0xFFD4A574).withValues(alpha: 0.6 * opacity);
      canvas.drawCircle(Offset(x, y), 2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant ParticleStreamPainter old) => true;
}

class ChronoLens extends StatefulWidget {
  const ChronoLens({required this.title, required this.description, super.key});
  final String title;
  final String description;
  @override
  State<ChronoLens> createState() => _ChronoLensState();
}

class _ChronoLensState extends State<ChronoLens>
    with SingleTickerProviderStateMixin {
  late AnimationController _scrollController;
  @override
  void initState() {
    super.initState();
    _scrollController = AnimationController(
      duration: const Duration(seconds: 12),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Fill available space (up to constraint)
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      // Frame removed as requested
      child: ClipRect(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: AnimatedBuilder(
                animation: _scrollController,
                builder: (context, child) {
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      // Scroll logic adapted for flex height
                      final viewH = constraints.maxHeight;
                      final scrollRange = viewH * 1.5; // Scroll 1.5x height
                      final offset = _scrollController.value * scrollRange;

                      return Stack(
                        children: [
                          Transform.translate(
                            offset: Offset(0, viewH * 0.8 - offset),
                            child: _buildText(),
                          ),
                          Transform.translate(
                            offset: Offset(
                              0,
                              viewH * 0.8 + scrollRange - offset,
                            ),
                            child: _buildText(),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),

            // Fade Gradients maintained for readability
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 30,
              child: _Gradient(top: true),
            ),
            const Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 30,
              child: _Gradient(top: false),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildText() {
    return OverflowBox(
      minHeight: 0,
      maxHeight: double.infinity,
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DecryptingText(
            text: widget.title,
            style: GoogleFonts.cinzel(
              fontSize: 22, // Slightly smaller for better fit
              fontWeight: FontWeight.bold,
              color: const Color(0xFFD4A574),
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          DecryptingText(
            text: widget.description,
            style: GoogleFonts.lora(
              fontSize: 15,
              height: 1.5,
              color: const Color(0xFFE8DCC4),
            ),
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}

class _Gradient extends StatelessWidget {
  const _Gradient({required this.top});
  final bool top;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: top ? Alignment.topCenter : Alignment.bottomCenter,
          end: top ? Alignment.bottomCenter : Alignment.topCenter,
          colors: [Colors.black.withValues(alpha: 0.8), Colors.transparent],
        ),
      ),
    );
  }
}

class DecryptingText extends StatefulWidget {
  const DecryptingText({required this.text, required this.style, super.key});
  final String text;
  final TextStyle style;
  @override
  State<DecryptingText> createState() => _DecryptingTextState();
}

class _DecryptingTextState extends State<DecryptingText> {
  String _d = '';
  final _r = math.Random();
  int _runId = 0; // Track animation instances to prevent race conditions
  @override
  void initState() {
    super.initState();
    _run();
  }

  @override
  void didUpdateWidget(DecryptingText old) {
    super.didUpdateWidget(old);
    if (old.text != widget.text) {
      _runId++; // Increment to cancel stale animations
      _run();
    }
  }

  Future<void> _run() async {
    if (!mounted) return;

    // Capture text and runId locally to prevent race conditions
    final localText = widget.text;
    final currentRun = _runId;

    setState(() => _d = '');
    final chars = localText.split('');
    // Fast typing: 10ms-20ms
    final delay = (500 / math.max(1, chars.length)).clamp(5.0, 20.0).toInt();

    for (int i = 0; i < chars.length; i++) {
      // Check if this animation is still valid
      if (!mounted || currentRun != _runId) return;

      setState(() {
        // Show partially decrypted
        _d = localText.substring(0, i + 1) +
            (i < chars.length - 1
                ? String.fromCharCode(33 + _r.nextInt(90))
                : '');
      });
      await Future<void>.delayed(Duration(milliseconds: delay));
    }

    // Final update only if still valid
    if (mounted && currentRun == _runId) {
      setState(() => _d = localText);
    }
  }

  @override
  Widget build(BuildContext context) =>
      Text(_d, style: widget.style, textAlign: TextAlign.center);
}

class ControlDeck extends StatelessWidget {
  const ControlDeck({
    required this.currentPage,
    required this.totalPages,
    required this.onNext,
    required this.isLastPage,
    super.key,
  });
  final int currentPage;
  final int totalPages;
  final VoidCallback onNext;
  final bool isLastPage;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Indicators & Skip
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Indicators
              Row(
                children: List.generate(totalPages, (i) {
                  final active = i == currentPage;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: active ? 24 : 6,
                    height: 4,
                    decoration: BoxDecoration(
                      color: active
                          ? const Color(0xFFD4A574)
                          : const Color(0xFFD4A574).withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Button
          GestureDetector(
            onTap: onNext,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFD4A574).withValues(alpha: 0.15),
                border: Border.all(color: const Color(0xFFD4A574)),
                borderRadius: BorderRadius.circular(4),
              ),
              alignment: Alignment.center,
              child: Text(
                isLastPage ? 'INITIATE' : 'NEXT SEQUENCE',
                style: GoogleFonts.cinzel(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFD4A574),
                  letterSpacing: 3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
