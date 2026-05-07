import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:chrono/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Full App Flow Tests', () {
    testWidgets('App starts and shows auth screen', (tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Verify auth screen is displayed (user not logged in)
      expect(find.text('HOYA'), findsOneWidget);
      expect(find.text('Welcome Back'), findsOneWidget);
    });

    testWidgets('Can navigate between sign in and sign up', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Initially in sign in mode
      expect(find.text('Welcome Back'), findsOneWidget);

      // Tap sign up toggle
      await tester.tap(find.text('SIGN UP'));
      await tester.pumpAndSettle();

      // Verify we've switched to sign up mode
      expect(find.text('Join the Journey'), findsOneWidget);

      // Go back to sign in
      await tester.tap(find.text('SIGN IN'));
      await tester.pumpAndSettle();

      expect(find.text('Welcome Back'), findsOneWidget);
    });

    testWidgets('Form fields are interactive', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Find and interact with text fields
      final textFields = find.byType(TextField);

      if (textFields.evaluate().isNotEmpty) {
        // Enter email
        await tester.enterText(textFields.first, 'test@example.com');
        await tester.pump();

        // Verify text was entered
        expect(find.text('test@example.com'), findsOneWidget);
      }
    });
  });

  group('UI Responsiveness Tests', () {
    testWidgets('Auth screen renders without overflow', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // If there's an overflow, pumpAndSettle would show errors
      // Just verify key elements render
      expect(find.text('HOYA'), findsOneWidget);
      expect(find.text('Welcome Back'), findsOneWidget);

      // No exception = no overflow
    });
  });
}
