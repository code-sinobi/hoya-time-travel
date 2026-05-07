import 'package:json_annotation/json_annotation.dart';

part 'user_traits.g.dart';

/// The Wisdom Compass - tracks user's growth across 5 core virtues
/// Values increase/decrease based on story choices
@JsonSerializable()
class UserTraits {
  const UserTraits({
    required this.userId,
    this.empathy = 0,
    this.justice = 0,
    this.courage = 0,
    this.wisdom = 0,
    this.patience = 0,
    this.traitHistory = const [],
    this.updatedAt,
  });

  /// Creates default traits for a new user with all values at 0
  factory UserTraits.defaults(String userId) => UserTraits(userId: userId);

  factory UserTraits.fromJson(Map<String, dynamic> json) =>
      _$UserTraitsFromJson(json);
  @JsonKey(name: 'user_id')
  final String userId;

  final int empathy;
  final int justice;
  final int courage;
  final int wisdom;
  final int patience;

  @JsonKey(name: 'trait_history')
  final List<TraitChange> traitHistory;

  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  /// Get the dominant trait (highest value)
  String get dominantTrait {
    final traits = {
      'empathy': empathy,
      'justice': justice,
      'courage': courage,
      'wisdom': wisdom,
      'patience': patience,
    };
    return traits.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  /// Get the weakest trait (lowest value)
  String get weakestTrait {
    final traits = {
      'empathy': empathy,
      'justice': justice,
      'courage': courage,
      'wisdom': wisdom,
      'patience': patience,
    };
    return traits.entries.reduce((a, b) => a.value < b.value ? a : b).key;
  }

  /// Get trait value by name
  int getTraitValue(String traitName) {
    switch (traitName.toLowerCase()) {
      case 'empathy':
        return empathy;
      case 'justice':
        return justice;
      case 'courage':
        return courage;
      case 'wisdom':
        return wisdom;
      case 'patience':
        return patience;
      default:
        return 0;
    }
  }

  /// Get all traits as a map for the Wisdom Compass visualization
  Map<String, int> toCompassMap() => {
        'empathy': empathy,
        'justice': justice,
        'courage': courage,
        'wisdom': wisdom,
        'patience': patience,
      };

  UserTraits copyWith({
    String? userId,
    int? empathy,
    int? justice,
    int? courage,
    int? wisdom,
    int? patience,
    List<TraitChange>? traitHistory,
    DateTime? updatedAt,
  }) {
    return UserTraits(
      userId: userId ?? this.userId,
      empathy: empathy ?? this.empathy,
      justice: justice ?? this.justice,
      courage: courage ?? this.courage,
      wisdom: wisdom ?? this.wisdom,
      patience: patience ?? this.patience,
      traitHistory: traitHistory ?? this.traitHistory,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => _$UserTraitsToJson(this);
}

/// Records a single trait change for the Journey Map
@JsonSerializable()
class TraitChange {
  const TraitChange({
    required this.trait,
    required this.delta,
    required this.changedAt,
    this.storyId,
    this.choiceId,
  });

  factory TraitChange.fromJson(Map<String, dynamic> json) =>
      _$TraitChangeFromJson(json);
  final String trait;
  final int delta;

  @JsonKey(name: 'story_id')
  final String? storyId;

  @JsonKey(name: 'choice_id')
  final String? choiceId;

  @JsonKey(name: 'changed_at')
  final DateTime changedAt;
  Map<String, dynamic> toJson() => _$TraitChangeToJson(this);
}
