import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/era_theme.dart';
import '../../core/widgets/galactic_background.dart';
import 'widgets/glitch_anomaly_card.dart';

class RiftsScreen extends ConsumerWidget {
  const RiftsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: MythicColors.voidBackground,
      body: Stack(
        children: [
          const GalacticBackground(
            showStars: true,
          ), // Keep stars for void effect

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                16,
                16,
                0,
              ), // Reduced padding, no bottom
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Compact Anomalies Header
                  Row(
                    children: [
                      const Icon(
                        Icons.broken_image_outlined,
                        color: MythicColors.ochreRed,
                        size: 24, // Reduced from 32
                      ),
                      const SizedBox(width: 8), // Reduced from 12
                      Expanded(
                        child: Text(
                          'ANOMALIES: LEGENDS FADING',
                          style: GoogleFonts.orbitron(
                            fontSize: 20, // Reduced from 24
                            color: MythicColors.ochreRed,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              const BoxShadow(
                                color: Colors.black,
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20), // Reduced from 32
                  // Anomaly List with proper spacing
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.only(
                        top: 4,
                        bottom: 16, // Proper SafeArea for navbar
                      ),
                      children: const [
                        GlitchAnomalyCard(
                          title: 'The Fire Thief',
                          location: 'Mythic Age • Caucasus',
                          severity: AnomalySeverity.critical,
                          timeRemaining: 'FADING FAST',
                          isGlitching: true,
                        ),
                        SizedBox(height: 16), // Reduced from 20
                        GlitchAnomalyCard(
                          title: "Arthur's Return",
                          location: 'Medieval • Avalon',
                          severity: AnomalySeverity.high,
                          timeRemaining: 'UNSTABLE',
                          isGlitching: false,
                        ),
                        SizedBox(height: 16), // Reduced from 20
                        GlitchAnomalyCard(
                          title: 'Library of Alexandria',
                          location: 'Ancient • Egypt',
                          severity: AnomalySeverity.stable,
                          timeRemaining: 'WATCHING',
                          isGlitching: false,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum AnomalySeverity { critical, high, stable }
