import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../auth/services/auth_service.dart';
import '../data/premise_repository.dart';
import '../domain/domain.dart';

part 'premise_controller.g.dart';

@riverpod
class PremiseController extends _$PremiseController {
  @override
  FutureOr<List<StoryPremise>> build() async {
    return ref.read(premiseRepositoryProvider).fetchActivePremises();
  }

  Future<void> castVote(String premiseId) async {
    final user = ref.read(authServiceProvider).currentUser;
    if (user == null) return;

    // Check if recently voted (optimistic local check not easy without separate state,
    // so we rely on repo check or UI disablement)

    // Optimistic update
    final currentList = state.value ?? [];
    final updatedList = currentList.map((p) {
      if (p.id == premiseId) {
        // Return new instance with incremented vote count
        // Note: StoryPremise needs copyWith or manual reconstruction
        // Using manual for now since frozen package not used
        return StoryPremise(
          id: p.id,
          title: p.title,
          description: p.description,
          era: p.era,
          culture: p.culture,
          status: p.status,
          voteCount: p.voteCount + 1,
          createdAt: p.createdAt,
        );
      }
      return p;
    }).toList();

    state = AsyncData(updatedList);

    try {
      await ref.read(premiseRepositoryProvider).castVote(premiseId, user.id);
    } on Object catch (e) {
      // Revert
      state = AsyncError(e, StackTrace.current);
      ref.invalidateSelf();
    }
  }
}
