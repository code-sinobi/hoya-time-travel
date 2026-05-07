// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_premise.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoryPremise _$StoryPremiseFromJson(Map<String, dynamic> json) => StoryPremise(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      era: json['era'] as String,
      culture: json['culture'] as String,
      status: json['status'] as String? ?? 'active',
      voteCount: (json['vote_count'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      imageUrl: json['image_url'] as String?,
    );

Map<String, dynamic> _$StoryPremiseToJson(StoryPremise instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'era': instance.era,
      'culture': instance.culture,
      'status': instance.status,
      'vote_count': instance.voteCount,
      'created_at': instance.createdAt.toIso8601String(),
      'image_url': instance.imageUrl,
    };
