import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/era_theme.dart';
import '../../../core/theme/priority_colors.dart';
import '../rifts_screen.dart'; // For AnomalySeverity enum

class GlitchAnomalyCard extends StatelessWidget {
  final String title;
  final String location;
  final AnomalySeverity severity;
  final String timeRemaining;
  final bool isGlitching;

  const GlitchAnomalyCard({
    super.key,
    required this.title,
    required this.location,
    required this.severity,
    required this.timeRemaining,
    required this.isGlitching,
  });

  LinearGradient _getGradient(AnomalySeverity severity, Color color) {
    final double opacity = severity == AnomalySeverity.critical
        ? 0.1
        : (severity == AnomalySeverity.high ? 0.05 : 0.0);
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        color.withValues(alpha: opacity),
        Colors.transparent,
      ],
    );
  }

  BoxDecoration _getBorderDecoration(
    AnomalySeverity severity,
    Color baseColor,
    Color borderColor,
  ) {
    late final BoxDecoration decoration;

    switch (severity) {
      case AnomalySeverity.critical:
        decoration = BoxDecoration(
          color: baseColor.withValues(alpha: 0.9),
          border: Border.all(color: borderColor, width: 4),
          borderRadius: BorderRadius.circular(4),
        );
        break;
      case AnomalySeverity.high:
        decoration = BoxDecoration(
          color: baseColor.withValues(alpha: 0.9),
          // Use uniform border here to avoid "A borderRadius can only be given on borders with uniform colors" error.
          // The thick left accent is handled by the Stack in build().
          border: Border.all(
            color: borderColor.withValues(alpha: 0.3),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(4),
        );
        break;
      case AnomalySeverity.stable:
        decoration = BoxDecoration(
          color: baseColor.withValues(alpha: 0.9),
          border: Border.all(
            color: borderColor.withValues(alpha: 0.6),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(4),
        );
        break;
    }

    return decoration.copyWith(
      boxShadow: [
        BoxShadow(
          color: borderColor.withValues(alpha: 0.2),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color baseColor;
    final Color borderColor;
    final Color textColor;
    final IconData statusIcon;
    final int badgeIconSize;
    final double badgeFontSize;

    switch (severity) {
      case AnomalySeverity.critical:
        baseColor = PriorityColors.criticalBackground;
        borderColor = PriorityColors.criticalBorder;
        textColor = PriorityColors.criticalText;
        statusIcon = Icons.warning_amber;
        badgeIconSize = 16; // Larger for critical
        badgeFontSize = 11;
        break;
      case AnomalySeverity.high:
        baseColor = PriorityColors.highBackground;
        borderColor = PriorityColors.highBorder;
        textColor = PriorityColors.highText;
        statusIcon = Icons.priority_high;
        badgeIconSize = 14;
        badgeFontSize = 10;
        break;
      case AnomalySeverity.stable:
        baseColor = PriorityColors.stableBackground;
        borderColor = PriorityColors.stableBorder;
        textColor = PriorityColors.stableText;
        statusIcon = Icons.check_circle_outline;
        badgeIconSize = 12;
        badgeFontSize = 10;
        break;
    }

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: _getGradient(severity, borderColor),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Container(
            padding: const EdgeInsets.all(16), // Reduced from 20
            decoration: _getBorderDecoration(severity, baseColor, borderColor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header Row - Priority Badge + Status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: borderColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: borderColor.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            statusIcon,
                            size: badgeIconSize.toDouble(),
                            color: textColor,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            severity.name.toUpperCase(),
                            style: GoogleFonts.orbitron(
                              color: textColor,
                              fontWeight: FontWeight.bold,
                              fontSize: badgeFontSize,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isGlitching)
                      Text(
                        'ERROR: TIMELINE DESYNC',
                        style: GoogleFonts.shareTechMono(
                          color: textColor,
                          fontSize: severity == AnomalySeverity.critical
                              ? 11
                              : 10,
                          fontWeight: severity == AnomalySeverity.critical
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 12), // Reduced from 16
                // Title
                Text(
                  title.toUpperCase(),
                  style: GoogleFonts.orbitron(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),

                const SizedBox(height: 2), // Reduced from 4
                // Location
                Text(
                  location.toUpperCase(),
                  style: GoogleFonts.exo2(
                    fontSize: 12,
                    color: MythicColors.stoneGray,
                    letterSpacing: 1,
                  ),
                ),

                const SizedBox(height: 16), // Reduced from 20
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: textColor,
                          side: BorderSide(
                            color: borderColor.withValues(alpha: 0.5),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ), // Reduced from 16
                        ),
                        onPressed: () {
                          HapticFeedback.heavyImpact();
                        },
                        child: Text(
                          'PURGE',
                          style: GoogleFonts.orbitron(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: borderColor.withValues(alpha: 0.2),
                          foregroundColor: textColor,
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ), // Reduced from 16
                        ),
                        onPressed: () {
                          HapticFeedback.lightImpact();
                        },
                        child: Text(
                          'STABILIZE',
                          style: GoogleFonts.orbitron(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        // Add left accent strip for High priority
        if (severity == AnomalySeverity.high)
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: 4,
            child: Container(
              decoration: BoxDecoration(
                color: borderColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  bottomLeft: Radius.circular(4),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
