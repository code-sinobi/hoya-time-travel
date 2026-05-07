import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/era_theme.dart';
import '../../../core/theme/priority_colors.dart';
import '../../rifts/domain/anomaly.dart';
import '../domain/era.dart';
import 'anomaly_blip.dart';
import 'era_wheel.dart';
import 'fog_overlay.dart';
import 'radar_sweep_painter.dart';

/// The main Temporal Radar Navigator widget.
/// A circular radar that sweeps through time eras, detecting anomalies.
class TemporalRadar extends StatefulWidget {
  const TemporalRadar({
    super.key,
    this.anomalies = const [],
    this.currentEra,
    this.exploredEras = const {},
    this.onEraSelected,
    this.onAnomalyTapped,
    this.onScanComplete,
  });

  /// List of detected anomalies to display as blips
  final List<AnomalyBlipData> anomalies;

  /// Currently selected era
  final Era? currentEra;

  /// Eras the user has explored
  final Set<Era> exploredEras;

  /// Callback when an era is selected
  final ValueChanged<Era>? onEraSelected;

  /// Callback when an anomaly blip is tapped
  final ValueChanged<AnomalyBlipData>? onAnomalyTapped;

  /// Callback when scan completes a full rotation
  final VoidCallback? onScanComplete;

  @override
  State<TemporalRadar> createState() => _TemporalRadarState();
}

class _TemporalRadarState extends State<TemporalRadar>
    with SingleTickerProviderStateMixin {
  late AnimationController _sweepController;

  // Track which anomalies have been "detected" by the sweep
  final Set<String> _detectedAnomalies = {};

  // Tactile Tuner State
  double _rotationOffset = 0.0;
  bool _isDivining = false;

  static const _sweepDuration = Duration(seconds: 4);
  static const _radarRadius = 130.0;

  @override
  void initState() {
    super.initState();
    _sweepController = AnimationController(
      vsync: this,
      duration: _sweepDuration,
    )
      ..addListener(_onSweepTick)
      ..addStatusListener(_onSweepStatus);

    _sweepController.repeat();
  }

  @override
  void dispose() {
    _sweepController.removeListener(_onSweepTick);
    _sweepController.dispose();
    super.dispose();
  }

  void _onSweepStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      widget.onScanComplete?.call();
      _sweepController.repeat();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // The radar visualization
        _buildRadar(),

        const SizedBox(height: 24),

        // Status bar
        _buildStatusBar(),
      ],
    );
  }

  Widget _buildRadar() {
    return GestureDetector(
      onPanUpdate: (details) {
        // Tactile tuning: Rotate the era wheel manually
        setState(() {
          _rotationOffset += details.delta.dx * 0.01;
        });
        // Haptic feedback on rotation "clicks" (simulated by int check)
        if ((_rotationOffset * 10).toInt() !=
            ((_rotationOffset - details.delta.dx * 0.01) * 10).toInt()) {
          HapticFeedback.selectionClick();
        }
      },
      child: SizedBox(
        width: _radarRadius * 2 + 100,
        height: _radarRadius * 2 + 100,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Era wheel (labels around the radar) - Rotatable
            Transform.rotate(
              angle: _rotationOffset,
              child: EraWheel(
                selectedEra: widget.currentEra,
                exploredEras: widget.exploredEras,
                onEraTapped: widget.onEraSelected,
                radius: _radarRadius,
              ),
            ),

            // Fog overlay for unexplored areas
            FogOverlay(
              exploredEras: widget.exploredEras,
              radius: _radarRadius,
            ),

            // Radar sweep animation - Only active when divining or idling
            AnimatedBuilder(
              animation: _sweepController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _rotationOffset,
                  child: CustomPaint(
                    size: const Size(_radarRadius * 2, _radarRadius * 2),
                    painter: RadarSweepPainter(
                      sweepAngle:
                          _sweepController.value * 2 * math.pi - (math.pi / 2),
                      sweepColor: _isDivining
                          ? const Color(0xFF00FFFF)
                          : const Color(0xFF00FFFF).withValues(alpha: 0.2),
                    ),
                  ),
                );
              },
            ),

            // Anomaly blips - Rotated to match wheel
            Transform.rotate(
              angle: _rotationOffset,
              child: Stack(
                children: widget.anomalies.map(_buildBlip).toList(),
              ),
            ),

            // Center "SCAN" button
            _buildCenterButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildBlip(AnomalyBlipData anomaly) {
    final isDetected = _detectedAnomalies.contains(anomaly.id);

    if (!isDetected) {
      return const SizedBox.shrink();
    }

    return AnomalyBlip(
      data: anomaly,
      radarRadius: _radarRadius,
      isHighlighted: widget.currentEra == anomaly.era,
      onTap: () => widget.onAnomalyTapped?.call(anomaly),
    );
  }

  void _onSweepTick() {
    final sweepAngle = _sweepController.value * 2 * math.pi;
    _checkAnomalyDetection(sweepAngle);
  }

  void _checkAnomalyDetection(double sweepAngle) {
    for (final anomaly in widget.anomalies) {
      // Check if sweep has passed this anomaly's angle
      final normalizedSweep = (sweepAngle - (math.pi / 2)) % (2 * math.pi);
      final normalizedAnomaly = (anomaly.angle + math.pi) % (2 * math.pi);

      // If sweep is within 0.2 radians of anomaly, detect it
      if ((normalizedSweep - normalizedAnomaly).abs() < 0.2 ||
          (normalizedSweep - normalizedAnomaly).abs() > (2 * math.pi - 0.2)) {
        if (!_detectedAnomalies.contains(anomaly.id)) {
          setState(() {
            _detectedAnomalies.add(anomaly.id);
          });
          HapticFeedback.lightImpact();
        }
      }
    }
  }

  Widget _buildCenterButton() {
    return GestureDetector(
      onLongPressStart: (_) {
        HapticFeedback.heavyImpact();
        setState(() {
          _isDivining = true;
          _sweepController.duration = const Duration(seconds: 1); // Fast scan
          _sweepController.repeat();
        });
      },
      onLongPressEnd: (_) {
        HapticFeedback.mediumImpact();
        setState(() {
          _isDivining = false;
          _sweepController.duration = _sweepDuration; // Normal sweep
          _sweepController.repeat();
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: _isDivining ? 70 : 60,
        height: _isDivining ? 70 : 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _isDivining
              ? const Color(0xFF00FFFF).withValues(alpha: 0.2)
              : const Color(0xFF0A0A0F),
          border: Border.all(
            color: _isDivining
                ? Colors.white
                : const Color(0xFF00FFFF).withValues(alpha: 0.5),
            width: _isDivining ? 3 : 2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00FFFF)
                  .withValues(alpha: _isDivining ? 0.6 : 0.2),
              blurRadius: _isDivining ? 25 : 15,
              spreadRadius: _isDivining ? 5 : 2,
            ),
          ],
        ),
        child: Center(
          child: Text(
            _isDivining ? 'DIVINING' : 'HOLD',
            style: GoogleFonts.orbitron(
              fontSize: _isDivining ? 8 : 10,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF00FFFF),
              letterSpacing: 2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBar() {
    final criticalCount = widget.anomalies
        .where((a) => a.severity == AnomalySeverity.critical)
        .length;
    final totalCount = widget.anomalies.length;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF00FFFF).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.radar,
            size: 16,
            color: const Color(0xFF00FFFF).withValues(alpha: 0.8),
          ),
          const SizedBox(width: 8),
          Text(
            '$totalCount anomal${totalCount == 1 ? 'y' : 'ies'} detected',
            style: GoogleFonts.shareTechMono(
              fontSize: 12,
              color: Colors.white70,
            ),
          ),
          if (criticalCount > 0) ...[
            const SizedBox(width: 12),
            Container(
              width: 1,
              height: 14,
              color: MythicColors.stoneGray.withValues(alpha: 0.3),
            ),
            const SizedBox(width: 12),
            const Icon(
              Icons.warning_amber,
              size: 14,
              color: PriorityColors.criticalText,
            ),
            const SizedBox(width: 4),
            Text(
              '$criticalCount critical',
              style: GoogleFonts.shareTechMono(
                fontSize: 12,
                color: PriorityColors.criticalText,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
