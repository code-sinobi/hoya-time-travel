import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
      height: 56,
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: MythicColors.surface1.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: MythicColors.fluxCyan.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: MythicColors.fluxCyan.withValues(alpha: 0.05),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          _buildTab(
            context,
            ref,
            ArchiveMode.map,
            'STAR MAP',
            Icons.public,
            mode,
          ),
          _buildTab(
            context,
            ref,
            ArchiveMode.timeline,
            'CHRONO',
            Icons.linear_scale,
            mode,
          ),
          _buildTab(
            context,
            ref,
            ArchiveMode.vault,
            'RIFTS',
            Icons.blur_circular,
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
    final color = isSelected ? MythicColors.fluxCyan : MythicColors.stoneGray;

    return Expanded(
      child: Semantics(
        label: 'Switch to $label mode',
        button: true,
        selected: isSelected,
        child: GestureDetector(
          onTap: () =>
              ref.read(archiveFilterProvider.notifier).setMode(tabMode),
          child: AnimatedContainer(
            height: double.infinity,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutExpo,
            decoration: BoxDecoration(
              color: isSelected
                  ? color.withValues(alpha: 0.15)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isSelected
                    ? color.withValues(alpha: 0.5)
                    : Colors.transparent,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: color.withValues(alpha: 0.3),
                        blurRadius: 12,
                      ),
                    ]
                  : [],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 16, color: color)
                    .animate(target: isSelected ? 1 : 0)
                    .scale(end: const Offset(1.1, 1.1), duration: 200.ms),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: GoogleFonts.orbitron(
                    fontSize: 11,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: color,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
