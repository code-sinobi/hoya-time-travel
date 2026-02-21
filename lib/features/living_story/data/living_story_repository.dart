import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../story/models/story_models.dart'
    as legacy; // thorough check needed if we reuse models
import '../domain/domain.dart';

part 'living_story_repository.g.dart';

@Riverpod(keepAlive: true)
LivingStoryRepository livingStoryRepository(Ref ref) {
  return LivingStoryRepository(Supabase.instance.client);
}

class LivingStoryRepository {
  final SupabaseClient _supabase;

  // In-memory cache
  final Map<String, legacy.StoryNode> _nodeCache = {};
  final Map<String, List<legacy.StoryChoice>> _choiceCache = {};
  final Map<String, List<NodeVariant>> _variantCache = {};
  final Map<String, UserTraits> _traitsCache = {};
  final Map<String, List<TemporalEcho>> _echoesCache = {};

  LivingStoryRepository(this._supabase);

  // --- Story & Nodes ---

  Future<legacy.Story> getStory(String storyId) async {
    final response =
        await _supabase.from('stories').select().eq('id', storyId).single();
    return legacy.Story.fromJson(response);
  }

  Future<legacy.StoryNode> getNode(String nodeId) async {
    if (_nodeCache.containsKey(nodeId)) {
      return _nodeCache[nodeId]!;
    }

    final response =
        await _supabase.from('story_nodes').select().eq('id', nodeId).single();

    final node = legacy.StoryNode.fromJson(response);
    _nodeCache[nodeId] = node;
    return node;
  }

  Future<legacy.StoryNode?> getRootNode(String storyId) async {
    final response = await _supabase
        .from('story_nodes')
        .select()
        .eq('story_id', storyId)
        .eq('is_root', true)
        .limit(1)
        .maybeSingle();

    if (response == null) return null;
    final node = legacy.StoryNode.fromJson(response);
    _nodeCache[node.id] = node;
    return node;
  }

  Future<List<legacy.StoryChoice>> getChoices(String nodeId) async {
    if (_choiceCache.containsKey(nodeId)) {
      return _choiceCache[nodeId]!;
    }

    final response = await _supabase
        .from('story_choices')
        .select()
        .eq('from_node_id', nodeId)
        .order('display_order', ascending: true);

    final choices =
        (response as List).map((e) => legacy.StoryChoice.fromJson(e)).toList();

    _choiceCache[nodeId] = choices;
    return choices;
  }

  Future<List<NodeVariant>> getNodeVariants(String nodeId) async {
    if (_variantCache.containsKey(nodeId)) {
      return _variantCache[nodeId]!;
    }

    final response = await _supabase
        .from('node_variants')
        .select()
        .eq('base_node_id', nodeId)
        .order('priority', ascending: false);

    final variants =
        (response as List).map((e) => NodeVariant.fromJson(e)).toList();

    _variantCache[nodeId] = variants;
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
    if (_traitsCache.containsKey(userId)) {
      return _traitsCache[userId]!;
    }

    final response = await _supabase
        .from('user_traits')
        .select()
        .eq('user_id', userId)
        .single();

    final traits = UserTraits.fromJson(response);
    _traitsCache[userId] = traits;
    return traits;
  }

  Future<List<TemporalEcho>> getUserEchoes(String userId) async {
    if (_echoesCache.containsKey(userId)) {
      return _echoesCache[userId]!;
    }

    final response =
        await _supabase.from('temporal_echoes').select().eq('user_id', userId);

    final echoes =
        (response as List).map((e) => TemporalEcho.fromJson(e)).toList();

    _echoesCache[userId] = echoes;
    return echoes;
  }

  Future<void> addEcho(TemporalEcho echo) async {
    await _supabase.from('temporal_echoes').insert(echo.toJson());
    if (_echoesCache.containsKey(echo.userId)) {
      _echoesCache[echo.userId]!.add(echo);
    }
  }

  Future<void> updateUserTraits(UserTraits traits) async {
    await _supabase
        .from('user_traits')
        .update(traits.toJson())
        .eq('user_id', traits.userId);
    _traitsCache[traits.userId] = traits;
  }

  // --- Content Seeding (Admin) ---

  Future<void> insertStory(legacy.Story story) async {
    await _supabase.from('stories').upsert(story.toJson());
  }

  Future<void> insertNode(legacy.StoryNode node) async {
    final json = node.toJson();
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

    return (response as List)
        .map((e) => EchoResponseTemplate.fromJson(e))
        .toList();
  }

  Future<void> insertEchoTemplate(EchoResponseTemplate template) async {
    await _supabase.from('echo_response_templates').upsert(template.toJson());
  }

  // --- Recommendations ---

  Future<List<Recommendation>> fetchRecommendedStories(String userId) async {
    try {
      final rpcResponse = await _supabase.rpc(
        'recommend_stories',
        params: {'p_user_id': userId, 'p_limit': 3},
      );

      final List<dynamic> data = rpcResponse as List<dynamic>;
      if (data.isEmpty) return [];

      final storyIds = data.map((e) => e['story_id'] as String).toList();
      final scoreMap = {
        for (var e in data)
          e['story_id'] as String: (e['relevance_score'] as num).toDouble(),
      };

      final storiesResponse =
          await _supabase.from('stories').select().inFilter('id', storyIds);

      final stories = (storiesResponse as List)
          .map((e) => legacy.Story.fromJson(e))
          .toList();

      return stories.map((story) {
        return Recommendation(
          story: story,
          relevanceScore: scoreMap[story.id] ?? 0.0,
        );
      }).toList()
        ..sort(
          (a, b) => b.relevanceScore.compareTo(a.relevanceScore),
        );
    } catch (e) {
      return [];
    }
  }
}
