import 'package:json_annotation/json_annotation.dart';

part 'echo_response.g.dart';

/// Pre-authored Echo mentor response template
/// Used for pattern-matching based on user context
@JsonSerializable()
class EchoResponseTemplate {
  const EchoResponseTemplate({
    required this.id,
    required this.contextType,
    required this.responseTemplate,
    this.triggerConditions = const {},
    this.variables = const [],
    this.tone = 'philosophical',
    this.priority = 0,
    this.isActive = true,
    this.createdAt,
  });

  factory EchoResponseTemplate.fromJson(Map<String, dynamic> json) =>
      _$EchoResponseTemplateFromJson(json);
  final String id;

  /// Context when this response is applicable
  /// Options: greeting, farewell, post_story, trait_reflection,
  /// growth_guidance, snippet_coaching, dilemma_reframe
  @JsonKey(name: 'context_type')
  final String contextType;

  /// JSON conditions that must match for this template to be selected
  /// e.g., {"dominant_trait": "courage", "ending_type": "triumph"}
  @JsonKey(name: 'trigger_conditions')
  final Map<String, dynamic> triggerConditions;

  /// Template string with variables in {braces}
  /// e.g., "Your {dominant_trait} shines, Traveler."
  @JsonKey(name: 'response_template')
  final String responseTemplate;

  /// List of variable names used in the template
  final List<String> variables;

  /// Tone of the response: philosophical, warm, mystical, etc.
  final String tone;

  /// Higher priority templates are checked first
  final int priority;

  @JsonKey(name: 'is_active')
  final bool isActive;

  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  /// Resolve the template with provided variable values
  String resolve(Map<String, String> variableValues) {
    String result = responseTemplate;
    for (final variable in variables) {
      final value = variableValues[variable] ?? variable;
      result = result.replaceAll('{$variable}', value);
    }
    return result;
  }

  Map<String, dynamic> toJson() => _$EchoResponseTemplateToJson(this);
}

/// Context types for Echo responses
class EchoContextType {
  static const greeting = 'greeting';
  static const farewell = 'farewell';
  static const postStory = 'post_story';
  static const traitReflection = 'trait_reflection';
  static const growthGuidance = 'growth_guidance';
  static const snippetCoaching = 'snippet_coaching';
  static const dilemmaReframe = 'dilemma_reframe';
}
