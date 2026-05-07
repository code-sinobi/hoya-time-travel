// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'node_variant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NodeVariant _$NodeVariantFromJson(Map<String, dynamic> json) => NodeVariant(
      id: json['id'] as String,
      baseNodeId: json['base_node_id'] as String,
      variantTrigger: json['variant_trigger'] as String,
      variantContent: json['variant_content'] as String,
      priority: (json['priority'] as num?)?.toInt() ?? 0,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$NodeVariantToJson(NodeVariant instance) =>
    <String, dynamic>{
      'id': instance.id,
      'base_node_id': instance.baseNodeId,
      'variant_trigger': instance.variantTrigger,
      'variant_content': instance.variantContent,
      'priority': instance.priority,
      'created_at': instance.createdAt?.toIso8601String(),
    };
