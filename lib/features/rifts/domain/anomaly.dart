import 'package:json_annotation/json_annotation.dart';
import '../../explore/domain/era.dart';

part 'anomaly.g.dart';

/// Severity levels for timeline anomalies
enum AnomalySeverity {
  @JsonValue('critical')
  critical,
  @JsonValue('high')
  high,
  @JsonValue('stable')
  stable,
}

/// Represents a timeline anomaly that threatens to destabilize history.
/// Anomalies can cascade - affecting other connected stories.
@JsonSerializable(fieldRename: FieldRename.snake)
class Anomaly {
  const Anomaly({
    required this.id,
    required this.storyId,
    required this.title,
    required this.location,
    required this.severity,
    this.era = 'MODERN',
    this.destabilizationPercent = 0.0,
    this.collapseDeadline,
    this.storySnippet = '',
    this.purgeCost = 50,
    this.stabilizeCost = 100,
    this.cascadeAnomalyIds = const [],
    this.isGlitching = false,
    this.imageUrl,
  });

  factory Anomaly.fromJson(Map<String, dynamic> json) =>
      _$AnomalyFromJson(json);
  final String id;
  final String storyId;
  final String title;
  final String location;
  final AnomalySeverity severity;

  /// The Era this anomaly belongs to (e.g. MYTHIC, ANCIENT)
  final String era;

  /// Current destabilization level (0.0 = stable, 1.0 = collapsed)
  final double destabilizationPercent;

  /// When this anomaly will auto-collapse if not addressed
  @JsonKey(name: 'collapse_deadline')
  final DateTime? collapseDeadline;

  /// Narrative snippet explaining the crisis
  @JsonKey(name: 'story_snippet')
  final String storySnippet;

  /// Temporal Energy cost to purge this anomaly
  @JsonKey(name: 'purge_cost')
  final int purgeCost;

  /// Chronos cost to stabilize this anomaly
  @JsonKey(name: 'stabilize_cost')
  final int stabilizeCost;

  /// IDs of other anomalies affected if this one collapses
  @JsonKey(name: 'cascade_anomaly_ids')
  final List<String> cascadeAnomalyIds;

  /// Whether this anomaly is actively glitching (visual effect)
  @JsonKey(name: 'is_glitching')
  final bool isGlitching;

  /// Optional image URL for the anomaly thumbnail
  @JsonKey(name: 'image_url')
  final String? imageUrl;

  /// Time remaining until collapse, or Duration.zero if no deadline
  Duration get timeRemaining {
    if (collapseDeadline == null) return Duration.zero;
    final remaining = collapseDeadline!.difference(DateTime.now());
    return remaining.isNegative ? Duration.zero : remaining;
  }

  /// Whether this anomaly has a countdown active
  bool get hasCountdown =>
      collapseDeadline != null && timeRemaining > Duration.zero;

  /// Whether this anomaly is about to collapse (< 1 hour remaining)
  bool get isUrgent => hasCountdown && timeRemaining.inHours < 1;

  /// Returns the parsed Era enum from the string value
  Era get parsedEra {
    return Era.values.firstWhere(
      (e) => e.label.toUpperCase() == era.toUpperCase(),
      orElse: () => Era.modern,
    );
  }

  /// Human-readable time remaining (e.g., "2h 34m")
  String get timeRemainingFormatted {
    if (!hasCountdown) return '';
    final hours = timeRemaining.inHours;
    final minutes = timeRemaining.inMinutes % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  Map<String, dynamic> toJson() => _$AnomalyToJson(this);

  Anomaly copyWith({
    String? id,
    String? storyId,
    String? title,
    String? location,
    AnomalySeverity? severity,
    String? era,
    double? destabilizationPercent,
    DateTime? collapseDeadline,
    String? storySnippet,
    int? purgeCost,
    int? stabilizeCost,
    List<String>? cascadeAnomalyIds,
    bool? isGlitching,
    String? imageUrl,
  }) {
    return Anomaly(
      id: id ?? this.id,
      storyId: storyId ?? this.storyId,
      title: title ?? this.title,
      location: location ?? this.location,
      severity: severity ?? this.severity,
      era: era ?? this.era,
      destabilizationPercent:
          destabilizationPercent ?? this.destabilizationPercent,
      collapseDeadline: collapseDeadline ?? this.collapseDeadline,
      storySnippet: storySnippet ?? this.storySnippet,
      purgeCost: purgeCost ?? this.purgeCost,
      stabilizeCost: stabilizeCost ?? this.stabilizeCost,
      cascadeAnomalyIds: cascadeAnomalyIds ?? this.cascadeAnomalyIds,
      isGlitching: isGlitching ?? this.isGlitching,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
