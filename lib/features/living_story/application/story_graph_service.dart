import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../story/models/story_models.dart' as legacy;
import '../data/living_story_repository.dart';
import '../domain/domain.dart';

part 'story_graph_service.g.dart';

@riverpod
StoryGraphService storyGraphService(Ref ref) {
  return StoryGraphService(
    ref.watch(livingStoryRepositoryProvider),
  );
}

class StoryGraphService {
  StoryGraphService(this._repository);
  final LivingStoryRepository _repository;

  /// Get a node with all context applied (variants resolved, content updated)
  Future<legacy.StoryNode> getNodeWithContext({
    required String nodeId,
    required String userId,
  }) async {
    // 1. Fetch base node
    final baseNode = await _repository.getNode(nodeId);

    // 2. Fetch user context (echoes, traits)
    // In a real app, these might be cached or passed in
    final userEchoes = await _repository.getUserEchoes(userId);
    final userTraits = await _repository.getUserTraits(userId);

    // 3. Fetch variants
    final variants = await _repository.getNodeVariants(nodeId);

    // 4. Select best variant
    final selectedVariant = _selectVariant(
      baseNode,
      variants,
      userEchoes,
      userTraits,
    );

    // 5. Update content if variant selected
    legacy.StoryNode finalNode = baseNode;
    if (selectedVariant != null) {
      finalNode = baseNode.copyWith(content: selectedVariant.variantContent);
    }

    // 6. Fetch and filter choices
    final allChoices = await _repository.getChoices(nodeId);
    final availableChoices = _filterChoices(
      allChoices,
      userEchoes,
      userTraits,
    );

    // 7. Return merged node
    return finalNode.copyWith(choices: availableChoices);
  }

  /// Select the highest priority variant that matches conditions
  NodeVariant? _selectVariant(
    legacy.StoryNode baseNode,
    List<NodeVariant> variants,
    List<TemporalEcho> echoes,
    UserTraits traits,
  ) {
    for (final variant in variants) {
      if (_matchesTrigger(variant.variantTrigger, echoes, traits)) {
        return variant;
      }
    }
    return null;
  }

  /// Check if a trigger condition matches user context
  bool _matchesTrigger(
    String trigger,
    List<TemporalEcho> echoes,
    UserTraits traits,
  ) {
    if (trigger.startsWith('has:')) {
      final requiredEcho = trigger.substring(4);
      return echoes.any((e) => e.echoTag == requiredEcho);
    }

    if (trigger.contains('>=')) {
      // e.g. "courage >= 10"
      final parts = trigger.split('>=');
      if (parts.length != 2) return false;

      final traitName = parts[0].trim();
      final threshold = int.tryParse(parts[1].trim()) ?? 0;

      return traits.getTraitValue(traitName) >= threshold;
    }

    // Handle other operators as needed
    return false;
  }

  /// Filter choices based on their conditions (echoes, traits)
  List<legacy.StoryChoice> _filterChoices(
    List<legacy.StoryChoice> choices,
    List<TemporalEcho> echoes,
    UserTraits traits,
  ) {
    return choices.where((choice) {
      // Check required echoes — hide choices the user hasn't unlocked
      if (choice.requiredEchoes != null && choice.requiredEchoes!.isNotEmpty) {
        final hasAll = choice.requiredEchoes!.every(
          (tag) => echoes.any((e) => e.echoTag == tag),
        );
        if (!hasAll) return false;
      }
      return true;
    }).toList();
  }
}
