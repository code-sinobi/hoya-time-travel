import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/mythic_colors.dart';
import '../library_provider.dart';
import 'rift_portal_card.dart';

class RiftFeed extends ConsumerStatefulWidget {
  const RiftFeed({super.key});

  @override
  ConsumerState<RiftFeed> createState() => _RiftFeedState();
}

class _RiftFeedState extends ConsumerState<RiftFeed> {
  late final PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final storiesAsync = ref.watch(libraryFilteredStoriesProvider);

    return storiesAsync.when(
      data: (stories) {
        if (stories.isEmpty) {
          return const Center(
            child: Text(
              'No rifts detected in this sector.',
              style: TextStyle(color: MythicColors.stoneGray),
            ),
          );
        }

        return PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.vertical,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          itemCount: stories.length,
          itemBuilder: (context, index) {
            final story = stories[index];
            final isActive = index == _currentIndex;

            return RiftPortalCard(
              story: story,
              isActive: isActive,
              onTap: () => context.push('/story/${story.id}/intro'),
            );
          },
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(color: MythicColors.fluxCyan),
      ),
      error: (e, st) {
        return const Center(
          child: Text(
            'Temporal interference. Cannot load rifts.',
            style: TextStyle(color: MythicColors.error),
          ),
        );
      },
    );
  }
}
