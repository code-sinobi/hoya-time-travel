import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/widgets/galactic_background.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/era_theme.dart';
import '../story/data/story_library.dart';
import '../story/repositories/story_repository.dart';
import '../auth/services/profile_service.dart';
import '../auth/services/auth_service.dart';

class PortalScreen extends ConsumerStatefulWidget {
  const PortalScreen({super.key});

  @override
  ConsumerState<PortalScreen> createState() => _PortalScreenState();
}

class _PortalScreenState extends ConsumerState<PortalScreen> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.7);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<EraTheme>();
    final profileAsync = ref.watch(userProfileProvider);
    final progressAsync = ref.watch(allUserProgressProvider);

    if (theme == null) return const SizedBox();

    return Scaffold(
      body: Stack(
        children: [
          // Galactic Background
          const GalacticBackground(showStars: true),

          // Content
          Column(
            children: [
              const SizedBox(height: 60),

              // Top HUD
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    profileAsync.when(
                      data: (profile) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            profile?.username?.toUpperCase() ?? 'CHRONICLER',
                            style: theme.headlineStyle.copyWith(
                              fontSize: 14,
                              letterSpacing: 2,
                            ),
                          ),
                          Text(
                            'LEVEL ${profile?.level ?? 1} • ${profile?.xp ?? 0} XP',
                            style: theme.bodyStyle.copyWith(
                              fontSize: 10,
                              color: theme.secondaryColor,
                            ),
                          ),
                        ],
                      ),
                      loading: () => const SizedBox.shrink(),
                      error: (_, stack) => const SizedBox.shrink(),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.logout,
                        color: theme.primaryColor,
                        size: 20,
                      ),
                      onPressed: () => ref.read(authServiceProvider).signOut(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              // App Title
              Text(
                'HOYA',
                style: theme.headlineStyle.copyWith(
                  fontSize: 48,
                  letterSpacing: 8,
                ),
              ).animate().fadeIn().moveY(begin: -20, end: 0),

              Text(
                'LIBRARY OF LEGENDS',
                style: theme.bodyStyle.copyWith(
                  fontSize: 14,
                  letterSpacing: 4,
                  color: theme.primaryColor,
                ),
              ).animate().fadeIn(delay: 300.ms),

              // 3D Carousel
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (idx) => setState(() => _currentPage = idx),
                  itemCount: storyLibrary.length,
                  itemBuilder: (context, index) {
                    final story = storyLibrary[index];
                    final isActive = index == _currentPage;

                    // Check if this story has progress
                    final progressList = progressAsync.value ?? [];
                    final progress = progressList
                        .where((p) => p.storyId == story.id)
                        .firstOrNull;

                    return AnimatedScale(
                      scale: isActive ? 1.0 : 0.85,
                      duration: 300.ms,
                      child: AnimatedOpacity(
                        opacity: isActive ? 1.0 : 0.5,
                        duration: 300.ms,
                        child: _StoryCard(
                          story: story,
                          theme: theme,
                          isCompleted: progress?.isCompleted ?? false,
                          hasProgress: progress != null,
                          onEnter: () => context.push('/story/${story.id}'),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ],
      ),
    );
  }
}

class _StoryCard extends StatefulWidget {
  final StoryMetadata story;
  final EraTheme theme;
  final VoidCallback onEnter;
  final bool isCompleted;
  final bool hasProgress;

  const _StoryCard({
    required this.story,
    required this.theme,
    required this.onEnter,
    this.isCompleted = false,
    this.hasProgress = false,
  });

  @override
  State<_StoryCard> createState() => _StoryCardState();
}

class _StoryCardState extends State<_StoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(vsync: this, duration: 200.ms);
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTapDown: (_) => _pressController.forward(),
        onTap: () {
          _pressController.reverse();
          widget.onEnter();
        },
        onTapCancel: () => _pressController.reverse(),
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 40),
            decoration: BoxDecoration(
              color: widget.story.primaryColor,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: widget.story.primaryColor.withValues(alpha: 0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Story Image
                  Image.asset(widget.story.imagePath, fit: BoxFit.cover),

                  // Gradient Overlay for text readability
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          widget.story.primaryColor.withValues(alpha: 0.3),
                          Colors.black.withValues(alpha: 0.6),
                        ],
                      ),
                    ),
                  ),

                  // Text Overlay
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.9),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  widget.story.era.toUpperCase(),
                                  style: widget.theme.bodyStyle.copyWith(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                              if (widget.isCompleted)
                                Icon(
                                  Icons.check_circle,
                                  color: widget.theme.secondaryColor,
                                  size: 20,
                                )
                              else if (widget.hasProgress)
                                Icon(
                                  Icons.play_circle_outline,
                                  color: widget.theme.primaryColor,
                                  size: 20,
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.story.title,
                            style: widget.theme.headlineStyle.copyWith(
                              fontSize: 24,
                              color: Colors.white,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Wisdom: ${widget.story.moral}",
                            style: widget.theme.bodyStyle.copyWith(
                              color: Colors.white70,
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            widget.story.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: widget.theme.bodyStyle.copyWith(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
