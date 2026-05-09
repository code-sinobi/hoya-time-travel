import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/mythic_colors.dart';
import '../../../story/data/story_library.dart';

class VaultStoryCard extends StatelessWidget {
  const VaultStoryCard({
    required this.story,
    required this.onTap,
    super.key,
    this.index = 0,
  });

  final StoryMetadata story;
  final VoidCallback onTap;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Story: ${story.title}. Era: ${story.era}.',
      button: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: story.eraColor.withValues(alpha: 0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // 1. Background Image
                  Image.asset(
                    story.imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) =>
                        Container(color: MythicColors.voidBackground),
                  ),

                  // 2. Gradient Overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          MythicColors.transparent,
                          MythicColors.black.withValues(alpha: 0.6),
                          MythicColors.black.withValues(alpha: 0.9),
                        ],
                        stops: const [0.3, 0.7, 1.0],
                      ),
                      border: Border.all(
                        color: story.eraColor.withValues(alpha: 0.3),
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),

                  // 3. Content
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Era Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: story.eraColor.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: story.eraColor.withValues(alpha: 0.5),
                            ),
                          ),
                          child: Text(
                            story.era.toUpperCase(),
                            style: AppTypography.hudLabel.copyWith(
                              fontSize: 8,
                              color: story.eraColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Title
                        Text(
                          story.title,
                          style: AppTypography.hudLabel.copyWith(
                            fontSize: 14,
                            color: MythicColors.white,
                            shadows: [
                              const BoxShadow(blurRadius: 4),
                            ],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        // Moral
                        Text(
                          story.moral,
                          style: AppTypography.uiBodySm.copyWith(
                            fontSize: 10,
                            color: MythicColors.white.withValues(alpha: 0.7),
                            fontStyle: FontStyle.italic,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ).animate(delay: (50 * (index % 10)).ms).scale(),
    );
  }
}
