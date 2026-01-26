import 'package:json_annotation/json_annotation.dart';

part 'story_models.g.dart';

@JsonSerializable()
class Story {
  final String id;
  final String title;
  final String eraId;
  final String description;
  final String heroImageUrl;

  Story({
    required this.id,
    required this.title,
    required this.eraId,
    required this.description,
    required this.heroImageUrl,
  });

  factory Story.fromJson(Map<String, dynamic> json) => _$StoryFromJson(json);
  Map<String, dynamic> toJson() => _$StoryToJson(this);
}

enum NodeType { narrative, choice, puzzle, combat, ending }

@JsonSerializable()
class StoryNode {
  final String id;
  final NodeType type;
  final String content; // The narrative text or puzzle description
  @JsonKey(name: 'background_image')
  final String? backgroundImage;
  @JsonKey(
    includeFromJson: false,
  ) // Choices are fetched separately now and merged manually in repository
  final List<StoryChoice> choices;

  StoryNode({
    required this.id,
    required this.type,
    required this.content,
    this.backgroundImage,
    this.choices = const [],
  });

  factory StoryNode.fromJson(Map<String, dynamic> json) =>
      _$StoryNodeFromJson(json);
  Map<String, dynamic> toJson() => _$StoryNodeToJson(this);
}

@JsonSerializable()
class StoryChoice {
  final String id;
  final String text;
  @JsonKey(name: 'next_node_id')
  final String? nextNodeId; // Null if it triggers AI generation
  final Map<String, dynamic>? impact; // { "health": -10, "gold": +5 }

  StoryChoice({
    required this.id,
    required this.text,
    this.nextNodeId,
    this.impact,
  });

  factory StoryChoice.fromJson(Map<String, dynamic> json) =>
      _$StoryChoiceFromJson(json);
  Map<String, dynamic> toJson() => _$StoryChoiceToJson(this);
}
