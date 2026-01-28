import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';
import '../../story/data/story_library.dart';
import '../../../core/theme/era_theme.dart';

class SciFiStoryCard extends StatelessWidget {
  final StoryMetadata story;
  final VoidCallback onTap;
  final int index; // For staggered animation delay

  const SciFiStoryCard({
    super.key,
    required this.story,
    required this.onTap,
    this.index = 0,
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
              color: story.eraColor.withValues(alpha: 0.2),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 1. Background Image
              Image.asset(
                story.imagePath,
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) =>
                    Container(color: MythicColors.voidBackground),
              ),

              // 2. Glassmorphism Gradient Overlay
              BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 0,
                  sigmaY: 0,
                ), // Slight blur maybe? Or just sharp.
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.6),
                        Colors.black.withValues(alpha: 0.9),
                      ],
                      stops: const [0.3, 0.7, 1.0],
                    ),
                    border: Border.all(
                      color: story.eraColor.withValues(alpha: 0.3),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),

              // 3. Content
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Era Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: story.eraColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: story.eraColor.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Text(
                        story.era.toUpperCase(),
                        style: GoogleFonts.orbitron(
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          color: story.eraColor,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Title
                    Text(
                      story.title,
                      style: GoogleFonts.orbitron(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          const BoxShadow(color: Colors.black, blurRadius: 4),
                        ],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Moral
                    Text(
                      story.moral,
                      style: GoogleFonts.exo2(
                        fontSize: 10,
                        color: Colors.white70,
                        fontStyle: FontStyle.italic,
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
      ).animate(delay: (50 * (index % 10)).ms).fadeIn().scale(),
    );
  }
}
