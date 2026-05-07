import 'dart:developer' as dev;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../auth/services/auth_service.dart';
import '../../story/models/story_models.dart';
import '../application/story_graph_service.dart';
import '../data/living_story_repository.dart';
import '../domain/domain.dart';

part 'living_story_controller.g.dart';

// State for the Living Story Screen
class LivingStoryState {
  LivingStoryState({
    this.session,
    this.currentNode,
    this.isLoading = false,
    this.error,
  });
  final LivingStorySession? session;
  final StoryNode? currentNode;
  final bool isLoading;
  final String? error;

  LivingStoryState copyWith({
    LivingStorySession? session,
    StoryNode? currentNode,
    bool? isLoading,
    String? error,
  }) {
    return LivingStoryState(
      session: session ?? this.session,
      currentNode: currentNode ?? this.currentNode,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

@riverpod
class LivingStoryController extends _$LivingStoryController {
  @override
  LivingStoryState build() {
    return LivingStoryState(isLoading: true);
  }

  Future<void> loadSession(String storyId) async {
    state = LivingStoryState(isLoading: true);

    try {
      final user = ref.read(authServiceProvider).currentUser;
      if (user == null) throw Exception('User not logged in');

      final repo = ref.read(livingStoryRepositoryProvider);

      // 1. Check for existing active session
      var session = await repo.getActiveSession(user.id, storyId);

      if (session == null) {
        // 2. Create new session if none exists
        // Get root node first to set current_node_id
        final rootNode = await repo.getRootNode(storyId);
        if (rootNode == null) {
          throw Exception('Story definitions missing: No root node');
        }

        session = LivingStorySession(
          id: '', // DB will generate
          userId: user.id,
          storyId: storyId,
          currentNodeId: rootNode.id,
          startedAt: DateTime.now(),
        );
        dev.log(
          'Creating session for ${user.id} in story $storyId',
          name: 'LivingStory',
        );
        try {
          session = await repo.createSession(session);
          dev.log('Session created: ${session.id}', name: 'LivingStory');
        } on Object catch (e) {
          dev.log('Error creating session: $e', name: 'LivingStory', error: e);
          rethrow;
        }
      }

      // 3. Load current node content
      if (session.currentNodeId == null) {
        throw Exception('Session has no current node');
      }

      final graphService = ref.read(storyGraphServiceProvider);
      final node = await graphService.getNodeWithContext(
        nodeId: session.currentNodeId!,
        userId: user.id,
      );

      state = LivingStoryState(
        session: session,
        currentNode: node,
      );
    } on Object catch (e) {
      state = LivingStoryState(
        error: e.toString(),
      );
    }
  }

  Future<void> makeChoice(StoryChoice choice) async {
    final currentSession = state.session;
    if (currentSession == null) return;

    // Optimistic update could happen here, but for now we settle for loading
    // We don't want full screen loader, maybe just disable choices?
    // For MVP, isLoading = true works.
    state = LivingStoryState(
      session: currentSession,
      currentNode: state.currentNode,
      isLoading: true,
    );

    try {
      final user = ref.read(authServiceProvider).currentUser;
      if (user == null) throw Exception('User lost session');

      final repo = ref.read(livingStoryRepositoryProvider);

      // 1. Validate resources (TE/CI)
      if (!currentSession.canAffordChoice(
        teCost: choice.teCost,
        ciCost: choice.ciCost,
      )) {
        state = LivingStoryState(
          session: currentSession,
          currentNode: state.currentNode,
          error:
              'Not enough resources (TE: ${choice.teCost}, CI: ${choice.ciCost})',
        );
        return;
      }

      // 2. Calculate new resource checks (deduct costs, add rewards)
      var updatedSession = currentSession.copyWith(
        temporalEnergy: currentSession.temporalEnergy - choice.teCost,
        culturalInsight:
            currentSession.culturalInsight + choice.ciReward - choice.ciCost,
        currentNodeId: choice.nextNodeId,
        pathTaken: [...currentSession.pathTaken, choice.id],
        updatedAt: DateTime.now(),
      );

      // 3. Update session in DB
      updatedSession = await repo.updateSession(updatedSession);

      // 4. Update traits/echoes if any
      if (choice.traitImpacts != null && choice.traitImpacts!.isNotEmpty) {
        final currentTraits = await repo.getUserTraits(user.id);
        final impacts = choice.traitImpacts!;
        final updatedTraits = currentTraits.copyWith(
          empathy: currentTraits.empathy +
              ((impacts['empathy'] as num?)?.toInt() ?? 0),
          justice: currentTraits.justice +
              ((impacts['justice'] as num?)?.toInt() ?? 0),
          courage: currentTraits.courage +
              ((impacts['courage'] as num?)?.toInt() ?? 0),
          wisdom: currentTraits.wisdom +
              ((impacts['wisdom'] as num?)?.toInt() ?? 0),
          patience: currentTraits.patience +
              ((impacts['patience'] as num?)?.toInt() ?? 0),
          updatedAt: DateTime.now(),
        );
        await repo.updateUserTraits(updatedTraits);
      }

      // 5. Load next node
      if (updatedSession.currentNodeId != null) {
        final graphService = ref.read(storyGraphServiceProvider);
        final nextNode = await graphService.getNodeWithContext(
          nodeId: updatedSession.currentNodeId!,
          userId: user.id,
        );

        state = LivingStoryState(
          session: updatedSession,
          currentNode: nextNode,
        );
      } else {
        // End of story or error
        state = LivingStoryState(
          session: updatedSession,
          currentNode: state.currentNode, // Stay on old node? Or show ending?
          error: 'End of content (No next node)',
        );
      }
    } on Object catch (e) {
      state = LivingStoryState(
        session: currentSession,
        currentNode: state.currentNode,
        error: e.toString(),
      );
    }
  }
}
