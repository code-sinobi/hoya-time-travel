import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/galactic_colors.dart';

class TemporalHUD extends StatelessWidget {
  const TemporalHUD({
    required this.level,
    required this.xp,
    required this.temporalEnergy,
    super.key,
  });
  final int level;
  final int xp;
  final int temporalEnergy;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Level & XP
            Flexible(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: GalacticColors.deepNebula.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: GalacticColors.temporalGold,
                    width: 2,
                  ),
                  boxShadow: GalacticColors.glowGold,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.auto_awesome,
                      color: GalacticColors.temporalGold,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'LEVEL $level',
                              style: GoogleFonts.orbitron(
                                fontSize: 12,
                                color: GalacticColors.temporalGold,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            '$xp XP',
                            style: GoogleFonts.exo2(
                              fontSize: 10,
                              color: Colors.white.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Temporal Energy
            Flexible(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: GalacticColors.deepNebula.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: GalacticColors.etherealCyan,
                    width: 2,
                  ),
                  boxShadow: GalacticColors.glowCyan,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.bolt,
                      color: GalacticColors.etherealCyan,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'TEMPORAL ENERGY',
                              style: GoogleFonts.orbitron(
                                fontSize: 10,
                                color: GalacticColors.etherealCyan,
                              ),
                            ),
                          ),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              '$temporalEnergy TE',
                              style: GoogleFonts.audiowide(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Avatar/Profile
            GestureDetector(
              onTap: () => context.push(
                '/profile',
              ), // Use push to not lose navigation stack context if simple
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      GalacticColors.quantumPurple,
                      GalacticColors.wormholeBlue,
                    ],
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: GalacticColors.etherealCyan,
                    width: 2,
                  ),
                  boxShadow: GalacticColors.glowCyan,
                ),
                child: const Icon(Icons.person, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
