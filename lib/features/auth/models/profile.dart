import 'package:json_annotation/json_annotation.dart';

part 'profile.g.dart';

@JsonSerializable()
class Profile {
  Profile({
    required this.id,
    this.username,
    this.avatarUrl,
    this.xp = 0,
    this.level = 1,
    this.subscriptionTier = 'free',
    this.role = 'traveler',
  });

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
  final String id;
  final String? username;
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;
  final int xp;
  final int level;

  @JsonKey(name: 'subscription_tier')
  final String subscriptionTier;
  @JsonKey(name: 'role')
  final String role;

  bool get isChronicler => role == 'chronicler' || role == 'admin';
  Map<String, dynamic> toJson() => _$ProfileToJson(this);
}
