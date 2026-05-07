import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/era_theme.dart';
import '../../community/domain/domain.dart';
import 'fate_card.dart';

/// A horizontal carousel of fate cards for voting on possible futures.
/// Shows 3 cards at a time with the center card enlarged.
class FateCardCarousel extends StatefulWidget {
  const FateCardCarousel({
    required this.premises,
    super.key,
    this.votedPremiseId,
    this.onCardTapped,
    this.onVote,
    this.revealedCards = const {},
  });

  /// List of story premises to display as cards
  final List<StoryPremise> premises;

  /// ID of the premise the user has voted for
  final String? votedPremiseId;

  /// Callback when a card is tapped
  final ValueChanged<StoryPremise>? onCardTapped;

  /// Callback when user casts a vote
  final ValueChanged<StoryPremise>? onVote;

  /// Set of revealed card IDs
  final Set<String> revealedCards;

  @override
  State<FateCardCarousel> createState() => _FateCardCarouselState();
}

class _FateCardCarouselState extends State<FateCardCarousel> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.4,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Card carousel
        SizedBox(
          height: 240,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (page) => setState(() => _currentPage = page),
            itemCount: widget.premises.length,
            itemBuilder: (context, index) {
              final premise = widget.premises[index];
              final isCenter = index == _currentPage;
              final isRevealed = widget.revealedCards.contains(premise.id);
              final hasVoted = widget.votedPremiseId == premise.id;

              return AnimatedScale(
                scale: isCenter ? 1.0 : 0.85,
                duration: const Duration(milliseconds: 200),
                child: AnimatedOpacity(
                  opacity: isCenter ? 1.0 : 0.7,
                  duration: const Duration(milliseconds: 200),
                  child: Center(
                    child: FateCard(
                      premise: isRevealed ? premise : null,
                      isRevealed: isRevealed,
                      isSelected: isCenter,
                      hasVoted: hasVoted,
                      onTap: () => widget.onCardTapped?.call(premise),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 16),

        // Page indicators
        _buildPageIndicators(),

        const SizedBox(height: 20),

        // Vote button for current card
        if (widget.premises.isNotEmpty && _currentPage < widget.premises.length)
          _buildVoteButton(widget.premises[_currentPage]),
      ],
    );
  }

  Widget _buildPageIndicators() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          widget.premises.length,
          (index) => AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: index == _currentPage ? 24 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: index == _currentPage
                  ? MythicColors.bronze
                  : MythicColors.bronze.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVoteButton(StoryPremise premise) {
    final hasVotedForThis = widget.votedPremiseId == premise.id;
    final isRevealed = widget.revealedCards.contains(premise.id);

    if (!isRevealed) {
      return Text(
        'Tap to reveal this future',
        style: GoogleFonts.cormorantGaramond(
          fontSize: 14,
          fontStyle: FontStyle.italic,
          color: MythicColors.stoneGray,
        ),
      );
    }

    if (hasVotedForThis) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, size: 18, color: MythicColors.bronze),
          const SizedBox(width: 8),
          Text(
            'You voted for this future',
            style: GoogleFonts.exo2(
              fontSize: 13,
              color: MythicColors.bronze,
            ),
          ),
        ],
      ).animate().fadeIn().scale(begin: const Offset(0.9, 0.9));
    }

    if (widget.votedPremiseId != null) {
      return Text(
        'Vote already cast',
        style: GoogleFonts.exo2(
          fontSize: 13,
          color: MythicColors.stoneGray.withValues(alpha: 0.7),
        ),
      );
    }

    return ElevatedButton.icon(
      icon: const Icon(Icons.how_to_vote, size: 18),
      label: Text(
        'CAST VOTE',
        style: GoogleFonts.orbitron(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: MythicColors.bronze,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: () => widget.onVote?.call(premise),
    ).animate().fadeIn(duration: 300.ms).shimmer(
          duration: 2.seconds,
          color: Colors.white.withValues(alpha: 0.2),
        );
  }
}
