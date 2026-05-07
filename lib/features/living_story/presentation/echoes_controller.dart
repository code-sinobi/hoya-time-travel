import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../auth/services/auth_service.dart';
import '../../living_story/data/living_story_repository.dart';
import '../../living_story/domain/domain.dart';

part 'echoes_controller.g.dart';

@riverpod
class EchoesController extends _$EchoesController {
  @override
  Future<List<TemporalEcho>> build() async {
    final user = ref.read(authServiceProvider).currentUser;
    if (user == null) return [];

    final repo = ref.read(livingStoryRepositoryProvider);
    return repo.getUserEchoes(user.id);
  }
}
