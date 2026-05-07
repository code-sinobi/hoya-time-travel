import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/era_theme.dart';
import '../../../core/theme/priority_colors.dart';
import '../domain/anomaly.dart';
import 'countdown_timer.dart';
import 'destabilization_bar.dart';

/// Enhanced anomaly card with living animations, countdown timers,
/// story snippets, and cascade connections.
class LivingAnomalyCard extends StatefulWidget {
  const LivingAnomalyCard({
    required this.anomaly,
    super.key,
    this.onPurge,
    this.onStabilize,
    this.showCascadeIndicator = false,
    this.cascadeCount = 0,
  });
  final Anomaly anomaly;
  final VoidCallback? onPurge;
  final VoidCallback? onStabilize;
  final bool showCascadeIndicator;
  final int cascadeCount;

  @override
  State<LivingAnomalyCard> createState() => _LivingAnomalyCardState();
}

class _LivingAnomalyCardState extends State<LivingAnomalyCard>
    with SingleTickerProviderStateMixin {
  // Minigame State
  double _stabilizeProgress = 0.0;
  bool _isStabilizing = false;
  late AnimationController _pulseController;

  // Design Constants
  static const double _targetMin = 0.7;
  static const double _targetMax = 0.9;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  // Colors helpers
  Color get _baseColor {
    switch (widget.anomaly.severity) {
      case AnomalySeverity.critical:
        return PriorityColors.criticalBackground;
      case AnomalySeverity.high:
        return PriorityColors.highBackground;
      case AnomalySeverity.stable:
        return PriorityColors.stableBackground;
    }
  }

  Color get _borderColor {
    switch (widget.anomaly.severity) {
      case AnomalySeverity.critical:
        return PriorityColors.criticalBorder;
      case AnomalySeverity.high:
        return PriorityColors.highBorder;
      case AnomalySeverity.stable:
        return PriorityColors.stableBorder;
    }
  }

  Color get _textColor {
    switch (widget.anomaly.severity) {
      case AnomalySeverity.critical:
        return PriorityColors.criticalText;
      case AnomalySeverity.high:
        return PriorityColors.highText;
      case AnomalySeverity.stable:
        return PriorityColors.stableText;
    }
  }

  IconData get _statusIcon {
    switch (widget.anomaly.severity) {
      case AnomalySeverity.critical:
        return Icons.warning_amber;
      case AnomalySeverity.high:
        return Icons.priority_high;
      case AnomalySeverity.stable:
        return Icons.check_circle_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget card = DecoratedBox(
      decoration: BoxDecoration(
        color: _baseColor.withValues(alpha: 0.9),
        border: Border.all(
          color: _borderColor,
          width: widget.anomaly.severity == AnomalySeverity.critical ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: _borderColor.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title with potential glitch
                _GlitchText(
                  text: widget.anomaly.title.toUpperCase(),
                  style: GoogleFonts.orbitron(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                  enabled: widget.anomaly.isGlitching ||
                      widget.anomaly.severity == AnomalySeverity.critical,
                ),

                const SizedBox(height: 4),
                Text(
                  widget.anomaly.location.toUpperCase(),
                  style: GoogleFonts.exo2(
                    fontSize: 11,
                    color: MythicColors.stoneGray,
                    letterSpacing: 1,
                  ),
                ),

                if (widget.anomaly.storySnippet.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    widget.anomaly.storySnippet,
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 14,
                      color: Colors.white70,
                      fontStyle: FontStyle.italic,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],

                if (widget.anomaly.destabilizationPercent > 0) ...[
                  const SizedBox(height: 16),
                  DestabilizationIndicator(
                    percent: widget.anomaly.destabilizationPercent,
                    color: _borderColor,
                  ),
                ],

                if (widget.showCascadeIndicator && widget.cascadeCount > 0) ...[
                  const SizedBox(height: 12),
                  _buildCascadeIndicator(),
                ],

                const SizedBox(height: 16),
                _buildActionButtons(),
              ],
            ),
          ),
        ],
      ),
    );

    if (widget.anomaly.severity == AnomalySeverity.critical) {
      card = _wrapWithBreathingGlow(card);
    }

    return Dismissible(
      key: Key(widget.anomaly.id),
      confirmDismiss: (direction) async {
        unawaited(HapticFeedback.mediumImpact());
        if (direction == DismissDirection.startToEnd) {
          // Swipe Stabilize not allowed if minigame exists?
          // Let's keep swipe as "Quick Stabilize" (maybe cost more?)
          // or disable it to force minigame.
          // Let's disable Swipe Stabilize in favor of button mechanics for gamification
          return false;
        } else {
          widget.onPurge?.call();
        }
        return false;
      },
      background: _buildSwipeBackground(isStabilize: true), // Hidden behavior
      secondaryBackground: _buildSwipeBackground(isStabilize: false),
      child: card,
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        // Purge button (Instant)
        Expanded(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: _textColor,
              side: BorderSide(color: _borderColor.withValues(alpha: 0.5)),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            onPressed: () {
              HapticFeedback.heavyImpact();
              widget.onPurge?.call();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.delete_forever, size: 16),
                const SizedBox(width: 6),
                Text(
                  'PURGE',
                  style: GoogleFonts.orbitron(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 12),

        // Stabilize button (Minigame)
        Expanded(
          child: GestureDetector(
            onLongPressStart: (_) => _startStabilizing(),
            onLongPressEnd: (_) => _endStabilizing(),
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                // Background
                Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: _borderColor.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(6),
                    border:
                        Border.all(color: _borderColor.withValues(alpha: 0.5)),
                  ),
                ),
                // Progress Bar
                AnimatedFractionallySizedBox(
                  duration: const Duration(milliseconds: 100),
                  widthFactor: _stabilizeProgress,
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: _getProgressBarColor(),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                // Target Zone Marker (Visual guide)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: 4,
                  child: Row(
                    children: [
                      Spacer(flex: (_targetMin * 100).toInt()),
                      Expanded(
                        flex: ((_targetMax - _targetMin) * 100).toInt(),
                        child: Container(
                          color: Colors.white.withValues(alpha: 0.5),
                        ),
                      ),
                      Spacer(flex: ((1.0 - _targetMax) * 100).toInt()),
                    ],
                  ),
                ),

                // Text Content
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.auto_fix_high, size: 16, color: _textColor),
                      const SizedBox(width: 6),
                      Text(
                        _isStabilizing ? 'HOLD TO SYNC...' : 'STABILIZE',
                        style: GoogleFonts.orbitron(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: _textColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _startStabilizing() async {
    unawaited(HapticFeedback.lightImpact());
    setState(() {
      _isStabilizing = true;
      _stabilizeProgress = 0.0;
    });

    // Game loop
    while (_isStabilizing && _stabilizeProgress < 1.0) {
      await Future<void>.delayed(const Duration(milliseconds: 16));
      if (!_isStabilizing) break;

      setState(() {
        _stabilizeProgress += 0.015; // Speed of fill
      });

      // Haptic tick when entering zone
      if (_stabilizeProgress >= _targetMin &&
          _stabilizeProgress - 0.015 < _targetMin) {
        unawaited(HapticFeedback.mediumImpact());
      }
    }
  }

  void _endStabilizing() {
    setState(() => _isStabilizing = false);

    if (_stabilizeProgress >= _targetMin && _stabilizeProgress <= _targetMax) {
      // Success!
      HapticFeedback.heavyImpact();
      widget.onStabilize?.call();
    } else {
      // Failed
      HapticFeedback.vibrate();
      setState(() => _stabilizeProgress = 0.0);
    }
  }

  Color _getProgressBarColor() {
    if (_stabilizeProgress >= _targetMin && _stabilizeProgress <= _targetMax) {
      return const Color(0xFF00FF00).withValues(alpha: 0.5); // Sweet spot
    } else if (_stabilizeProgress > _targetMax) {
      return const Color(0xFFFF0000).withValues(alpha: 0.5); // Overload
    }
    return _borderColor.withValues(alpha: 0.5);
  }

  // ... (Keep existing helpers: _buildHeader, _buildCascadeIndicator, _buildSwipeBackground, _wrapWithBreathingGlow)
  // Re-implementing them briefly to ensure closure of file correctly

  Widget _buildHeader() {
    // ... same code as before ...
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      // ...
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _borderColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: _borderColor.withValues(alpha: 0.5)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(_statusIcon, size: 14, color: _textColor),
                const SizedBox(width: 6),
                Text(
                  widget.anomaly.severity.name.toUpperCase(),
                  style: GoogleFonts.orbitron(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: _textColor,
                  ),
                ),
              ],
            ),
          ),
          if (widget.anomaly.hasCountdown)
            CountdownTimer(
              deadline: widget.anomaly.collapseDeadline!,
              color: _textColor,
              showPulse: widget.anomaly.isUrgent,
            ),
        ],
      ),
    );
  }

  Widget _buildCascadeIndicator() {
    return Row(
      children: [
        Icon(
          Icons.account_tree_outlined,
          size: 14,
          color: _borderColor.withValues(
            alpha: 0.7,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          'Affects ${widget.cascadeCount} timelines',
          style: GoogleFonts.exo2(
            fontSize: 11,
            color: _borderColor.withValues(
              alpha: 0.8,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSwipeBackground({required bool isStabilize}) {
    return Container(
      color: isStabilize
          ? PriorityColors.stableBorder.withValues(alpha: 0.3)
          : PriorityColors.criticalBorder.withValues(alpha: 0.3),
    );
  }

  Widget _wrapWithBreathingGlow(Widget child) {
    return child.animate(onPlay: (c) => c.repeat(reverse: true)).custom(
          duration: const Duration(seconds: 2),
          builder: (context, value, child) => DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: _borderColor.withValues(alpha: 0.2 + (value * 0.3)),
                  blurRadius: 15 + (value * 10),
                ),
              ],
            ),
            child: child,
          ),
        );
  }
}

class _GlitchText extends StatefulWidget {
  const _GlitchText({
    required this.text,
    required this.style,
    this.enabled = false,
  });
  final String text;
  final TextStyle style;
  final bool enabled;

  @override
  State<_GlitchText> createState() => _GlitchTextState();
}

class _GlitchTextState extends State<_GlitchText> {
  String _displayText = '';
  Timer? _glitchTimer;
  final _chars = r'!@#$%^&*<>?[]{}/\|+=~-_';
  final _random = math.Random();

  @override
  void initState() {
    super.initState();
    _displayText = widget.text;
    if (widget.enabled) {
      _startGlitchLoop();
    }
  }

  @override
  void didUpdateWidget(_GlitchText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.text != oldWidget.text) {
      _displayText = widget.text;
    }
    if (widget.enabled != oldWidget.enabled) {
      if (widget.enabled) {
        _startGlitchLoop();
      } else {
        _glitchTimer?.cancel();
        _displayText = widget.text;
      }
    }
  }

  @override
  void dispose() {
    _glitchTimer?.cancel();
    super.dispose();
  }

  void _startGlitchLoop() {
    // Random glitch every 2-5 seconds
    _glitchTimer = Timer.periodic(
      Duration(milliseconds: 2000 + _random.nextInt(3000)),
      (_) => _triggerGlitch(),
    );
  }

  Future<void> _triggerGlitch() async {
    if (!mounted) return;

    // Glitch for 200ms
    for (int i = 0; i < 5; i++) {
      if (!mounted) return;
      setState(() {
        _displayText = String.fromCharCodes(
          widget.text.runes.map((rune) {
            return _random.nextDouble() > 0.7
                ? _chars.codeUnitAt(_random.nextInt(_chars.length))
                : rune;
          }),
        );
      });
      await Future<void>.delayed(const Duration(milliseconds: 50));
    }

    if (mounted) {
      setState(() => _displayText = widget.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _displayText,
      style: widget.style,
    );
  }
}
