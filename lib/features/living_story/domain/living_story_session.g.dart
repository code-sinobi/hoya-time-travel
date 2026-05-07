// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'living_story_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LivingStorySession _$LivingStorySessionFromJson(Map<String, dynamic> json) =>
    LivingStorySession(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      storyId: json['story_id'] as String,
      currentNodeId: json['current_node_id'] as String?,
      pathTaken: (json['path_taken'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      temporalEnergy: (json['temporal_energy'] as num?)?.toInt() ?? 100,
      culturalInsight: (json['cultural_insight'] as num?)?.toInt() ?? 0,
      earnedEchoes: (json['earned_echoes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isActive: json['is_active'] as bool? ?? true,
      startedAt: DateTime.parse(json['started_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$LivingStorySessionToJson(LivingStorySession instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'story_id': instance.storyId,
      'current_node_id': instance.currentNodeId,
      'path_taken': instance.pathTaken,
      'temporal_energy': instance.temporalEnergy,
      'cultural_insight': instance.culturalInsight,
      'earned_echoes': instance.earnedEchoes,
      'is_active': instance.isActive,
      'started_at': instance.startedAt.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
