import 'dart:io';
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
          .update({'username': newName}).eq('id', current.id);

      // Refresh state
      ref.invalidateSelf();
    } on Object catch (e) {
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

    await Supabase.instance.client.from('profiles').update({
      'xp': newXp,
      'level': newLevel,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', current.id);

    // Refresh state
    ref.invalidateSelf();
  }

  Future<void> upgradeSubscription() async {
    final current = state.value;
    if (current == null) return;

    await Supabase.instance.client
        .from('profiles')
        .update({'subscription_tier': 'patron'}).eq('id', current.id);

    ref.invalidateSelf();
  }

  Future<void> becomeChronicler() async {
    final current = state.value;
    if (current == null) return;

    await Supabase.instance.client
        .from('profiles')
        .update({'role': 'chronicler'}).eq('id', current.id);

    ref.invalidateSelf();
  }

  Future<void> inscribeAvatar(String imagePath) async {
    final current = state.value;
    if (current == null) return;

    try {
      final file = File(imagePath);
      final fileExt = imagePath.split('.').last;
      final fileName = '${current.id}-${DateTime.now().millisecondsSinceEpoch}.$fileExt';
      final filePath = '${current.id}/$fileName';

      await Supabase.instance.client.storage
          .from('avatars')
          .upload(filePath, file); // ignore: vocabulary

      final imageUrlResponse = Supabase.instance.client.storage
          .from('avatars')
          .getPublicUrl(filePath);

      await Supabase.instance.client
          .from('profiles')
          .update({'avatar_url': imageUrlResponse})
          .eq('id', current.id);

      ref.invalidateSelf();
    } catch (e) {
      throw Exception('Failed to inscribe avatar: $e');
    }
  }
}
