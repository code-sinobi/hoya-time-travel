import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/mythic_colors.dart';
import '../library_provider.dart';
import 'vault_story_card.dart';

class LoreTimelineView extends ConsumerWidget {
  const LoreTimelineView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storiesAsync = ref.watch(libraryFilteredStoriesProvider);

    return storiesAsync.when(
      data: (stories) {
        // Group by era
        final eras = stories.map((s) => s.era).toSet().toList()..sort();

        if (eras.isEmpty) {
          return const Center(
            child: Text(
              'No stories found in timeline.',
              style: TextStyle(color: MythicColors.stoneGray),
            ),
          );
        }

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          itemCount: eras.length,
          itemBuilder: (context, index) {
            final era = eras[index];
            final eraStories = stories.where((s) => s.era == era).toList();

            return _EraColumn(
              era: era,
              stories: eraStories,
              isLast: index == eras.length - 1,
            );
          },
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(color: MythicColors.bronze),
      ),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}

class _EraColumn extends StatelessWidget {
  const _EraColumn({
    required this.era,
    required this.stories,
    required this.isLast,
  });

  final String era;
  final List<dynamic> stories;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280, // Fixed width for era columns
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Era Header with Thread Line
          Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: MythicColors.forEra(era),
                  border: Border.all(color: MythicColors.white, width: 2),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                era.toUpperCase(),
                style: AppTypography.headingLg.copyWith(fontSize: 18),
              ),
              const SizedBox(width: 12),
              if (!isLast)
                Expanded(
                  child: Container(
                    height: 2,
                    color: MythicColors.forEra(era).withValues(alpha: 0.5),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),

          // Stories
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.only(bottom: 100),
              itemCount: stories.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final story = stories[index];
                return AspectRatio(
                  aspectRatio: 2.5 / 1.5,
                  child: VaultStoryCard(
                    story: story,
                    onTap: () => context.push('/story/${story.id}/intro'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
