import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/era_theme.dart';
import '../../../core/widgets/galactic_background.dart';
import '../../story/models/story_models.dart';
import 'chronicler_controller.dart';

class ChroniclerDashboardScreen extends ConsumerWidget {
  const ChroniclerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myStoriesAsync = ref.watch(chroniclerControllerProvider);

    return Scaffold(
      backgroundColor: MythicColors.voidBackground,
      appBar: AppBar(
        title: Text(
          'CHRONICLER\'S DESK',
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
          myStoriesAsync.when(
            data: (stories) {
              if (stories.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.edit_note,
                        size: 60,
                        color: MythicColors.stoneGray,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'The page is blank.',
                        style: GoogleFonts.cinzel(
                          color: MythicColors.stoneGray,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Begin your first chronicle.',
                        style: GoogleFonts.exo2(color: Colors.white54),
                      ),
                    ],
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: stories.length,
                itemBuilder: (context, index) {
                  return _StoryDraftCard(story: stories[index]);
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
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: MythicColors.bronze,
        foregroundColor: Colors.black,
        icon: const Icon(Icons.history_edu),
        label: const Text('NEW STORY'),
        onPressed: () => _showCreateDialog(context, ref),
      ),
    );
  }

  void _showCreateDialog(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    String selectedEra = 'MYTHIC';
    // Simplified dialog for MVP
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E2C),
        title: Text(
          'New Chronicle',
          style: GoogleFonts.cinzel(
            color: MythicColors.parchment,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white30,
                  ),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: selectedEra,
              dropdownColor: const Color(0xFF2A2A35),
              items: [
                'MYTHIC',
                'ANCIENT',
                'MEDIEVAL',
                'INDUSTRIAL',
                'MODERN',
                'FUTURE',
              ]
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(
                        e,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (v) {
                if (v != null) selectedEra = v;
              },
              decoration: const InputDecoration(
                labelText: 'Era',
                labelStyle: TextStyle(
                  color: Colors.white70,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            style:
                ElevatedButton.styleFrom(backgroundColor: MythicColors.bronze),
            onPressed: () {
              final title = titleController.text.trim();
              if (title.isEmpty) return;
              ref.read(chroniclerControllerProvider.notifier).createStory(
                    title: title,
                    eraId: selectedEra,
                    culture: 'Unknown', // Default for now
                    theme: 'Adventure', // Default
                  ).then((_) {
                if (context.mounted) context.pop();
              }).catchError((e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to create story')),
                  );
                }
              });
            },
            child: const Text('CREATE', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    ).then((_) => titleController.dispose());
  }
}

class _StoryDraftCard extends StatelessWidget {
  const _StoryDraftCard({required this.story});
  final Story story;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1E1E2C),
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        title: Text(
          story.title,
          style: GoogleFonts.cinzel(
            color: MythicColors.parchment,
          ),
        ),
        subtitle: Text(
          '${story.eraId} • ${story.isPublished ? "PUBLISHED" : "DRAFT"}',
          style: const TextStyle(color: Colors.white54),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.white54),
        onTap: () {
          // Navigate to editor
          context.push(
            '/chronicler/story/${story.id}?title=${Uri.encodeComponent(story.title)}',
          );
        },
      ),
    );
  }
}
