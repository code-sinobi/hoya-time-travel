import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/era_theme.dart';
import '../../core/widgets/galactic_background.dart';
import '../story/repositories/story_repository.dart';
import 'services/auth_service.dart';
import 'services/profile_service.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);
    final progressAsync = ref.watch(allUserProgressProvider);

    return Scaffold(
      backgroundColor: MythicColors.voidBackground,
      body: Stack(
        children: [
          const GalacticBackground(showStars: true),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    'TRAVELER IDENTIFICATION',
                    style: GoogleFonts.cinzelDecorative(
                      fontSize: 18,
                      color: MythicColors.bronze,
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // ID Card (Parchment/Leather style)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E2C).withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: MythicColors.bronze.withValues(alpha: 0.6),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.5),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Avatar Medallion
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: MythicColors.deepIndigo,
                            border: Border.all(
                              color: MythicColors.bronze,
                              width: 3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: MythicColors.bronze.withValues(
                                  alpha: 0.3,
                                ),
                                blurRadius: 20,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              profileAsync.value?.username
                                      ?.substring(0, 1)
                                      .toUpperCase() ??
                                  'T',
                              style: GoogleFonts.cinzelDecorative(
                                fontSize: 48,
                                color: MythicColors.parchment,
                              ),
                            ),
                          ),
                        )
                            .animate(onPlay: (c) => c.repeat(reverse: true))
                            .shimmer(
                              duration: 4.seconds,
                              color: Colors.white24,
                            ),

                        const SizedBox(height: 20),

                        profileAsync.when(
                          data: (profile) => Column(
                            children: [
                              Text(
                                profile?.username?.toUpperCase() ??
                                    'UNKNOWN TRAVELER',
                                style: GoogleFonts.cinzel(
                                  fontSize: 18,
                                  color: MythicColors.parchment,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black38,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: MythicColors.stoneGray,
                                  ),
                                ),
                                child: Text(
                                  "ID: ${profile?.id.substring(0, 8).toUpperCase() ?? '8X-92-B'}",
                                  style: GoogleFonts.spaceMono(
                                    color: MythicColors.bronze,
                                    fontSize: 10,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          loading: () => const CircularProgressIndicator(
                            color: MythicColors.bronze,
                          ),
                          error: (_, __) => const Text(
                            'ID ERROR',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Coin Stats
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _StatCoin(
                              label: 'LEVEL',
                              value: '${profileAsync.value?.level ?? 1}',
                              icon: Icons.star_border,
                            ),
                            _StatCoin(
                              label: 'XP',
                              value: '${profileAsync.value?.xp ?? 0}',
                              icon: Icons.auto_awesome,
                            ),
                            _StatCoin(
                              label: 'WISDOM',
                              value: '${progressAsync.value?.length ?? 0}',
                              icon: Icons.menu_book,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Achievements Section
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'HONORS & RELICS',
                      style: GoogleFonts.cinzel(
                        fontSize: 14,
                        color: MythicColors.bronze,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF15151A),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: MythicColors.stoneGray.withValues(alpha: 0.3),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _AchievementBadge(
                          icon: Icons.local_fire_department,
                          label: 'Prometheus',
                        ),
                        _AchievementBadge(
                          icon: Icons.shield,
                          label: 'Guardian',
                        ),
                        _AchievementBadge(icon: Icons.explore, label: 'Nomad'),
                        _AchievementBadge(
                          icon: Icons.lock_open,
                          label: 'Keymaster',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Menu Options
                  _MenuButton(
                    icon: Icons.settings_outlined,
                    label: 'TEMPORAL RITUALS',
                    onTap: () {},
                  ),
                  _MenuButton(
                    icon: Icons.cloud_sync_outlined,
                    label: 'ARCHIVE SYNC',
                    onTap: () {},
                  ),

                  const SizedBox(height: 48),

                  // Sever Link Button (Wax Seal style)
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (c) => AlertDialog(
                          backgroundColor: const Color(0xFF1A1A24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: const BorderSide(
                              color: MythicColors.ochreRed,
                            ),
                          ),
                          title: Text(
                            'SEVER LINK?',
                            style: GoogleFonts.cinzelDecorative(
                              color: MythicColors.ochreRed,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          content: Text(
                            'Disconnecting will cease all temporal operations. Unsaved paradoxes may collapse.\n\nAre you sure?',
                            style: GoogleFonts.cormorantGaramond(
                              color: MythicColors.parchment,
                              fontSize: 18,
                            ),
                          ),
                          actions: [
                            TextButton(
                              child: const Text(
                                'CANCEL',
                                style: TextStyle(color: MythicColors.parchment),
                              ),
                              onPressed: () => Navigator.pop(c),
                            ),
                            TextButton(
                              child: const Text(
                                'SEVER',
                                style: TextStyle(
                                  color: MythicColors.ochreRed,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(c);
                                ref.read(authServiceProvider).signOut();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: MythicColors.ochreRed.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: MythicColors.ochreRed.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.link_off,
                            color: MythicColors.ochreRed,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'SEVER TEMPORAL LINK',
                            style: GoogleFonts.cinzel(
                              color: MythicColors.ochreRed,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCoin extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatCoin({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF1E1E2C),
            border: Border.all(
              color: MythicColors.bronze.withValues(alpha: 0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: MythicColors.bronze.withValues(alpha: 0.2),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
            gradient: const RadialGradient(
              colors: [Color(0xFF2C241B), Colors.black],
              center: Alignment.topLeft,
              radius: 1.2,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Progress Ring
              const SizedBox(
                width: 70,
                height: 70,
                child: CircularProgressIndicator(
                  value: 0.7, // Mock value or pass in
                  strokeWidth: 2,
                  color: MythicColors.bronze,
                  backgroundColor: Colors.transparent,
                ),
              ),
              Icon(icon, size: 40, color: Colors.white.withValues(alpha: 0.05)),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    value,
                    style: GoogleFonts.cinzelDecorative(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: MythicColors.bronze,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          style: GoogleFonts.cinzel(
            fontSize: 10,
            color: MythicColors.parchment.withValues(alpha: 0.7),
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }
}

class _AchievementBadge extends StatelessWidget {
  final IconData icon;
  final String label;

  const _AchievementBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: MythicColors.bronze.withValues(alpha: 0.5), size: 30),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.cormorantGaramond(
            fontSize: 10,
            color: MythicColors.stoneGray,
          ),
        ),
      ],
    );
  }
}

class _MenuButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MenuButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: MythicColors.bronze.withValues(alpha: 0.2)),
        ),
      ),
      child: ListTile(
        leading: Icon(icon, color: MythicColors.bronze),
        title: Text(
          label,
          style: GoogleFonts.cinzel(color: MythicColors.parchment),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: MythicColors.stoneGray,
        ),
        onTap: onTap,
      ),
    );
  }
}
