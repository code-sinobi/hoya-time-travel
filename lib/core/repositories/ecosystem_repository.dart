import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../utils/logger.dart';

part 'ecosystem_repository.g.dart';

@Riverpod(keepAlive: true)
EcosystemRepository ecosystemRepository(Ref ref) {
  return EcosystemRepository(Supabase.instance.client);
}

class EcosystemRepository {
  final SupabaseClient _client;

  EcosystemRepository(this._client);

  /// 1. User Traits / Wisdom Compass
  Future<Map<String, int>> getUserTraits() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return {};

    try {
      final response = await _client
          .from('user_traits')
          .select()
          .eq('user_id', userId)
          .single();

      return {
        'empathy': response['empathy'] as int,
        'justice': response['justice'] as int,
        'courage': response['courage'] as int,
        'wisdom': response['wisdom'] as int,
        'patience': response['patience'] as int,
      };
    } catch (e) {
      AppLogger.error('Error fetching user traits', error: e);
      return {};
    }
  }

  Future<void> updateTrait(String trait, int delta) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return;

    try {
      final currentTraits = await getUserTraits();
      final currentValue = currentTraits[trait] ?? 0;

      await _client.from('user_traits').update({
        trait: currentValue + delta,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('user_id', userId);
    } catch (e) {
      AppLogger.error('Error updating trait $trait', error: e);
    }
  }

  /// 2. Wisdom Snippets
  Future<void> submitSnippet({
    required String content,
    String? title,
    String? culture,
    String? theme,
  }) async {
    final userId = _client.auth.currentUser?.id;

    try {
      await _client.from('wisdom_snippets').insert({
        'user_id': userId,
        'title': title,
        'content': content,
        'source_culture': culture,
        'theme': theme,
      });
    } catch (e) {
      AppLogger.error('Error submitting snippet', error: e);
    }
  }

  /// 3. Mentor Conversations
  Future<List<Map<String, dynamic>>> getMentorHistory() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return [];

    try {
      final response = await _client
          .from('mentor_conversations')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: true);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      AppLogger.error('Error fetching mentor history', error: e);
      return [];
    }
  }

  Future<void> saveMentorMessage(String role, String message) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return;

    try {
      await _client.from('mentor_conversations').insert({
        'user_id': userId,
        'role': role,
        'message': message,
      });
    } catch (e) {
      AppLogger.error('Error saving mentor message', error: e);
    }
  }

  /// 4. Live Events
  Future<List<Map<String, dynamic>>> getActiveEvents() async {
    final now = DateTime.now().toIso8601String();
    try {
      final response = await _client
          .from('live_events')
          .select()
          .lte('start_time', now)
          .gte('end_time', now);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      AppLogger.error('Error fetching active events', error: e);
      return [];
    }
  }
}
