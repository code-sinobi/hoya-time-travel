import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/era_theme.dart';
import 'echoes_controller.dart';

class EchoesSheet extends ConsumerWidget {
  const EchoesSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final echoesAsync = ref.watch(echoesControllerProvider);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Color(0xFF15151A),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: MythicColors.stoneGray.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'MEMORY ARCHIVE',
            style: GoogleFonts.cinzelDecorative(
              fontSize: 20,
              color: MythicColors.bronze,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Echoes of your journey across time.',
            style: GoogleFonts.cormorantGaramond(
              fontSize: 16,
              color: MythicColors.parchment.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: echoesAsync.when(
              data: (echoes) {
                if (echoes.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.hourglass_empty,
                          size: 48,
                          color: MythicColors.stoneGray.withValues(
                            alpha: 0.3,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No echoes yet recorded.',
                          style: GoogleFonts.cormorantGaramond(
                            fontSize: 18,
                            color: MythicColors.stoneGray,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: echoes.length,
                  separatorBuilder: (c, i) => Divider(
                    color: MythicColors.bronze.withValues(alpha: 0.1),
                  ),
                  itemBuilder: (context, index) {
                    final echo = echoes[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: MythicColors.deepIndigo.withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: MythicColors.bronze.withValues(
                              alpha: 0.3,
                            ),
                          ),
                        ),
                        child: const Icon(
                          Icons.auto_awesome,
                          color: MythicColors.bronze,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        _formatTag(echo.echoTag),
                        style: GoogleFonts.cinzel(
                          color: MythicColors.parchment,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        echo.description,
                        style: GoogleFonts.cormorantGaramond(
                          color: MythicColors.stoneGray,
                          fontSize: 14,
                        ),
                      ),
                      trailing: Text(
                        DateFormat('MMM d').format(echo.earnedAt),
                        style: GoogleFonts.spaceMono(
                          color: MythicColors.stoneGray.withValues(alpha: 0.5),
                          fontSize: 10,
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(
                  color: MythicColors.bronze,
                ),
              ),
              error: (err, stack) => Center(
                child: Text(
                  'Error: $err',
                  style: const TextStyle(
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

  String _formatTag(String tag) {
    return tag
        .split('_')
        .map(
          (word) => word.isEmpty
              ? ''
              : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}',
        )
        .join(' ');
  }
}
