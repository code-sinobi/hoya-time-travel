import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/era_theme.dart';
import '../../core/theme/app_theme.dart';
import '../story/data/story_library.dart';
import '../story/repositories/story_repository.dart';

/// Library screen showing all 30 stories in a grid with filtering
class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  String? _selectedEra;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<StoryMetadata> get _filteredStories {
    var stories = storyLibrary;

    // Filter by era
    if (_selectedEra != null) {
      stories = stories.where((s) => s.era == _selectedEra).toList();
    }

    // Filter by search
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

  List<String> get _availableEras {
    return storyLibrary.map((s) => s.era).toSet().toList()..sort();
  }

  @override
  Widget build(BuildContext context) {
    final theme =
        Theme.of(context).extension<EraTheme>() ??
        ref.watch(appThemeProvider).extension<EraTheme>()!;
    final completedStories = ref.watch(completedStoryIdsProvider);
    final textColor = theme.bodyStyle.color ?? Colors.white;

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Story Library',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.1),
                  const SizedBox(height: 4),
                  Text(
                    '${_filteredStories.length} stories available',
                    style: TextStyle(
                      fontSize: 14,
                      color: textColor.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: theme.surfaceColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.primaryColor.withValues(alpha: 0.2),
                  ),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) => setState(() => _searchQuery = value),
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    hintText: 'Search stories...',
                    hintStyle: TextStyle(
                      color: textColor.withValues(alpha: 0.4),
                    ),
                    prefixIcon: Icon(Icons.search, color: theme.primaryColor),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
            ).animate().fadeIn(delay: 100.ms, duration: 400.ms),

            const SizedBox(height: 16),

            // Era Filter Chips
            SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _FilterChip(
                    label: 'All',
                    isSelected: _selectedEra == null,
                    onTap: () => setState(() => _selectedEra = null),
                    theme: theme,
                    textColor: textColor,
                  ),
                  ..._availableEras.map(
                    (era) => Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: _FilterChip(
                        label: era,
                        isSelected: _selectedEra == era,
                        onTap: () => setState(() => _selectedEra = era),
                        theme: theme,
                        textColor: textColor,
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 200.ms, duration: 400.ms),

            const SizedBox(height: 20),

            // Story Grid
            Expanded(
              child: completedStories.when(
                data: (completed) => GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.65,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: _filteredStories.length,
                  itemBuilder: (context, index) {
                    final story = _filteredStories[index];
                    final isCompleted = completed.contains(story.id);
                    return _StoryGridItem(
                          story: story,
                          isCompleted: isCompleted,
                          theme: theme,
                          textColor: textColor,
                          onTap: () => context.push('/story/${story.id}'),
                        )
                        .animate(delay: (100 + index * 50).ms)
                        .fadeIn()
                        .scale(
                          begin: const Offset(0.9, 0.9),
                          end: const Offset(1, 1),
                        );
                  },
                ),
                loading: () => Center(
                  child: CircularProgressIndicator(color: theme.primaryColor),
                ),
                error: (e, _) => Center(
                  child: Text('Error: $e', style: TextStyle(color: textColor)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final EraTheme theme;
  final Color textColor;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.theme,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? theme.primaryColor : theme.surfaceColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? theme.primaryColor
                : theme.primaryColor.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : textColor.withValues(alpha: 0.8),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _StoryGridItem extends StatelessWidget {
  final StoryMetadata story;
  final bool isCompleted;
  final EraTheme theme;
  final Color textColor;
  final VoidCallback onTap;

  const _StoryGridItem({
    required this.story,
    required this.isCompleted,
    required this.theme,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: theme.primaryColor.withValues(alpha: 0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Story Image
              Image.asset(
                story.imagePath,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        theme.primaryColor.withValues(alpha: 0.6),
                        theme.secondaryColor.withValues(alpha: 0.6),
                      ],
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.auto_stories,
                      size: 48,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  ),
                ),
              ),

              // Gradient Overlay
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.8),
                      ],
                      stops: const [0.5, 1.0],
                    ),
                  ),
                ),
              ),

              // Completed Badge
              if (isCompleted)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),

              // Era Badge
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    story.era,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              // Title & Moral
              Positioned(
                bottom: 12,
                left: 12,
                right: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      story.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      story.moral,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 11,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
