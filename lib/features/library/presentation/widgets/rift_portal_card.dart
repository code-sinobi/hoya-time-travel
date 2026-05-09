import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';

import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/mythic_colors.dart';
import '../../../story/data/story_library.dart';

class RiftPortalCard extends StatelessWidget {
  const RiftPortalCard({
    required this.story,
    required this.onTap,
    this.isActive = false,
    super.key,
  });

  final StoryMetadata story;
  final VoidCallback onTap;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Rift: ${story.title}. Era: ${story.era}.',
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(
            horizontal: isActive ? 16 : 32,
            vertical: isActive ? 16 : 48,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: story.eraColor.withValues(alpha: 0.3),
                      blurRadius: 30,
                      spreadRadius: 2,
                      offset: const Offset(0, 10),
                    ),
                  ]
                : [],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Background Image
                Image.asset(
                  story.imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) =>
                      Container(color: MythicColors.voidBackground),
                ).animate(target: isActive ? 1 : 0).scale(
                      begin: const Offset(1.1, 1.1),
                      end: const Offset(1.0, 1.0),
                      duration: 800.ms,
                      curve: Curves.easeOutCubic,
                    ),

                // Scanline & Vignette Overlay
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      MythicColors.transparent,
                      MythicColors.voidBackground.withValues(alpha: 0.5),
                      MythicColors.voidBackground.withValues(alpha: 0.95),
                    ],
                    stops: const [0.4, 0.7, 1.0],
                  ).createShader(bounds),
                  blendMode: BlendMode.darken,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: story.eraColor.withValues(alpha: 0.5),
                        width: isActive ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                ),

                // Info Glass Strip
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(32),),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: MythicColors.surface1.withValues(alpha: 0.4),
                          border: Border(
                            top: BorderSide(
                              color: story.eraColor.withValues(alpha: 0.3),
                            ),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        story.eraColor.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      color:
                                          story.eraColor.withValues(alpha: 0.5),
                                    ),
                                  ),
                                  child: Text(
                                    story.era.toUpperCase(),
                                    style: AppTypography.hudLabel.copyWith(
                                      fontSize: 10,
                                      color: story.eraColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    story.culture.toUpperCase(),
                                    style: AppTypography.uiBodySm.copyWith(
                                      letterSpacing: 2,
                                      color: MythicColors.parchment
                                          .withValues(alpha: 0.7),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              story.title,
                              style: AppTypography.headlineXl.copyWith(
                                fontSize: 28,
                                color: MythicColors.white,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Moral: ${story.moral}',
                              style: AppTypography.storyBody.copyWith(
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                                color:
                                    MythicColors.white.withValues(alpha: 0.7),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
