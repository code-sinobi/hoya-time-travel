// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$libraryFilteredStoriesHash() =>
    r'de820b629cd04686b0b6503fd01f6a3b00d244a0';

/// See also [libraryFilteredStories].
@ProviderFor(libraryFilteredStories)
final libraryFilteredStoriesProvider =
    AutoDisposeFutureProvider<List<StoryMetadata>>.internal(
  libraryFilteredStories,
  name: r'libraryFilteredStoriesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$libraryFilteredStoriesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LibraryFilteredStoriesRef
    = AutoDisposeFutureProviderRef<List<StoryMetadata>>;
String _$archiveFilterHash() => r'f575a4c6de18604000e3516173b24cf733054a81';

/// See also [ArchiveFilter].
@ProviderFor(ArchiveFilter)
final archiveFilterProvider =
    AutoDisposeNotifierProvider<ArchiveFilter, ArchiveFilterState>.internal(
  ArchiveFilter.new,
  name: r'archiveFilterProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$archiveFilterHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ArchiveFilter = AutoDisposeNotifier<ArchiveFilterState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
