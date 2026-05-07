import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/era_theme.dart';
import '../data/chronicler_repository.dart';

class ChroniclerDashboardScreen extends ConsumerWidget {
  const ChroniclerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storiesAsync = ref.watch(chroniclerStoriesProvider);

    return Scaffold(
      backgroundColor: MythicColors.voidBackground,
      appBar: AppBar(
        title: Text(
          'CHRONICLER VAULT',
          style: GoogleFonts.cinzel(
            color: MythicColors.bronze,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: storiesAsync.when(
              data: (stories) {
                if (stories.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.history_edu,
                          size: 64,
                          color: Colors.white10,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No stories pinned yet.',
                          style: GoogleFonts.exo2(
                            color: MythicColors.stoneGray,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: stories.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final story = stories[index];
                    return _StoryDraftCard(story: story);
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
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: MythicColors.bronze,
        foregroundColor: Colors.black,
        icon: const Icon(Icons.add),
        label: Text(
          'START NEW THREAD',
          style: GoogleFonts.orbitron(fontWeight: FontWeight.bold),
        ),
        onPressed: () => _showCreateDialog(context, ref),
      ),
    );
  }

  void _showCreateDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E2C),
        title: Text(
          'NEW STORY THREAD',
          style: GoogleFonts.cinzel(color: MythicColors.bronze),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Story Title...',
            hintStyle: TextStyle(color: Colors.white24),
          ),
        ),
        actions: [
          TextButton(
            child: const Text('CANCEL'),
            onPressed: () {
              Navigator.pop(ctx);
              controller.dispose();
            },
          ),
          ElevatedButton(
            child: const Text('CREATE'),
            onPressed: () async {
              if (controller.text.trim().isEmpty) return;
              try {
                final id = await ref
                    .read(chroniclerRepositoryProvider)
                    .createStory(controller.text.trim());
                if (ctx.mounted) {
                  Navigator.pop(ctx);
                  controller.dispose();
                  context.push('/chronicler/story/$id');
                }
              } catch (e) {
                if (ctx.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Failed to create story. Try again.'),
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}

class _StoryDraftCard extends StatelessWidget {
  final dynamic story;

  const _StoryDraftCard({required this.story});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withValues(alpha: 0.05),
      child: ListTile(
        title: Text(
          story.title,
          style: GoogleFonts.exo2(
            color: MythicColors.parchment,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          'Last modified: ${story.createdAt}',
          style: const TextStyle(
            color: MythicColors.stoneGray,
            fontSize: 10,
          ),
        ),
        trailing: const Icon(Icons.edit, color: MythicColors.bronze, size: 18),
        onTap: () => context.push('/chronicler/story/${story.id}'),
      ),
    );
  }
}
