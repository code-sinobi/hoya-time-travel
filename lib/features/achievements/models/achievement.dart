import 'package:flutter/material.dart';

class Achievement {
  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.iconCodePoint,
    required this.iconFontFamily,
    required this.iconFontPackage,
    required this.threshold,
    required this.requirementType,
    this.isUnlocked = false,
    this.currentProgress = 0,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      iconCodePoint: json['iconCodePoint'] as String,
      iconFontFamily: json['iconFontFamily'] as String,
      iconFontPackage: json['iconFontPackage'] as String,
      threshold: json['threshold'] as int,
      requirementType: json['requirementType'] as String,
      isUnlocked: json['isUnlocked'] as bool? ?? false,
      currentProgress: json['currentProgress'] as int? ?? 0,
    );
  }
  final String id;
  final String title;
  final String description;
  final String iconCodePoint;
  final String iconFontFamily;
  final String iconFontPackage;
  final int threshold; // For progress-based achievements
  final String requirementType; // e.g. 'stories_read', 'nodes_discovered'
  final bool isUnlocked;
  final int currentProgress;

  Achievement copyWith({
    String? id,
    String? title,
    String? description,
    String? iconCodePoint,
    String? iconFontFamily,
    String? iconFontPackage,
    int? threshold,
    String? requirementType,
    bool? isUnlocked,
    int? currentProgress,
  }) {
    return Achievement(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      iconFontFamily: iconFontFamily ?? this.iconFontFamily,
      iconFontPackage: iconFontPackage ?? this.iconFontPackage,
      threshold: threshold ?? this.threshold,
      requirementType: requirementType ?? this.requirementType,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      currentProgress: currentProgress ?? this.currentProgress,
    );
  }
}

// Extension to easily get the IconData
extension AchievementIcon on Achievement {
  IconData get iconData => IconData(
        int.parse(iconCodePoint, radix: 16),
        fontFamily: iconFontFamily,
        fontPackage: iconFontPackage.isEmpty ? null : iconFontPackage,
      );
}
