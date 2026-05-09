import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/mythic_colors.dart';
import '../../domain/archive_filter_state.dart';
import '../library_provider.dart';

class ModeTabSwitcher extends ConsumerWidget {
  const ModeTabSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(archiveFilterProvider.select((s) => s.selectedMode));

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: MythicColors.surface1.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: MythicColors.bronze.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          _buildTab(
            context,
            ref,
            ArchiveMode.map,
            'MAP',
            Icons.map_outlined,
            mode,
          ),
          _buildTab(
            context,
            ref,
            ArchiveMode.timeline,
            'TIMELINE',
            Icons.linear_scale_outlined,
            mode,
          ),
          _buildTab(
            context,
            ref,
            ArchiveMode.vault,
            'VAULT',
            Icons.grid_view_outlined,
            mode,
          ),
        ],
      ),
    );
  }

  Widget _buildTab(
    BuildContext context,
    WidgetRef ref,
    ArchiveMode tabMode,
    String label,
    IconData icon,
    ArchiveMode currentMode,
  ) {
    final isSelected = tabMode == currentMode;

    return Expanded(
      child: GestureDetector(
        onTap: () => ref.read(archiveFilterProvider.notifier).setMode(tabMode),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? MythicColors.bronze.withValues(alpha: 0.2)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color:
                    isSelected ? MythicColors.bronze : MythicColors.stoneGray,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.orbitron(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color:
                      isSelected ? MythicColors.bronze : MythicColors.stoneGray,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
