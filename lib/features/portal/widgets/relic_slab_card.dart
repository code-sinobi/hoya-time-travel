import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../story/data/story_library.dart';

class RelicSlabCard extends StatefulWidget {
  const RelicSlabCard({
    required this.story,
    required this.onEnter,
    super.key,
    this.isLocked = false,
  });
  final StoryMetadata story;
  final VoidCallback onEnter;
  final bool isLocked;

  @override
  State<RelicSlabCard> createState() => _RelicSlabCardState();
}

class _RelicSlabCardState extends State<RelicSlabCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Colors
    const bronze = Color(0xFFD4A574);
    const cyan = Color(0xFF00FFFF);
    const voidColor = Color(0xFF0A0A0F);

    return GestureDetector(
      onTap: widget.isLocked
          ? HapticFeedback.heavyImpact
          : () {
              HapticFeedback.lightImpact();
              widget.onEnter();
            },
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          final glowValue = _pulseController.value;

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
            decoration: BoxDecoration(
              color: voidColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: widget.isLocked ? bronze.withValues(alpha: 0.3) : bronze,
                width: 2,
              ),
              boxShadow: widget.isLocked
                  ? []
                  : [
                      BoxShadow(
                        color: cyan.withValues(alpha: 0.1 + (glowValue * 0.1)),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                      BoxShadow(
                        color: bronze.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // "Stone" Texture / Background Image
                  // If we had a stone texture asset we'd use it.
                  // Instead, we use the story image with a heavy shading overlay
                  // to make it look like an engraving or embedded screen.
                  Image.asset(
                    widget.story.imagePath,
                    fit: BoxFit.cover,
                    color: Colors.black.withValues(alpha: 0.6),
                    colorBlendMode: BlendMode.darken,
                  ),

                  // Forcefield Scanline (if active)
                  if (!widget.isLocked)
                    Positioned.fill(
                      child: CustomPaint(
                        painter: ForcefieldPainter(progress: glowValue),
                      ),
                    ),

                  // Content Overlay
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        // Myth Age Header
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: bronze.withValues(alpha: 0.5),
                            ),
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.black.withValues(alpha: 0.5),
                          ),
                          child: Text(
                            widget.story.era.toUpperCase(),
                            style: GoogleFonts.cinzel(
                              fontSize: 12,
                              color: bronze,
                              letterSpacing: 2,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const Spacer(),

                        // Title
                        Text(
                          widget.story.title.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.cinzel(
                            fontSize: 28,
                            color:
                                widget.isLocked ? Colors.white38 : Colors.white,
                            letterSpacing: 1.5,
                            shadows: widget.isLocked
                                ? []
                                : [const Shadow(color: cyan, blurRadius: 10)],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Wisdom Trait
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              widget.isLocked
                                  ? Icons.lock_outline
                                  : Icons.auto_awesome,
                              color: widget.isLocked ? Colors.white38 : bronze,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              widget.isLocked
                                  ? 'TEMPORAL LOCK'
                                  : widget.story.moral, // moral as wisdom
                              style: GoogleFonts.lora(
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                                color: widget.isLocked
                                    ? Colors.white38
                                    : const Color(0xFFE8DCC4),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ForcefieldPainter extends CustomPainter {
  ForcefieldPainter({required this.progress});
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00FFFF).withValues(alpha: 0.05)
      ..strokeWidth = 1;

    // Scanlines
    for (double y = 0; y < size.height; y += 4) {
      if ((y + (progress * 100)) % 20 < 2) {
        canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
      }
    }

    // Corner accents
    final cornerPaint = Paint()
      ..color = const Color(0xFF00FFFF).withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    const double cornerSize = 20;

    // TL
    canvas.drawPath(
      Path()
        ..moveTo(0, cornerSize)
        ..lineTo(0, 0)
        ..lineTo(cornerSize, 0),
      cornerPaint,
    );
    // TR
    canvas.drawPath(
      Path()
        ..moveTo(size.width - cornerSize, 0)
        ..lineTo(size.width, 0)
        ..lineTo(size.width, cornerSize),
      cornerPaint,
    );
    // BL
    canvas.drawPath(
      Path()
        ..moveTo(0, size.height - cornerSize)
        ..lineTo(0, size.height)
        ..lineTo(cornerSize, size.height),
      cornerPaint,
    );
    // BR
    canvas.drawPath(
      Path()
        ..moveTo(size.width - cornerSize, size.height)
        ..lineTo(size.width, size.height)
        ..lineTo(size.width, size.height - cornerSize),
      cornerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant ForcefieldPainter old) => true;
}
