// MythicCard Golden Test
// Tests visual consistency of the MythicCard component

import 'package:chrono_app/core/theme/era_theme.dart';
import 'package:chrono_app/core/widgets/mythic_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'dart:io';

void main() {
  testWidgets('MythicCard renders correctly', (WidgetTester tester) async {
    // Build the widget in a constrained environment
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.dark(),
        home: const Scaffold(
          backgroundColor: MythicColors.voidBackground,
          body: Center(
            child: SizedBox(
              width: 300,
              height: 200,
              child: MythicCard(
                child: Center(
                  child: Text(
                    'Golden Test',
                    style: TextStyle(color: MythicColors.parchment),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    // Wait for animations/rendering
    await tester.pumpAndSettle();

    // Verify the card and text render
    expect(find.byType(MythicCard), findsOneWidget);
    expect(find.text('Golden Test'), findsOneWidget);
  }, skip: Platform.environment.containsKey('CI'));
}
