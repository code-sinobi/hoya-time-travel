import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/era_theme.dart';

/// Animated progress bar showing vote percentages for a future option.
/// Features gradient fill, vote count animation, and winner highlighting.
class VoteProgressBar extends StatelessWidget {
  const VoteProgressBar({
    required this.label,
    required this.percentage,
    required this.voteCount,
    super.key,
    this.isWinning = false,
    this.icon,
    this.color = const Color(0xFFD4AF37), // Gold
    this.animate = true,
  });

  /// Label for this option (e.g., "PROMETHEUS RETURNS")
  final String label;

  /// Current vote percentage (0.0 - 1.0)
  final double percentage;

  /// Total vote count for this option
  final int voteCount;

  /// Whether this is currently the winning option
  final bool isWinning;

  /// Optional icon to display
  final IconData? icon;

  /// Primary color for this option
  final Color color;

  /// Whether to animate the bar on build
  final bool animate;

  @override
  Widget build(BuildContext context) {
    Widget bar = Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isWinning
              ? color.withValues(alpha: 0.5)
              : MythicColors.stoneGray.withValues(alpha: 0.2),
          width: isWinning ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label row
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 16, color: color),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.orbitron(
                    fontSize: 11,
                    fontWeight: isWinning ? FontWeight.bold : FontWeight.normal,
                    color: isWinning ? color : Colors.white70,
                    letterSpacing: 1,
                  ),
                ),
              ),
              if (isWinning)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'LEADING',
                    style: GoogleFonts.shareTechMono(
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 8),

          // Progress bar
          Stack(
            children: [
              // Background
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),

              // Filled portion
              FractionallySizedBox(
                widthFactor: percentage.clamp(0.0, 1.0),
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        color.withValues(alpha: 0.7),
                        color,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: isWinning
                        ? [
                            BoxShadow(
                              color: color.withValues(alpha: 0.4),
                              blurRadius: 6,
                            ),
                          ]
                        : null,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // Vote count and percentage
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$voteCount votes',
                style: GoogleFonts.exo2(
                  fontSize: 10,
                  color: MythicColors.stoneGray,
                ),
              ),
              Text(
                '${(percentage * 100).toStringAsFixed(0)}%',
                style: GoogleFonts.shareTechMono(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isWinning ? color : Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
    );

    if (animate) {
      bar = bar
          .animate()
          .fadeIn(duration: 400.ms)
          .slideX(begin: -0.1, end: 0, duration: 400.ms);
    }

    // Add pulse effect for winning option
    if (isWinning) {
      bar = bar.animate(onPlay: (c) => c.repeat(reverse: true)).custom(
            duration: const Duration(milliseconds: 2000),
            builder: (context, value, child) => DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.1 + (value * 0.1)),
                    blurRadius: 10 + (value * 5),
                    spreadRadius: value * 2,
                  ),
                ],
              ),
              child: child,
            ),
          );
    }

    return bar;
  }
}

/// A collection of vote progress bars for multiple options
class VotingResults extends StatelessWidget {
  const VotingResults({
    required this.options,
    required this.totalVotes,
    super.key,
  });
  final List<VoteOption> options;
  final int totalVotes;

  @override
  Widget build(BuildContext context) {
    // Find the winning option
    final maxVotes = options.isEmpty
        ? 0
        : options.map((o) => o.voteCount).reduce((a, b) => a > b ? a : b);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'VOTING OPTIONS',
              style: GoogleFonts.orbitron(
                fontSize: 12,
                color: MythicColors.stoneGray,
                letterSpacing: 2,
              ),
            ),
            Text(
              '$totalVotes total votes',
              style: GoogleFonts.shareTechMono(
                fontSize: 11,
                color: MythicColors.bronze,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Progress bars
        ...options.asMap().entries.map((entry) {
          final option = entry.value;
          final percentage =
              totalVotes > 0 ? option.voteCount / totalVotes : 0.0;

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: VoteProgressBar(
              label: option.label,
              percentage: percentage,
              voteCount: option.voteCount,
              isWinning: option.voteCount == maxVotes && maxVotes > 0,
              icon: option.icon,
              color: option.color,
            ),
          );
        }),
      ],
    );
  }
}

/// Data class for a voting option
class VoteOption {
  const VoteOption({
    required this.id,
    required this.label,
    required this.voteCount,
    this.icon,
    this.color = const Color(0xFFD4AF37),
  });
  final String id;
  final String label;
  final int voteCount;
  final IconData? icon;
  final Color color;
}
