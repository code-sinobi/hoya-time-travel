import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/router/routes.dart';
import '../../core/theme/era_theme.dart';
import 'data/story_library.dart';

class StoryIntroScreen extends ConsumerWidget {
  const StoryIntroScreen({required this.storyId, super.key});
  final String storyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stories = ref.watch(storyLibraryProvider);
    final story = stories.firstWhere(
      (s) => s.id == storyId,
      orElse: () => throw Exception('Story not found'),
    );

    return Scaffold(
      backgroundColor: MythicColors.voidBackground,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400.0,
            pinned: true,
            backgroundColor: MythicColors.voidBackground,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: MythicColors.parchment,
                semanticLabel: 'Back',
              ),
              tooltip: 'Back',
              onPressed: () => context.pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'story_cover_${story.id}',
                child: Image.asset(
                  story.imagePath,
                  fit: BoxFit.cover,
                  semanticLabel: story.title,
                  errorBuilder: (c, _, __) => ColoredBox(
                    color: story.primaryColor,
                    child: const Center(
                      child: Icon(
                        Icons.image_not_supported,
                        color: MythicColors.parchment,
                        size: 48,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(24.0),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black87,
                    MythicColors.voidBackground,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    story.title,
                    style: GoogleFonts.cinzelDecorative(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: MythicColors.parchment,
                      letterSpacing: 1.5,
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 500.ms)
                      .slideY(begin: 0.2, end: 0),
                  const SizedBox(height: 16),

                  // Metadata Wrap (Changed from Row to prevent overflow)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _MetaChip(
                        icon: Icons.hourglass_top,
                        label: '${story.era.toUpperCase()} ERA',
                        color: MythicColors.bronze,
                      ),
                      _MetaChip(
                        icon: Icons.public,
                        label: story.culture.toUpperCase(),
                        color: MythicColors.fluxCyan,
                      ),
                    ],
                  ).animate().fadeIn(delay: 200.ms, duration: 500.ms),

                  const SizedBox(height: 32),
                  Text(
                    'SYNOPSIS',
                    style: GoogleFonts.orbitron(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: MythicColors.stoneGray,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    story.description,
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 20,
                      color: MythicColors.parchment.withValues(alpha: 0.9),
                      height: 1.5,
                    ),
                  ).animate().fadeIn(delay: 400.ms, duration: 500.ms),

                  const SizedBox(height: 32),
                  Text(
                    'MORAL FOCUS',
                    style: GoogleFonts.orbitron(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: MythicColors.stoneGray,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: story.primaryColor.withValues(alpha: 0.1),
                      border: Border.all(
                        color: story.primaryColor.withValues(alpha: 0.3),
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      story.moral,
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                        color: story.primaryColor,
                      ),
                    ),
                  ).animate().fadeIn(delay: 600.ms, duration: 500.ms),

                  const SizedBox(height: 64),

                  // Action Button
                  Center(
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: story.primaryColor,
                          foregroundColor: MythicColors.voidBackground,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 8,
                        ),
                        onPressed: () {
                          // Navigate to actual story
                          context.pushReplacement(AppRoutes.story(story.id));
                        },
                        child: Text(
                          'ENTER THE ARCHIVE',
                          style: GoogleFonts.cinzel(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 800.ms, duration: 500.ms)
                        .scale(begin: const Offset(0.9, 0.9)),
                  ),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({
    required this.icon,
    required this.label,
    required this.color,
  });
  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.orbitron(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
