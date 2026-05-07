import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/era_theme.dart';
import '../../core/widgets/galactic_background.dart';
import '../achievements/models/achievement.dart';
import '../achievements/providers/achievement_provider.dart';
import '../community/presentation/snippet_compose_sheet.dart';
import '../living_story/presentation/echo_mentor_sheet.dart';
import '../living_story/presentation/echoes_sheet.dart';
import '../living_story/presentation/user_traits_controller.dart';
import '../living_story/presentation/widgets/journey_map_chart.dart';
import '../living_story/presentation/widgets/wisdom_compass_chart.dart';
import 'services/auth_service.dart';
import 'services/profile_service.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: MythicColors.voidBackground,
      body: Stack(
        children: [
          const GalacticBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
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

                        const SizedBox(height: 24),

                        // Subscription Badge
                        profileAsync.when(
                          data: (profile) {
                            final isPatron =
                                profile?.subscriptionTier == 'patron' ||
                                    profile?.subscriptionTier == 'oracle';
                            return Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isPatron
                                        ? MythicColors.bronze
                                            .withValues(alpha: 0.2)
                                        : Colors.transparent,
                                    border: Border.all(
                                      color: isPatron
                                          ? MythicColors.bronze
                                          : Colors.white24,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    'TIER: ${(profile?.subscriptionTier ?? "FREE").toUpperCase()}',
                                    style: GoogleFonts.cinzel(
                                      color: isPatron
                                          ? MythicColors.bronze
                                          : Colors.white54,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                                if (!isPatron) ...[
                                  const SizedBox(height: 12),
                                  OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                        color: MythicColors.bronze,
                                      ),
                                      foregroundColor: MythicColors.bronze,
                                    ),
                                    onPressed: () {
                                      ref
                                          .read(userProfileProvider.notifier)
                                          .upgradeSubscription();
                                    },
                                    child: const Text('UPGRADE TO PATRON'),
                                  ),
                                ],
                              ],
                            );
                          },
                          loading: () => const SizedBox.shrink(),
                          error: (_, __) => const SizedBox.shrink(),
                        ),

                        const SizedBox(height: 20),

                        profileAsync.when(
                          data: (profile) {
                            if (profile?.role == 'chronicler' ||
                                profile?.role == 'admin') {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 20),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: MythicColors.deepIndigo
                                      .withValues(alpha: 0.5),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: MythicColors.deepIndigo,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.edit_note,
                                      color: Colors.cyanAccent,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'MASTER CHRONICLER',
                                      style: GoogleFonts.cinzel(
                                        color: Colors.cyanAccent,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 24.0),
                              child: TextButton.icon(
                                icon: const Icon(
                                  Icons.history_edu,
                                  color: MythicColors.bronze,
                                ),
                                label: Text(
                                  'BECOME A CHRONICLER',
                                  style: GoogleFonts.cinzel(
                                    color: MythicColors.bronze,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onPressed: () {
                                  context.push('/chronicler/onboarding');
                                },
                              ),
                            );
                          },
                          loading: () => const SizedBox.shrink(),
                          error: (_, __) => const SizedBox.shrink(),
                        ),

                        // Wisdom Compass Section
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'WISDOM COMPASS',
                            style: GoogleFonts.cinzel(
                              fontSize: 14,
                              color: MythicColors.bronze,
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ref.watch(userTraitsControllerProvider).when(
                              data: (traits) => SizedBox(
                                height: 220,
                                child: WisdomCompassChart(
                                  traits: traits.toCompassMap(),
                                ),
                              ),
                              loading: () => const SizedBox(
                                height: 220,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: MythicColors.bronze,
                                  ),
                                ),
                              ),
                              error: (_, __) => const SizedBox(
                                height: 220,
                              ), // Fail gracefully
                            ),
                      ],
                    ),
                  ),

                  // Journey Map Section
                  const SizedBox(height: 32),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'JOURNEY CHRONICLE',
                      style: GoogleFonts.cinzel(
                        fontSize: 14,
                        color: MythicColors.bronze,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ref.watch(userTraitsControllerProvider).when(
                        data: (traits) => JourneyMapChart(
                          history: traits.traitHistory,
                          height: 180,
                        ),
                        loading: () => const SizedBox(height: 180),
                        error: (_, __) => const SizedBox(
                          height: 180,
                          child: Center(
                            child: Text(
                              'Unable to load chronicle',
                              style: TextStyle(
                                color: MythicColors.stoneGray,
                              ),
                            ),
                          ),
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
                    child: ref.watch(achievementNotifierProvider).when(
                          data: (achievements) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children:
                                  achievements.cast<Achievement>().map((a) {
                                return _AchievementBadge(
                                  achievement: a,
                                );
                              }).toList(),
                            );
                          },
                          loading: () => const Center(
                            child: CircularProgressIndicator(
                              color: MythicColors.bronze,
                            ),
                          ),
                          error: (err, _) => const Center(
                            child: Text(
                              'Failed to load honors',
                              style: TextStyle(color: MythicColors.stoneGray),
                            ),
                          ),
                        ),
                  ),

                  const SizedBox(height: 32),

                  // Menu Options
                  _MenuButton(
                    icon: Icons.spatial_audio_off,
                    label: 'SPEAK TO THE ECHO',
                    onTap: () {
                      showModalBottomSheet<void>(
                        context: context,
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                        builder: (context) => DraggableScrollableSheet(
                          initialChildSize: 0.6,
                          minChildSize: 0.4,
                          maxChildSize: 0.9,
                          builder: (_, controller) => const EchoMentorSheet(),
                        ),
                      );
                    },
                  ),
                  _MenuButton(
                    icon: Icons.auto_stories,
                    label: 'MEMORY ARCHIVE',
                    onTap: () {
                      showModalBottomSheet<void>(
                        context: context,
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                        builder: (context) => DraggableScrollableSheet(
                          initialChildSize: 0.6,
                          minChildSize: 0.4,
                          maxChildSize: 0.9,
                          builder: (_, controller) => const EchoesSheet(),
                        ),
                      );
                    },
                  ),
                  _MenuButton(
                    icon: Icons.edit_note,
                    label: 'ETCH A SNIPPET',
                    onTap: () {
                      showModalBottomSheet<void>(
                        context: context,
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                        builder: (context) => Padding(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),
                          child: const SnippetComposeSheet(),
                        ),
                      );
                    },
                  ),
                  _MenuButton(
                    icon: Icons.cloud_sync_outlined,
                    label: 'ARCHIVE SYNC',
                    onTap: () {},
                  ),
                  _MenuButton(
                    icon: Icons.auto_awesome,
                    label: 'NARRATIVE ORCHESTRATOR',
                    onTap: () {
                      GoRouter.of(context).push('/admin');
                    },
                  ),

                  const SizedBox(height: 48),

                  // Sever Link Button (Wax Seal style)
                  GestureDetector(
                    onTap: () {
                      showDialog<void>(
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
                              onPressed: () async {
                                Navigator.pop(c);
                                await ref.read(authServiceProvider).signOut();

                                // Explicit cache invalidation to prevent data leaks
                                ref.invalidate(userProfileProvider);
                                ref.invalidate(userTraitsControllerProvider);
                                // Also invalidate rifts/anomalies if imported,
                                // but we might not have it imported here.
                                // Instead of importing anomalies_provider here,
                                // Riverpod's autoDispose handles most, but we force Profile/Traits.
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

class _AchievementBadge extends StatelessWidget {
  const _AchievementBadge({required this.achievement});
  final Achievement achievement;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          achievement.iconData,
          color: achievement.isUnlocked
              ? MythicColors.bronze
              : MythicColors.bronze.withValues(alpha: 0.2),
          size: 30,
        )
            .animate(target: achievement.isUnlocked ? 1 : 0)
            .shimmer(duration: 2000.ms, color: Colors.white24),
        Text(
          achievement.title,
          style: GoogleFonts.cormorantGaramond(
            fontSize: 10,
            color: achievement.isUnlocked
                ? MythicColors.parchment
                : MythicColors.stoneGray.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }
}

class _MenuButton extends StatelessWidget {
  const _MenuButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;

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
