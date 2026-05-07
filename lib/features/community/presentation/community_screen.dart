import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/era_theme.dart';
import '../../../core/widgets/galactic_background.dart';

class CommunityScreen extends ConsumerWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: MythicColors.voidBackground,
      body: Stack(
        children: [
          const GalacticBackground(),
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.auto_awesome,
                    size: 64,
                    color: MythicColors.fluxCyan.withValues(alpha: 0.8),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'THE LORE ARCHIVE',
                    style: GoogleFonts.cinzelDecorative(
                      fontSize: 24,
                      color: MythicColors.parchment,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'A convergence of timelines.\nComing soon.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 18,
                      color: MythicColors.stoneGray,
                      height: 1.5,
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
