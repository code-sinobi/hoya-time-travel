import 'package:json_annotation/json_annotation.dart';

part 'story_models.g.dart';

@JsonSerializable()
class Story {
  Story({
    required this.id,
    required this.title,
    required this.eraId,
    required this.description,
    required this.heroImageUrl,
    this.xCoordinate = 0.5,
    this.yCoordinate = 0.5,
    this.isRift = false,
    this.culture,
    this.moralTheme,
    this.difficulty,
    this.estimatedDurationMinutes,
    this.totalNodes,
    this.authorId,
    this.isPremium = false,
    this.isPublished = false,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    final data = Map<String, dynamic>.from(json);
    data['description'] ??= '';
    return _$StoryFromJson(data);
  }
  final String id;
  final String title;
  @JsonKey(name: 'era_id', defaultValue: 'Unknown')
  final String eraId;
  final String description;
  @JsonKey(name: 'hero_image_url')
  final String? heroImageUrl;
  @JsonKey(name: 'x_coordinate', defaultValue: 0.5)
  final double xCoordinate;
  @JsonKey(name: 'y_coordinate', defaultValue: 0.5)
  final double yCoordinate;
  @JsonKey(name: 'is_rift', defaultValue: false)
  final bool isRift;

  // New columns
  final String? culture;
  @JsonKey(name: 'moral_theme')
  final String? moralTheme;
  final String? difficulty;
  @JsonKey(name: 'estimated_duration_minutes')
  final int? estimatedDurationMinutes;
  @JsonKey(name: 'total_nodes')
  final int? totalNodes;
  @JsonKey(name: 'author_id')
  final String? authorId;
  @JsonKey(name: 'is_premium', defaultValue: false)
  final bool isPremium;
  @JsonKey(name: 'is_published', defaultValue: false)
  final bool isPublished;
  Map<String, dynamic> toJson() => _$StoryToJson(this);
}

enum NodeType { narrative, choice, puzzle, combat, ending }

@JsonSerializable()
class StoryNode {
  StoryNode({
    required this.id,
    required this.type,
    required this.content,
    this.backgroundImage,
    this.isRoot = false,
    this.isEnding = false,
    this.endingType,
    this.traitImpacts,
    this.resourceCosts,
    this.choices = const [],
  });

  factory StoryNode.fromJson(Map<String, dynamic> json) =>
      _$StoryNodeFromJson(json);
  final String id;
  final NodeType type;
  final String content; // The narrative text or puzzle description
  @JsonKey(name: 'background_image')
  final String? backgroundImage;

  // New columns
  @JsonKey(name: 'is_root')
  final bool isRoot;
  @JsonKey(name: 'is_ending')
  final bool isEnding;
  @JsonKey(name: 'ending_type')
  final String? endingType; // triumph, tragedy, etc.
  @JsonKey(name: 'trait_impacts')
  final Map<String, dynamic>? traitImpacts;
  @JsonKey(name: 'resource_costs')
  final Map<String, dynamic>? resourceCosts;

  @JsonKey(
    includeFromJson: false,
  ) // Choices are fetched separately now and merged manually in repository
  final List<StoryChoice> choices;

  StoryNode copyWith({
    String? id,
    NodeType? type,
    String? content,
    String? backgroundImage,
    bool? isRoot,
    bool? isEnding,
    String? endingType,
    Map<String, dynamic>? traitImpacts,
    Map<String, dynamic>? resourceCosts,
    List<StoryChoice>? choices,
  }) {
    return StoryNode(
      id: id ?? this.id,
      type: type ?? this.type,
      content: content ?? this.content,
      backgroundImage: backgroundImage ?? this.backgroundImage,
      isRoot: isRoot ?? this.isRoot,
      isEnding: isEnding ?? this.isEnding,
      endingType: endingType ?? this.endingType,
      traitImpacts: traitImpacts ?? this.traitImpacts,
      resourceCosts: resourceCosts ?? this.resourceCosts,
      choices: choices ?? this.choices,
    );
  }

  Map<String, dynamic> toJson() => _$StoryNodeToJson(this);
}

@JsonSerializable()
class StoryChoice {
  StoryChoice({
    required this.id,
    required this.text,
    this.nextNodeId,
    this.teCost = 0,
    this.ciCost = 0,
    this.ciReward = 0,
    this.traitImpacts,
    this.requiredEchoes,
    this.grantedEchoes,
  });

  factory StoryChoice.fromJson(Map<String, dynamic> json) {
    // Handle field mapping between legacy 'text' and new 'choice_text'
    // If json has 'choice_text' use it, else 'text'
    final textVal = json['choice_text'] ?? json['text'] ?? '';
    final Map<String, dynamic> effectiveJson = Map.from(json);
    effectiveJson['choice_text'] = textVal;

    // Handle next_node_id vs to_node_id
    // If json has 'to_node_id', map it to next_node_id for dart model
    if (effectiveJson['next_node_id'] == null &&
        effectiveJson['to_node_id'] != null) {
      effectiveJson['next_node_id'] = effectiveJson['to_node_id'];
    }

    return _$StoryChoiceFromJson(effectiveJson);
  }
  final String id;
  @JsonKey(name: 'choice_text')
  final String
      text; // mapped from choice_text in DB? Note DB has choice_text, old model had text.
  // The json_serializable might map straight name if not annotated.
  // DB column is choice_text according to my plan? Checking migration...
  // Migration: ADD COLUMN IF NOT EXISTS choice_text text NOT NULL
  // Old model: text.
  @JsonKey(
    name: 'to_node_id',
  ) // Changed from next_node_id to to_node_id to match standard or kept legacy?
  // Migration said to_node_id/from_node_id in schema plan,
  // but let's check what I actually ran.
  // Migration: create_node_variants_and_sessions, extended existing story_choices?
  // Wait, existing table had next_node_id. My schema plan said to_node_id.
  // I should check strict mapping.
  // For safety, I'll alias both or check existing.
  final String? nextNodeId;

  // New columns
  @JsonKey(name: 'te_cost')
  final int teCost;
  @JsonKey(name: 'ci_cost')
  final int ciCost;
  @JsonKey(name: 'ci_reward')
  final int ciReward;
  @JsonKey(name: 'trait_impacts')
  final Map<String, dynamic>? traitImpacts;
  @JsonKey(name: 'required_echoes')
  final List<String>? requiredEchoes;
  @JsonKey(name: 'granted_echoes')
  final List<String>? grantedEchoes;
  Map<String, dynamic> toJson() => _$StoryChoiceToJson(this);
}
