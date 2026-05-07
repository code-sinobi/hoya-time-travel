import 'package:json_annotation/json_annotation.dart';

part 'user_progress.g.dart';

@JsonSerializable()
class UserProgress {
  UserProgress({
    required this.id,
    required this.userId,
    required this.storyId,
    this.currentNodeId,
    this.isCompleted = false,
    this.lastPlayedAt,
  });

  factory UserProgress.fromJson(Map<String, dynamic> json) =>
      _$UserProgressFromJson(json);
  final String id;
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'story_id')
  final String storyId;
  @JsonKey(name: 'current_node_id')
  final String? currentNodeId;
  @JsonKey(name: 'is_completed')
  final bool isCompleted;
  @JsonKey(name: 'last_played_at')
  final DateTime? lastPlayedAt;
  Map<String, dynamic> toJson() => _$UserProgressToJson(this);
}
