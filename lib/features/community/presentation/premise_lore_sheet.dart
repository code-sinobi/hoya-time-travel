import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/mythic_colors.dart';
import '../domain/domain.dart';
import 'snippet_compose_sheet.dart';

/// Full-screen lore detail sheet for a [StoryPremise].
/// Opened via the "READ LORE" action on an expanded premise card.
class PremiseLoreSheet extends StatelessWidget {
  const PremiseLoreSheet({super.key, required this.premise});

  final StoryPremise premise;

  @override
  Widget build(BuildContext context) {
    final eraColor = MythicColors.forEra(premise.era);

    return DraggableScrollableSheet(
      initialChildSize: 0.88,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.lerp(MythicColors.voidBackground, eraColor, 0.06)!,
                MythicColors.voidBackground,
              ],
            ),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppRadius.xl),
            ),
            border: Border(
              top: BorderSide(
                color: eraColor.withValues(alpha: 0.4),
                width: 1.5,
              ),
            ),
          ),
          child: SafeArea(
            top: true,
            bottom: false,
            child: Column(
              children: [
                // ── Drag handle ─────────────────────────────
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.sm),
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: MythicColors.stoneGray.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                  ),
                ),

                // ── Scrollable body ──────────────────────────
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.md,
                      AppSpacing.lg,
                      AppSpacing.x4l,
                    ),
                    children: [
                      // Header: era & culture badges
                      Row(
                        children: [
                          _LoreBadge(label: premise.era, color: eraColor),
                          const SizedBox(width: AppSpacing.xs),
                          Flexible(
                            child: _LoreBadge(
                              label: premise.culture,
                              color: MythicColors.stoneGray,
                              outlined: true,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.close_rounded),
                            color: MythicColors.stoneGray,
                            onPressed: () => Navigator.of(context).pop(),
                            tooltip: 'Close',
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Era accent line
                      Container(
                        height: 2,
                        width: 48,
                        decoration: BoxDecoration(
                          color: eraColor.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Title
                      Text(
                        premise.title,
                        style: AppTypography.headingLg.copyWith(
                          color: MythicColors.parchment,
                          height: 1.15,
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 500.ms)
                          .slideY(begin: 0.03, end: 0),
                      const SizedBox(height: AppSpacing.lg),

                      // Full description
                      Text(
                        premise.description,
                        style: AppTypography.storyBody.copyWith(
                          color: MythicColors.parchment.withValues(alpha: 0.8),
                          height: 1.8,
                        ),
                      ).animate().fadeIn(delay: 150.ms, duration: 500.ms),
                      const SizedBox(height: AppSpacing.xl),

                      // Divider
                      Container(
                        height: 1,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              MythicColors.transparent,
                              eraColor.withValues(alpha: 0.3),
                              MythicColors.transparent,
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),

                      // Community pulse
                      Row(
                        children: [
                          Icon(
                            Icons.local_fire_department_outlined,
                            size: AppIconSize.sm,
                            color: eraColor,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            '${premise.voteCount} Chroniclers voted on this premise',
                            style: AppTypography.storyCaption.copyWith(
                              color: MythicColors.stoneGray,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Snippets placeholder (future: list real snippets)
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        decoration: BoxDecoration(
                          color: MythicColors.surface1,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          border: Border.all(
                            color:
                                MythicColors.stoneGray.withValues(alpha: 0.12),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ECHOES FROM THE ARCHIVE',
                              style: AppTypography.label.copyWith(
                                color: MythicColors.stoneGray,
                                fontSize: FontSize.micro,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              'No fragments written yet. Be the first chronicler to etch a snippet into this legend.',
                              style: AppTypography.storyCaption.copyWith(
                                color: MythicColors.stoneGray
                                    .withValues(alpha: 0.65),
                                height: 1.6,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),

                      // CTA: Etch Snippet
                      ElevatedButton.icon(
                        onPressed: () {
                          final parentNav =
                              Navigator.of(context, rootNavigator: true);
                          parentNav.pop();
                          showModalBottomSheet<void>(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: MythicColors.transparent,
                            builder: (_) =>
                                SnippetComposeSheet(originStoryId: premise.id),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: eraColor.withValues(alpha: 0.15),
                          foregroundColor: eraColor,
                          elevation: 0,
                          minimumSize: const Size.fromHeight(52),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            side: BorderSide(
                              color: eraColor.withValues(alpha: 0.4),
                            ),
                          ),
                        ),
                        icon: const Icon(Icons.edit_note_rounded),
                        label: Text(
                          'ETCH A SNIPPET INTO THIS LEGEND',
                          style:
                              AppTypography.uiButton.copyWith(color: eraColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _LoreBadge extends StatelessWidget {
  const _LoreBadge({
    required this.label,
    required this.color,
    this.outlined = false,
  });
  final String label;
  final Color color;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color:
            outlined ? MythicColors.transparent : color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(
          color: color.withValues(alpha: outlined ? 0.25 : 0.35),
        ),
      ),
      child: Text(
        label.toUpperCase(),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTypography.label.copyWith(
          color: color,
          fontSize: FontSize.micro,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
