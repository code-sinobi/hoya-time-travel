import 'package:chrono_app/core/widgets/mythic_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_typography.dart';
import '../../../core/theme/mythic_colors.dart';
import '../../achievements/models/achievement.dart';
import '../../achievements/providers/achievement_provider.dart';

class AchievementsSection extends ConsumerWidget {
  const AchievementsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: MythicColors.surface1,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: MythicColors.stoneGray.withValues(alpha: 0.3),
        ),
      ),
      child: ref.watch(achievementNotifierProvider).when(
            data: (achievements) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: achievements.cast<Achievement>().map((a) {
                  return AchievementBadge(achievement: a);
                }).toList(),
              );
            },
            loading: () => const Center(
              child: MythicLoading(),
            ),
            error: (err, _) => const Center(
              child: Text(
                'Failed to load honors',
                style: TextStyle(color: MythicColors.stoneGray),
              ),
            ),
          ),
    );
  }
}

class AchievementBadge extends StatelessWidget {
  const AchievementBadge({required this.achievement, super.key});

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
        ).animate(target: achievement.isUnlocked ? 1 : 0).shimmer(
              duration: 2000.ms,
              color: MythicColors.white.withValues(alpha: 0.24),
            ),
        Text(
          achievement.title,
          style: AppTypography.storyCaption.copyWith(
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
