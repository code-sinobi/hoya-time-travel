import 'package:json_annotation/json_annotation.dart';

part 'snippet.g.dart';

@JsonSerializable()
class Snippet {
  const Snippet({
    required this.id,
    required this.userId,
    required this.content,
    required this.createdAt,
    this.tags = const [],
    this.status = 'submitted',
    this.upvotes = 0,
    this.downvotes = 0,
    this.originStoryId,
  });

  factory Snippet.fromJson(Map<String, dynamic> json) =>
      _$SnippetFromJson(json);
  final String id;
  @JsonKey(name: 'user_id')
  final String userId;
  final String content;
  final List<String> tags;
  final String status;

  @JsonKey(name: 'upvotes')
  final int upvotes;

  @JsonKey(name: 'downvotes')
  final int downvotes;

  @JsonKey(name: 'origin_story_id')
  final String? originStoryId;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  Map<String, dynamic> toJson() => _$SnippetToJson(this);
}
