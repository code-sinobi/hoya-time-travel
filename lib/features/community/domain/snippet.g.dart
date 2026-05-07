// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'snippet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Snippet _$SnippetFromJson(Map<String, dynamic> json) => Snippet(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      content: json['content'] as String,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      status: json['status'] as String? ?? 'submitted',
      upvotes: (json['upvotes'] as num?)?.toInt() ?? 0,
      downvotes: (json['downvotes'] as num?)?.toInt() ?? 0,
      originStoryId: json['origin_story_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$SnippetToJson(Snippet instance) => <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'content': instance.content,
      'tags': instance.tags,
      'status': instance.status,
      'upvotes': instance.upvotes,
      'downvotes': instance.downvotes,
      'origin_story_id': instance.originStoryId,
      'created_at': instance.createdAt.toIso8601String(),
    };
