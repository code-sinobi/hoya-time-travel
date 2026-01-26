import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/era_theme.dart';
import '../../core/theme/app_theme.dart';
import '../story/data/story_library.dart';
import '../story/repositories/story_repository.dart';

/// Rifts screen showing daily/weekly time-limited challenges
class RiftsScreen extends ConsumerStatefulWidget {
  const RiftsScreen({super.key});

  @override
  ConsumerState<RiftsScreen> createState() => _RiftsScreenState();
}

class _RiftsScreenState extends ConsumerState<RiftsScreen> {
  Timer? _timer;
  Duration _dailyTimeRemaining = Duration.zero;
  Duration _weeklyTimeRemaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _calculateTimeRemaining();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _calculateTimeRemaining();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _calculateTimeRemaining() {
    final now = DateTime.now();

    // Daily reset at midnight
    final nextMidnight = DateTime(now.year, now.month, now.day + 1);
    _dailyTimeRemaining = nextMidnight.difference(now);

    // Weekly reset on Sunday midnight
    final daysUntilSunday = (DateTime.sunday - now.weekday) % 7;
    final nextSunday = DateTime(
      now.year,
      now.month,
      now.day + (daysUntilSunday == 0 ? 7 : daysUntilSunday),
    );
    _weeklyTimeRemaining = nextSunday.difference(now);

    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme =
        Theme.of(context).extension<EraTheme>() ??
        ref.watch(appThemeProvider).extension<EraTheme>()!;
    final completedStories = ref.watch(completedStoryIdsProvider);
    final textColor = theme.bodyStyle.color ?? Colors.white;

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Time Rifts',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                theme.primaryColor,
                                theme.secondaryColor,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'LIMITED',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ],
                    ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.1),
                    const SizedBox(height: 4),
                    Text(
                      'Complete challenges before time runs out',
                      style: TextStyle(
                        fontSize: 14,
                        color: textColor.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Daily Challenge Card
              Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: completedStories.when(
                      data: (completed) => _RiftChallengeCard(
                        title: 'Daily Rift',
                        subtitle: 'Complete any story today',
                        timeRemaining: _dailyTimeRemaining,
                        progress: completed.isNotEmpty ? 1.0 : 0.0,
                        target: 1,
                        current: completed.isNotEmpty ? 1 : 0,
                        reward: '50 XP',
                        gradient: [
                          const Color(0xFFFF6B6B),
                          const Color(0xFFEE5A24),
                        ],
                        icon: Icons.wb_sunny,
                        theme: theme,
                      ),
                      loading: () => _RiftChallengeCard(
                        title: 'Daily Rift',
                        subtitle: 'Complete any story today',
                        timeRemaining: _dailyTimeRemaining,
                        progress: 0,
                        target: 1,
                        current: 0,
                        reward: '50 XP',
                        gradient: [
                          const Color(0xFFFF6B6B),
                          const Color(0xFFEE5A24),
                        ],
                        icon: Icons.wb_sunny,
                        theme: theme,
                      ),
                      error: (_, _) => const SizedBox(),
                    ),
                  )
                  .animate()
                  .fadeIn(delay: 100.ms, duration: 500.ms)
                  .slideY(begin: 0.1),

              const SizedBox(height: 20),

              // Weekly Challenge Card
              Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: completedStories.when(
                      data: (completed) => _RiftChallengeCard(
                        title: 'Weekly Odyssey',
                        subtitle: 'Complete 5 stories this week',
                        timeRemaining: _weeklyTimeRemaining,
                        progress: (completed.length / 5).clamp(0, 1),
                        target: 5,
                        current: completed.length.clamp(0, 5),
                        reward: '300 XP + Badge',
                        gradient: [
                          const Color(0xFF7B68EE),
                          const Color(0xFF9B59B6),
                        ],
                        icon: Icons.auto_awesome,
                        theme: theme,
                      ),
                      loading: () => _RiftChallengeCard(
                        title: 'Weekly Odyssey',
                        subtitle: 'Complete 5 stories this week',
                        timeRemaining: _weeklyTimeRemaining,
                        progress: 0,
                        target: 5,
                        current: 0,
                        reward: '300 XP + Badge',
                        gradient: [
                          const Color(0xFF7B68EE),
                          const Color(0xFF9B59B6),
                        ],
                        icon: Icons.auto_awesome,
                        theme: theme,
                      ),
                      error: (_, _) => const SizedBox(),
                    ),
                  )
                  .animate()
                  .fadeIn(delay: 200.ms, duration: 500.ms)
                  .slideY(begin: 0.1),

              const SizedBox(height: 32),

              // Era-specific challenges
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Era Expeditions',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              ).animate().fadeIn(delay: 300.ms),

              const SizedBox(height: 16),

              ...(_getEraExpeditions().asMap().entries.map((entry) {
                final index = entry.key;
                final expedition = entry.value;
                return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      child: completedStories.when(
                        data: (completed) {
                          final eraStories = storyLibrary
                              .where((s) => s.era == expedition['era'])
                              .toList();
                          final completedInEra = eraStories
                              .where((s) => completed.contains(s.id))
                              .length;
                          return _EraExpeditionTile(
                            era: expedition['era'] as String,
                            target: expedition['target'] as int,
                            current: completedInEra,
                            reward: expedition['reward'] as String,
                            theme: theme,
                            textColor: textColor,
                          );
                        },
                        loading: () => _EraExpeditionTile(
                          era: expedition['era'] as String,
                          target: expedition['target'] as int,
                          current: 0,
                          reward: expedition['reward'] as String,
                          theme: theme,
                          textColor: textColor,
                        ),
                        error: (_, _) => const SizedBox(),
                      ),
                    )
                    .animate(delay: (350 + index * 100).ms)
                    .fadeIn()
                    .slideX(begin: 0.1);
              })),

              const SizedBox(height: 32),

              // Coming Soon Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: theme.surfaceColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: theme.primaryColor.withValues(alpha: 0.2),
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: theme.primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.rocket_launch,
                          color: theme.primaryColor,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'More Rifts Coming Soon',
                              style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Seasonal events, special challenges, and more!',
                              style: TextStyle(
                                color: textColor.withValues(alpha: 0.6),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: 600.ms),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getEraExpeditions() {
    final eras = storyLibrary.map((s) => s.era).toSet().toList()..sort();
    return eras.take(4).map((era) {
      final count = storyLibrary.where((s) => s.era == era).length;
      return {'era': era, 'target': count, 'reward': '${count * 25} XP'};
    }).toList();
  }
}

class _RiftChallengeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Duration timeRemaining;
  final double progress;
  final int target;
  final int current;
  final String reward;
  final List<Color> gradient;
  final IconData icon;
  final EraTheme theme;

  const _RiftChallengeCard({
    required this.title,
    required this.subtitle,
    required this.timeRemaining,
    required this.progress,
    required this.target,
    required this.current,
    required this.reward,
    required this.gradient,
    required this.icon,
    required this.theme,
  });

  String _formatDuration(Duration d) {
    final hours = d.inHours;
    final minutes = d.inMinutes.remainder(60);
    final seconds = d.inSeconds.remainder(60);
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m ${seconds}s';
  }

  @override
  Widget build(BuildContext context) {
    final isComplete = current >= target;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradient,
        ),
        boxShadow: [
          BoxShadow(
            color: gradient[0].withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.access_time,
                      color: Colors.white.withValues(alpha: 0.9),
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatDuration(timeRemaining),
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.95),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white.withValues(alpha: 0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$current / $target completed',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 13,
                ),
              ),
              Row(
                children: [
                  Icon(
                    isComplete ? Icons.check_circle : Icons.star,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    isComplete ? 'Claimed!' : reward,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EraExpeditionTile extends StatelessWidget {
  final String era;
  final int target;
  final int current;
  final String reward;
  final EraTheme theme;
  final Color textColor;

  const _EraExpeditionTile({
    required this.era,
    required this.target,
    required this.current,
    required this.reward,
    required this.theme,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final progress = target > 0 ? (current / target).clamp(0.0, 1.0) : 0.0;
    final isComplete = current >= target;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.surfaceColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isComplete
              ? Colors.green.withValues(alpha: 0.5)
              : theme.primaryColor.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: theme.primaryColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.explore, color: theme.primaryColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Complete all $era stories',
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: textColor.withValues(alpha: 0.1),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isComplete ? Colors.green : theme.primaryColor,
                          ),
                          minHeight: 6,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '$current/$target',
                      style: TextStyle(
                        color: textColor.withValues(alpha: 0.6),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: isComplete
                  ? Colors.green.withValues(alpha: 0.15)
                  : theme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              isComplete ? '✓' : reward,
              style: TextStyle(
                color: isComplete ? Colors.green : theme.primaryColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
