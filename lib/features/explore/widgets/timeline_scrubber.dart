import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/era_theme.dart';

class TimelineScrubber extends StatefulWidget {
  final String selectedEra;
  final ValueChanged<String> onEraChanged;

  const TimelineScrubber({
    super.key,
    required this.selectedEra,
    required this.onEraChanged,
  });

  @override
  State<TimelineScrubber> createState() => _TimelineScrubberState();
}

class _TimelineScrubberState extends State<TimelineScrubber> {
  final List<String> _eras = ['MYTHIC', 'MEDIEVAL', 'MODERN', 'FUTURE'];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      margin: const EdgeInsets.only(bottom: 24, left: 16, right: 16),
      child: Column(
        children: [
          // Scrubber Track
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Track Line
                Container(
                  height: 2,
                  width: double.infinity,
                  color: MythicColors.bronze.withValues(alpha: 0.3),
                ),

                // Era Points
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: _eras.map((era) {
                    final isSelected = widget.selectedEra == era;
                    return GestureDetector(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        widget.onEraChanged(era);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: isSelected ? 24 : 12,
                        height: isSelected ? 24 : 12,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? MythicColors.bronze
                              : MythicColors.voidBackground,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: MythicColors.bronze.withValues(
                              alpha: isSelected ? 1.0 : 0.5,
                            ),
                            width: 2,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: MythicColors.bronze.withValues(
                                      alpha: 0.5,
                                    ),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ]
                              : [],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          // Era Label
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              widget.selectedEra,
              key: ValueKey(widget.selectedEra),
              style: GoogleFonts.orbitron(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: MythicColors.bronze,
                letterSpacing: 4,
                shadows: [
                  BoxShadow(
                    color: MythicColors.bronze.withValues(alpha: 0.5),
                    blurRadius: 10,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
