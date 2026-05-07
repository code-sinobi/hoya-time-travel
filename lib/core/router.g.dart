// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'router.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$routerHash() => r'2a6a04a187df979b9d3e0e80bf83ace7fe1eb3f8';

/// See also [router].
@ProviderFor(router)
final routerProvider = AutoDisposeProvider<GoRouter>.internal(
  router,
  name: r'routerProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$routerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RouterRef = AutoDisposeProviderRef<GoRouter>;
String _$routerRefreshNotifierHash() =>
    r'bd50dce67bc1e02b250320a03574ae1c27311093';

/// A notifier that combines auth and onboarding state to trigger router refreshes
///
/// Copied from [RouterRefreshNotifier].
@ProviderFor(RouterRefreshNotifier)
final routerRefreshNotifierProvider =
    AutoDisposeNotifierProvider<RouterRefreshNotifier, void>.internal(
  RouterRefreshNotifier.new,
  name: r'routerRefreshNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$routerRefreshNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$RouterRefreshNotifier = AutoDisposeNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
