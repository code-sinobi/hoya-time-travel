import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../story/data/story_library.dart';
import '../domain/archive_filter_state.dart';

part 'library_provider.g.dart';

@riverpod
class ArchiveFilter extends _$ArchiveFilter {
  @override
  ArchiveFilterState build() {
    return const ArchiveFilterState();
  }

  void setMode(ArchiveMode mode) {
    state = state.copyWith(selectedMode: mode);
  }

  void setEra(String? era) {
    state = state.copyWith(selectedEra: era);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }
}

@riverpod
Future<List<StoryMetadata>> libraryFilteredStories(
  LibraryFilteredStoriesRef ref,
) async {
  final filter = ref.watch(archiveFilterProvider);
  final query = filter.searchQuery;
  final era = filter.selectedEra;

  // Debounce for search
  bool didDispose = false;
  ref.onDispose(() => didDispose = true);

  await Future.delayed(const Duration(milliseconds: 300));
  if (didDispose) return ref.state.valueOrNull ?? [];

  var stories = ref.watch(storyLibraryProvider);
  if (era != null) {
    stories = stories.where((s) => s.era == era).toList();
  }

  if (query.isNotEmpty) {
    stories = stories.where((s) {
      final q = query.toLowerCase();
      return s.title.toLowerCase().contains(q) ||
          s.moral.toLowerCase().contains(q) ||
          s.culture.toLowerCase().contains(q);
    }).toList();
  }

  return stories;
}
