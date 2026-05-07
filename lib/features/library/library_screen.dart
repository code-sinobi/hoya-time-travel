import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/era_theme.dart';
import '../../core/widgets/galactic_background.dart';
import '../../core/widgets/sci_fi_search_bar.dart';
import '../story/data/story_library.dart';
import 'widgets/sci_fi_story_card.dart'; // Renamed class inside, keeping file name

final librarySearchQueryProvider =
    StateProvider.autoDispose<String>((ref) => '');
final librarySelectedEraProvider =
    StateProvider.autoDispose<String?>((ref) => null);

final libraryFilteredStoriesProvider =
    FutureProvider.autoDispose<List<StoryMetadata>>((ref) async {
  final query = ref.watch(librarySearchQueryProvider);
  final era = ref.watch(librarySelectedEraProvider);

  // Debounce
  bool cancelled = false;
  ref.onDispose(() => cancelled = true);
  await Future<void>.delayed(const Duration(milliseconds: 300));
  if (cancelled) return []; // Will be ignored by riverpod when disposed

  // Simulate remote fetch
  await Future<void>.delayed(const Duration(milliseconds: 500));
  if (cancelled) return [];

  var stories = ref.watch(storyLibraryProvider);
  if (era != null) {
    stories = stories.where((s) => s.era == era).toList();
  }
  if (query.isNotEmpty) {
    stories = stories
        .where(
          (s) =>
              s.title.toLowerCase().contains(query.toLowerCase()) ||
              s.moral.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }
  return stories;
});

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Pagination trigger logic for future remote data
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // ref.read(libraryPaginationProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final storiesAsync = ref.watch(libraryFilteredStoriesProvider);
    final selectedEra = ref.watch(librarySelectedEraProvider);

    return Scaffold(
      backgroundColor: MythicColors.voidBackground,
      body: Stack(
        children: [
          // BG
          const GalacticBackground(),

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
                    onChanged: (value) => ref
                        .read(librarySearchQueryProvider.notifier)
                        .state = value,
                    hintText: 'Search timelines...',
                  ),
                ),

                const SizedBox(height: 16),

                // Era Filters (Futuristic Chips)
                SizedBox(
                  height: 48,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: _availableEras.length + 1,
                    itemBuilder: (context, index) {
                      final isAll = index == 0;
                      final era = isAll ? null : _availableEras[index - 1];
                      final isSelected = selectedEra == era;
                      final filterColor = isSelected
                          ? MythicColors.temporalGold
                          : MythicColors.stoneGray;

                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => ref
                                .read(librarySelectedEraProvider.notifier)
                                .state = era,
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

                // Masonry Grid or Loading State
                Expanded(
                  child: storiesAsync.when(
                    data: (stories) {
                      if (stories.isEmpty) {
                        return Center(
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
                        );
                      }

                      return MasonryGridView.count(
                        controller: _scrollController,
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
                            aspectRatio: 2 / 3,
                            child: SciFiStoryCard(
                              story: story,
                              index: index,
                              onTap: () =>
                                  context.push('/story/${story.id}/intro'),
                            ),
                          );
                        },
                      );
                    },
                    loading: () => const Center(
                      child: CircularProgressIndicator(
                        color: MythicColors.fluxCyan,
                      ),
                    ),
                    error: (err, stack) => Center(
                      child: Text(
                        'Error: $err',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
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
    return ref.watch(storyLibraryProvider).map((s) => s.era).toSet().toList()
      ..sort();
  }
}
