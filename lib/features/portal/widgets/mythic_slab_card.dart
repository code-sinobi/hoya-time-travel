import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/era_theme.dart';
import '../../story/data/story_library.dart';

class MythicSlabCard extends ConsumerStatefulWidget {
  const MythicSlabCard({
    required this.story,
    required this.isLocked,
    required this.onTap,
    super.key,
  });
  final StoryMetadata story;
  final bool isLocked;
  final VoidCallback onTap;

  @override
  ConsumerState<MythicSlabCard> createState() => _MythicSlabCardState();
}

class _MythicSlabCardState extends ConsumerState<MythicSlabCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _chargeController;
  late Animation<double> _chargeAnimation;
  bool _isCharging = false;

  @override
  void initState() {
    super.initState();
    _chargeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // 2 seconds to charge
    );
    _chargeAnimation = CurvedAnimation(
      parent: _chargeController,
      curve: Curves.easeInOut,
    );

    _chargeController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Portal Fully Charged!
        HapticFeedback.heavyImpact();
        widget.onTap(); // Trigger open
        _chargeController.reset();
        setState(() => _isCharging = false);
      }
    });
  }

  @override
  void dispose() {
    _chargeController.dispose();
    super.dispose();
  }

  void _startCharging() {
    if (widget.isLocked) return;
    HapticFeedback.mediumImpact();
    setState(() => _isCharging = true);
    _chargeController.forward();
  }

  void _cancelCharging() {
    if (_chargeController.isCompleted) return;
    setState(() => _isCharging = false);
    _chargeController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    // AspectRatio constraint
    return AspectRatio(
      aspectRatio: 9 / 16,
      child: DecoratedBox(
        // No margin here, handled by carousel
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: widget.story.eraColor.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 1. Full Background Image
              Image.asset(
                widget.story.imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),

              // 2. Glassmorphism Overlay (Gradient Only - optimized for performance)
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.1),
                      Colors.black.withValues(alpha: 0.5),
                      Colors.black.withValues(alpha: 0.8),
                    ],
                    stops: const [0.0, 0.6, 1.0],
                  ),
                ),
              ),

              // 3. Portal Charge Effect (Radial Fill)
              if (_isCharging)
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: _chargeController,
                    builder: (context, child) {
                      return Container(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            radius: 1.5 * _chargeAnimation.value,
                            colors: [
                              MythicColors.wormholeBlue.withValues(
                                alpha: 0.4 * _chargeAnimation.value,
                              ),
                              Colors.transparent,
                            ],
                            stops: const [0.5, 1.0],
                          ),
                        ),
                      );
                    },
                  ),
                ),

              // 4. Content Content
              Padding(
                padding: const EdgeInsets.all(20),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Era Badge (Top Left)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                widget.story.eraColor,
                                widget.story.eraColor.withValues(alpha: 0.6),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: widget.story.eraColor.withValues(
                                  alpha: 0.4,
                                ),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: Text(
                            widget.story.era.toUpperCase(),
                            style: GoogleFonts.orbitron(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),

                        const Spacer(),

                        // Title
                        Text(
                          widget.story.title.toUpperCase(),
                          style: GoogleFonts.orbitron(
                            fontSize: 24, // Slightly reduced for safety
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            height: 1.1,
                            shadows: [
                              BoxShadow(
                                color: widget.story.eraColor.withValues(
                                  alpha: 0.8,
                                ),
                                blurRadius: 15,
                              ),
                              const BoxShadow(
                                blurRadius: 2,
                                offset: Offset(1, 1),
                              ),
                            ],
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 12),

                        // Wisdom / Moral with Icon
                        Row(
                          children: [
                            const Icon(
                              Icons.auto_awesome,
                              color: MythicColors.temporalGold,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                widget.story.moral,
                                style: GoogleFonts.exo2(
                                  fontSize: 12, // Reduced for safety
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontStyle: FontStyle.italic,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16), // Bottom padding
                      ],
                    );
                  },
                ),
              ),

              // 5. Charging Indicator Ring (Center)
              if (_isCharging)
                Center(
                  child: AnimatedBuilder(
                    animation: _chargeController,
                    builder: (context, child) {
                      return SizedBox(
                        width: 150,
                        height: 150,
                        child: CircularProgressIndicator(
                          value: _chargeAnimation.value,
                          strokeWidth: 4,
                          color: MythicColors.fluxCyan,
                          backgroundColor: MythicColors.fluxCyan.withValues(
                            alpha: 0.2,
                          ),
                        ),
                      );
                    },
                  ),
                ),

              // Transparent Tap/Long-Press Layer (allows horizontal drags to pass through)
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: widget.isLocked ? null : widget.onTap,
                  onLongPressStart:
                      widget.isLocked ? null : (_) => _startCharging(),
                  onLongPressEnd:
                      widget.isLocked ? null : (_) => _cancelCharging(),
                  child: const SizedBox.expand(),
                ),
              ),

              // 6. Locked Overlay
              if (widget.isLocked)
                ColoredBox(
                  color: Colors.black.withValues(alpha: 0.7),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.lock_clock,
                          color: MythicColors.bronze,
                          size: 64,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'TIMELINE LOCKED',
                          style: GoogleFonts.orbitron(
                            color: MythicColors.bronze,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
