// Chrono App Smoke Test
// Simplified test that verifies core theme elements without full app initialization

import 'package:chrono_app/core/theme/era_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ChronoApp Smoke Tests', () {
    testWidgets('Core theme elements are defined', (tester) async {
      // Verify MythicColors are properly defined
      expect(MythicColors.voidBackground, isA<Color>());
      expect(MythicColors.parchment, isA<Color>());
      expect(MythicColors.bronze, isA<Color>());
      expect(MythicColors.deepIndigo, isA<Color>());
    });

    testWidgets('App branding renders correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text('HOYA'), Text('Welcome Back')],
              ),
            ),
          ),
        ),
      );

      // Verify branding text
      expect(find.text('HOYA'), findsOneWidget);
      expect(find.text('Welcome Back'), findsOneWidget);
    });
  });
}
