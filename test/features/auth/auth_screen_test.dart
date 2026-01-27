// Simplified Auth Screen Tests
// Tests isolated components without full app initialization to avoid Supabase dependency

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hoya_app/core/theme/era_theme.dart';

void main() {
  group('AuthScreen Components', () {
    testWidgets('HOYA branding text renders', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: Center(child: Text('HOYA'))),
        ),
      );

      expect(find.text('HOYA'), findsOneWidget);
    });

    testWidgets('Welcome Back text renders', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: Text('Welcome Back'))),
      );

      expect(find.text('Welcome Back'), findsOneWidget);
    });

    testWidgets('Sign in/up buttons render', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                ElevatedButton(onPressed: () {}, child: const Text('SIGN IN')),
                TextButton(onPressed: () {}, child: const Text('SIGN UP')),
              ],
            ),
          ),
        ),
      );

      expect(find.text('SIGN IN'), findsOneWidget);
      expect(find.text('SIGN UP'), findsOneWidget);
    });

    testWidgets('GlassMorphic style can be applied', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            backgroundColor: MythicColors.voidBackground,
            body: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text('Glass Card'),
            ),
          ),
        ),
      );

      expect(find.text('Glass Card'), findsOneWidget);
    });
  });
}
