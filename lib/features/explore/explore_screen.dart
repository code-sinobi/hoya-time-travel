import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/era_theme.dart';
import '../../core/theme/app_theme.dart';
import '../story/data/story_library.dart';
import '../story/repositories/story_repository.dart';

/// Explore screen for discovering eras, wisdom topics, and achievements
class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme =
        Theme.of(context).extension<EraTheme>() ??
        ref.watch(appThemeProvider).extension<EraTheme>()!;
    final completedStories = ref.watch(completedStoryIdsProvider);
    final textColor = theme.bodyStyle.color ?? Colors.white;

    // Get unique eras and their story counts
    final eraData = _getEraData();
    final wisdomTopics = _getWisdomTopics();

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
                    Text(
                      'Explore',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.1),
                    const SizedBox(height: 4),
                    Text(
                      'Discover wisdom across time',
                      style: TextStyle(
                        fontSize: 14,
                        color: textColor.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Featured Wisdom Card
              Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _FeaturedWisdomCard(theme: theme),
                  )
                  .animate()
                  .fadeIn(delay: 100.ms, duration: 500.ms)
                  .slideY(begin: 0.1),

              const SizedBox(height: 32),

              // Era Discovery Section
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  'Journey Through Eras',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              ).animate().fadeIn(delay: 200.ms),

              const SizedBox(height: 16),

              SizedBox(
                height: 160,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: eraData.length,
                  itemBuilder: (context, index) {
                    final era = eraData[index];
                    return Padding(
                          padding: EdgeInsets.only(
                            right: index < eraData.length - 1 ? 16 : 0,
                          ),
                          child: completedStories.when(
                            data: (completed) {
                              final completedInEra = storyLibrary
                                  .where(
                                    (s) =>
                                        s.era == era['name'] &&
                                        completed.contains(s.id),
                                  )
                                  .length;
                              return _EraCard(
                                name: era['name'] as String,
                                storyCount: era['count'] as int,
                                completedCount: completedInEra,
                                icon: era['icon'] as IconData,
                                gradient: era['gradient'] as List<Color>,
                                theme: theme,
                              );
                            },
                            loading: () => _EraCard(
                              name: era['name'] as String,
                              storyCount: era['count'] as int,
                              completedCount: 0,
                              icon: era['icon'] as IconData,
                              gradient: era['gradient'] as List<Color>,
                              theme: theme,
                            ),
                            error: (_, _) => const SizedBox(),
                          ),
                        )
                        .animate(delay: (250 + index * 100).ms)
                        .fadeIn()
                        .slideX(begin: 0.2);
                  },
                ),
              ),

              const SizedBox(height: 32),

              // Wisdom Topics Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Wisdom Topics',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              ).animate().fadeIn(delay: 400.ms),

              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: wisdomTopics.asMap().entries.map((entry) {
                    return _WisdomTopicChip(
                          topic: entry.value,
                          theme: theme,
                          textColor: textColor,
                        )
                        .animate(delay: (450 + entry.key * 50).ms)
                        .fadeIn()
                        .scale(
                          begin: const Offset(0.8, 0.8),
                          end: const Offset(1, 1),
                        );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 32),

              // Achievements Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Achievements',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              ).animate().fadeIn(delay: 600.ms),

              const SizedBox(height: 16),

              completedStories
                  .when(
                    data: (completed) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _AchievementsGrid(
                        completedCount: completed.length,
                        totalCount: storyLibrary.length,
                        theme: theme,
                        textColor: textColor,
                      ),
                    ),
                    loading: () => const SizedBox(height: 100),
                    error: (_, _) => const SizedBox(),
                  )
                  .animate()
                  .fadeIn(delay: 650.ms),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getEraData() {
    final eras = storyLibrary.map((s) => s.era).toSet().toList()..sort();
    return eras.map((era) {
      final count = storyLibrary.where((s) => s.era == era).length;
      return {
        'name': era,
        'count': count,
        'icon': _getEraIcon(era),
        'gradient': _getEraGradient(era),
      };
    }).toList();
  }

  IconData _getEraIcon(String era) {
    if (era.toLowerCase().contains('ancient')) return Icons.account_balance;
    if (era.toLowerCase().contains('medieval')) return Icons.castle;
    if (era.toLowerCase().contains('modern')) return Icons.location_city;
    if (era.toLowerCase().contains('future')) return Icons.rocket_launch;
    return Icons.auto_stories;
  }

  List<Color> _getEraGradient(String era) {
    if (era.toLowerCase().contains('ancient')) {
      return [const Color(0xFFD4A574), const Color(0xFF8B6914)];
    }
    if (era.toLowerCase().contains('medieval')) {
      return [const Color(0xFF7B68EE), const Color(0xFF4B0082)];
    }
    if (era.toLowerCase().contains('modern')) {
      return [const Color(0xFF00CED1), const Color(0xFF008B8B)];
    }
    if (era.toLowerCase().contains('future')) {
      return [const Color(0xFF00D4FF), const Color(0xFF7B2CBF)];
    }
    return [const Color(0xFF667eea), const Color(0xFF764ba2)];
  }

  List<String> _getWisdomTopics() {
    return storyLibrary.map((s) => s.moral).toSet().toList()..sort();
  }
}

class _FeaturedWisdomCard extends StatelessWidget {
  final EraTheme theme;

  const _FeaturedWisdomCard({required this.theme});

  @override
  Widget build(BuildContext context) {
    // Pick a random featured story
    final featured = storyLibrary.isNotEmpty ? storyLibrary.first : null;

    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [theme.primaryColor, theme.secondaryColor],
        ),
        boxShadow: [
          BoxShadow(
            color: theme.primaryColor.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            top: -30,
            right: -30,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
          ),
          Positioned(
            bottom: -40,
            left: -40,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      color: Colors.white.withValues(alpha: 0.9),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Featured Wisdom',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  featured != null
                      ? '"${featured.moral}"'
                      : '"Every journey begins with a single step."',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Text(
                  featured != null ? '— ${featured.era}' : '— Ancient Wisdom',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.75),
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EraCard extends StatelessWidget {
  final String name;
  final int storyCount;
  final int completedCount;
  final IconData icon;
  final List<Color> gradient;
  final EraTheme theme;

  const _EraCard({
    required this.name,
    required this.storyCount,
    required this.completedCount,
    required this.icon,
    required this.gradient,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradient,
        ),
        boxShadow: [
          BoxShadow(
            color: gradient[0].withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white, size: 32),
            const Spacer(),
            Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              '$completedCount / $storyCount completed',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8),
            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: storyCount > 0 ? completedCount / storyCount : 0,
                backgroundColor: Colors.white.withValues(alpha: 0.3),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                minHeight: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WisdomTopicChip extends StatelessWidget {
  final String topic;
  final EraTheme theme;
  final Color textColor;

  const _WisdomTopicChip({
    required this.topic,
    required this.theme,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: theme.surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.primaryColor.withValues(alpha: 0.3)),
      ),
      child: Text(
        topic,
        style: TextStyle(
          color: textColor.withValues(alpha: 0.85),
          fontSize: 13,
        ),
      ),
    );
  }
}

class _AchievementsGrid extends StatelessWidget {
  final int completedCount;
  final int totalCount;
  final EraTheme theme;
  final Color textColor;

  const _AchievementsGrid({
    required this.completedCount,
    required this.totalCount,
    required this.theme,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final achievements = [
      {
        'title': 'First Step',
        'desc': 'Complete your first story',
        'unlocked': completedCount >= 1,
        'icon': Icons.play_arrow,
      },
      {
        'title': 'Explorer',
        'desc': 'Complete 5 stories',
        'unlocked': completedCount >= 5,
        'icon': Icons.explore,
      },
      {
        'title': 'Time Traveler',
        'desc': 'Complete 10 stories',
        'unlocked': completedCount >= 10,
        'icon': Icons.access_time,
      },
      {
        'title': 'Sage',
        'desc': 'Complete 20 stories',
        'unlocked': completedCount >= 20,
        'icon': Icons.psychology,
      },
      {
        'title': 'Enlightened',
        'desc': 'Complete all stories',
        'unlocked': completedCount >= totalCount,
        'icon': Icons.auto_awesome,
      },
    ];

    return Column(
      children: achievements.map((a) {
        final unlocked = a['unlocked'] as bool;
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.surfaceColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: unlocked
                  ? theme.primaryColor.withValues(alpha: 0.5)
                  : textColor.withValues(alpha: 0.1),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: unlocked
                      ? theme.primaryColor.withValues(alpha: 0.2)
                      : textColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  a['icon'] as IconData,
                  color: unlocked
                      ? theme.primaryColor
                      : textColor.withValues(alpha: 0.3),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      a['title'] as String,
                      style: TextStyle(
                        color: unlocked
                            ? textColor
                            : textColor.withValues(alpha: 0.5),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      a['desc'] as String,
                      style: TextStyle(
                        color: textColor.withValues(alpha: 0.5),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              if (unlocked)
                Icon(
                  Icons.check_circle,
                  color: Colors.green.shade400,
                  size: 24,
                ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
