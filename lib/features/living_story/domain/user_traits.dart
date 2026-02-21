import 'package:json_annotation/json_annotation.dart';

part 'user_traits.g.dart';

@JsonSerializable()
class UserTraits {
  final String userId;
  final int order;
  final int chaos;
  final int heroism;
  final int pragmatism;
  final DateTime lastUpdated;

  UserTraits({
    required this.userId,
    required this.order,
    required this.chaos,
    required this.heroism,
    required this.pragmatism,
    required this.lastUpdated,
  });

  factory UserTraits.fromJson(Map<String, dynamic> json) =>
      _$UserTraitsFromJson(json);

  Map<String, dynamic> toJson() => _$UserTraitsToJson(this);

  /// Default starting traits for a new user.
  factory UserTraits.defaults(String userId) {
    return UserTraits(
      userId: userId,
      order: 50,
      chaos: 50,
      heroism: 50,
      pragmatism: 50,
      lastUpdated: DateTime.now(),
    );
  }

  UserTraits copyWithTrait(String traitName, int newValue) {
    return UserTraits(
      userId: userId,
      order: traitName.toLowerCase() == 'order' ? newValue : order,
      chaos: traitName.toLowerCase() == 'chaos' ? newValue : chaos,
      heroism: traitName.toLowerCase() == 'heroism' ? newValue : heroism,
      pragmatism: traitName.toLowerCase() == 'pragmatism' ? newValue : pragmatism,
      lastUpdated: DateTime.now(),
    );
  }

  int getTraitValue(String trait) {
    switch (trait.toLowerCase()) {
      case 'order': return order;
      case 'chaos': return chaos;
      case 'heroism': return heroism;
      case 'pragmatism': return pragmatism;
      default: return 50;
    }
  }

  String get dominantTrait {
    final map = {
      'ORDER': order,
      'CHAOS': chaos,
      'HEROISM': heroism,
      'PRAGMATISM': pragmatism,
    };
    return map.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }
}

class TraitHistory {
  final String traitName;
  final int value;
  final DateTime timestamp;

  TraitHistory({
    required this.traitName,
    required this.value,
    required this.timestamp,
  });
}
