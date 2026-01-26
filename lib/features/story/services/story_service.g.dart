// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(StoryService)
final storyServiceProvider = StoryServiceProvider._();

final class StoryServiceProvider extends $NotifierProvider<StoryService, void> {
  StoryServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'storyServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$storyServiceHash();

  @$internal
  @override
  $ProviderElement<StoryService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  StoryService create() => StoryService();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$storyServiceHash() => r'3596d7aad0781c69fdddd18b190d82ac928f703f';

abstract class _$StoryService extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
