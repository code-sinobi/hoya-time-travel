import 'package:chrono_app/features/library/domain/archive_filter_state.dart';
import 'package:chrono_app/features/library/presentation/library_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Archive Filter State Tests', () {
    test('archiveFilterProvider defaults are correct', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final filter = container.read(archiveFilterProvider);
      expect(filter.searchQuery, '');
      expect(filter.selectedMode, ArchiveMode.vault);
      expect(filter.selectedEra, isNull);
    });

    test('Updating search query updates the state correctly', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(archiveFilterProvider.notifier).setSearchQuery('space');
      expect(container.read(archiveFilterProvider).searchQuery, 'space');

      container
          .read(archiveFilterProvider.notifier)
          .setSearchQuery('cyberpunk');
      expect(container.read(archiveFilterProvider).searchQuery, 'cyberpunk');
    });
  });
}
