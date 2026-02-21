import '../domain/echo_template.dart';
import '../domain/user_traits.dart';

class EchoResponseSelector {
  /// Selects the best template based on user traits and recent history
  EchoTemplate? selectBest(
    List<EchoTemplate> templates,
    UserTraits traits,
    TemporalContext context,
  ) {
    if (templates.isEmpty) return null;

    final scoredTemplates = templates.map((template) {
      double score = calculateScore(template, traits, context);
      return MapEntry(template, score);
    }).toList();

    // Sort by score descending
    scoredTemplates.sort((a, b) => b.value.compareTo(a.value));

    // Filter out templates with score < 0 (requirements not met)
    final eligible = scoredTemplates.where((e) => e.value >= 0).toList();

    return eligible.isNotEmpty ? eligible.first.key : null;
  }

  double calculateScore(
    EchoTemplate template,
    UserTraits traits,
    TemporalContext context,
  ) {
    double score = template.baseWeight.toDouble();

    // 1. Requirement Checks (Must pass or score becomes negative)
    final requirements = template.triggerConditions['requirements'] as Map<String, dynamic>?;
    if (requirements != null) {
      for (var entry in requirements.entries) {
        final traitValue = traits.getTraitValue(entry.key);
        final required = entry.value as int;
        if (traitValue < required) return -1.0; // Requirement not met
      }
    }

    // 2. Trait Affinities (Linear boost)
    for (var affinity in template.traitAffinities.entries) {
      final userVal = traits.getTraitValue(affinity.key);
      // Boost proportional to trait strength
      score += (userVal / 100.0) * affinity.value;
    }

    // 3. Contextual Boosts
    // Era match
    if (template.eraId == context.currentEra) {
      score += 10.0;
    }

    // Boost for recent activity relevance (guard against both being null)
    final recentStoryId = template.triggerConditions['recent_story_id'];
    if (recentStoryId != null &&
        context.lastStoryId != null &&
        recentStoryId == context.lastStoryId) {
      score += 5.0;
    }

    return score;
  }
}

class TemporalContext {
  final String currentEra;
  final String? lastStoryId;
  final Set<String> activeTraits;

  TemporalContext({
    required this.currentEra,
    this.lastStoryId,
    required this.activeTraits,
  });
}
