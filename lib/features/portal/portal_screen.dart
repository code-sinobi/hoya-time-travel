import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/widgets/galactic_background.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/galactic_colors.dart';
import '../../core/widgets/temporal_hud.dart';
import '../../core/widgets/temporal_nav_bar.dart';
import '../../core/widgets/time_particles.dart';
import 'widgets/time_portal_card.dart';
import '../story/data/story_library.dart';
import '../auth/services/profile_service.dart';

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
    // We can access theme extensions if needed, but we mostly use Galactic components now
    final profileAsync = ref.watch(userProfileProvider);
    // final progressAsync = ref.watch(allUserProgressProvider); // Unused in this view for now, handled inside card if needed logic

    return Scaffold(
      body: Stack(
        children: [
          // Galactic Background
          const GalacticBackground(showStars: true),

          // Time Particles
          const Positioned.fill(child: TimeParticles(count: 30)),

          // Animated nebula overlay
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    GalacticColors.quantumPurple.withOpacity(0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Content
          Column(
            children: [
              // Temporal HUD replacing old header
              // Mocking data for now or using profile data
              profileAsync.when(
                data: (profile) => TemporalHUD(
                  level: profile?.level ?? 1,
                  xp: profile?.xp ?? 0,
                  temporalEnergy: 100, // Placeholder or fetch from provider
                ),
                loading: () => const SizedBox(height: 80), // Placeholder space
                error: (_, __) => const SizedBox(height: 80),
              ),

              const SizedBox(height: 10),

              // Title Header (Optional, HUD covers info, but title defines screen)
              AnimatedTextKit(
                animatedTexts: [
                  TyperAnimatedText(
                    'TIME PORTAL NETWORK',
                    textStyle: GoogleFonts.orbitron(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: GalacticColors.neonCyan,
                    ),
                    speed: const Duration(milliseconds: 100),
                  ),
                ],
                totalRepeatCount: 1,
              ),

              const SizedBox(height: 20),

              // 3D Carousel with TimePortalCards
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (idx) => setState(() => _currentPage = idx),
                  itemCount: storyLibrary.length,
                  itemBuilder: (context, index) {
                    final story = storyLibrary[index];
                    // final isActive = index == _currentPage;

                    return TimePortalCard(
                      story: story,
                      onEnter: () => context.push('/story/${story.id}'),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // Navigation Dots (Optional Polish)
              _buildNavigationDots(storyLibrary.length),

              const SizedBox(height: 100), // Space for NavBar
            ],
          ),
        ],
      ),

      // Floating Temporal Navigation Bar
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: const TemporalNavBar(),
      bottomNavigationBar: const BottomAppBar(
        color: Colors.transparent,
        elevation: 0,
        child: SizedBox(height: 10), // Minimal height to push FAB up if needed
      ),
    );
  }

  Widget _buildNavigationDots(int count) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(count, (index) {
          return AnimatedContainer(
            duration: 300.ms,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: _currentPage == index ? 24 : 8,
            height: 8,
            decoration: BoxDecoration(
              gradient: _currentPage == index
                  ? LinearGradient(
                      colors: [
                        GalacticColors.neonCyan,
                        GalacticColors.wormholeBlue,
                      ],
                    )
                  : null,
              color: _currentPage == index ? null : GalacticColors.deepNebula,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: GalacticColors.neonCyan.withOpacity(0.5),
                width: 1,
              ),
            ),
          );
        }),
      ),
    );
  }
}

// Removed _StoryCard class as it is replaced by TimePortalCard
