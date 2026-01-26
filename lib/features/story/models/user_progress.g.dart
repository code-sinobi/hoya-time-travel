// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_progress.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProgress _$UserProgressFromJson(Map<String, dynamic> json) => UserProgress(
  id: json['id'] as String,
  userId: json['user_id'] as String,
  storyId: json['story_id'] as String,
  currentNodeId: json['current_node_id'] as String?,
  isCompleted: json['is_completed'] as bool? ?? false,
  lastPlayedAt: json['last_played_at'] == null
      ? null
      : DateTime.parse(json['last_played_at'] as String),
);

Map<String, dynamic> _$UserProgressToJson(UserProgress instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'story_id': instance.storyId,
      'current_node_id': instance.currentNodeId,
      'is_completed': instance.isCompleted,
      'last_played_at': instance.lastPlayedAt?.toIso8601String(),
    };
