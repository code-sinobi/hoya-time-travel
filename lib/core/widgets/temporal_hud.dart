import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../theme/galactic_colors.dart';

class TemporalHUD extends StatelessWidget {
  final int level;
  final int xp;
  final int temporalEnergy;

  const TemporalHUD({
    super.key,
    required this.level,
    required this.xp,
    required this.temporalEnergy,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Level & XP
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: GalacticColors.deepNebula.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: GalacticColors.temporalGold,
                  width: 2,
                ),
                boxShadow: GalacticColors.glowGold,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.auto_awesome,
                    color: GalacticColors.temporalGold,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'LEVEL $level',
                        style: GoogleFonts.orbitron(
                          fontSize: 12,
                          color: GalacticColors.temporalGold,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '$xp XP',
                        style: GoogleFonts.exo2(
                          fontSize: 10,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Temporal Energy
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: GalacticColors.deepNebula.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: GalacticColors.neonCyan, width: 2),
                boxShadow: GalacticColors.glowCyan,
              ),
              child: Row(
                children: [
                  Icon(Icons.bolt, color: GalacticColors.neonCyan, size: 20),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TEMPORAL ENERGY',
                        style: GoogleFonts.orbitron(
                          fontSize: 10,
                          color: GalacticColors.neonCyan,
                        ),
                      ),
                      Text(
                        '$temporalEnergy TE',
                        style: GoogleFonts.audiowide(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Avatar/Profile
            GestureDetector(
              onTap: () => context.push(
                '/profile',
              ), // Use push to not lose navigation stack context if simple
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      GalacticColors.quantumPurple,
                      GalacticColors.wormholeBlue,
                    ],
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(color: GalacticColors.neonCyan, width: 2),
                  boxShadow: GalacticColors.glowCyan,
                ),
                child: Icon(Icons.person, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
