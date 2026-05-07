import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/domain.dart';

part 'echo_response_selector.g.dart';

@riverpod
EchoResponseSelector echoResponseSelector(Ref ref) {
  return EchoResponseSelector();
}

class EchoResponseSelector {
  final Random _random = Random();

  /// Selects the best matching response template based on user context.
  ///
  /// Ranking Formula:
  /// 1. Base Priority: Template's `priority` field.
  /// 2. Context Match: +5 if specific story/context matches perfectly.
  /// 3. Echo Match: +1 for each required echo tag the user has.
  /// 4. Trait Match: +2 if user's dominant trait matches template condition.
  /// 5. Random Noise: +/- 0.5 to vary identical scores.
  EchoResponseTemplate? selectBestResponse({
    required List<EchoResponseTemplate> freshTemplates,
    required UserContext context,
    String? preferredContextType,
  }) {
    // 1. Filter by context type if specified
    var candidates = freshTemplates;
    if (preferredContextType != null) {
      candidates = candidates
          .where((t) => t.contextType == preferredContextType)
          .toList();
    }

    // 2. Filter by hard requirements (must have all req echoes/traits)
    candidates =
        candidates.where((t) => _meetsRequirements(t, context)).toList();

    if (candidates.isEmpty) return null;

    // 3. Score candidates
    final scored = candidates.map((t) {
      return MapEntry(t, _calculateScore(t, context));
    }).toList();

    // 4. Sort by score descending
    scored.sort((a, b) => b.value.compareTo(a.value));

    // 5. Return top match
    return scored.first.key;
  }

  bool _meetsRequirements(EchoResponseTemplate template, UserContext context) {
    // Check traits (e.g., min_trait:wisdom:10)
    // Check echoes (e.g., has_echo:patron_of_knowledge)
    // This logic relies on `triggerConditions` map in the model

    final conditions = template.triggerConditions;
    for (final key in conditions.keys) {
      final value = conditions[key];

      if (key.startsWith('min_trait:')) {
        final trait = key.split(':')[1];
        final minVal = int.tryParse(value.toString()) ?? 0;
        if (context.traits.getTraitValue(trait) < minVal) return false;
      }

      if (key == 'required_echo') {
        // Assume comma separated string or list
        final reqs = value.toString().split(',');
        for (final req in reqs) {
          if (!context.echoes.contains(req.trim())) return false;
        }
      }

      // Add more condition types as needed
    }

    return true;
  }

  double _calculateScore(EchoResponseTemplate template, UserContext context) {
    double score = template.priority.toDouble();

    // Boost if dominant trait matches template theme/tone
    if (template.triggerConditions.containsKey('dominant_trait')) {
      if (template.triggerConditions['dominant_trait'] ==
          context.traits.dominantTrait) {
        score += 2.0;
      }
    }

    // Boost for recent activity relevance (guard against both being null)
    final recentStoryId = template.triggerConditions['recent_story_id'];
    if (recentStoryId != null &&
        context.lastStoryId != null &&
        recentStoryId == context.lastStoryId) {
      score += 5.0;
    }

    // Add small random noise for variety among equals
    score += _random.nextDouble() - 0.5;

    return score;
  }
}

/// Helper class to pass context efficiently
class UserContext {
  UserContext({
    required this.traits,
    required this.echoes,
    this.lastStoryId,
  });
  final UserTraits traits;
  final List<String> echoes;
  final String? lastStoryId;
}
