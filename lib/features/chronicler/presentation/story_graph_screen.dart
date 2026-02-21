import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/era_theme.dart';
import '../../../core/widgets/galactic_background.dart';
import '../../story/models/story_models.dart';
import '../data/chronicler_repository.dart';

// State provider for the list of nodes
final storyNodesProvider =
    FutureProvider.family<List<StoryNode>, String>((ref, storyId) {
  return ref.watch(chroniclerRepositoryProvider).fetchNodesForStory(storyId);
});

class StoryGraphScreen extends ConsumerWidget {
  final String storyId;
  final String storyTitle;

  const StoryGraphScreen({
    super.key,
    required this.storyId,
    required this.storyTitle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nodesAsync = ref.watch(storyNodesProvider(storyId));

    return Scaffold(
      backgroundColor: MythicColors.voidBackground,
      appBar: AppBar(
        title: Text(
          storyTitle,
          style: GoogleFonts.cinzel(
            color: MythicColors.parchment,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: MythicColors.bronze),
            onPressed: () => ref.refresh(storyNodesProvider(storyId)),
          ),
        ],
      ),
      body: Stack(
        children: [
          const GalacticBackground(showStars: false),
          nodesAsync.when(
            data: (nodes) {
              if (nodes.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.hub,
                        size: 60,
                        color: MythicColors.stoneGray,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No nodes created yet.',
                        style: GoogleFonts.cinzel(color: Colors.white70),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Start your journey.',
                        style: GoogleFonts.exo2(color: Colors.white38),
                      ),
                    ],
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: nodes.length,
                itemBuilder: (context, index) {
                  return _NodeTile(node: nodes[index], storyId: storyId);
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => Center(
              child: Text(
                'Error: $e',
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: MythicColors.bronze,
        foregroundColor: Colors.black,
        icon: const Icon(Icons.add_circle),
        label: const Text('ADD NODE'),
        onPressed: () {
          context.push('/chronicler/story/$storyId/node/new');
        },
      ),
    );
  }
}

class _NodeTile extends StatelessWidget {
  final StoryNode node;
  final String storyId;

  const _NodeTile({required this.node, required this.storyId});

  @override
  Widget build(BuildContext context) {
    Color typeColor = Colors.white54;
    IconData typeIcon = Icons.article;

    switch (node.type) {
      case NodeType.choice:
        typeColor = Colors.amber;
        typeIcon = Icons.alt_route;
        break;
      case NodeType.ending:
        typeColor = Colors.redAccent;
        typeIcon = Icons.flag;
        break;
      case NodeType.narrative:
      default:
        typeColor = Colors.blueGrey;
        typeIcon = Icons.article;
        break;
    }

    return Card(
      color: const Color(0xFF1E1E2C),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(typeIcon, color: typeColor),
        title: Text(
          node.content.replaceAll('\n', ' ').substring(
                0,
                (node.content.length > 50 ? 50 : node.content.length),
              ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          '${node.type.name.toUpperCase()}${node.isRoot ? " \u2022 ROOT" : ""}',
          style: TextStyle(color: typeColor, fontSize: 10),
        ),
        trailing: const Icon(Icons.edit, size: 16, color: Colors.white24),
        onTap: () {
          context.push('/chronicler/story/$storyId/node/${node.id}');
        },
      ),
    );
  }
}
