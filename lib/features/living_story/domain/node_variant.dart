import 'package:json_annotation/json_annotation.dart';

part 'node_variant.g.dart';

/// A variant of a story node that activates based on user context
/// Allows personalized content without runtime AI generation
@JsonSerializable()
class NodeVariant {
  const NodeVariant({
    required this.id,
    required this.baseNodeId,
    required this.variantTrigger,
    required this.variantContent,
    this.priority = 0,
    this.createdAt,
  });

  factory NodeVariant.fromJson(Map<String, dynamic> json) =>
      _$NodeVariantFromJson(json);
  final String id;

  @JsonKey(name: 'base_node_id')
  final String baseNodeId;

  /// Trigger condition string, e.g.:
  /// - "has:patron_of_knowledge" (user has this echo)
  /// - "courage >= 15" (trait threshold)
  /// - "completed:greek_odyssey" (story completion)
  @JsonKey(name: 'variant_trigger')
  final String variantTrigger;

  /// The alternative content to display when trigger matches
  @JsonKey(name: 'variant_content')
  final String variantContent;

  /// Higher priority variants are checked first
  final int priority;

  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  /// Parse the trigger type from the trigger string
  VariantTriggerType get triggerType {
    if (variantTrigger.startsWith('has:')) {
      return VariantTriggerType.echo;
    } else if (variantTrigger.startsWith('completed:')) {
      return VariantTriggerType.storyCompleted;
    } else if (variantTrigger.contains('>=') ||
        variantTrigger.contains('<=') ||
        variantTrigger.contains('>') ||
        variantTrigger.contains('<')) {
      return VariantTriggerType.traitThreshold;
    }
    return VariantTriggerType.unknown;
  }

  Map<String, dynamic> toJson() => _$NodeVariantToJson(this);
}

enum VariantTriggerType {
  echo, // has:tag_name
  traitThreshold, // courage >= 15
  storyCompleted, // completed:story_id
  unknown,
}
