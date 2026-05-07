import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/era_theme.dart';
import '../../living_story/presentation/living_story_controller.dart';

class ResourceHeader extends ConsumerWidget {
  const ResourceHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context).extension<EraTheme>();
    final session = ref.watch(livingStoryControllerProvider).session;

    if (theme == null || session == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.surfaceColor.withValues(alpha: 0.9),
        border: Border(
          bottom: BorderSide(color: theme.primaryColor.withValues(alpha: 0.3)),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Temporal Energy (TE)
            _ResourceBadge(
              icon: Icons.hourglass_top,
              value: session.temporalEnergy,
              maxValue: session.resources.teMax,
              label: 'Energy',
              color: Colors.amber,
              theme: theme,
            ),

            // Cultural Insight (CI)
            _ResourceBadge(
              icon: Icons.auto_awesome,
              value: session.culturalInsight,
              label: 'Insight',
              color: Colors.purpleAccent,
              theme: theme,
            ),
          ],
        ),
      ),
    );
  }
}

class _ResourceBadge extends StatelessWidget {
  const _ResourceBadge({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    required this.theme,
    this.maxValue,
  });
  final IconData icon;
  final int value;
  final int? maxValue;
  final String label;
  final Color color;
  final EraTheme theme;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              maxValue != null ? '$value/$maxValue' : '$value',
              style: theme.headlineStyle.copyWith(
                fontSize: 16,
                color: theme.textColor,
              ),
            ),
            Text(
              label,
              style: theme.bodyStyle.copyWith(
                fontSize: 10,
                color: theme.textColor.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
