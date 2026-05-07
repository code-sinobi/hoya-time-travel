// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_traits.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserTraits _$UserTraitsFromJson(Map<String, dynamic> json) => UserTraits(
      userId: json['user_id'] as String,
      empathy: (json['empathy'] as num?)?.toInt() ?? 0,
      justice: (json['justice'] as num?)?.toInt() ?? 0,
      courage: (json['courage'] as num?)?.toInt() ?? 0,
      wisdom: (json['wisdom'] as num?)?.toInt() ?? 0,
      patience: (json['patience'] as num?)?.toInt() ?? 0,
      traitHistory: (json['trait_history'] as List<dynamic>?)
              ?.map((e) => TraitChange.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$UserTraitsToJson(UserTraits instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'empathy': instance.empathy,
      'justice': instance.justice,
      'courage': instance.courage,
      'wisdom': instance.wisdom,
      'patience': instance.patience,
      'trait_history': instance.traitHistory,
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

TraitChange _$TraitChangeFromJson(Map<String, dynamic> json) => TraitChange(
      trait: json['trait'] as String,
      delta: (json['delta'] as num).toInt(),
      storyId: json['story_id'] as String?,
      choiceId: json['choice_id'] as String?,
      changedAt: DateTime.parse(json['changed_at'] as String),
    );

Map<String, dynamic> _$TraitChangeToJson(TraitChange instance) =>
    <String, dynamic>{
      'trait': instance.trait,
      'delta': instance.delta,
      'story_id': instance.storyId,
      'choice_id': instance.choiceId,
      'changed_at': instance.changedAt.toIso8601String(),
    };
