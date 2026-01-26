// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$storyRepositoryHash() => r'dc9a138b3cdd77133cc7d37fd548de187aecf912';

/// See also [storyRepository].
@ProviderFor(storyRepository)
final storyRepositoryProvider = Provider<StoryRepository>.internal(
  storyRepository,
  name: r'storyRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$storyRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef StoryRepositoryRef = ProviderRef<StoryRepository>;
String _$allUserProgressHash() => r'0c0e87661a67cdd79f40167dc294d41d10492d1d';

/// See also [allUserProgress].
@ProviderFor(allUserProgress)
final allUserProgressProvider =
    AutoDisposeFutureProvider<List<UserProgress>>.internal(
      allUserProgress,
      name: r'allUserProgressProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$allUserProgressHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AllUserProgressRef = AutoDisposeFutureProviderRef<List<UserProgress>>;
String _$completedStoryIdsHash() => r'591e04f3e284f770d24ee12ca122aec39ef4735e';

/// Provider that returns a Set of completed story IDs for quick lookup
///
/// Copied from [completedStoryIds].
@ProviderFor(completedStoryIds)
final completedStoryIdsProvider =
    AutoDisposeFutureProvider<Set<String>>.internal(
      completedStoryIds,
      name: r'completedStoryIdsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$completedStoryIdsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CompletedStoryIdsRef = AutoDisposeFutureProviderRef<Set<String>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
