// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(storyRepository)
final storyRepositoryProvider = StoryRepositoryProvider._();

final class StoryRepositoryProvider
    extends
        $FunctionalProvider<StoryRepository, StoryRepository, StoryRepository>
    with $Provider<StoryRepository> {
  StoryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'storyRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$storyRepositoryHash();

  @$internal
  @override
  $ProviderElement<StoryRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  StoryRepository create(Ref ref) {
    return storyRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StoryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StoryRepository>(value),
    );
  }
}

String _$storyRepositoryHash() => r'dc9a138b3cdd77133cc7d37fd548de187aecf912';

@ProviderFor(allUserProgress)
final allUserProgressProvider = AllUserProgressProvider._();

final class AllUserProgressProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<UserProgress>>,
          List<UserProgress>,
          FutureOr<List<UserProgress>>
        >
    with
        $FutureModifier<List<UserProgress>>,
        $FutureProvider<List<UserProgress>> {
  AllUserProgressProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allUserProgressProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allUserProgressHash();

  @$internal
  @override
  $FutureProviderElement<List<UserProgress>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<UserProgress>> create(Ref ref) {
    return allUserProgress(ref);
  }
}

String _$allUserProgressHash() => r'0c0e87661a67cdd79f40167dc294d41d10492d1d';

/// Provider that returns a Set of completed story IDs for quick lookup

@ProviderFor(completedStoryIds)
final completedStoryIdsProvider = CompletedStoryIdsProvider._();

/// Provider that returns a Set of completed story IDs for quick lookup

final class CompletedStoryIdsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Set<String>>,
          Set<String>,
          FutureOr<Set<String>>
        >
    with $FutureModifier<Set<String>>, $FutureProvider<Set<String>> {
  /// Provider that returns a Set of completed story IDs for quick lookup
  CompletedStoryIdsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'completedStoryIdsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$completedStoryIdsHash();

  @$internal
  @override
  $FutureProviderElement<Set<String>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Set<String>> create(Ref ref) {
    return completedStoryIds(ref);
  }
}

String _$completedStoryIdsHash() => r'591e04f3e284f770d24ee12ca122aec39ef4735e';
