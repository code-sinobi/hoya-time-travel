import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/mythic_colors.dart';
import '../../../core/widgets/galactic_background.dart';
import '../domain/domain.dart';
import 'premise_controller.dart';
import 'premise_lore_sheet.dart';
import 'snippet_compose_sheet.dart';

class CommunityScreen extends ConsumerWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final premisesAsync = ref.watch(premiseControllerProvider);

    return Scaffold(
      backgroundColor: MythicColors.voidBackground,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showComposeSheet(context),
        backgroundColor: MythicColors.bronze,
        foregroundColor: MythicColors.voidBackground,
        tooltip: 'Compose Snippet',
        // semanticLabel on the Icon satisfies the accessibility checker
        child: const Icon(
          Icons.edit_note_rounded,
          semanticLabel: 'Compose Snippet',
        ),
      ),
      body: Stack(
        children: [
          const GalacticBackground(),
          SafeArea(
            child: CustomScrollView(
              slivers: [
                // ── Header ──────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md,
                      AppSpacing.lg,
                      AppSpacing.md,
                      AppSpacing.sm,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ECHOES OF THE VOID',
                          style: AppTypography.headingLg.copyWith(
                            color: MythicColors.bronze,
                          ),
                        )
                            .animate()
                            .fadeIn(duration: 600.ms)
                            .slideX(begin: -0.05, end: 0),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Vote on story premises. Share fragments of lore.',
                          style: AppTypography.storyCaption.copyWith(
                            color: MythicColors.stoneGray,
                          ),
                        ).animate().fadeIn(delay: 200.ms, duration: 500.ms),
                      ],
                    ),
                  ),
                ),

                // ── Section Label ───────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 3,
                          height: AppSpacing.md,
                          decoration: BoxDecoration(
                            color: MythicColors.bronze,
                            borderRadius: BorderRadius.circular(AppRadius.pill),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          'STORY PREMISES',
                          style: AppTypography.label,
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.how_to_vote_outlined,
                          size: AppIconSize.sm,
                          color: MythicColors.stoneGray,
                        ),
                      ],
                    ),
                  ),
                ),

                // ── Premise List ────────────────────────────
                premisesAsync.when(
                  loading: () => const SliverToBoxAdapter(
                    child: _PremiseLoadingSkeleton(),
                  ),
                  error: (err, _) => SliverToBoxAdapter(
                    child: _ErrorState(
                      message: 'Something went wrong — please try again.',
                      onRetry: () => ref.invalidate(premiseControllerProvider),
                    ),
                  ),
                  data: (premises) {
                    if (premises.isEmpty) {
                      return const SliverFillRemaining(child: _EmptyState());
                    }
                    return SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                      ),
                      sliver: SliverList.separated(
                        itemCount: premises.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: AppSpacing.sm),
                        itemBuilder: (context, index) => _PremiseCard(
                          key: ValueKey(premises[index].id),
                          premise: premises[index],
                          index: index,
                        ),
                      ),
                    );
                  },
                ),

                // Bottom spacer for FAB clearance
                const SliverToBoxAdapter(
                  child: SizedBox(height: AppSpacing.x4l),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showComposeSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: MythicColors.transparent,
      builder: (_) => const SnippetComposeSheet(),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// Premise Card — Interactive Expanding Archive Scroll
// ═══════════════════════════════════════════════════════════════════
class _PremiseCard extends ConsumerStatefulWidget {
  const _PremiseCard({
    super.key,
    required this.premise,
    required this.index,
  });
  final StoryPremise premise;
  final int index;

  @override
  ConsumerState<_PremiseCard> createState() => _PremiseCardState();
}

class _PremiseCardState extends ConsumerState<_PremiseCard> {
  bool _isExpanded = false;

  void _toggleExpand() => setState(() => _isExpanded = !_isExpanded);

  @override
  Widget build(BuildContext context) {
    final eraColor = MythicColors.forEra(widget.premise.era);

    return AnimatedContainer(
      duration: 300.ms,
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        // Subtle gradient wash that deepens on expand
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            MythicColors.surface1,
            Color.lerp(MythicColors.surface1, eraColor, 0.04)!,
          ],
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: eraColor.withValues(alpha: _isExpanded ? 0.55 : 0.2),
          width: _isExpanded ? 1.5 : 1.0,
        ),
        boxShadow: _isExpanded
            ? [
                BoxShadow(
                  color: eraColor.withValues(alpha: 0.18),
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ]
            : MythicColors.cardShadow,
      ),
      child: Material(
        color: MythicColors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          onTap: _toggleExpand,
          splashColor: eraColor.withValues(alpha: 0.08),
          highlightColor: eraColor.withValues(alpha: 0.04),
          child: Padding(
            padding: AppSpacing.allLg,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Top row: Era badge | Culture | Expand chevron | Vote ──
                Row(
                  children: [
                    _EraBadge(era: widget.premise.era, color: eraColor),
                    const SizedBox(width: AppSpacing.xs),
                    Flexible(
                      fit: FlexFit.loose,
                      child: _CultureBadge(culture: widget.premise.culture),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    const Spacer(),
                    // Expand indicator chevron
                    AnimatedRotation(
                      turns: _isExpanded ? 0.5 : 0,
                      duration: 300.ms,
                      curve: Curves.easeOutCubic,
                      child: Icon(
                        Icons.expand_more_rounded,
                        size: AppIconSize.sm,
                        color: MythicColors.stoneGray
                            .withValues(alpha: _isExpanded ? 0.8 : 0.4),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    _VoteButton(
                      premiseId: widget.premise.id,
                      voteCount: widget.premise.voteCount,
                      eraColor: eraColor,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),

                // ── Title — full weight, correct token ──────
                Text(
                  widget.premise.title,
                  style: AppTypography.headingLg.copyWith(
                    color: MythicColors.parchment,
                    height: 1.2,
                  ),
                  maxLines: _isExpanded ? null : 2,
                  overflow: _isExpanded ? null : TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xs),

                // ── Animated expandable body ─────────────────
                AnimatedSize(
                  duration: 300.ms,
                  curve: Curves.easeOutCubic,
                  alignment: Alignment.topCenter,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        widget.premise.description,
                        style: AppTypography.storyBody.copyWith(
                          color: MythicColors.parchment.withValues(alpha: 0.65),
                        ),
                        maxLines: _isExpanded ? null : 3,
                        overflow: _isExpanded ? null : TextOverflow.ellipsis,
                      ),
                      if (_isExpanded) ...[
                        const SizedBox(height: AppSpacing.md),
                        // ── Divider ──────────────────────────
                        Container(
                          height: 1,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                eraColor.withValues(alpha: 0.3),
                                MythicColors.transparent,
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        // ── Actions — stacked vertically to prevent overflow ──
                        _ActionButton(
                          label: 'READ LORE',
                          icon: Icons.menu_book_rounded,
                          isOutlined: true,
                          eraColor: eraColor,
                          onTap: () {
                            showModalBottomSheet<void>(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: MythicColors.transparent,
                              builder: (_) => PremiseLoreSheet(
                                premise: widget.premise,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        _ActionButton(
                          label: 'ETCH SNIPPET',
                          icon: Icons.edit_note_rounded,
                          isOutlined: false,
                          eraColor: eraColor,
                          onTap: () {
                            showModalBottomSheet<void>(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: MythicColors.transparent,
                              builder: (_) => const SnippetComposeSheet(),
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                ),

                // ── Bottom era accent line ───────────────────
                if (!_isExpanded) ...[
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          eraColor.withValues(alpha: 0.35),
                          MythicColors.transparent,
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(delay: (80 * widget.index).ms, duration: 400.ms)
        .slideY(begin: 0.04, end: 0);
  }
}

// ═══════════════════════════════════════════════════════════════════
// Action button — full-width, avoids overflow entirely
// ═══════════════════════════════════════════════════════════════════
class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.isOutlined,
    required this.eraColor,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isOutlined;
  final Color eraColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    if (isOutlined) {
      return OutlinedButton.icon(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: MythicColors.stoneGray,
          side:
              BorderSide(color: MythicColors.stoneGray.withValues(alpha: 0.3)),
          minimumSize: const Size.fromHeight(44),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
        icon: Icon(icon, size: AppIconSize.sm),
        label: Text(label, style: AppTypography.uiButton),
      );
    }
    return ElevatedButton.icon(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: eraColor.withValues(alpha: 0.15),
        foregroundColor: eraColor,
        elevation: 0,
        minimumSize: const Size.fromHeight(44),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: BorderSide(color: eraColor.withValues(alpha: 0.35)),
        ),
      ),
      icon: Icon(icon, size: AppIconSize.sm),
      label: Text(label, style: AppTypography.uiButton),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// Sub-widgets
// ═══════════════════════════════════════════════════════════════════
class _EraBadge extends StatelessWidget {
  const _EraBadge({required this.era, required this.color});
  final String era;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Text(
        era.toUpperCase(),
        style: AppTypography.label.copyWith(
          color: color,
          fontSize: FontSize.micro,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _CultureBadge extends StatelessWidget {
  const _CultureBadge({required this.culture});
  final String culture;

  @override
  Widget build(BuildContext context) {
    return Text(
      '· ${culture.toUpperCase()}',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: AppTypography.label.copyWith(
        color: MythicColors.stoneGray.withValues(alpha: 0.6),
        fontSize: FontSize.micro,
        letterSpacing: 0.8,
      ),
    );
  }
}

// Vote button: guaranteed 48×48 tap area via SizedBox wrapping the InkWell
class _VoteButton extends ConsumerWidget {
  const _VoteButton({
    required this.premiseId,
    required this.voteCount,
    required this.eraColor,
  });
  final String premiseId;
  final int voteCount;
  final Color eraColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Semantics(
      label: 'Vote for this premise, $voteCount votes',
      button: true,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 60, minHeight: 48),
        child: Material(
          color: MythicColors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          child: InkWell(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            onTap: () {
              ref.read(premiseControllerProvider.notifier).castVote(premiseId);
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.pill),
                border: Border.all(
                  color: eraColor.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.local_fire_department_outlined,
                    size: AppIconSize.sm,
                    color: eraColor,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    '$voteCount',
                    style: AppTypography.hudValue.copyWith(
                      color: eraColor,
                      fontSize: FontSize.caption,
                    ),
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

// ═══════════════════════════════════════════════════════════════════
// Loading / Error / Empty states
// ═══════════════════════════════════════════════════════════════════
class _PremiseLoadingSkeleton extends StatelessWidget {
  const _PremiseLoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        children: List.generate(
          3,
          (i) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Container(
              height: 140,
              decoration: BoxDecoration(
                color: MythicColors.surface1,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(
                  color: MythicColors.stoneGray.withValues(alpha: 0.1),
                ),
              ),
            ).animate(onPlay: (c) => c.repeat(reverse: true)).shimmer(
                  duration: 1500.ms,
                  color: MythicColors.bronze.withValues(alpha: 0.08),
                ),
          ),
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.allLg,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              size: AppIconSize.xl,
              color: MythicColors.error,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Failed to load premises',
              style: AppTypography.headingSm.copyWith(
                color: MythicColors.error,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              message,
              style: AppTypography.uiBodySm,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.md),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(
                'RETRY',
                style: AppTypography.uiButton.copyWith(
                  color: MythicColors.bronze,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: MythicColors.bronze),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.allXl,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.auto_awesome,
              size: AppIconSize.xxl,
              color: MythicColors.bronze.withValues(alpha: 0.6),
            ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
                  begin: const Offset(1, 1),
                  end: const Offset(1.1, 1.1),
                  duration: 2000.ms,
                ),
            const SizedBox(height: AppSpacing.lg),
            Text('NO PREMISES YET', style: AppTypography.headingSm),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'The void awaits its first story seed.\nTap the pen to etch your echo.',
              style: AppTypography.storyCaption,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
