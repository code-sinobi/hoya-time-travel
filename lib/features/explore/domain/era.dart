/// Era represents different time periods in the mythological timeline.
/// Used for categorizing stories and navigation in the Temporal Radar.
enum Era {
  mythic('MYTHIC', 'Age of Gods and Titans'),
  ancient('ANCIENT', 'Classical Civilizations'),
  medieval('MEDIEVAL', 'Knights and Kingdoms'),
  modern('MODERN', 'Industrial to Present'),
  future('FUTURE', 'Tomorrow' 's Myths');

  const Era(this.label, this.description);

  final String label;
  final String description;

  /// Returns the angle position on the radar (in radians)
  double get radarAngle {
    switch (this) {
      case Era.mythic:
        return -1.5708; // 12 o'clock (top)
      case Era.ancient:
        return 0; // 3 o'clock (right)
      case Era.medieval:
        return 1.5708; // 6 o'clock (bottom)
      case Era.modern:
        return 3.1416; // 9 o'clock (left)
      case Era.future:
        return -0.7854; // Between mythic and ancient
    }
  }

  /// Returns the color associated with this era
  int get colorValue {
    switch (this) {
      case Era.mythic:
        return 0xFFFFD700; // Gold
      case Era.ancient:
        return 0xFFE6B17E; // Bronze
      case Era.medieval:
        return 0xFF8B4513; // Saddle brown
      case Era.modern:
        return 0xFF708090; // Slate gray
      case Era.future:
        return 0xFF00CED1; // Dark turquoise
    }
  }
}
