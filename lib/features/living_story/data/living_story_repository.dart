import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../story/models/story_models.dart'
    as legacy; // thorough check needed if we reuse models
import '../domain/domain.dart';

part 'living_story_repository.g.dart';

@Riverpod(keepAlive: true)
LivingStoryRepository livingStoryRepository(Ref ref) {
  return LivingStoryRepository(Supabase.instance.client);
}

class _CacheEntry<T> {
  _CacheEntry(this.data) : timestamp = DateTime.now();
  final T data;
  final DateTime timestamp;
  bool get isExpired =>
      DateTime.now().difference(timestamp) > const Duration(minutes: 15);
}

class LivingStoryRepository {
  LivingStoryRepository(this._supabase);
  final SupabaseClient _supabase;

  // In-memory cache with TTL
  final Map<String, _CacheEntry<legacy.StoryNode>> _nodeCache = {};
  final Map<String, _CacheEntry<List<legacy.StoryChoice>>> _choiceCache = {};
  final Map<String, _CacheEntry<List<NodeVariant>>> _variantCache = {};
  final Map<String, _CacheEntry<UserTraits>> _traitsCache = {};
  final Map<String, _CacheEntry<List<TemporalEcho>>> _echoesCache = {};

  // --- Story & Nodes ---

  Future<legacy.Story> getStory(String storyId) async {
    // Stories could also be cached, but they are fetched less often.
    // Adding lightweight cache for them could be good too, but let's stick to nodes for now.
    final response =
        await _supabase.from('stories').select().eq('id', storyId).single();
    return legacy.Story.fromJson(response);
  }

  Future<legacy.StoryNode> getNode(String nodeId) async {
    final cached = _nodeCache[nodeId];
    if (cached != null && !cached.isExpired) {
      return cached.data;
    }

    final response =
        await _supabase.from('story_nodes').select().eq('id', nodeId).single();

    final node = legacy.StoryNode.fromJson(response);
    _nodeCache[nodeId] = _CacheEntry(node);
    return node;
  }

  Future<legacy.StoryNode?> getRootNode(String storyId) async {
    // Root node ID is stable for a story
    final response = await _supabase
        .from('story_nodes')
        .select()
        .eq('story_id', storyId)
        .eq('is_root', true)
        .limit(1)
        .maybeSingle();

    if (response == null) return null;
    final node = legacy.StoryNode.fromJson(response);
    _nodeCache[node.id] = _CacheEntry(node); // Cache it by ID
    return node;
  }

  Future<List<legacy.StoryChoice>> getChoices(String nodeId) async {
    final cached = _choiceCache[nodeId];
    if (cached != null && !cached.isExpired) {
      return cached.data;
    }

    final response = await _supabase
        .from('story_choices')
        .select()
        .eq('from_node_id', nodeId)
        .order('display_order', ascending: true);

    final choices = List<Map<String, dynamic>>.from(response as List)
        .map(legacy.StoryChoice.fromJson)
        .toList();

    _choiceCache[nodeId] = _CacheEntry(choices);
    return choices;
  }

  Future<List<NodeVariant>> getNodeVariants(String nodeId) async {
    final cached = _variantCache[nodeId];
    if (cached != null && !cached.isExpired) {
      return cached.data;
    }

    final response = await _supabase
        .from('node_variants')
        .select()
        .eq('base_node_id', nodeId)
        .order('priority', ascending: false);

    final variants = List<Map<String, dynamic>>.from(response as List)
        .map(NodeVariant.fromJson)
        .toList();

    _variantCache[nodeId] = _CacheEntry(variants);
    return variants;
  }

  // --- Session Management ---

  Future<LivingStorySession?> getActiveSession(
    String userId,
    String storyId,
  ) async {
    final response = await _supabase
        .from('living_story_sessions')
        .select()
        .eq('user_id', userId)
        .eq('story_id', storyId)
        .eq('is_active', true)
        .maybeSingle();

    if (response == null) return null;
    return LivingStorySession.fromJson(response);
  }

  Future<LivingStorySession> createSession(LivingStorySession session) async {
    final response = await _supabase
        .from('living_story_sessions')
        .insert(session.toJson()..remove('id'))
        .select()
        .single();
    return LivingStorySession.fromJson(response);
  }

  Future<LivingStorySession> updateSession(LivingStorySession session) async {
    final response = await _supabase
        .from('living_story_sessions')
        .update(session.toJson())
        .eq('id', session.id)
        .select()
        .single();
    return LivingStorySession.fromJson(response);
  }

  // --- User Context (Echoes & Traits) ---

  Future<UserTraits> getUserTraits(String userId) async {
    final cached = _traitsCache[userId];
    if (cached != null && !cached.isExpired) {
      return cached.data;
    }

    final response = await _supabase
        .from('user_traits')
        .select()
        .eq('user_id', userId)
        .maybeSingle();

    if (response == null) {
      // New user with no traits row yet — return defaults
      final defaults = UserTraits.defaults(userId);
      _traitsCache[userId] = _CacheEntry(defaults);
      return defaults;
    }

    final traits = UserTraits.fromJson(response);
    _traitsCache[userId] = _CacheEntry(traits);
    return traits;
  }

  Future<List<TemporalEcho>> getUserEchoes(String userId) async {
    final cached = _echoesCache[userId];
    if (cached != null && !cached.isExpired) {
      return cached.data;
    }

    final response =
        await _supabase.from('temporal_echoes').select().eq('user_id', userId);

    final echoes = List<Map<String, dynamic>>.from(response as List)
        .map(TemporalEcho.fromJson)
        .toList();

    _echoesCache[userId] = _CacheEntry(echoes);
    return echoes;
  }

  Future<void> addEcho(TemporalEcho echo) async {
    await _supabase.from('temporal_echoes').insert(echo.toJson());
    // Invalidate or append to cache
    final cached = _echoesCache[echo.userId];
    if (cached != null && !cached.isExpired) {
      cached.data.add(echo);
    }
  }

  Future<void> updateUserTraits(UserTraits traits) async {
    await _supabase
        .from('user_traits')
        .update(traits.toJson())
        .eq('user_id', traits.userId);
    // Update cache
    _traitsCache[traits.userId] = _CacheEntry(traits);
  }

  // --- Content Seeding (Admin) ---

  Future<void> insertStory(legacy.Story story) async {
    await _supabase.from('stories').upsert(story.toJson());
  }

  Future<void> insertNode(legacy.StoryNode node) async {
    final json = node.toJson();
    // remove choices from node insert, they go to choices table
    json.remove('choices');
    await _supabase.from('story_nodes').upsert(json);
  }

  Future<void> insertChoice(
    legacy.StoryChoice choice,
    String fromNodeId,
  ) async {
    final json = choice.toJson();
    json['from_node_id'] = fromNodeId;
    await _supabase.from('story_choices').upsert(json);
  }

  Future<void> insertVariant(NodeVariant variant) async {
    await _supabase.from('node_variants').upsert(variant.toJson());
  }

  // --- Echo Responses ---

  Future<List<EchoResponseTemplate>> getEchoTemplates(
    String contextType,
  ) async {
    final response = await _supabase
        .from('echo_response_templates')
        .select()
        .eq('context_type', contextType)
        .eq('is_active', true)
        .order('priority', ascending: false);

    return List<Map<String, dynamic>>.from(response as List)
        .map(EchoResponseTemplate.fromJson)
        .toList();
  }

  Future<void> insertEchoTemplate(EchoResponseTemplate template) async {
    await _supabase.from('echo_response_templates').upsert(template.toJson());
  }

  // --- Recommendations ---

  Future<List<Recommendation>> fetchRecommendedStories(String userId) async {
    try {
      // 1. Call RPC to get IDs and scores
      final rpcResponse = await _supabase.rpc<List<dynamic>>(
        'recommend_stories',
        params: {'p_user_id': userId, 'p_limit': 3},
      );

      final List<dynamic> data = rpcResponse;
      if (data.isEmpty) return [];

      // 2. Extract IDs and map scores
      final storyIds = data
          .map((e) => (e as Map<String, dynamic>)['story_id'] as String)
          .toList();
      final scoreMap = {
        for (final e in data)
          (e as Map<String, dynamic>)['story_id'] as String:
              (e['relevance_score'] as num?)?.toDouble() ?? 0.0,
      };

      // 3. Fetch full stories
      final storiesResponse =
          await _supabase.from('stories').select().inFilter('id', storyIds);

      final stories = List<Map<String, dynamic>>.from(storiesResponse as List)
          .map(legacy.Story.fromJson)
          .toList();

      // 4. Combine into Recommendations
      return stories.map((story) {
        return Recommendation(
          story: story,
          relevanceScore: scoreMap[story.id] ?? 0.0,
        );
      }).toList()
        ..sort(
          (a, b) => b.relevanceScore.compareTo(a.relevanceScore),
        ); // Sort DESC
    } on Object catch (e, st) {
      debugPrint('fetchRecommendedStories failed: $e\n$st');
      // Return empty list on error (e.g. RPC not found yet)
      return [];
    }
  }
}
