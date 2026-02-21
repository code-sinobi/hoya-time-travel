import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/era_theme.dart';
import '../../story/models/story_models.dart';
import '../data/admin_repository.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snippetsAsync = ref.watch(pendingSnippetsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF15151A),
      appBar: AppBar(
        title: Text(
          'CHRONOS ADMIN',
          style: GoogleFonts.orbitron(
            color: MythicColors.bronze,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: snippetsAsync.when(
        data: (snippets) => snippets.isEmpty
            ? _buildEmptyState()
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: snippets.length,
                itemBuilder: (context, index) => _SnippetCurationCard(
                  snippet: snippets[index],
                ),
              ),
        loading: () => const Center(
          child: CircularProgressIndicator(color: MythicColors.bronze),
        ),
        error: (e, s) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              const Text(
                'ADMIN SYSTEM OFFLINE',
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Check temporal connection.',
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(pendingSnippetsProvider),
                child: const Text('RETRY'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.auto_awesome,
            size: 64,
            color: MythicColors.bronze.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'THE TIMELINE IS STABLE',
            style: GoogleFonts.cinzel(
              color: MythicColors.parchment,
              fontSize: 18,
            ),
          ),
          const Text(
            'No pending snippets for review.',
            style: TextStyle(color: Colors.white38),
          ),
        ],
      ),
    );
  }
}

class _SnippetCurationCard extends ConsumerWidget {
  final CommunitySnippet snippet;

  const _SnippetCurationCard({required this.snippet});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      color: const Color(0xFF1E1E2C),
      margin: const EdgeInsets.bottom(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: MythicColors.bronze.withValues(alpha: 0.2),
        ),
      ),
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
                  snippet.eraId.toUpperCase(),
                  style: const TextStyle(
                    color: MythicColors.bronze,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              snippet.content,
              style: GoogleFonts.cormorantGaramond(
                fontSize: 18,
                color: MythicColors.parchment,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 12),
            Flexible(
              child: Wrap(
                spacing: 4,
                runSpacing: 4,
                children: snippet.tags
                    .map(
                      (tag) => Chip(
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
                    )
                    .toList(),
              ),
            ),
            const Divider(color: Colors.white10, height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () {
                    ref
                        .read(adminRepositoryProvider)
                        .updateSnippetStatus(snippet.id, 'rejected');
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.redAccent,
                    side: const BorderSide(color: Colors.redAccent),
                  ),
                  child: const Text('REJECT'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    ref
                        .read(adminRepositoryProvider)
                        .updateSnippetStatus(snippet.id, 'approved');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MythicColors.bronze,
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('APPROVE'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
