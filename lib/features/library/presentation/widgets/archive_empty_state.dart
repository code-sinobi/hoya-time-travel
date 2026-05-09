import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/mythic_colors.dart';

class ArchiveEmptyState extends StatelessWidget {
  const ArchiveEmptyState({super.key});

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
            'TIMELINE EMPTY',
            style: AppTypography.headingMd.copyWith(
              color: MythicColors.stoneGray,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'No stories found in this temporal coordinate.',
            style: AppTypography.uiBodySm,
          ),
        ],
      ),
    );
  }
}
