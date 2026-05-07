// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'anomaly.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Anomaly _$AnomalyFromJson(Map<String, dynamic> json) => Anomaly(
      id: json['id'] as String,
      storyId: json['story_id'] as String,
      title: json['title'] as String,
      location: json['location'] as String,
      severity: $enumDecode(_$AnomalySeverityEnumMap, json['severity']),
      era: json['era'] as String? ?? 'MODERN',
      destabilizationPercent:
          (json['destabilization_percent'] as num?)?.toDouble() ?? 0.0,
      collapseDeadline: json['collapse_deadline'] == null
          ? null
          : DateTime.parse(json['collapse_deadline'] as String),
      storySnippet: json['story_snippet'] as String? ?? '',
      purgeCost: (json['purge_cost'] as num?)?.toInt() ?? 50,
      stabilizeCost: (json['stabilize_cost'] as num?)?.toInt() ?? 100,
      cascadeAnomalyIds: (json['cascade_anomaly_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isGlitching: json['is_glitching'] as bool? ?? false,
      imageUrl: json['image_url'] as String?,
    );

Map<String, dynamic> _$AnomalyToJson(Anomaly instance) => <String, dynamic>{
      'id': instance.id,
      'story_id': instance.storyId,
      'title': instance.title,
      'location': instance.location,
      'severity': _$AnomalySeverityEnumMap[instance.severity]!,
      'era': instance.era,
      'destabilization_percent': instance.destabilizationPercent,
      'collapse_deadline': instance.collapseDeadline?.toIso8601String(),
      'story_snippet': instance.storySnippet,
      'purge_cost': instance.purgeCost,
      'stabilize_cost': instance.stabilizeCost,
      'cascade_anomaly_ids': instance.cascadeAnomalyIds,
      'is_glitching': instance.isGlitching,
      'image_url': instance.imageUrl,
    };

const _$AnomalySeverityEnumMap = {
  AnomalySeverity.critical: 'critical',
  AnomalySeverity.high: 'high',
  AnomalySeverity.stable: 'stable',
};
