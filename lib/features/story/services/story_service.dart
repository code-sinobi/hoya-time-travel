import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/ai/openrouter_service.dart';
import '../../../core/utils/logger.dart';
import '../models/story_models.dart';
import '../repositories/story_repository.dart';

part 'story_service.g.dart';

@Riverpod(keepAlive: true)
StoryService storyService(Ref ref) {
  return StoryService(ref);
}

class StoryService {
  StoryService(this._ref);
  final Ref _ref;

  Future<StoryNode> loadNode(String storyId, String nodeId) async {
    final repo = _ref.read(storyRepositoryProvider);

    // Resolve "start" to the actual start node ID convention
    final targetId = nodeId == 'start' ? '${storyId}_start' : nodeId;

    try {
      final node = await repo.getStoryNode(targetId);

      if (node == null) {
        AppLogger.warning(
          'Node $targetId not found. Triggering AI generation.',
        );
        try {
          final ai = _ref.read(openRouterServiceProvider);
          final response = await ai.generateContent(
            'You are an interactive storyteller. Output ONLY valid JSON containing "content" (string, the narrative text) and "choices" (array of objects, each with "text" and "next_node_id" strings).',
            'The user has reached an undocumented path in story "$storyId" at node "$targetId". Create a compelling continuation of the narrative with 2 choices.',
          );

          return StoryNode(
            id: targetId,
            type: NodeType.choice,
            content: response['content'] as String? ??
                'The tapestry of time weaves a new path...',
            choices: (response['choices'] as List?)?.map((c) {
                  final cMap = c as Map<String, dynamic>;
                  return StoryChoice(
                    id: 'ai_${DateTime.now().millisecondsSinceEpoch}',
                    text: cMap['text'] as String? ?? 'Step forward',
                    nextNodeId:
                        cMap['next_node_id'] as String? ?? '${targetId}_next',
                  );
                }).toList() ??
                [
                  StoryChoice(
                    id: 'ai_fallback',
                    text: 'Continue',
                    nextNodeId: '${targetId}_next',
                  ),
                ],
          );
        } on Object catch (aiError) {
          AppLogger.error('AI Fallback Failed', error: aiError);
          return _errorNode(
            'Node not found: $targetId\n(AI generation also failed)',
          );
        }
      }

      // Save progress to Supabase
      unawaited(
        repo.saveProgress(
          storyId: storyId,
          currentNodeId: node.id,
          isCompleted: node.type == NodeType.ending,
        ),
      );

      return node;
    } on Object catch (e, st) {
      AppLogger.error('Story Load Failed', error: e, stackTrace: st);
      return _errorNode('Error retrieving story: $e');
    }
  }

  StoryNode _errorNode(String message) {
    return StoryNode(
      id: 'error',
      type: NodeType.choice,
      content: 'The scrolls are faded here... \n($message)',
      choices: [
        StoryChoice(id: 'back', text: 'Return to Portal'),
      ],
    );
  }
}
