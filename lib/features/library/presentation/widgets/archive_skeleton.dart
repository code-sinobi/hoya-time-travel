import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../../core/theme/mythic_colors.dart';

class ArchiveSkeleton extends StatelessWidget {
  const ArchiveSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.count(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      itemCount: 6,
      itemBuilder: (context, index) {
        return AspectRatio(
          aspectRatio: 2 / 3,
          child: Container(
            decoration: BoxDecoration(
              color: MythicColors.surface1,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: MythicColors.stoneGray.withValues(alpha: 0.1),
              ),
            ),
          ).animate(onPlay: (controller) => controller.repeat()).shimmer(
                duration: 1500.ms,
                color: MythicColors.stoneGray.withValues(alpha: 0.2),
              ),
        );
      },
    );
  }
}
