// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'echo_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EchoResponseTemplate _$EchoResponseTemplateFromJson(
        Map<String, dynamic> json) =>
    EchoResponseTemplate(
      id: json['id'] as String,
      contextType: json['context_type'] as String,
      triggerConditions:
          json['trigger_conditions'] as Map<String, dynamic>? ?? const {},
      responseTemplate: json['response_template'] as String,
      variables: (json['variables'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      tone: json['tone'] as String? ?? 'philosophical',
      priority: (json['priority'] as num?)?.toInt() ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$EchoResponseTemplateToJson(
        EchoResponseTemplate instance) =>
    <String, dynamic>{
      'id': instance.id,
      'context_type': instance.contextType,
      'trigger_conditions': instance.triggerConditions,
      'response_template': instance.responseTemplate,
      'variables': instance.variables,
      'tone': instance.tone,
      'priority': instance.priority,
      'is_active': instance.isActive,
      'created_at': instance.createdAt?.toIso8601String(),
    };
