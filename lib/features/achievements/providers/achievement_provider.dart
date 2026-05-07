import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/shared_preferences_provider.dart';
import '../models/achievement.dart';

final List<Achievement> _masterAchievements = [
  Achievement(
    id: 'prometheus',
    title: 'Prometheus',
    description: 'Brought fire to the ancients by completing your first story.',
    iconCodePoint: Icons.local_fire_department.codePoint.toRadixString(16),
    iconFontFamily: Icons.local_fire_department.fontFamily ?? 'MaterialIcons',
    iconFontPackage: Icons.local_fire_department.fontPackage ?? '',
    threshold: 1,
    requirementType: 'stories_read',
  ),
  Achievement(
    id: 'guardian',
    title: 'Guardian',
    description: 'Secured the timeline by fixing 5 anomalies.',
    iconCodePoint: Icons.shield.codePoint.toRadixString(16),
    iconFontFamily: Icons.shield.fontFamily ?? 'MaterialIcons',
    iconFontPackage: Icons.shield.fontPackage ?? '',
    threshold: 5,
    requirementType: 'anomalies_fixed',
  ),
  Achievement(
    id: 'nomad',
    title: 'Nomad',
    description: 'Traveled to 3 different eras.',
    iconCodePoint: Icons.explore.codePoint.toRadixString(16),
    iconFontFamily: Icons.explore.fontFamily ?? 'MaterialIcons',
    iconFontPackage: Icons.explore.fontPackage ?? '',
    threshold: 3,
    requirementType: 'eras_visited',
  ),
  Achievement(
    id: 'keymaster',
    title: 'Keymaster',
    description: 'Unlocked a hidden story node.',
    iconCodePoint: Icons.lock_open.codePoint.toRadixString(16),
    iconFontFamily: Icons.lock_open.fontFamily ?? 'MaterialIcons',
    iconFontPackage: Icons.lock_open.fontPackage ?? '',
    threshold: 1,
    requirementType: 'hidden_nodes_unlocked',
  ),
];

class AchievementNotifier extends AsyncNotifier<List<Achievement>> {
  @override
  Future<List<Achievement>> build() async {
    return _loadAchievements();
  }

  Future<List<Achievement>> _loadAchievements() async {
    final prefs = ref.read(sharedPreferencesProvider);
    final unlockedIds = prefs.getStringList('unlocked_achievements') ?? [];

    return _masterAchievements.map((a) {
      if (unlockedIds.contains(a.id)) {
        return a.copyWith(isUnlocked: true, currentProgress: a.threshold);
      }
      return a;
    }).toList();
  }

  Future<void> unlockAchievement(String id) async {
    final prefs = ref.read(sharedPreferencesProvider);
    final unlockedIds = prefs.getStringList('unlocked_achievements') ?? [];

    if (!unlockedIds.contains(id)) {
      unlockedIds.add(id);
      await prefs.setStringList('unlocked_achievements', unlockedIds);
      state = AsyncData(await _loadAchievements());
    }
  }

  // Helper method to simulate earning an achievement for testing
  Future<void> clearAchievements() async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.remove('unlocked_achievements');
    state = AsyncData(await _loadAchievements());
  }
}

final achievementNotifierProvider =
    AsyncNotifierProvider<AchievementNotifier, List<Achievement>>(() {
  return AchievementNotifier();
});
