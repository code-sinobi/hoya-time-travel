import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/content/founder_story_1.dart';
import '../data/living_story_repository.dart';
import 'content/echo_templates_seed.dart';

part 'seeding_service.g.dart';

@riverpod
SeedingService seedingService(Ref ref) {
  return SeedingService(ref.watch(livingStoryRepositoryProvider));
}

class SeedingService {
  SeedingService(this._repository);
  final LivingStoryRepository _repository;

  Future<void> seedFounderStory() async {
    // 1. Insert Metadata
    await _repository.insertStory(FounderStory1.metadata);

    // 2. Insert Nodes & Nested Choices
    for (final node in FounderStory1.nodes) {
      await _repository.insertNode(node);

      // Insert nested choices if any
      for (final choice in node.choices) {
        await _repository.insertChoice(choice, node.id);
      }
    }

    // 3. Insert Variants
    for (final variant in FounderStory1.variants) {
      await _repository.insertVariant(variant);
    }

    // 4. Seed Echo Templates
    for (final template in EchoTemplatesSeed.templates) {
      await _repository.insertEchoTemplate(template);
    }
  }
}
