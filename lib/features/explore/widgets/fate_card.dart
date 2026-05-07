import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/era_theme.dart';
import '../../community/domain/domain.dart';

/// A mystical tarot-style card for futures voting.
/// Features 3D flip animation, reveal effects, and voting integration.
class FateCard extends StatefulWidget {
  const FateCard({
    super.key,
    this.premise,
    this.isRevealed = false,
    this.isSelected = false,
    this.hasVoted = false,
    this.onTap,
    this.width = 140,
    this.height = 200,
  });

  /// The story premise this card represents, null if unrevealed
  final StoryPremise? premise;

  /// Whether the card has been revealed
  final bool isRevealed;

  /// Whether this card is currently selected
  final bool isSelected;

  /// Whether the user has voted for this card
  final bool hasVoted;

  /// Callback when card is tapped
  final VoidCallback? onTap;

  /// Card width
  final double width;

  /// Card height
  final double height;

  @override
  State<FateCard> createState() => _FateCardState();
}

class _FateCardState extends State<FateCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _flipController;
  bool _showFront = true;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _showFront = !widget.isRevealed;
  }

  @override
  void didUpdateWidget(FateCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Trigger flip animation when reveal state changes
    if (widget.isRevealed != oldWidget.isRevealed) {
      _flipCard();
    }
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  void _flipCard() {
    HapticFeedback.mediumImpact();
    if (_showFront) {
      _flipController.forward().then((_) {
        setState(() => _showFront = false);
      });
    } else {
      _flipController.reverse().then((_) {
        setState(() => _showFront = true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onTap?.call();
      },
      child: AnimatedBuilder(
        animation: _flipController,
        builder: (context, child) {
          final angle = _flipController.value * math.pi;
          final showBack = angle > math.pi / 2;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            child: showBack
                ? Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(math.pi),
                    child: _buildCardFront(),
                  )
                : _buildCardBack(),
          );
        },
      ),
    );
  }

  Widget _buildCardBack() {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: MythicColors.bronze.withValues(alpha: 0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative pattern
          Center(
            child: _buildMysteryPattern(),
          ),

          // Question mark
          Center(
            child: Icon(
              Icons.help_outline,
              size: 48,
              color: MythicColors.bronze.withValues(alpha: 0.6),
            ),
          ),

          // Corner decorations
          Positioned(
            top: 8,
            left: 8,
            child: _buildCornerDecoration(),
          ),
          Positioned(
            bottom: 8,
            right: 8,
            child: Transform.rotate(
              angle: math.pi,
              child: _buildCornerDecoration(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMysteryPattern() {
    return CustomPaint(
      size: Size(widget.width - 20, widget.height - 20),
      painter: _MysteryPatternPainter(
        color: MythicColors.bronze.withValues(alpha: 0.2),
      ),
    );
  }

  Widget _buildCornerDecoration() {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: MythicColors.bronze.withValues(alpha: 0.5)),
          left: BorderSide(color: MythicColors.bronze.withValues(alpha: 0.5)),
        ),
      ),
    );
  }

  Widget _buildCardFront() {
    final premise = widget.premise;

    Widget card = Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF2D2A4A),
            Color(0xFF1A1A2E),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.isSelected
              ? MythicColors.bronze
              : MythicColors.bronze.withValues(alpha: 0.5),
          width: widget.isSelected ? 3 : 2,
        ),
        boxShadow: [
          BoxShadow(
            color: widget.isSelected
                ? MythicColors.bronze.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.5),
            blurRadius: widget.isSelected ? 20 : 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Card image area
          Expanded(
            flex: 3,
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: MythicColors.bronze.withValues(alpha: 0.2),
                ),
              ),
              child: premise?.imageUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        premise!.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _buildPlaceholderImage(),
                      ),
                    )
                  : _buildPlaceholderImage(),
            ),
          ),

          // Title area
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    premise?.title.toUpperCase() ?? 'UNKNOWN',
                    style: GoogleFonts.cinzelDecorative(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: MythicColors.parchment,
                      letterSpacing: 1,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  if (premise != null)
                    Text(
                      '${premise.era} • ${premise.culture}',
                      style: GoogleFonts.exo2(
                        fontSize: 8,
                        color: MythicColors.stoneGray,
                        letterSpacing: 1,
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Vote indicator
          if (widget.hasVoted)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: MythicColors.bronze.withValues(alpha: 0.2),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(10),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.how_to_vote,
                    size: 12,
                    color: MythicColors.bronze,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'VOTED',
                    style: GoogleFonts.orbitron(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: MythicColors.bronze,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );

    // Add glow animation for selected cards
    if (widget.isSelected) {
      card = card.animate(onPlay: (c) => c.repeat(reverse: true)).custom(
            duration: const Duration(milliseconds: 1500),
            builder: (context, value, child) => DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: MythicColors.bronze
                        .withValues(alpha: 0.2 + (value * 0.2)),
                    blurRadius: 20 + (value * 10),
                    spreadRadius: value * 5,
                  ),
                ],
              ),
              child: child,
            ),
          );
    }

    return card;
  }

  Widget _buildPlaceholderImage() {
    return Center(
      child: Icon(
        Icons.auto_fix_high,
        size: 32,
        color: MythicColors.bronze.withValues(alpha: 0.4),
      ),
    );
  }
}

/// Custom painter for the mysterious back pattern
class _MysteryPatternPainter extends CustomPainter {
  _MysteryPatternPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);

    // Draw concentric circles
    for (var i = 1; i <= 3; i++) {
      canvas.drawCircle(center, size.width / 4 * i / 2, paint);
    }

    // Draw compass points
    final radius = size.width / 4;
    for (var i = 0; i < 8; i++) {
      final angle = i * math.pi / 4;
      canvas.drawLine(
        center,
        Offset(
          center.dx + radius * math.cos(angle),
          center.dy + radius * math.sin(angle),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
