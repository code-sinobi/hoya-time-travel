import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/era_theme.dart';
import '../../story/models/story_models.dart';
import '../data/chronicler_repository.dart';

class ChroniclerDashboardScreen extends ConsumerWidget {
  const ChroniclerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myStoriesAsync = ref.watch(myStoriesProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF15151A),
      appBar: AppBar(
        title: Text(
          'CHRONICLER CELL',
          style: GoogleFonts.cinzel(color: MythicColors.parchment),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: MythicColors.bronze),
            onPressed: () => _showCreateDialog(context, ref),
          ),
        ],
      ),
      body: myStoriesAsync.when(
        data: (stories) => stories.isEmpty
            ? _buildEmptyState(context, ref)
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: stories.length,
                itemBuilder: (context, index) => _StoryDraftCard(
                  story: stories[index],
                ),
              ),
        loading: () => const Center(
          child: CircularProgressIndicator(color: MythicColors.bronze),
        ),
        error: (e, s) => Center(
          child: Text(
            'Failed to load your threads. Please try again.',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.history_edu, size: 64, color: Colors.white12),
          const SizedBox(height: 16),
          Text(
            'NO THREADS WOVEN YET',
            style: GoogleFonts.orbitron(color: Colors.white38),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => _showCreateDialog(context, ref),
            child: const Text('START NEW STORY'),
          ),
        ],
      ),
    );
  }

  void _showCreateDialog(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    String selectedEra = 'MYTHIC';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: const Color(0xFF1E1E2C),
          title: Text(
            'NEW TIMELINE THREAD',
            style: GoogleFonts.cinzel(color: MythicColors.bronze, fontSize: 18),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Story Title',
                  labelStyle: TextStyle(color: Colors.white54),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButton<String>(
                value: selectedEra,
                dropdownColor: const Color(0xFF2A2A35),
                isExpanded: true,
                items: ['MYTHIC', 'ANCIENT', 'MODERN']
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e, style: const TextStyle(color: Colors.white)),
                        ))
                    .toList(),
                onChanged: (val) => setDialogState(() => selectedEra = val!),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('CANCEL', style: TextStyle(color: Colors.white38)),
            ),
            ElevatedButton(
              onPressed: () async {
                final repo = ref.read(chroniclerRepositoryProvider);
                try {
                  final story = await repo.createStory(
                    title: titleController.text,
                    eraId: selectedEra,
                  );
                  if (context.mounted) {
                    Navigator.pop(ctx);
                    context.push('/chronicler/story/${story.id}');
                  }
                } catch (e) {
                  // error handled by snackbar usually
                }
              },
              child: const Text('CREATE'),
            ),
          ],
        ),
      ),
    ).then((_) => titleController.dispose());
  }
}

class _StoryDraftCard extends StatelessWidget {
  final Story story;

  const _StoryDraftCard({required this.story});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withValues(alpha: 0.05),
      margin: const EdgeInsets.bottom(12),
      child: ListTile(
        onTap: () => context.push('/chronicler/story/${story.id}'),
        title: Text(
          story.title,
          style: GoogleFonts.cinzel(
            color: MythicColors.parchment,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          '${story.eraId} • ${story.isPublished ? "PUBLISHED" : "DRAFT"}',
          style: const TextStyle(color: Colors.white54),
        ),
        trailing: const Icon(Icons.chevron_right, color: MythicColors.bronze),
      ),
    );
  }
}
