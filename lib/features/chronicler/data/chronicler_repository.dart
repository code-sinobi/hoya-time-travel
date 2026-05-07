import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../story/models/story_models.dart';

part 'chronicler_repository.g.dart';

@Riverpod(keepAlive: true)
ChroniclerRepository chroniclerRepository(Ref ref) {
  return ChroniclerRepository(Supabase.instance.client);
}

class ChroniclerRepository {
  ChroniclerRepository(this._supabase);
  final SupabaseClient _supabase;

  Future<List<Story>> fetchMyStories(String userId) async {
    final response = await _supabase
        .from('stories')
        .select()
        .eq('author_id', userId)
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => Story.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<Story> createDraftStory({
    required String userId,
    required String title,
    required String eraId,
    required String culture,
    required String theme,
  }) async {
    final response = await _supabase
        .from('stories')
        .insert({
          'author_id': userId,
          'title': title,
          'era_id': eraId,
          'culture': culture,
          'moral_theme': theme,
          'is_published': false,
          'metadata': {'status': 'draft'}, // Store draft status in metadata
        })
        .select()
        .single();

    return Story.fromJson(response);
  }

  // Method to check if user needs to create author profile? (Optional, skipping for now)

  Future<List<StoryNode>> fetchNodesForStory(String storyId) async {
    final response = await _supabase
        .from('story_nodes')
        .select()
        .eq('story_id', storyId)
        .order('created_at', ascending: true); // or depth_level

    // Note: choices are not fetched here by default in this MVP list view
    return (response as List)
        .map((json) => StoryNode.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<StoryNode> fetchNodeWithChoices(String nodeId) async {
    final nodeResponse =
        await _supabase.from('story_nodes').select().eq('id', nodeId).single();

    final choicesResponse = await _supabase
        .from('story_choices')
        .select()
        .eq('from_node_id', nodeId)
        .order('display_order');

    final choices = (choicesResponse as List)
        .map((c) => StoryChoice.fromJson(c as Map<String, dynamic>))
        .toList();
    return StoryNode.fromJson(nodeResponse).copyWith(choices: choices);
  }

  Future<void> upsertNode(StoryNode node, String storyId) async {
    // 1. Upsert Node
    final nodeData = node.toJson();
    nodeData.remove('choices'); // handled separately
    nodeData['story_id'] = storyId;
    nodeData['type'] = node.type.name; // Enum to string

    // Clean up nulls
    nodeData.removeWhere((key, value) => value == null);

    if (node.id.isEmpty || node.id == 'new') {
      nodeData.remove('id'); // let DB generate
      // If we need the ID back, we use select().single()
    }

    final savedNodeRes =
        await _supabase.from('story_nodes').upsert(nodeData).select().single();
    final savedNodeId = savedNodeRes['id'] as String;

    // 2. Handle Choices (Full replace approach for MVP simplicity)
    // First delete existing choices for this node
    await _supabase
        .from('story_choices')
        .delete()
        .eq('from_node_id', savedNodeId);

    // Insert new choices
    if (node.choices.isNotEmpty) {
      final choicesData = node.choices.map((c) {
        return {
          'from_node_id': savedNodeId,
          'to_node_id': c.nextNodeId,
          'choice_text': c.text,
          'te_cost': c.teCost,
          // ... map other fields
        };
      }).toList();

      await _supabase.from('story_choices').insert(choicesData);
    }
  }

  Future<void> deleteNode(String nodeId) async {
    await _supabase.from('story_nodes').delete().eq('id', nodeId);
  }
}
