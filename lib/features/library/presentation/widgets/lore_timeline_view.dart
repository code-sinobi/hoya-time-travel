import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/mythic_colors.dart';
import '../../../story/data/story_library.dart';
import '../library_provider.dart';

class LoreTimelineView extends ConsumerWidget {
  const LoreTimelineView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storiesAsync = ref.watch(libraryFilteredStoriesProvider);

    return storiesAsync.when(
      data: (stories) {
        if (stories.isEmpty) {
          return const Center(
            child: Text(
              'No anomalies found in timeline.',
              style: TextStyle(color: MythicColors.stoneGray),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(top: 24, bottom: 100),
          itemCount: stories.length,
          itemBuilder: (context, index) {
            final story = stories[index];
            final isLast = index == stories.length - 1;
            final eraColor = MythicColors.forEra(story.era);

            return Stack(
              clipBehavior: Clip.none,
              children: [
                // Connecting Temporal Wire
                if (!isLast)
                  Positioned(
                    left: 34,
                    top: 60,
                    bottom: -24,
                    child: Container(
                      width: 2,
                      decoration: BoxDecoration(
                        color: eraColor.withValues(alpha: 0.5),
                        boxShadow: [
                          BoxShadow(
                            color: eraColor,
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),

                // Temporal Node Indicator
                Positioned(
                  left: 24,
                  top: 24,
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: MythicColors.voidBackground,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: eraColor,
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: eraColor.withValues(alpha: 0.6),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: MythicColors.white,
                          boxShadow: [
                            BoxShadow(
                              color: MythicColors.white,
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ).animate().scale(delay: (100 * index).ms),
                ),

                // The Card
                Padding(
                  padding:
                      const EdgeInsets.only(left: 64, right: 24, bottom: 24),
                  child: _TimelineStoryCard(
                    story: story,
                    onTap: () => context.push('/story/${story.id}/intro'),
                  )
                      .animate()
                      .fadeIn(delay: (100 * index).ms)
                      .slideX(begin: 0.2),
                ),
              ],
            );
          },
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(color: MythicColors.fluxCyan),
      ),
      error: (e, st) {
        return const Center(
          child: Text(
            'Temporal interference. Cannot load timeline.',
            style: TextStyle(color: MythicColors.error),
          ),
        );
      },
    );
  }
}

class _TimelineStoryCard extends StatelessWidget {
  const _TimelineStoryCard({required this.story, required this.onTap});

  final StoryMetadata story;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = MythicColors.forEra(story.era);

    return Semantics(
      label: 'Open ${story.title}',
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            color: MythicColors.surface1.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: color.withValues(alpha: 0.3),
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.05),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.horizontal(left: Radius.circular(16)),
                child: SizedBox(
                  width: 100,
                  height: 120,
                  child: Image.asset(
                    story.imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        Container(color: MythicColors.voidBackground),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        story.era.toUpperCase(),
                        style: GoogleFonts.orbitron(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: color,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        story.title,
                        style: GoogleFonts.exo2(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: MythicColors.white,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        story.moral,
                        style: TextStyle(
                          fontSize: 12,
                          color: MythicColors.parchment.withValues(alpha: 0.7),
                          fontStyle: FontStyle.italic,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
