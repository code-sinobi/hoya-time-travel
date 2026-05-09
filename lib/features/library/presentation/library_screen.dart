import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/mythic_colors.dart';
import '../../../core/widgets/galactic_background.dart';
import '../../../core/widgets/sci_fi_search_bar.dart';
import '../domain/archive_filter_state.dart';
import 'library_provider.dart';
import 'widgets/era_filter_strip.dart';
import 'widgets/lore_timeline_view.dart';
import 'widgets/rift_feed.dart';
import 'widgets/lore_world_map.dart';
import 'widgets/mode_tab_switcher.dart';

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mode = ref.watch(archiveFilterProvider.select((s) => s.selectedMode));

    return Scaffold(
      backgroundColor: MythicColors.voidBackground,
      body: Stack(
        children: [
          // Background based on mode
          if (mode == ArchiveMode.vault || mode == ArchiveMode.timeline)
            const GalacticBackground(),

          // Content
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                const ModeTabSwitcher(),

                // Era Filters
                const EraFilterStrip(),
                const SizedBox(height: 16),

                // Search Bar (Only in Vault/Timeline, or overlay in map? Let's keep it global for now)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SciFiSearchBar(
                    onChanged: (value) => ref
                        .read(archiveFilterProvider.notifier)
                        .setSearchQuery(value),
                    hintText: 'Search lore...',
                  ),
                ),

                const SizedBox(height: 16),

                // Main View Area
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _buildModeBody(mode),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeBody(ArchiveMode mode) {
    switch (mode) {
      case ArchiveMode.map:
        return const LoreWorldMap(key: ValueKey('map_mode'));
      case ArchiveMode.timeline:
        return const LoreTimelineView(key: ValueKey('timeline_mode'));
      case ArchiveMode.vault:
        return const RiftFeed(key: ValueKey('vault_mode'));
    }
  }
}
