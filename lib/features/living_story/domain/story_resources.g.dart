// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_resources.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoryResources _$StoryResourcesFromJson(Map<String, dynamic> json) =>
    StoryResources(
      temporalEnergy: (json['temporal_energy'] as num?)?.toInt() ?? 100,
      culturalInsight: (json['cultural_insight'] as num?)?.toInt() ?? 0,
      teMax: (json['te_max'] as num?)?.toInt() ?? 100,
      teRefreshRate: (json['te_refresh_rate'] as num?)?.toInt() ?? 20,
      teLastRefresh: json['te_last_refresh'] == null
          ? null
          : DateTime.parse(json['te_last_refresh'] as String),
    );

Map<String, dynamic> _$StoryResourcesToJson(StoryResources instance) =>
    <String, dynamic>{
      'temporal_energy': instance.temporalEnergy,
      'cultural_insight': instance.culturalInsight,
      'te_max': instance.teMax,
      'te_refresh_rate': instance.teRefreshRate,
      'te_last_refresh': instance.teLastRefresh?.toIso8601String(),
    };
