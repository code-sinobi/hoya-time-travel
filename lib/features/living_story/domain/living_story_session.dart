import 'package:json_annotation/json_annotation.dart';
import 'story_resources.dart';

part 'living_story_session.g.dart';

/// A user's active session in a Living Story
/// Tracks current position, path taken, resources, and earned echoes
@JsonSerializable()
class LivingStorySession {
  const LivingStorySession({
    required this.id,
    required this.userId,
    required this.storyId,
    required this.startedAt,
    this.currentNodeId,
    this.pathTaken = const [],
    this.temporalEnergy = 100,
    this.culturalInsight = 0,
    this.earnedEchoes = const [],
    this.isActive = true,
    this.updatedAt,
  });

  factory LivingStorySession.fromJson(Map<String, dynamic> json) =>
      _$LivingStorySessionFromJson(json);
  final String id;

  @JsonKey(name: 'user_id')
  final String userId;

  @JsonKey(name: 'story_id')
  final String storyId;

  @JsonKey(name: 'current_node_id')
  final String? currentNodeId;

  @JsonKey(name: 'path_taken')
  final List<String> pathTaken;

  @JsonKey(name: 'temporal_energy')
  final int temporalEnergy;

  @JsonKey(name: 'cultural_insight')
  final int culturalInsight;

  @JsonKey(name: 'earned_echoes')
  final List<String> earnedEchoes;

  @JsonKey(name: 'is_active')
  final bool isActive;

  @JsonKey(name: 'started_at')
  final DateTime startedAt;

  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  /// Get resources as a StoryResources object
  StoryResources get resources => StoryResources(
        temporalEnergy: temporalEnergy,
        culturalInsight: culturalInsight,
      );

  /// Check if a choice can be made with current resources
  bool canAffordChoice({int teCost = 0, int ciCost = 0}) {
    return temporalEnergy >= teCost && culturalInsight >= ciCost;
  }

  /// Get the depth of the current journey
  int get journeyDepth => pathTaken.length;

  /// Check if user has a specific echo
  bool hasEcho(String echoTag) => earnedEchoes.contains(echoTag);

  LivingStorySession copyWith({
    String? id,
    String? userId,
    String? storyId,
    String? currentNodeId,
    List<String>? pathTaken,
    int? temporalEnergy,
    int? culturalInsight,
    List<String>? earnedEchoes,
    bool? isActive,
    DateTime? startedAt,
    DateTime? updatedAt,
  }) {
    return LivingStorySession(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      storyId: storyId ?? this.storyId,
      currentNodeId: currentNodeId ?? this.currentNodeId,
      pathTaken: pathTaken ?? this.pathTaken,
      temporalEnergy: temporalEnergy ?? this.temporalEnergy,
      culturalInsight: culturalInsight ?? this.culturalInsight,
      earnedEchoes: earnedEchoes ?? this.earnedEchoes,
      isActive: isActive ?? this.isActive,
      startedAt: startedAt ?? this.startedAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => _$LivingStorySessionToJson(this);
}
