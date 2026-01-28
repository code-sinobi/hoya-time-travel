import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/story_models.dart';
import '../repositories/story_repository.dart';

part 'story_service.g.dart';

@riverpod
class StoryService extends _$StoryService {
  @override
  void build() {
    // No local state needed yet
  }

  Future<StoryNode> loadNode(String storyId, String nodeId) async {
    final repo = ref.read(storyRepositoryProvider);

    // Resolve "start" to the actual start node ID convention
    final targetId = nodeId == 'start' ? '${storyId}_start' : nodeId;

    try {
      final node = await repo.getStoryNode(targetId);

      if (node == null) {
        return _errorNode('Node not found: $targetId');
      }

      // Save progress to Supabase
      // In a real app, you might want to debounce this or do it in background
      repo.saveProgress(
        storyId: storyId,
        currentNodeId: node.id,
        isCompleted: node.type == NodeType.ending,
      );

      return node;
    } catch (e) {
      debugPrint('Story Load Failed: $e');
      return _errorNode('Error retrieving story: $e');
    }
  }

  StoryNode _errorNode(String message) {
    return StoryNode(
      id: 'error',
      type: NodeType.choice,
      content: 'The scrolls are faded here... \n($message)',
      choices: [
        StoryChoice(id: 'back', text: 'Return to Portal', nextNodeId: null),
      ],
    );
  }
}
