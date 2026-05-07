import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../auth/services/auth_service.dart';
import '../data/snippet_repository.dart';

part 'snippet_controller.g.dart';

@riverpod
class SnippetController extends _$SnippetController {
  @override
  FutureOr<void> build() {
    // Initial state is idle (void)
  }

  Future<void> submitSnippet({
    required String content,
    List<String> tags = const [],
    String? originStoryId,
  }) async {
    state = const AsyncLoading();

    try {
      final user = ref.read(authServiceProvider).currentUser;
      if (user == null) throw Exception('User not logged in');

      await ref.read(snippetRepositoryProvider).submitSnippet(
            userId: user.id,
            content: content,
            tags: tags,
            originStoryId: originStoryId,
          );

      state = const AsyncData(null);
    } on Object catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
