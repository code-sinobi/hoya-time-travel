import 'package:json_annotation/json_annotation.dart';

part 'temporal_echo.g.dart';

/// A persistent tag earned by users through story choices
/// Echoes influence future story variants and unlock special content
@JsonSerializable()
class TemporalEcho {
  const TemporalEcho({
    required this.id,
    required this.userId,
    required this.echoTag,
    required this.earnedAt,
    this.sourceStoryId,
    this.sourceChoiceId,
  });

  factory TemporalEcho.fromJson(Map<String, dynamic> json) =>
      _$TemporalEchoFromJson(json);
  final String id;

  @JsonKey(name: 'user_id')
  final String userId;

  @JsonKey(name: 'echo_tag')
  final String echoTag;

  @JsonKey(name: 'source_story_id')
  final String? sourceStoryId;

  @JsonKey(name: 'source_choice_id')
  final String? sourceChoiceId;

  @JsonKey(name: 'earned_at')
  final DateTime earnedAt;

  /// Common echo tags and their meanings
  static const Map<String, String> echoDescriptions = {
    'patron_of_knowledge': 'One who seeks wisdom above all',
    'friend_of_muses': 'Beloved by the arts and inspiration',
    'ally_of_athena': 'Favored by wisdom and strategy',
    'voice_of_justice': 'A defender of the oppressed',
    'keeper_of_secrets': 'Trusted with hidden truths',
    'child_of_storms': 'One who thrives in chaos',
    'heart_of_mercy': 'Compassionate even to enemies',
    'blade_of_vengeance': 'Justice through retribution',
  };

  String get description => echoDescriptions[echoTag] ?? 'A temporal resonance';
  Map<String, dynamic> toJson() => _$TemporalEchoToJson(this);
}
