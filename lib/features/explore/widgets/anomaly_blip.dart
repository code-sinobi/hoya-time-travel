import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/theme/priority_colors.dart';
import '../../rifts/domain/anomaly.dart';
import '../domain/era.dart';

/// Represents a detected anomaly on the radar.
class AnomalyBlipData {
  const AnomalyBlipData({
    required this.id,
    required this.era,
    required this.angle,
    required this.severity,
    required this.title,
    this.distance = 0.7,
  });
  final String id;
  final Era era;
  final double angle; // Position angle in radians
  final double distance; // 0.0 to 1.0, relative to radar radius
  final AnomalySeverity severity;
  final String title;
}

/// Animated blip widget that appears on the radar when detected.
class AnomalyBlip extends StatefulWidget {
  const AnomalyBlip({
    required this.data,
    required this.radarRadius,
    super.key,
    this.onTap,
    this.isHighlighted = false,
  });
  final AnomalyBlipData data;
  final double radarRadius;
  final VoidCallback? onTap;
  final bool isHighlighted;

  @override
  State<AnomalyBlip> createState() => _AnomalyBlipState();
}

class _AnomalyBlipState extends State<AnomalyBlip> {
  bool _wasJustDetected = true;

  @override
  void initState() {
    super.initState();
    // Trigger haptic feedback when first appearing
    HapticFeedback.lightImpact();

    // Mark as no longer "just detected" after animation
    Future<void>.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _wasJustDetected = false);
      }
    });
  }

  Color get _blipColor {
    switch (widget.data.severity) {
      case AnomalySeverity.critical:
        return PriorityColors.criticalBorder;
      case AnomalySeverity.high:
        return PriorityColors.highBorder;
      case AnomalySeverity.stable:
        return PriorityColors.stableBorder;
    }
  }

  double get _blipSize {
    switch (widget.data.severity) {
      case AnomalySeverity.critical:
        return 16;
      case AnomalySeverity.high:
        return 12;
      case AnomalySeverity.stable:
        return 10;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calculate position on radar
    final distance = widget.data.distance * widget.radarRadius;
    final dx = distance * math.cos(widget.data.angle);
    final dy = distance * math.sin(widget.data.angle);

    Widget blip = GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        widget.onTap?.call();
      },
      child: Container(
        width: _blipSize,
        height: _blipSize,
        decoration: BoxDecoration(
          color: _blipColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: _blipColor.withValues(alpha: 0.6),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
      ),
    );

    // Apply pulsing animation for critical anomalies or when highlighted
    if (widget.data.severity == AnomalySeverity.critical ||
        widget.isHighlighted) {
      blip = Stack(
        alignment: Alignment.center,
        children: [
          // Outer pulse ring
          Container(
            width: _blipSize * 2.5,
            height: _blipSize * 2.5,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: _blipColor.withValues(alpha: 0.3),
              ),
            ),
          )
              .animate(onPlay: (c) => c.repeat())
              .scale(
                begin: const Offset(0.6, 0.6),
                end: const Offset(1.2, 1.2),
                duration: const Duration(milliseconds: 1200),
              )
              .fadeOut(duration: const Duration(milliseconds: 1200)),
          blip,
        ],
      );
    }

    // Entry animation when first detected
    if (_wasJustDetected) {
      blip = blip
          .animate()
          .scale(
            begin: Offset.zero,
            end: const Offset(1, 1),
            duration: const Duration(milliseconds: 300),
            curve: Curves.elasticOut,
          )
          .fadeIn(duration: const Duration(milliseconds: 200));
    }

    return Transform.translate(
      offset: Offset(dx, dy),
      child: blip,
    );
  }
}
