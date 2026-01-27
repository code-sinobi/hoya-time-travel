import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/widgets/galactic_background.dart';
import '../../core/theme/era_theme.dart';
import '../story/data/story_library.dart';
import '../auth/services/profile_service.dart';

import 'widgets/temporal_conduit.dart';
import 'widgets/mythic_slab_card.dart';

class PortalScreen extends ConsumerStatefulWidget {
  const PortalScreen({super.key});

  @override
  ConsumerState<PortalScreen> createState() => _PortalScreenState();
}

class _PortalScreenState extends ConsumerState<PortalScreen>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _pulseController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    // 5:4 aspect ratio (Landscape/Square-ish) request
    _pageController = PageController(viewportFraction: 0.85);
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: MythicColors.voidBackground,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // LAYER 1: Deep Space Background
          const GalacticBackground(showStars: true),

          // LAYER 2: Temporal Conduit (The Core) - moved slightly up
          Positioned(
            top: MediaQuery.of(context).size.height * 0.2, // Align with cards
            left: 0,
            right: 0,
            height: 400,
            child: const Center(child: TemporalConduit()),
          ),

          // LAYER 3: Content (SafeArea)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TOP HUD
              _buildMythicHUD(profileAsync),

              const SizedBox(height: 20),

              // FEATURED CAROUSEL (3D Time Rift Effect)
              Expanded(
                flex: 1, // Fill available space
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (idx) => setState(() => _currentPage = idx),
                  itemCount: storyLibrary.length,
                  itemBuilder: (context, index) {
                    final story = storyLibrary[index];
                    return AnimatedBuilder(
                      animation: _pageController,
                      builder: (context, child) {
                        double value = 1.0;
                        if (_pageController.hasClients &&
                            _pageController.page != null) {
                          value = _pageController.page! - index;
                          value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);
                        } else {
                          value = index == _currentPage ? 1.0 : 0.8;
                        }

                        final double scale = Curves.easeOut.transform(value);
                        final double opacity = Curves.easeOut.transform(value);
                        // Parallax offset calculation
                        double pageOffset = 0;
                        if (_pageController.hasClients &&
                            _pageController.page != null) {
                          pageOffset = _pageController.page! - index;
                        } else {
                          pageOffset = (index == _currentPage
                              ? 0.0
                              : (index > _currentPage ? 1.0 : -1.0));
                        }

                        // 3D Tilt & Parallax Effect
                        // Removed Center/SizedBox constraint to let PageView control main size
                        // AspectRatio 5:4 applied here
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
                              child: Opacity(
                                opacity: opacity.clamp(0.4, 1.0),
                                child: child,
                              ),
                            ),
                          ),
                        );
                      },
                      child: MythicSlabCard(
                        story: story,
                        isLocked: false,
                        onTap: () => context.push('/story/${story.id}'),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMythicHUD(AsyncValue profileAsync) {
    return Container(
      margin: const EdgeInsets.only(top: 50, left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // App Title
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'CHRONO',
                style: GoogleFonts.cinzelDecorative(
                  fontSize: 16,
                  color: MythicColors.bronze.withValues(alpha: 0.7),
                  letterSpacing: 4,
                ),
              ),
              Text(
                'ARCHIVE',
                style: GoogleFonts.cinzelDecorative(
                  fontSize: 32,
                  color: MythicColors.parchment,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    const BoxShadow(color: Colors.black, blurRadius: 10),
                  ],
                ),
              ),
            ],
          ),

          // Profile Medallion with Completion Ring
          Stack(
            alignment: Alignment.center,
            children: [
              // Completion Ring (Static 60% for now)
              SizedBox(
                width: 58,
                height: 58,
                child: CircularProgressIndicator(
                  value: 0.6, // Mocked 60% completion
                  strokeWidth: 2,
                  color: MythicColors.bronze,
                  backgroundColor: MythicColors.bronze.withValues(alpha: 0.2),
                ),
              ),

              // Detailed Avatar Container
              GestureDetector(
                onTap: () {
                  // Navigate to Profile with Hero transition (Phase 2)
                },
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: MythicColors.deepIndigo,
                    border: Border.all(color: MythicColors.bronze, width: 2),
                    boxShadow: const [
                      BoxShadow(color: Colors.black45, blurRadius: 8),
                    ],
                  ),
                  child: Center(
                    child: profileAsync.when(
                      data: (profile) {
                        final initial = (profile?.username ?? 'T')
                            .substring(0, 1)
                            .toUpperCase();
                        if (profile?.avatarUrl != null &&
                            profile!.avatarUrl!.isNotEmpty) {
                          return ClipOval(
                            child: Image.network(
                              profile.avatarUrl!,
                              fit: BoxFit.cover,
                              width: 50,
                              height: 50,
                              errorBuilder: (context, error, stackTrace) =>
                                  _buildInitial(initial),
                            ),
                          );
                        }
                        return _buildInitial(initial);
                      },
                      loading: () =>
                          const CircularProgressIndicator(strokeWidth: 2),
                      error: (context, error) =>
                          const Icon(Icons.error, color: Colors.red, size: 20),
                    ),
                  ),
                ),
              ),

              // Online Status Dot
              Positioned(
                bottom: 0,
                right: 0,
                child: AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    return Container(
                      width: 12 + (_pulseController.value * 2), // Pulse size
                      height: 12 + (_pulseController.value * 2),
                      decoration: BoxDecoration(
                        color: const Color(
                          0xFF4CAF50,
                        ).withValues(alpha: 0.4), // Glow
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFF4CAF50), // Solid green base
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInitial(String initial) {
    return Text(
      initial,
      style: GoogleFonts.cinzel(
        fontSize: 24,
        color: MythicColors.bronze,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
