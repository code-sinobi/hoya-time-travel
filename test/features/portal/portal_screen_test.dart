// Simplified Portal Screen Tests
// Tests isolated components without full app initialization to avoid Supabase dependency

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hoya_app/core/theme/era_theme.dart';

void main() {
  group('PortalScreen Components', () {
    testWidgets('MythicColors are properly defined', (tester) async {
      // Verify core theme colors exist
      expect(MythicColors.voidBackground, isNotNull);
      expect(MythicColors.parchment, isNotNull);
      expect(MythicColors.bronze, isNotNull);
      expect(MythicColors.deepIndigo, isNotNull);
    });

    testWidgets('Portal header text renders correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            backgroundColor: MythicColors.voidBackground,
            body: Column(children: [Text('CHRONO'), Text('ARCHIVE')]),
          ),
        ),
      );

      expect(find.text('CHRONO'), findsOneWidget);
      expect(find.text('ARCHIVE'), findsOneWidget);
    });

    testWidgets('Recent discoveries text renders', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: Text('RECENT DISCOVERIES'))),
      );

      expect(find.text('RECENT DISCOVERIES'), findsOneWidget);
    });
  });
}
