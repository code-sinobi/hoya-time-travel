import 'package:json_annotation/json_annotation.dart';

part 'profile.g.dart';

@JsonSerializable()
class Profile {
  final String id;
  final String? username;
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;
  final int xp;
  final int level;

  Profile({
    required this.id,
    this.username,
    this.avatarUrl,
    this.xp = 0,
    this.level = 1,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileToJson(this);
}
