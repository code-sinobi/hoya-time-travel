import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/priority_colors.dart';

/// Animated countdown timer widget for anomaly collapse deadlines.
/// Pulses urgently when time is running low.
class CountdownTimer extends StatefulWidget {
  const CountdownTimer({
    required this.deadline,
    super.key,
    this.color = PriorityColors.criticalText,
    this.showPulse = true,
    this.onExpired,
  });

  /// The target time to count down to
  final DateTime deadline;

  /// Color theme for the timer
  final Color color;

  /// Whether to show pulsing animation (for urgent timers)
  final bool showPulse;

  /// Callback when countdown reaches zero
  final VoidCallback? onExpired;

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  Timer? _timer;
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _updateRemaining();
    _timer =
        Timer.periodic(const Duration(seconds: 1), (_) => _updateRemaining());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateRemaining() {
    final remaining = widget.deadline.difference(DateTime.now());

    if (remaining.isNegative) {
      _timer?.cancel();
      widget.onExpired?.call();
      setState(() => _remaining = Duration.zero);
    } else {
      setState(() => _remaining = remaining);
    }
  }

  String _formatDuration(Duration d) {
    if (d == Duration.zero) return 'COLLAPSED';

    final hours = d.inHours;
    final minutes = d.inMinutes % 60;
    final seconds = d.inSeconds % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  bool get _isUrgent => _remaining.inMinutes < 60 && _remaining > Duration.zero;

  @override
  Widget build(BuildContext context) {
    final timerText = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.timer_outlined,
          size: 16,
          color: widget.color,
        ),
        const SizedBox(width: 6),
        Text(
          _formatDuration(_remaining),
          style: GoogleFonts.shareTechMono(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: widget.color,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          'until collapse',
          style: GoogleFonts.exo2(
            fontSize: 11,
            color: widget.color.withValues(alpha: 0.7),
          ),
        ),
      ],
    );

    if (widget.showPulse && _isUrgent) {
      return timerText
          .animate(onPlay: (controller) => controller.repeat(reverse: true))
          .custom(
            duration: const Duration(milliseconds: 800),
            builder: (context, value, child) => Opacity(
              opacity: 0.6 + (value * 0.4),
              child: child,
            ),
          );
    }

    return timerText;
  }
}
