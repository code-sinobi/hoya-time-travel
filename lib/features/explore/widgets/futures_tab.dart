import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/era_theme.dart';
import '../../community/presentation/premise_controller.dart';
import 'fate_card_carousel.dart';
import 'vote_progress_bar.dart';

class FuturesTab extends ConsumerStatefulWidget {
  const FuturesTab({super.key});

  @override
  ConsumerState<FuturesTab> createState() => _FuturesTabState();
}

class _FuturesTabState extends ConsumerState<FuturesTab> {
  // Track which cards have been revealed by the user in this session
  final Set<String> _revealedCards = {};

  @override
  Widget build(BuildContext context) {
    final premisesAsync = ref.watch(premiseControllerProvider);

    return ColoredBox(
      color: const Color(0xFF15151A),
      child: Column(
        children: [
          // Header Area
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.6),
                  Colors.transparent,
                ],
              ),
            ),
            child: Column(
              children: [
                SafeArea(
                  bottom: false,
                  child: Text(
                    'FATE CARDS',
                    style: GoogleFonts.cinzelDecorative(
                      fontSize: 28,
                      color: MythicColors.bronze,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        BoxShadow(
                          color: MythicColors.bronze.withValues(alpha: 0.3),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Choose the Next Thread',
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 16,
                    color: MythicColors.parchment.withValues(alpha: 0.8),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: premisesAsync.when(
              data: (premises) {
                if (premises.isEmpty) return _buildEmptyState();

                // Calculate total votes for progress bars
                final totalVotes =
                    premises.fold(0, (sum, p) => sum + p.voteCount);

                // Check if user has voted (mock logic: check if any premise is 'voted' in local state or model)
                // For now, assume no persistence of 'voted state' in model other than count,
                // but usually we'd check UserInteraction.
                // We'll track a local 'votedId' for session, or verify against something else if available.
                // Since Premise model doesn't have "hasVoted", we'll rely on local state or assume not voted.

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      // 1. Fate Card Carousel
                      FateCardCarousel(
                        premises: premises,
                        revealedCards: _revealedCards,
                        onCardTapped: (premise) {
                          setState(() {
                            _revealedCards.add(premise.id);
                          });
                        },
                        onVote: (premise) {
                          ref
                              .read(premiseControllerProvider.notifier)
                              .castVote(premise.id);
                          // We immediately reveal the voted card if not already
                          setState(() {
                            _revealedCards.add(premise.id);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Vote cast for ${premise.title}',
                                style: GoogleFonts.exo2(),
                              ),
                              backgroundColor: MythicColors.bronze,
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 40),

                      // 2. Voting Results (only show if at least one card revealed or voted)
                      if (_revealedCards.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: VotingResults(
                            totalVotes: totalVotes,
                            options: premises
                                .map(
                                  (p) => VoteOption(
                                    id: p.id,
                                    label: p.title.toUpperCase(),
                                    voteCount: p.voteCount,
                                    color: _getColorForEra(p.era),
                                  ),
                                )
                                .toList(),
                          )
                              .animate()
                              .fadeIn(delay: 300.ms)
                              .slideY(begin: 0.1, end: 0),
                        ),

                      const SizedBox(height: 40),
                    ],
                  ),
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(color: MythicColors.bronze),
              ),
              error: (e, s) => const Center(
                child: Text(
                  'The fates are unclear. Please try again.',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getColorForEra(String era) {
    switch (era.toUpperCase()) {
      case 'MYTHIC':
        return const Color(0xFFFFD700); // Gold
      case 'ANCIENT':
        return const Color(0xFFE6B17E); // Bronze
      case 'MEDIEVAL':
        return const Color(0xFF8B4513); // Brown
      case 'MODERN':
        return const Color(0xFF708090); // Slate
      case 'FUTURE':
        return const Color(0xFF00CED1); // Cyan
      default:
        return MythicColors.bronze;
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.hourglass_empty,
            size: 48,
            color: MythicColors.stoneGray.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'The Threads are Silent',
            style: GoogleFonts.cinzel(color: MythicColors.stoneGray),
          ),
        ],
      ),
    );
  }
}
