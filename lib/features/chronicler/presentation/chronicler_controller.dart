import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../auth/services/auth_service.dart';
import '../../story/models/story_models.dart';
import '../data/chronicler_repository.dart';

part 'chronicler_controller.g.dart';

@riverpod
class ChroniclerController extends _$ChroniclerController {
  @override
  FutureOr<List<Story>> build() async {
    final user = ref.read(authServiceProvider).currentUser;
    if (user == null) return [];

    return ref.read(chroniclerRepositoryProvider).fetchMyStories(user.id);
  }

  Future<void> createStory({
    required String title,
    required String eraId,
    required String culture,
    required String theme,
  }) async {
    final user = ref.read(authServiceProvider).currentUser;
    if (user == null) return;

    state = const AsyncLoading();

    try {
      final newStory =
          await ref.read(chroniclerRepositoryProvider).createDraftStory(
                userId: user.id,
                title: title,
                eraId: eraId,
                culture: culture,
                theme: theme,
              );

      // Refresh list
      final currentList = state.value ?? [];
      state = AsyncData([newStory, ...currentList]);
    } on Object catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
