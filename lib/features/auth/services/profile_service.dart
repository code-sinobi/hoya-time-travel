import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/profile.dart';
import 'auth_service.dart';

part 'profile_service.g.dart';

@riverpod
class UserProfile extends _$UserProfile {
  @override
  FutureOr<Profile?> build() async {
    final authState = ref.watch(authStateChangesProvider);
    final user = authState.value?.session?.user;

    if (user == null) return null;

    final response = await Supabase.instance.client
        .from('profiles')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    if (response == null) return null;
    return Profile.fromJson(response);
  }

  Future<void> updateUsername(String newName) async {
    final current = state.value;
    if (current == null) return;

    try {
      await Supabase.instance.client
          .from('profiles')
          .update({'username': newName})
          .eq('id', current.id);

      // Refresh state
      ref.invalidateSelf();
    } catch (e) {
      // Re-throw or handle error
      throw Exception('Failed to update username: $e');
    }
  }

  Future<void> addXp(int amount) async {
    final current = state.value;
    if (current == null) return;

    final newXp = current.xp + amount;
    // Simple level up logic: level = (xp / 100) + 1
    final newLevel = (newXp / 100).floor() + 1;

    await Supabase.instance.client
        .from('profiles')
        .update({
          'xp': newXp,
          'level': newLevel,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', current.id);

    // Refresh state
    ref.invalidateSelf();
  }
}
