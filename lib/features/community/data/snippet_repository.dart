import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/domain.dart';

part 'snippet_repository.g.dart';

@Riverpod(keepAlive: true)
SnippetRepository snippetRepository(Ref ref) {
  return SnippetRepository(Supabase.instance.client);
}

class SnippetRepository {
  SnippetRepository(this._supabase);
  final SupabaseClient _supabase;

  Future<void> submitSnippet({
    required String userId,
    required String content,
    List<String> tags = const [],
    String? originStoryId,
  }) async {
    await _supabase.from('user_snippets').insert({
      'user_id': userId,
      'content': content,
      'tags': tags,
      'origin_story_id': originStoryId,
      // status defaults to 'submitted'
      // votes default to 0
    });
  }

  Future<List<Snippet>> fetchMySnippets(String userId) async {
    final response = await _supabase
        .from('user_snippets')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response as List)
        .map(Snippet.fromJson)
        .toList();
  }

  Future<List<Snippet>> fetchPendingSnippets() async {
    final response = await _supabase
        .from('user_snippets')
        .select()
        .eq('status', 'submitted')
        .order('created_at', ascending: true);

    return List<Map<String, dynamic>>.from(response as List)
        .map(Snippet.fromJson)
        .toList();
  }

  Future<void> updateSnippetStatus(String snippetId, String status) async {
    await _supabase
        .from('user_snippets')
        .update({'status': status}).eq('id', snippetId);
  }
}
