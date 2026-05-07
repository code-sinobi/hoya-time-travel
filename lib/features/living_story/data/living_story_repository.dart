import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/user_traits.dart';

class LivingStoryRepository {
  final SupabaseClient _supabase;

  LivingStoryRepository(this._supabase);

  // Cache for user traits
  final Map<String, UserTraits> _traitsCache = {};

  /// Fetches traits for a specific user.
  /// Uses maybeSingle() and defaults if not found to prevent crashes for new users.
  Future<UserTraits> getUserTraits(String userId) async {
    // Return from cache if available
    if (_traitsCache.containsKey(userId)) {
      return _traitsCache[userId]!;
    }

    try {
      final response = await _supabase
          .from('user_traits')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      if (response == null) {
        // New user with no traits row yet — return defaults
        final defaults = UserTraits.defaults(userId);
        _traitsCache[userId] = defaults;
        return defaults;
      }

      final traits = UserTraits.fromJson(response);
      _traitsCache[userId] = traits;
      return traits;
    } catch (e) {
      // In case of error, provide safe defaults instead of failing
      return UserTraits.defaults(userId);
    }
  }

  /// Updates a single trait value for a user.
  Future<void> updateTrait(String userId, String traitName, int newValue) async {
    try {
      await _supabase.from('user_traits').upsert({
        'user_id': userId,
        traitName.toLowerCase(): newValue,
        'last_updated': DateTime.now().toIso8601String(),
      });

      // Update cache
      if (_traitsCache.containsKey(userId)) {
        final current = _traitsCache[userId]!;
        final updated = current.copyWithTrait(traitName, newValue);
        _traitsCache[userId] = updated;
      }
    } catch (e) {
      // Log or handle error internally
      rethrow;
    }
  }

  /// Fetches the recent echoes for a user.
  Future<List<Map<String, dynamic>>> getUserEchoes(String userId) async {
    try {
      final response = await _supabase
          .from('user_echoes')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .limit(10);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      return [];
    }
  }
}
