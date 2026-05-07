import 'package:supabase_flutter/supabase_flutter.dart';

class StoryImporterService {
  StoryImporterService(this._supabase);
  final SupabaseClient _supabase;

  /// Imports a full story structure including nodes and choices from a JSON map.
  /// Expects JSON structure:
  /// {
  ///   "story": { ...story fields... },
  ///   "nodes": [
  ///     {
  ///       ...node fields...,
  ///       "choices": [ ...choice fields with to_node_id alias... ]
  ///     }
  ///   ]
  /// }
  Future<void> importStory(Map<String, dynamic> data) async {
    final storyData = data['story'] as Map<String, dynamic>;
    final nodesData = (data['nodes'] as List).cast<Map<String, dynamic>>();

    // 1. Insert Story
    final storyId = storyData['id'];
    await _supabase.from('stories').upsert(storyData);

    // 2. Insert Nodes (First Pass - No choices yet)
    for (final nodeJson in nodesData) {
      // Strip choices for node insertion
      final nodeInsert = Map<String, dynamic>.from(nodeJson);
      nodeInsert.remove('choices');
      nodeInsert['story_id'] = storyId;

      // Map 'type' if needed
      if (nodeInsert['node_type'] != null) {
        nodeInsert['type'] = nodeInsert['node_type']; // Handle alias
        nodeInsert.remove('node_type');
      }

      await _supabase.from('story_nodes').upsert(nodeInsert);
    }

    // 3. Insert Choices (Second Pass)
    for (final nodeJson in nodesData) {
      if (nodeJson.containsKey('choices')) {
        final fromNodeId = nodeJson['id'];
        final choicesList =
            (nodeJson['choices'] as List).cast<Map<String, dynamic>>();

        for (final choiceJson in choicesList) {
          final choiceInsert = Map<String, dynamic>.from(choiceJson);
          choiceInsert['from_node_id'] = fromNodeId;

          await _supabase.from('story_choices').upsert(choiceInsert);
        }
      }
    }
  }
}
