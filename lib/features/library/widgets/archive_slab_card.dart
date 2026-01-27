import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../story/data/story_library.dart';

class ArchiveSlabCard extends StatelessWidget {
  final StoryMetadata story;
  final bool isCompleted;
  final VoidCallback onTap;

  const ArchiveSlabCard({
    super.key,
    required this.story,
    required this.isCompleted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Colors
    const bronze = Color(0xFFD4A574);
    const cyan = Color(0xFF00FFFF);
    const deepVoid = Color(0xFF0A0A0F);

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        height: 100, // Compact height for list
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: deepVoid.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(12),
          border: Border(
            left: BorderSide(
              color: isCompleted ? bronze : cyan.withValues(alpha: 0.3),
              width: 4,
            ),
            top: BorderSide(color: bronze.withValues(alpha: 0.3), width: 1),
            bottom: BorderSide(color: bronze.withValues(alpha: 0.3), width: 1),
            right: BorderSide(color: bronze.withValues(alpha: 0.3), width: 1),
          ),
          boxShadow: [
            BoxShadow(
              color: isCompleted
                  ? bronze.withValues(alpha: 0.1)
                  : cyan.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
              child: SizedBox(
                width: 80,
                height: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      story.imagePath,
                      fit: BoxFit.cover,
                      color: Colors.black.withValues(alpha: 0.4),
                      colorBlendMode: BlendMode.darken,
                    ),
                    if (isCompleted)
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: bronze,
                            size: 20,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: bronze.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: bronze.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            story.era.toUpperCase(),
                            style: GoogleFonts.spaceMono(
                              fontSize: 10,
                              color: bronze,
                            ),
                          ),
                        ),
                        const Spacer(),
                        if (!isCompleted)
                          Icon(
                            Icons.lock_open,
                            color: cyan.withValues(alpha: 0.5),
                            size: 14,
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      story.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.cinzel(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      story.moral,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.lora(
                        fontSize: 12,
                        color: const Color(0xFFE8DCC4).withValues(alpha: 0.7),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Garnish
            Container(
              width: 12,
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: bronze.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  3,
                  (i) => Container(
                    margin: const EdgeInsets.symmetric(vertical: 2),
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: bronze.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
