import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/mythic_colors.dart';
import '../../../story/data/story_library.dart';

class MapStoryNode extends StatelessWidget {
  const MapStoryNode({
    required this.story,
    required this.onTap,
    super.key,
  });

  final StoryMetadata story;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = MythicColors.forEra(story.era);

    return RepaintBoundary(
      child: Semantics(
        label: 'Story Node: ${story.title}',
        button: true,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.6),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: MythicColors.white.withValues(alpha: 0.8),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Center(
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: MythicColors.white,
                ),
              ),
            ),
          )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .scale(
                begin: const Offset(1, 1),
                end: const Offset(1.2, 1.2),
                duration: 1500.ms,
              )
              .shimmer(duration: 2.seconds, color: MythicColors.white),
        ),
      ),
    );
  }
}
