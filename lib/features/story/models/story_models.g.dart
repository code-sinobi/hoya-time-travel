// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Story _$StoryFromJson(Map<String, dynamic> json) => Story(
      id: json['id'] as String,
      title: json['title'] as String,
      eraId: json['eraId'] as String,
      description: json['description'] as String,
      heroImageUrl: json['hero_image_url'] as String?,
      xCoordinate: (json['x_coordinate'] as num?)?.toDouble() ?? 0.5,
      yCoordinate: (json['y_coordinate'] as num?)?.toDouble() ?? 0.5,
      isRift: json['is_rift'] as bool? ?? false,
    );

Map<String, dynamic> _$StoryToJson(Story instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'eraId': instance.eraId,
      'description': instance.description,
      'hero_image_url': instance.heroImageUrl,
      'x_coordinate': instance.xCoordinate,
      'y_coordinate': instance.yCoordinate,
      'is_rift': instance.isRift,
    };

StoryNode _$StoryNodeFromJson(Map<String, dynamic> json) => StoryNode(
      id: json['id'] as String,
      type: $enumDecode(_$NodeTypeEnumMap, json['type']),
      content: json['content'] as String,
      backgroundImage: json['background_image'] as String?,
    );

Map<String, dynamic> _$StoryNodeToJson(StoryNode instance) => <String, dynamic>{
      'id': instance.id,
      'type': _$NodeTypeEnumMap[instance.type]!,
      'content': instance.content,
      'background_image': instance.backgroundImage,
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
      text: json['text'] as String,
      nextNodeId: json['next_node_id'] as String?,
      impact: json['impact'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$StoryChoiceToJson(StoryChoice instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'next_node_id': instance.nextNodeId,
      'impact': instance.impact,
    };
