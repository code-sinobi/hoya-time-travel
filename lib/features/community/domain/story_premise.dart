import 'package:json_annotation/json_annotation.dart';

part 'story_premise.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class StoryPremise {
  const StoryPremise({
    required this.id,
    required this.title,
    required this.description,
    required this.era,
    required this.culture,
    required this.createdAt,
    this.status = 'active',
    this.voteCount = 0,
    this.imageUrl,
  });

  factory StoryPremise.fromJson(Map<String, dynamic> json) =>
      _$StoryPremiseFromJson(json);
  final String id;
  final String title;
  final String description;
  final String era;
  final String culture;
  final String status;

  @JsonKey(name: 'vote_count')
  final int voteCount;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @JsonKey(name: 'image_url')
  final String? imageUrl;
  Map<String, dynamic> toJson() => _$StoryPremiseToJson(this);
}
