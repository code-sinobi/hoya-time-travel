// Test utilities for Chrono App tests
// Provides common setup helpers for widget and integration tests

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Wraps a widget in required providers for testing
Widget createTestableWidget(Widget child, {List<Override>? overrides}) {
  return ProviderScope(
    overrides: overrides ?? [],
    child: MaterialApp(home: child),
  );
}

/// Pumps widget with optional settling for animations
Future<void> pumpWidgetAndSettle(
  WidgetTester tester,
  Widget widget, {
  Duration? duration,
}) async {
  await tester.pumpWidget(widget);
  if (duration != null) {
    await tester.pump(duration);
  } else {
    await tester.pumpAndSettle();
  }
}

/// Common text finders for the app
class AppFinders {
  // Portal Screen
  static Finder get chronoTitle => find.text('CHRONO');
  static Finder get archiveTitle => find.text('ARCHIVE');
  static Finder get recentDiscoveries => find.text('RECENT DISCOVERIES');

  // Auth Screen
  static Finder get welcomeBack => find.text('Welcome Back');
  static Finder get signIn => find.text('SIGN IN');
  static Finder get signUp => find.text('SIGN UP');
  static Finder get emailField => find.byType(TextField).first;
}
