import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../auth/services/auth_service.dart';
import '../data/living_story_repository.dart';
import '../domain/domain.dart';

part 'recommendation_controller.g.dart';

@riverpod
Future<List<Recommendation>> recommendedStories(Ref ref) async {
  final user = ref.watch(authServiceProvider).currentUser;
  if (user == null) return [];

  return ref
      .read(livingStoryRepositoryProvider)
      .fetchRecommendedStories(user.id);
}
