import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/domain.dart';

part 'premise_repository.g.dart';

@Riverpod(keepAlive: true)
PremiseRepository premiseRepository(Ref ref) {
  return PremiseRepository(Supabase.instance.client);
}

class PremiseRepository {
  PremiseRepository(this._supabase);
  final SupabaseClient _supabase;

  Future<List<StoryPremise>> fetchActivePremises() async {
    final response = await _supabase
        .from('story_premises')
        .select()
        .eq('status', 'active')
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response as List)
        .map(StoryPremise.fromJson)
        .toList();
  }

  Future<bool> hasUserVoted(String premiseId, String userId) async {
    final response = await _supabase
        .from('premise_votes')
        .select()
        .eq('premise_id', premiseId)
        .eq('user_id', userId)
        .maybeSingle();

    return response != null;
  }

  Future<void> castVote(String premiseId, String userId) async {
    // 1. Record vote in join table
    await _supabase.from('premise_votes').insert({
      'premise_id': premiseId,
      'user_id': userId,
    });

    // 2. Increment counter on premise
    await _supabase.rpc<void>('increment_vote', params: {'row_id': premiseId});
  }
}
