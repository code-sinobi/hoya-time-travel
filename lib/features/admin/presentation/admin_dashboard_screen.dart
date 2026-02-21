import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/era_theme.dart';
import '../../../core/widgets/galactic_background.dart';
import '../../community/domain/domain.dart';
import 'admin_snippet_controller.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingSnippets = ref.watch(adminSnippetControllerProvider);

    return Scaffold(
      backgroundColor: MythicColors.voidBackground,
      appBar: AppBar(
        title: Text(
          'NARRATIVE ORCHESTRATOR',
          style: GoogleFonts.cinzel(color: MythicColors.bronze),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: MythicColors.bronze),
          onPressed: () => context.pop(),
        ),
      ),
      body: Stack(
        children: [
          const GalacticBackground(showStars: false),
          pendingSnippets.when(
            data: (snippets) {
              if (snippets.isEmpty) {
                return Center(
                  child: Text(
                    'The Void is silent.',
                    style: GoogleFonts.cinzel(
                      color: MythicColors.stoneGray,
                      fontSize: 18,
                    ),
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: snippets.length,
                itemBuilder: (context, index) {
                  return _SnippetCurationCard(snippet: snippets[index]);
                },
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(color: MythicColors.bronze),
            ),
            error: (err, st) => Center(
              child: Text(
                'Error: $err',
                style: const TextStyle(color: MythicColors.ochreRed),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SnippetCurationCard extends ConsumerWidget {
  final Snippet snippet;

  const _SnippetCurationCard({required this.snippet});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      color: const Color(0xFF1E1E2C),
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: MythicColors.bronze.withValues(alpha: 0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User ID + Tags
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    snippet.userId.substring(0, 8).toUpperCase(),
                    style: GoogleFonts.spaceMono(
                      color: MythicColors.stoneGray,
                      fontSize: 10,
                    ),
                  ),
                ),
                const Spacer(),
                ...snippet.tags.map(
                  (tag) => Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Chip(
                      label: Text(
                        tag.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 10,
                          color: MythicColors.bronze,
                        ),
                      ),
                      backgroundColor:
                          MythicColors.bronze.withValues(alpha: 0.1),
                      padding: EdgeInsets.zero,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Content
            Text(
              snippet.content,
              style: GoogleFonts.cormorantGaramond(
                fontSize: 18,
                color: MythicColors.parchment,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 16),

            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.close, color: MythicColors.ochreRed),
                  label: const Text(
                    'REJECT',
                    style: TextStyle(
                      color: MythicColors.ochreRed,
                    ),
                  ),
                  onPressed: () {
                    ref
                        .read(adminSnippetControllerProvider.notifier)
                        .rejectSnippet(snippet.id);
                  },
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  icon: const Icon(Icons.check, size: 18),
                  label: const Text('APPROVE'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MythicColors.bronze,
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () {
                    ref
                        .read(adminSnippetControllerProvider.notifier)
                        .approveSnippet(snippet.id);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
