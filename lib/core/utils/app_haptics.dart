import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Centralized utility for consistent haptic feedback across the app.
class AppHaptics {
  /// Light tap for standard buttons, minor interactions, and generic taps.
  static Future<void> buttonPress() {
    if (!kIsWeb) return HapticFeedback.lightImpact();
    return Future.value();
  }

  /// Medium tap for important actions, destructive confirmations, or opening modals.
  static Future<void> mediumImpact() {
    if (!kIsWeb) return HapticFeedback.mediumImpact();
    return Future.value();
  }

  /// Heavy impact for completing major tasks, level ups, or big state changes.
  static Future<void> heavyImpact() {
    if (!kIsWeb) return HapticFeedback.heavyImpact();
    return Future.value();
  }

  /// Selection feedback for tabs, segmented controls, sliders, and list items.
  static Future<void> selection() {
    if (!kIsWeb) return HapticFeedback.selectionClick();
    return Future.value();
  }

  /// Special feedback for success states.
  static Future<void> success() {
    if (!kIsWeb) return HapticFeedback.mediumImpact();
    return Future.value();
  }

  /// Vibrate for errors, warnings, or invalid states.
  static Future<void> error() {
    if (!kIsWeb) return HapticFeedback.vibrate();
    return Future.value();
  }
}
