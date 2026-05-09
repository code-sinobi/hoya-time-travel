import 'package:flutter/material.dart';
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

    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: eras.length + 1,
        itemBuilder: (context, index) {
          final isAll = index == 0;
          final era = isAll ? null : eras[index - 1];
          final isSelected = selectedEra == era;

          final filterColor =
              isSelected ? MythicColors.temporalGold : MythicColors.stoneGray;

          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () =>
                    ref.read(archiveFilterProvider.notifier).setEra(era),
                borderRadius: BorderRadius.circular(18),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? filterColor.withValues(alpha: 0.2)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isSelected
                          ? filterColor
                          : filterColor.withValues(alpha: 0.3),
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: filterColor.withValues(alpha: 0.3),
                              blurRadius: 8,
                            ),
                          ]
                        : [],
                  ),
                  child: Center(
                    child: Text(
                      isAll ? 'ALL ERAS' : era!.toUpperCase(),
                      style: GoogleFonts.exo2(
                        fontSize: 12,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected
                            ? filterColor
                            : MythicColors.parchment.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
