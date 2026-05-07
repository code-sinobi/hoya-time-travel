// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'temporal_echo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TemporalEcho _$TemporalEchoFromJson(Map<String, dynamic> json) => TemporalEcho(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      echoTag: json['echo_tag'] as String,
      sourceStoryId: json['source_story_id'] as String?,
      sourceChoiceId: json['source_choice_id'] as String?,
      earnedAt: DateTime.parse(json['earned_at'] as String),
    );

Map<String, dynamic> _$TemporalEchoToJson(TemporalEcho instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'echo_tag': instance.echoTag,
      'source_story_id': instance.sourceStoryId,
      'source_choice_id': instance.sourceChoiceId,
      'earned_at': instance.earnedAt.toIso8601String(),
    };
