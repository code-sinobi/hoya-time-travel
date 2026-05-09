import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/mythic_colors.dart';
import '../../../story/data/story_library.dart';

class LorePreviewSheet extends StatelessWidget {
  const LorePreviewSheet({
    required this.story,
    super.key,
  });

  final StoryMetadata story;

  static void show(BuildContext context, StoryMetadata story) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => LorePreviewSheet(story: story),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = MythicColors.forEra(story.era);

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (_, controller) {
        return Container(
          decoration: BoxDecoration(
            color: MythicColors.surface1,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border(
              top: BorderSide(color: color.withValues(alpha: 0.3)),
            ),
          ),
          child: ListView(
            controller: controller,
            padding: EdgeInsets.zero,
            children: [
              _SheetHeader(story: story),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _StoryMetadata(story: story, color: color),
                    const SizedBox(height: 16),
                    Text(
                      story.title,
                      style: AppTypography.headlineXl.copyWith(fontSize: 32),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Moral: ${story.moral}',
                      style: AppTypography.storyBody.copyWith(
                        fontStyle: FontStyle.italic,
                        color: MythicColors.bronze,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _StoryContent(story: story),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SheetHeader extends StatelessWidget {
  const _SheetHeader({required this.story});
  final StoryMetadata story;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: Image.asset(
            story.imagePath,
            height: 250,
            width: double.infinity,
            fit: BoxFit.cover,
            semanticLabel: story.title,
            errorBuilder: (c, e, s) => Container(
              height: 250,
              color: MythicColors.voidBackground,
            ),
          )
              .animate()
              .shimmer(
                duration: 1500.ms,
                color: MythicColors.fluxCyan.withValues(alpha: 0.5),
                angle: 1.5,
              )
              .fadeIn(duration: 800.ms),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  MythicColors.surface1.withValues(alpha: 0.5),
                  MythicColors.surface1,
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 12,
          right: 12,
          child: IconButton(
            icon: const Icon(
              Icons.close,
              color: MythicColors.stoneGray,
            ),
            tooltip: 'Close preview',
            onPressed: () => context.pop(),
          ),
        ),
      ],
    );
  }
}

class _StoryMetadata extends StatelessWidget {
  const _StoryMetadata({required this.story, required this.color});
  final StoryMetadata story;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: color.withValues(alpha: 0.5)),
          ),
          child: Text(
            story.era.toUpperCase(),
            style: AppTypography.hudLabel.copyWith(
              fontSize: 10,
              color: color,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          story.culture.toUpperCase(),
          style: AppTypography.uiBodySm.copyWith(
            letterSpacing: 2,
            color: MythicColors.parchment.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}

class _StoryContent extends StatelessWidget {
  const _StoryContent({required this.story});
  final StoryMetadata story;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          story.description,
          style: AppTypography.storyBodyLg,
        ),
        const SizedBox(height: 48),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: FilledButton(
            onPressed: () {
              context.pop();
              context.push('/story/${story.id}/intro');
            },
            style: FilledButton.styleFrom(
              backgroundColor: MythicColors.bronze,
              foregroundColor: MythicColors.voidBackground,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'BEGIN JOURNEY',
              style: AppTypography.uiButton,
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
