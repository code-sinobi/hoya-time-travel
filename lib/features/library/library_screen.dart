import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../core/widgets/galactic_background.dart';
import '../../core/theme/era_theme.dart';
import '../../core/widgets/sci_fi_search_bar.dart';
import '../story/data/story_library.dart';
import 'widgets/sci_fi_story_card.dart'; // Renamed class inside, keeping file name

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  String? _selectedEra;
  String _searchQuery = '';

  List<StoryMetadata> get _filteredStories {
    var stories = storyLibrary;
    if (_selectedEra != null) {
      stories = stories.where((s) => s.era == _selectedEra).toList();
    }
    if (_searchQuery.isNotEmpty) {
      stories = stories
          .where(
            (s) =>
                s.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                s.moral.toLowerCase().contains(_searchQuery.toLowerCase()),
          )
          .toList();
    }
    return stories;
  }

  @override
  Widget build(BuildContext context) {
    // We don't need 'completedIds' to filter viewing necessarily, just marking?
    // Using filtered stories directly.
    final stories = _filteredStories;

    return Scaffold(
      backgroundColor: MythicColors.voidBackground,
      body: Stack(
        children: [
          // BG
          const GalacticBackground(showStars: true),

          // Content
          SafeArea(
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'ARCHIVES',
                        style: GoogleFonts.orbitron(
                          fontSize: 28,
                          color: MythicColors.parchment,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          shadows: [
                            BoxShadow(
                              color: MythicColors.wormholeBlue.withValues(
                                alpha: 0.5,
                              ),
                              blurRadius: 15,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: MythicColors.deepIndigo.withValues(alpha: 0.5),
                          border: Border.all(
                            color: MythicColors.fluxCyan.withValues(alpha: 0.3),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: MythicColors.fluxCyan.withValues(
                                alpha: 0.2,
                              ),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.grid_view,
                          color: MythicColors.fluxCyan,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),

                // Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SciFiSearchBar(
                    onChanged: (value) => setState(() => _searchQuery = value),
                    hintText: 'Search timelines...',
                  ),
                ),

                const SizedBox(height: 16),

                // Era Filters (Futuristic Chips)
                SizedBox(
                  height: 36,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: _availableEras.length + 1,
                    itemBuilder: (context, index) {
                      final isAll = index == 0;
                      final era = isAll ? null : _availableEras[index - 1];
                      final isSelected = _selectedEra == era;
                      final filterColor = isSelected
                          ? MythicColors.temporalGold
                          : MythicColors.stoneGray;

                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => setState(() => _selectedEra = era),
                            borderRadius: BorderRadius.circular(18),
                            child: AnimatedContainer(
                              duration: 200.ms,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
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
                                          color: filterColor.withValues(
                                            alpha: 0.3,
                                          ),
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
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.w500,
                                    color: isSelected
                                        ? filterColor
                                        : MythicColors.parchment.withValues(
                                            alpha: 0.7,
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // Masonry Grid
                Expanded(
                  child: stories.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.search_off,
                                size: 64,
                                color: MythicColors.stoneGray,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'TIMELINE EMPTY',
                                style: GoogleFonts.orbitron(
                                  fontSize: 18,
                                  color: MythicColors.stoneGray,
                                ),
                              ),
                            ],
                          ),
                        )
                      : MasonryGridView.count(
                          padding: const EdgeInsets.fromLTRB(
                            24,
                            0,
                            24,
                            100,
                          ), // Bottom pad for nav
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          itemCount: stories.length,
                          itemBuilder: (context, index) {
                            final story = stories[index];
                            return AspectRatio(
                              aspectRatio:
                                  2 /
                                  3, // Fixed ratio for cards to ensure uniform height in staggered grid if desired, or let content drive it.
                              // Requirement says "Standardize card size (2:3 aspect ratio)".
                              // So we wrap constraint here.
                              child: SciFiStoryCard(
                                story: story,
                                index: index,
                                onTap: () => context.push('/story/${story.id}'),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<String> get _availableEras {
    return storyLibrary.map((s) => s.era).toSet().toList()..sort();
  }
}
