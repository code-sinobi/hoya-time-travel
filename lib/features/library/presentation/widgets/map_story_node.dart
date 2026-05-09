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
          child: SizedBox.square(
            dimension: 48,
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Outer Scanner Brackets
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: color.withValues(alpha: 0.3),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  )
                      .animate(
                          onPlay: (controller) =>
                              controller.repeat(reverse: true),)
                      .scale(
                        begin: const Offset(1, 1),
                        end: const Offset(1.1, 1.1),
                        duration: 2000.ms,
                      )
                      .shimmer(duration: 2.seconds, color: color),

                  // Inner Glowing Core
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: MythicColors.white,
                      boxShadow: [
                        BoxShadow(
                          color: color,
                          blurRadius: 12,
                          spreadRadius: 4,
                        ),
                        BoxShadow(
                          color: color.withValues(alpha: 0.5),
                          blurRadius: 24,
                          spreadRadius: 8,
                        ),
                      ],
                    ),
                  )
                      .animate(
                          onPlay: (controller) =>
                              controller.repeat(reverse: true),)
                      .scale(
                        begin: const Offset(1, 1),
                        end: const Offset(0.7, 0.7),
                        duration: 1000.ms,
                        curve: Curves.easeInOutSine,
                      ),

                  // Orbiting Ring
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: color.withValues(alpha: 0.8),
                        width: 1.5,
                      ),
                    ),
                  )
                      .animate(onPlay: (controller) => controller.repeat())
                      .rotate(duration: 3.seconds)
                      .scale(
                        begin: const Offset(1, 1),
                        end: const Offset(1.05, 1.05),
                        duration: 1500.ms,
                      ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
