import 'package:json_annotation/json_annotation.dart';

part 'story_models.g.dart';

enum NodeType { narrative, decision, checkpoint, ending }

@JsonSerializable()
class Story {
  final String id;
  final String title;
  final String authorId;
  final String eraId;
  final bool isPublished;
  final DateTime createdAt;
  final Map<String, dynamic>? metadata;

  Story({
    required this.id,
    required this.title,
    required this.authorId,
    required this.eraId,
    required this.isPublished,
    required this.createdAt,
    this.metadata,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    // Defensive copy to avoid mutating the original map
    final data = Map<String, dynamic>.from(json);
    return _$StoryFromJson(data);
  }

  Map<String, dynamic> toJson() => _$StoryToJson(this);
}

@JsonSerializable()
class StoryNode {
  final String id;
  final NodeType type;
  final String content;
  final List<StoryChoice> choices;
  final bool isRoot;
  final bool isEnding;
  final String? endingType;

  StoryNode({
    required this.id,
    required this.type,
    required this.content,
    required this.choices,
    this.isRoot = false,
    this.isEnding = false,
    this.endingType,
  });

  factory StoryNode.fromJson(Map<String, dynamic> json) =>
      _$StoryNodeFromJson(json);

  Map<String, dynamic> toJson() => _$StoryNodeToJson(this);
}

@JsonSerializable()
class StoryChoice {
  final String id;
  final String text;
  final String? nextNodeId;
  final Map<String, dynamic>? requirements;

  StoryChoice({
    required this.id,
    required this.text,
    this.nextNodeId,
    this.requirements,
  });

  factory StoryChoice.fromJson(Map<String, dynamic> json) =>
      _$StoryChoiceFromJson(json);

  Map<String, dynamic> toJson() => _$StoryChoiceToJson(this);
}
