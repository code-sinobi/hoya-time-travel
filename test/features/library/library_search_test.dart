import 'package:chrono_app/features/library/library_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Library Search Query State Tests', () {
    test('librarySearchQueryProvider defaults to empty string', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final query = container.read(librarySearchQueryProvider);
      expect(query, '');
    });

    test('Updating search query updates the state correctly', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(librarySearchQueryProvider.notifier).state = 'space';
      expect(container.read(librarySearchQueryProvider), 'space');

      container.read(librarySearchQueryProvider.notifier).state = 'cyberpunk';
      expect(container.read(librarySearchQueryProvider), 'cyberpunk');
    });
  });
}
