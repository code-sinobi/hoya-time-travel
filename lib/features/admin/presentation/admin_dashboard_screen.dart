import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/era_theme.dart';
import '../data/community_repository.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingAsync = ref.watch(pendingSnippetsProvider);

    return Scaffold(
      backgroundColor: MythicColors.voidBackground,
      appBar: AppBar(
        title: Text(
          'ADMIN: TEMPORAL CURATION',
          style: GoogleFonts.orbitron(
            color: MythicColors.bronze,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Stats row or filter row here...
          Expanded(
            child: pendingAsync.when(
              data: (snippets) {
                if (snippets.isEmpty) {
                  return Center(
                    child: Text(
                      'No snippets pending curation.',
                      style: GoogleFonts.cinzel(color: MythicColors.stoneGray),
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: snippets.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    return _SnippetCurationCard(snippet: snippets[index]);
                  },
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(color: MythicColors.bronze),
              ),
              error: (err, st) => const Center(
                child: Text(
                  'Something went wrong. Please try again.',
                  style: TextStyle(color: MythicColors.ochreRed),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SnippetCurationCard extends StatelessWidget {
  final dynamic snippet;

  const _SnippetCurationCard({required this.snippet});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withValues(alpha: 0.05),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    snippet.userId.length >= 8
                        ? snippet.userId.substring(0, 8).toUpperCase()
                        : snippet.userId.toUpperCase(),
                    style: GoogleFonts.spaceMono(
                      color: MythicColors.stoneGray,
                      fontSize: 10,
                    ),
                  ),
                ),
                Text(
                  snippet.eraId,
                  style: GoogleFonts.shareTechMono(
                    color: MythicColors.bronze,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              snippet.content,
              style: GoogleFonts.exo2(color: MythicColors.parchment),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Flexible(
                  child: Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: (snippet.tags as List)
                        .map(
                          (tag) => Chip(
                            label: Text(
                              tag.toString(),
                              style: const TextStyle(fontSize: 10),
                            ),
                            backgroundColor: Colors.white10,
                          ),
                        )
                        .toList(),
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.check_circle, color: Colors.green),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.cancel, color: MythicColors.ochreRed),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
