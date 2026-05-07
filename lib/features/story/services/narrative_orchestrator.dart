import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/ai/openrouter_service.dart';
import '../../../core/ai/prompts.dart';
import '../../../core/utils/logger.dart';
import '../data/story_library.dart';

class NarrativeOrchestrator {
  NarrativeOrchestrator(this._ai, this._supabase);
  final OpenRouterService _ai;
  final SupabaseClient _supabase;

  /// Expand all stories in the library to 700+ words across multiple nodes
  Future<void> expandAllStories() async {
    for (final meta in fallbackStoryLibrary) {
      AppLogger.info('Expanding story: ${meta.title} (${meta.id})');
      await expandStory(meta);
    }
  }

  Future<void> expandStory(StoryMetadata meta) async {
    // Section Mapping to Node IDs
    final sections = {
      'I: The Tapestry': '${meta.id}_start',
      'II: The Spark': '${meta.id}_n02',
      'III: The Path': '${meta.id}_n03',
      'IV: The Threshold': '${meta.id}_n04',
      'V: The Echo': '${meta.id}_end',
    };

    for (final entry in sections.entries) {
      final sectionTitle = entry.key;
      final nodeId = entry.value;

      try {
        AppLogger.info('Generating $sectionTitle for ${meta.title}...');

        final prompt = ChronoPrompts.expansionPrompt(
          title: meta.title,
          culture: meta.culture,
          era: meta.era,
          moral: meta.moral,
          sectionFocus: sectionTitle,
        );

        final content = await _ai.generateText(
          'You are a master storyteller. Output ONLY the narrative text, no JSON, no markdown.',
          prompt,
          model: OpenRouterService.modelStandard,
        );

        // Upsert the node into Supabase
        await _supabase.from('story_nodes').upsert({
          'id': nodeId,
          'story_id': meta.id,
          'type': _getNodeType(sectionTitle),
          'content': content.trim(),
        });
      } on Object catch (e) {
        AppLogger.error(
          'Failed to generate $sectionTitle for ${meta.title}',
          error: e,
        );
      }
    }
  }

  String _getNodeType(String sectionTitle) {
    if (sectionTitle.contains('V: The Echo')) return 'ending';
    if (sectionTitle.contains('II: The Spark')) return 'choice';
    if (sectionTitle.contains('III: The Path')) return 'choice';
    return 'narrative';
  }
}
