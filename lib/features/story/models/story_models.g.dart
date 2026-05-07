// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Story _$StoryFromJson(Map<String, dynamic> json) => Story(
      id: json['id'] as String,
      title: json['title'] as String,
      eraId: json['era_id'] as String? ?? 'Unknown',
      description: json['description'] as String,
      heroImageUrl: json['hero_image_url'] as String?,
      xCoordinate: (json['x_coordinate'] as num?)?.toDouble() ?? 0.5,
      yCoordinate: (json['y_coordinate'] as num?)?.toDouble() ?? 0.5,
      isRift: json['is_rift'] as bool? ?? false,
      culture: json['culture'] as String?,
      moralTheme: json['moral_theme'] as String?,
      difficulty: json['difficulty'] as String?,
      estimatedDurationMinutes:
          (json['estimated_duration_minutes'] as num?)?.toInt(),
      totalNodes: (json['total_nodes'] as num?)?.toInt(),
      authorId: json['author_id'] as String?,
      isPremium: json['is_premium'] as bool? ?? false,
      isPublished: json['is_published'] as bool? ?? false,
    );

Map<String, dynamic> _$StoryToJson(Story instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'era_id': instance.eraId,
      'description': instance.description,
      'hero_image_url': instance.heroImageUrl,
      'x_coordinate': instance.xCoordinate,
      'y_coordinate': instance.yCoordinate,
      'is_rift': instance.isRift,
      'culture': instance.culture,
      'moral_theme': instance.moralTheme,
      'difficulty': instance.difficulty,
      'estimated_duration_minutes': instance.estimatedDurationMinutes,
      'total_nodes': instance.totalNodes,
      'author_id': instance.authorId,
      'is_premium': instance.isPremium,
      'is_published': instance.isPublished,
    };

StoryNode _$StoryNodeFromJson(Map<String, dynamic> json) => StoryNode(
      id: json['id'] as String,
      type: $enumDecode(_$NodeTypeEnumMap, json['type']),
      content: json['content'] as String,
      backgroundImage: json['background_image'] as String?,
      isRoot: json['is_root'] as bool? ?? false,
      isEnding: json['is_ending'] as bool? ?? false,
      endingType: json['ending_type'] as String?,
      traitImpacts: json['trait_impacts'] as Map<String, dynamic>?,
      resourceCosts: json['resource_costs'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$StoryNodeToJson(StoryNode instance) => <String, dynamic>{
      'id': instance.id,
      'type': _$NodeTypeEnumMap[instance.type]!,
      'content': instance.content,
      'background_image': instance.backgroundImage,
      'is_root': instance.isRoot,
      'is_ending': instance.isEnding,
      'ending_type': instance.endingType,
      'trait_impacts': instance.traitImpacts,
      'resource_costs': instance.resourceCosts,
    };

const _$NodeTypeEnumMap = {
  NodeType.narrative: 'narrative',
  NodeType.choice: 'choice',
  NodeType.puzzle: 'puzzle',
  NodeType.combat: 'combat',
  NodeType.ending: 'ending',
};

StoryChoice _$StoryChoiceFromJson(Map<String, dynamic> json) => StoryChoice(
      id: json['id'] as String,
      text: json['choice_text'] as String,
      nextNodeId: json['to_node_id'] as String?,
      teCost: (json['te_cost'] as num?)?.toInt() ?? 0,
      ciCost: (json['ci_cost'] as num?)?.toInt() ?? 0,
      ciReward: (json['ci_reward'] as num?)?.toInt() ?? 0,
      traitImpacts: json['trait_impacts'] as Map<String, dynamic>?,
      requiredEchoes: (json['required_echoes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      grantedEchoes: (json['granted_echoes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$StoryChoiceToJson(StoryChoice instance) =>
    <String, dynamic>{
      'id': instance.id,
      'choice_text': instance.text,
      'to_node_id': instance.nextNodeId,
      'te_cost': instance.teCost,
      'ci_cost': instance.ciCost,
      'ci_reward': instance.ciReward,
      'trait_impacts': instance.traitImpacts,
      'required_echoes': instance.requiredEchoes,
      'granted_echoes': instance.grantedEchoes,
    };
