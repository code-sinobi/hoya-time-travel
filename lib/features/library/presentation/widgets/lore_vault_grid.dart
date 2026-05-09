import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';

import '../library_provider.dart';
import 'archive_empty_state.dart';
import 'archive_skeleton.dart';
import 'vault_story_card.dart';

class LoreVaultGrid extends ConsumerWidget {
  const LoreVaultGrid({
    required this.scrollController,
    super.key,
  });

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storiesAsync = ref.watch(libraryFilteredStoriesProvider);

    return storiesAsync.when(
      data: (stories) {
        if (stories.isEmpty) {
          return const ArchiveEmptyState();
        }

        return MasonryGridView.count(
          controller: scrollController,
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          itemCount: stories.length,
          itemBuilder: (context, index) {
            final story = stories[index];
            return AspectRatio(
              aspectRatio: 2 / 3,
              child: VaultStoryCard(
                story: story,
                index: index,
                onTap: () => context.push('/story/${story.id}/intro'),
              ),
            );
          },
        );
      },
      loading: () => const ArchiveSkeleton(),
      error: (err, stack) => Center(
        child: Text(
          'Error: $err',
          style: const TextStyle(color: Colors.red),
        ),
      ),
    );
  }
}
