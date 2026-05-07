import 'package:chrono_app/features/auth/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PasswordStrengthIndicator Tests', () {
    testWidgets('Empty password yields no label', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PasswordStrengthIndicator(password: ''),
          ),
        ),
      );

      expect(find.text('WEAK'), findsNothing);
      expect(find.text('GOOD'), findsNothing);
      expect(find.text('STRONG'), findsNothing);
    });

    testWidgets('Weak password yields WEAK indicator',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PasswordStrengthIndicator(password: '123'),
          ),
        ),
      );

      expect(find.text('WEAK'), findsOneWidget);
    });

    testWidgets('Good password yields GOOD indicator',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PasswordStrengthIndicator(password: 'password123'),
          ),
        ),
      );

      expect(find.text('GOOD'), findsOneWidget);
    });

    testWidgets('Strong password yields STRONG indicator',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PasswordStrengthIndicator(password: 'MySuperS3cr3tP@ssw0rd!'),
          ),
        ),
      );

      expect(find.text('STRONG'), findsOneWidget);
    });
  });
}
