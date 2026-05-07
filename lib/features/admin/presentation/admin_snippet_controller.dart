import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../community/data/snippet_repository.dart';
import '../../community/domain/domain.dart';

part 'admin_snippet_controller.g.dart';

@riverpod
class AdminSnippetController extends _$AdminSnippetController {
  @override
  FutureOr<List<Snippet>> build() {
    return _fetchPending();
  }

  Future<List<Snippet>> _fetchPending() async {
    return ref.read(snippetRepositoryProvider).fetchPendingSnippets();
  }

  Future<void> approveSnippet(String snippetId) async {
    await _updateStatus(snippetId, 'approved');
  }

  Future<void> rejectSnippet(String snippetId) async {
    await _updateStatus(snippetId, 'rejected');
  }

  Future<void> _updateStatus(String snippetId, String status) async {
    // Optimistic update
    final currentList = state.value ?? [];
    state = AsyncData(currentList.where((s) => s.id != snippetId).toList());

    try {
      await ref
          .read(snippetRepositoryProvider)
          .updateSnippetStatus(snippetId, status);
    } on Object catch (e) {
      // Revert on error
      state = AsyncError(e, StackTrace.current);
      // Reload actual data
      ref.invalidateSelf();
    }
  }
}
