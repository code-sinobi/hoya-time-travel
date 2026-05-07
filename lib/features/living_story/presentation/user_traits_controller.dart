import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../auth/services/auth_service.dart';
import '../data/living_story_repository.dart';
import '../domain/domain.dart';

part 'user_traits_controller.g.dart';

@riverpod
class UserTraitsController extends _$UserTraitsController {
  @override
  Future<UserTraits> build() async {
    final user = ref.watch(authServiceProvider).currentUser;
    if (user == null) {
      return const UserTraits(userId: '');
    }

    final repo = ref.watch(livingStoryRepositoryProvider);
    try {
      return await repo.getUserTraits(user.id);
    } on Object {
      // Graceful fallback for new users
      return UserTraits(userId: user.id);
    }
  }
}
