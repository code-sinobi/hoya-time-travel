import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/era_theme.dart';
import '../models/story_models.dart';

class StoryView extends ConsumerStatefulWidget {
  const StoryView({
    required this.node,
    required this.onChoiceSelected,
    super.key,
  });
  final StoryNode node;
  final void Function(StoryChoice) onChoiceSelected;

  @override
  ConsumerState<StoryView> createState() => _StoryViewState();
}

class _StoryViewState extends ConsumerState<StoryView> {
  bool _showChoices = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<EraTheme>()!;

    return Stack(
      children: [
        // Background (Placeholder)
        Positioned.fill(
          child: Container(
            color: theme.backgroundColor,
            // In real app, render widget.node.backgroundImage or generate it
          ),
        ),

        // Content Area
        SafeArea(
          child: Column(
            children: [
              // Story Text Panel
              Expanded(
                flex: 2,
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.all(24),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: theme.surfaceColor.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      child: Text(
                        widget.node.content,
                        style: theme.bodyStyle.copyWith(height: 1.6),
                      )
                          .animate(
                            onComplete: (controller) =>
                                setState(() => _showChoices = true),
                          )
                          .fadeIn(duration: 500.ms)
                          .moveY(begin: 10, end: 0),
                    ),
                  ),
                ),
              ),

              // Choices Area
              if (widget.node.choices.isNotEmpty)
                Expanded(
                  child: AnimatedOpacity(
                    opacity: _showChoices ? 1.0 : 0.0,
                    duration: 500.ms,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      itemCount: widget.node.choices.length,
                      separatorBuilder: (c, i) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final choice = widget.node.choices[index];
                        return _ChoiceCard(
                          choice: choice,
                          theme: theme,
                          onTap: () => widget.onChoiceSelected(choice),
                          index: index,
                        );
                      },
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ChoiceCard extends StatelessWidget {
  const _ChoiceCard({
    required this.choice,
    required this.theme,
    required this.onTap,
    required this.index,
  });
  final StoryChoice choice;
  final EraTheme theme;
  final VoidCallback onTap;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: theme.buttonShape,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: ShapeDecoration(
            color: theme.surfaceColor,
            shape: theme.buttonShape,
            shadows: [
              BoxShadow(
                color: theme.primaryColor.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: theme.primaryColor.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${index + 1}',
                  style: theme.headlineStyle.copyWith(fontSize: 14),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      choice.text,
                      style:
                          theme.bodyStyle.copyWith(fontWeight: FontWeight.bold),
                    ),
                    if (choice.teCost > 0 ||
                        choice.ciReward > 0 ||
                        choice.ciCost > 0)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Row(
                          children: [
                            if (choice.teCost > 0)
                              _CostBadge(
                                label: '-${choice.teCost} Energy',
                                color: Colors.amber,
                                theme: theme,
                              ),
                            if (choice.ciCost > 0)
                              _CostBadge(
                                label: '-${choice.ciCost} Insight',
                                color: Colors.purple,
                                theme: theme,
                              ),
                            if (choice.ciReward > 0)
                              _CostBadge(
                                label: '+${choice.ciReward} Insight',
                                color: Colors.purpleAccent,
                                theme: theme,
                              ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: (index * 200).ms).slideX(begin: 0.1, end: 0);
  }
}

class _CostBadge extends StatelessWidget {
  const _CostBadge({
    required this.label,
    required this.color,
    required this.theme,
  });
  final String label;
  final Color color;
  final EraTheme theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: theme.captionStyle.copyWith(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
