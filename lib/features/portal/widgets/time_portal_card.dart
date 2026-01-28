import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/galactic_colors.dart';
import '../../story/data/story_library.dart'; // Ensure correct import

class TimePortalCard extends StatefulWidget {
  final StoryMetadata story;
  final VoidCallback onEnter;

  const TimePortalCard({super.key, required this.story, required this.onEnter});

  @override
  State<TimePortalCard> createState() => _TimePortalCardState();
}

class _TimePortalCardState extends State<TimePortalCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _rotation;
  late Animation<double> _scale;
  late Animation<double> _glow;

  bool _isCharging = false;
  double _chargeProgress = 0.0;
  Timer? _chargeTimer;

  @override
  void initState() {
    super.initState();

    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _rotation = Tween(begin: -0.02, end: 0.02).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );

    _scale = Tween(begin: 1.0, end: 1.03).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );

    _glow = Tween(begin: 0.5, end: 0.8).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );
  }

  void _startCharging() {
    _isCharging = true;
    _chargeProgress = 0.0;

    _chargeTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        _chargeProgress += 0.02;
        if (_chargeProgress >= 1.0) {
          _completeCharge();
          timer.cancel();
        }
      });
    });

    // Haptic feedback
    HapticFeedback.lightImpact();
  }

  void _cancelCharging() {
    _chargeTimer?.cancel();
    _isCharging = false;
    _chargeProgress = 0.0;
    setState(() {});
  }

  void _completeCharge() {
    _isCharging = false;
    widget.onEnter();
    HapticFeedback.heavyImpact();
  }

  @override
  Widget build(BuildContext context) {
    // Basic era mapping or default colors
    final eraColors =
        GalacticColors.eraGradients[widget.story.era.toLowerCase()] ??
        [GalacticColors.etherealCyan, GalacticColors.wormholeBlue];

    return GestureDetector(
      onLongPressStart: (_) => _startCharging(),
      onLongPressEnd: (_) => _cancelCharging(),
      onTapCancel: _cancelCharging,
      onTap: widget
          .onEnter, // Optional tap to enter directly if preferred, or keep charge mechanic
      child: AnimatedBuilder(
        animation: _hoverController,
        builder: (context, child) {
          return Transform(
            transform: Matrix4.identity()
              ..rotateY(_rotation.value)
              ..multiply(
                Matrix4.diagonal3Values(
                  _scale.value,
                  _scale.value,
                  _scale.value,
                ),
              ),
            alignment: Alignment.center,
            child: Container(
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.2,
                  colors: [
                    eraColors[0].withValues(alpha: 0.8),
                    eraColors[1].withValues(alpha: 0.6),
                    GalacticColors.spaceBlack.withValues(alpha: 0.9),
                  ],
                ),
                border: Border.all(
                  color: GalacticColors.temporalGold.withValues(
                    alpha: _glow.value,
                  ),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: GalacticColors.etherealCyan.withValues(alpha: 0.25),
                    blurRadius: 15,
                    // spreadRadius: 2, // Removed for perf
                  ),
                  BoxShadow(
                    color: eraColors[0].withValues(alpha: _glow.value * 0.4),
                    blurRadius: 20,
                    // spreadRadius: 5, // Removed for perf
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Story content
                  _buildStoryContent(eraColors),

                  // Portal overlay effect (Optimized)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: Colors.black.withValues(alpha: 0.3),
                      ),
                    ),
                  ),

                  // Charging indicator
                  if (_isCharging) _buildChargeIndicator(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStoryContent(List<Color> eraColors) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Era tag
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: eraColors),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              widget.story.era.toUpperCase(),
              style: GoogleFonts.orbitron(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Title
          Flexible(
            child: Text(
              widget.story.title,
              style: GoogleFonts.orbitron(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                shadows: [
                  const Shadow(
                    blurRadius: 10,
                    color: GalacticColors.etherealCyan,
                  ),
                ],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          const SizedBox(height: 8),

          // Wisdom
          Row(
            children: [
              const Icon(
                Icons.auto_awesome,
                color: GalacticColors.temporalGold,
                size: 16,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Wisdom: ${widget.story.moral}',
                  style: GoogleFonts.exo2(
                    fontSize: 14,
                    color: GalacticColors.starWhite.withValues(alpha: 0.9),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Description
          // Description
          Expanded(
            child: Text(
              widget.story.description,
              style: GoogleFonts.exo2(
                fontSize: 14,
                color: GalacticColors.starWhite.withValues(alpha: 0.7),
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          const SizedBox(height: 16),

          // Portal entry hint
          Align(
            alignment: Alignment.bottomRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.timer,
                  color: GalacticColors.etherealCyan,
                  size: 14,
                ),
                const SizedBox(width: 4),
                Text(
                  'LONG PRESS TO ENTER',
                  style: GoogleFonts.orbitron(
                    fontSize: 10,
                    color: GalacticColors.etherealCyan,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChargeIndicator() {
    return Positioned.fill(
      child: Center(
        child: SizedBox(
          width: 100,
          height: 100,
          child: CircularProgressIndicator(
            value: _chargeProgress,
            strokeWidth: 4,
            backgroundColor: GalacticColors.deepNebula,
            valueColor: const AlwaysStoppedAnimation(
              GalacticColors.etherealCyan,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _chargeTimer?.cancel();
    super.dispose();
  }
}
