import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoya_app/main.dart';

void main() {
  testWidgets('HoyaApp smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: HoyaApp()));

    // Verify that the Portal Screen title is present.
    // Note: Since animations are involved, we might need to settle.
    await tester.pumpAndSettle();

    expect(find.text('HOYA'), findsOneWidget);
    // User is not logged in, so we expect Auth Screen content
    expect(find.text('Welcome Back'), findsOneWidget);
    // We should NOT see the portal content yet
    expect(find.text('LIBRARY OF LEGENDS'), findsNothing);
  });
}
