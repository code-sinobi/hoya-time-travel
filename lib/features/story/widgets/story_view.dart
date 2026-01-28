import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/era_theme.dart';
import '../models/story_models.dart';

class StoryView extends ConsumerStatefulWidget {
  final StoryNode node;
  final Function(StoryChoice) onChoiceSelected;

  const StoryView({
    super.key,
    required this.node,
    required this.onChoiceSelected,
  });

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
                      child:
                          Text(
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
                  flex: 1,
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
  final StoryChoice choice;
  final EraTheme theme;
  final VoidCallback onTap;
  final int index;

  const _ChoiceCard({
    required this.choice,
    required this.theme,
    required this.onTap,
    required this.index,
  });

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
                child: Text(
                  choice.text,
                  style: theme.bodyStyle.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: (index * 200).ms).slideX(begin: 0.1, end: 0);
  }
}
