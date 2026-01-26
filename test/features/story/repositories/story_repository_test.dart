import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoya_app/features/story/repositories/story_repository.dart';

void main() {
  group('StoryRepository', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('storyRepositoryProvider is created', () {
      final repository = container.read(storyRepositoryProvider);
      expect(repository, isA<StoryRepository>());
    });

    test('getProgress returns null when not authenticated', () async {
      final repository = container.read(storyRepositoryProvider);

      final progress = await repository.getProgress('test_story');
      expect(progress, isNull);
    });

    test('getAllProgress returns empty list when not authenticated', () async {
      final result = await container.read(allUserProgressProvider.future);
      expect(result, isEmpty);
    });

    test(
      'saveProgress completes without error when not authenticated',
      () async {
        final repository = container.read(storyRepositoryProvider);

        // Should complete without throwing
        await expectLater(
          repository.saveProgress(storyId: 'test', currentNodeId: 'node1'),
          completes,
        );
      },
    );

    // Future: Add tests with mocked SupabaseClient to verify:
    // - Successful progress retrieval
    // - Successful progress saving
    // - Error handling for network failures
    // - Data mapping from Supabase to UserProgress model
  });
}
