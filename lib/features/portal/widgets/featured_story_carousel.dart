import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/mythic_colors.dart';
import '../../auth/models/profile.dart';
import '../../story/data/story_library.dart';
import 'mythic_slab_card.dart';

class FeaturedStoryCarousel extends ConsumerStatefulWidget {
  const FeaturedStoryCarousel({
    super.key,
    required this.recommendedIds,
    required this.profileAsync,
  });

  final Set<String> recommendedIds;
  final AsyncValue<Profile?> profileAsync;

  @override
  ConsumerState<FeaturedStoryCarousel> createState() =>
      _FeaturedStoryCarouselState();
}

class _FeaturedStoryCarouselState extends ConsumerState<FeaturedStoryCarousel> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    // 5:4 aspect ratio (Landscape/Square-ish) request
    _pageController = PageController(viewportFraction: 0.85);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      onPageChanged: (idx) => setState(() => _currentPage = idx),
      itemCount: ref.watch(storyLibraryProvider).length,
      itemBuilder: (context, index) {
        final story = ref.watch(storyLibraryProvider)[index];
        final isRecommended = widget.recommendedIds.contains(story.id);

        final profile = widget.profileAsync.value;
        final isPatron = profile?.subscriptionTier == 'patron' ||
            profile?.subscriptionTier == 'oracle';
        final isLocked = story.isPremium && !isPatron;

        return AnimatedBuilder(
          animation: _pageController,
          builder: (context, child) {
            double value = 1.0;
            if (_pageController.hasClients && _pageController.page != null) {
              value = _pageController.page! - index;
              value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);
            } else {
              value = index == _currentPage ? 1.0 : 0.8;
            }

            final double scale = Curves.easeOut.transform(value);
            final double opacity = Curves.easeOut.transform(value);
            // Parallax offset calculation
            double pageOffset = 0;
            if (_pageController.hasClients && _pageController.page != null) {
              pageOffset = _pageController.page! - index;
            } else {
              pageOffset = index == _currentPage
                  ? 0.0
                  : (index > _currentPage ? 1.0 : -1.0);
            }

            // 3D Tilt & Parallax Effect
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 20,
              ),
              child: AspectRatio(
                aspectRatio: 5 / 4,
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001) // Reduced depth
                    ..rotateY(
                      pageOffset * -0.2,
                    ) // Reduced rotation for easier swipe feel
                    ..multiply(
                      Matrix4.diagonal3Values(scale, scale, 1.0),
                    ),
                  child: ColorFiltered(
                    colorFilter: ColorFilter.matrix([
                      1,
                      0,
                      0,
                      0,
                      0,
                      0,
                      1,
                      0,
                      0,
                      0,
                      0,
                      0,
                      1,
                      0,
                      0,
                      0,
                      0,
                      0,
                      opacity.clamp(0.4, 1.0),
                      0,
                    ]),
                    child: child,
                  ),
                ),
              ),
            );
          },
          child: Stack(
            children: [
              MythicSlabCard(
                story: story,
                isLocked: isLocked,
                onTap: () {
                  if (isLocked) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'This story requires Patron status.',
                          style: AppTypography.uiButton,
                        ),
                        action: SnackBarAction(
                          label: 'UPGRADE',
                          textColor: MythicColors.bronze,
                          onPressed: () {
                            context.pushNamed('profile');
                          },
                        ),
                        backgroundColor: const Color(0xFF1E1E2C),
                      ),
                    );
                  } else {
                    context.push('/story/${story.id}/intro');
                  }
                },
              ),
              if (isRecommended)
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xs,
                      vertical: AppSpacing.xxs,
                    ),
                    decoration: BoxDecoration(
                      color: MythicColors.bronze,
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 8,
                          color: MythicColors.bronze,
                        ),
                      ],
                    ),
                    child: Text(
                      'RECOMMENDED',
                      style: AppTypography.label.copyWith(
                        color: MythicColors.black,
                        fontSize: 10,
                      ),
                    ),
                  ).animate().shimmer(
                        duration: 2.seconds,
                        delay: 1.seconds,
                      ),
                ),
              if (isLocked)
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: MythicColors.scrim,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.lock,
                          color: MythicColors.bronze,
                          size: 48,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'PATRON ONLY',
                          style: AppTypography.label.copyWith(letterSpacing: 2),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
