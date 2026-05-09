import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/mythic_colors.dart';
import '../../../story/data/story_library.dart';
import '../library_provider.dart';

class EraFilterStrip extends ConsumerWidget {
  const EraFilterStrip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedEra =
        ref.watch(archiveFilterProvider.select((s) => s.selectedEra));
    final eras = ref
        .watch(storyLibraryProvider)
        .map((s) => s.era)
        .toSet()
        .toList()
      ..sort();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Text(
            'TEMPORAL FREQUENCY',
            style: GoogleFonts.orbitron(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: MythicColors.fluxCyan.withValues(alpha: 0.7),
              letterSpacing: 2,
            ),
          ),
        ),
        SizedBox(
          height: 56,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: eras.length + 1,
            itemBuilder: (context, index) {
              final isAll = index == 0;
              final era = isAll ? null : eras[index - 1];
              final isSelected = selectedEra == era;

              final eraColor = era != null
                  ? MythicColors.forEra(era)
                  : MythicColors.fluxCyan;
              final filterColor =
                  isSelected ? eraColor : MythicColors.stoneGray;

              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Semantics(
                  label: 'Filter by ${isAll ? 'all eras' : era}',
                  button: true,
                  selected: isSelected,
                  child: InkWell(
                    onTap: () =>
                        ref.read(archiveFilterProvider.notifier).setEra(era),
                    borderRadius: BorderRadius.circular(12),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutCubic,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 0,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? filterColor.withValues(alpha: 0.15)
                            : MythicColors.surface1,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? filterColor
                              : MythicColors.stoneGray.withValues(alpha: 0.3),
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: filterColor.withValues(alpha: 0.3),
                                  blurRadius: 12,
                                  spreadRadius: 1,
                                ),
                              ]
                            : [],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (isSelected)
                            Container(
                              width: 24,
                              height: 2,
                              margin: const EdgeInsets.only(bottom: 4),
                              decoration: BoxDecoration(
                                color: filterColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: filterColor,
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            ).animate().fadeIn(duration: 200.ms).scaleX(),
                          Text(
                            isAll ? 'ALL' : era!.toUpperCase(),
                            style: GoogleFonts.exo2(
                              fontSize: 14,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              color: isSelected
                                  ? filterColor
                                  : MythicColors.parchment
                                      .withValues(alpha: 0.5),
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
