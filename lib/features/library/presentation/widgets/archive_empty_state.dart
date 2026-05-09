import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/mythic_colors.dart';

class ArchiveEmptyState extends StatelessWidget {
  const ArchiveEmptyState({
    super.key,
    this.title = 'ARCHIVE EMPTY',
    this.subtitle = 'No stories found in this temporal coordinate.',
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: MythicColors.stoneGray.withValues(alpha: 0.5),
          )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .scale(
                begin: const Offset(1, 1),
                end: const Offset(1.1, 1.1),
                duration: 2.seconds,
              )
              .shimmer(duration: 3.seconds),
          const SizedBox(height: 16),
          Text(
            title,
            style: AppTypography.headingMd.copyWith(
              color: MythicColors.stoneGray,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: AppTypography.uiBodySm,
          ),
        ],
      ),
    );
  }
}
