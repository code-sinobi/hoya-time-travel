import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_progress.dart';
import '../models/story_models.dart';
import '../../../core/utils/logger.dart';

part 'story_repository.g.dart';

@Riverpod(keepAlive: true)
StoryRepository storyRepository(Ref ref) {
  return StoryRepository(Supabase.instance.client);
}

@riverpod
Future<List<UserProgress>> allUserProgress(Ref ref) {
  return ref.watch(storyRepositoryProvider).getAllProgress();
}

/// Provider that returns a Set of completed story IDs for quick lookup
@riverpod
Future<Set<String>> completedStoryIds(Ref ref) async {
  final progress = await ref.watch(allUserProgressProvider.future);
  return progress.where((p) => p.isCompleted).map((p) => p.storyId).toSet();
}

class StoryRepository {
  final SupabaseClient _client;

  StoryRepository(this._client);

  Future<UserProgress?> getProgress(String storyId) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return null;

    try {
      final response = await _client
          .from('user_progress')
          .select()
          .eq('user_id', userId)
          .eq('story_id', storyId)
          .maybeSingle();

      if (response == null) return null;
      return UserProgress.fromJson(response);
    } catch (e) {
      // If table doesn't exist or other error, return null to fail gracefully
      return null;
    }
  }

  Future<void> saveProgress({
    required String storyId,
    required String currentNodeId,
    bool isCompleted = false,
  }) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return;

    final data = {
      'user_id': userId,
      'story_id': storyId,
      'current_node_id': currentNodeId,
      'is_completed': isCompleted,
      'last_played_at': DateTime.now().toIso8601String(),
    };

    try {
      await _client
          .from('user_progress')
          .upsert(data, onConflict: 'user_id,story_id');
    } catch (e) {
      // Handle error (e.g. table missing)
      AppLogger.error(
        'Error saving progress',
        error: e,
        data: {'storyId': storyId},
      );
    }
  }

  Future<List<UserProgress>> getAllProgress() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return [];

    try {
      final response = await _client
          .from('user_progress')
          .select()
          .eq('user_id', userId);

      return (response as List).map((e) => UserProgress.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<StoryNode?> getStoryNode(String nodeId) async {
    try {
      // Fetch node
      final nodeResponse = await _client
          .from('story_nodes')
          .select()
          .eq('id', nodeId)
          .single();

      // Fetch choices for this node
      final choicesResponse = await _client
          .from('story_choices')
          .select()
          .eq('node_id', nodeId);

      final choices = (choicesResponse as List)
          .map((e) => StoryChoice.fromJson(e))
          .toList();

      final node = StoryNode.fromJson(nodeResponse);
      // Combine them (copy with choices)
      return StoryNode(
        id: node.id,
        type: node.type,
        content: node.content,
        backgroundImage: node.backgroundImage,
        choices: choices,
      );
    } catch (e) {
      AppLogger.error('Error fetching node $nodeId', error: e);
      return null;
    }
  }
}
