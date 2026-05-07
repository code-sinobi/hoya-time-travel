import 'package:json_annotation/json_annotation.dart';

part 'story_resources.g.dart';

/// User resources for the Living Story Engine
/// Temporal Energy (TE) - depletes with choices, regenerates over time
/// Cultural Insight (CI) - earned through wise choices, spent on premium options
@JsonSerializable()
class StoryResources {
  const StoryResources({
    this.temporalEnergy = 100,
    this.culturalInsight = 0,
    this.teMax = 100,
    this.teRefreshRate = 20,
    this.teLastRefresh,
  });

  factory StoryResources.fromJson(Map<String, dynamic> json) =>
      _$StoryResourcesFromJson(json);
  @JsonKey(name: 'temporal_energy')
  final int temporalEnergy;

  @JsonKey(name: 'cultural_insight')
  final int culturalInsight;

  @JsonKey(name: 'te_max')
  final int teMax;

  @JsonKey(name: 'te_refresh_rate')
  final int teRefreshRate;

  @JsonKey(name: 'te_last_refresh')
  final DateTime? teLastRefresh;

  /// Check if user can afford a choice
  bool canAfford({int teCost = 0, int ciCost = 0}) {
    return temporalEnergy >= teCost && culturalInsight >= ciCost;
  }

  /// Calculate refreshed TE based on time elapsed
  StoryResources withRefreshedEnergy() {
    if (teLastRefresh == null) return this;

    final elapsed = DateTime.now().difference(teLastRefresh!);
    final hoursElapsed = elapsed.inMinutes / 60.0;
    final energyGained = (hoursElapsed * teRefreshRate).floor();
    final newEnergy = (temporalEnergy + energyGained).clamp(0, teMax);

    return copyWith(
      temporalEnergy: newEnergy,
      teLastRefresh: DateTime.now(),
    );
  }

  StoryResources copyWith({
    int? temporalEnergy,
    int? culturalInsight,
    int? teMax,
    int? teRefreshRate,
    DateTime? teLastRefresh,
  }) {
    return StoryResources(
      temporalEnergy: temporalEnergy ?? this.temporalEnergy,
      culturalInsight: culturalInsight ?? this.culturalInsight,
      teMax: teMax ?? this.teMax,
      teRefreshRate: teRefreshRate ?? this.teRefreshRate,
      teLastRefresh: teLastRefresh ?? this.teLastRefresh,
    );
  }

  Map<String, dynamic> toJson() => _$StoryResourcesToJson(this);
}
