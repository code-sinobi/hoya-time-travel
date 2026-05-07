// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'anomaly_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$anomalyRepositoryHash() => r'2134331bd837718e4bbcf2ab8f0b6f783dcad0b8';

/// Provides the AnomalyRepository instance
///
/// Copied from [anomalyRepository].
@ProviderFor(anomalyRepository)
final anomalyRepositoryProvider =
    AutoDisposeProvider<AnomalyRepository>.internal(
  anomalyRepository,
  name: r'anomalyRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$anomalyRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AnomalyRepositoryRef = AutoDisposeProviderRef<AnomalyRepository>;
String _$activeAnomaliesHash() => r'ceec6589bb82f84838c75597712d4f59cc0bb2f1';

/// Fetches active anomalies as an async value
///
/// Copied from [activeAnomalies].
@ProviderFor(activeAnomalies)
final activeAnomaliesProvider =
    AutoDisposeFutureProvider<List<Anomaly>>.internal(
  activeAnomalies,
  name: r'activeAnomaliesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$activeAnomaliesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ActiveAnomaliesRef = AutoDisposeFutureProviderRef<List<Anomaly>>;
String _$anomaliesStreamHash() => r'5f09b8ee0e340036f9b9a730f3800cd48dc41d39';

/// Streams anomalies for real-time updates
///
/// Copied from [anomaliesStream].
@ProviderFor(anomaliesStream)
final anomaliesStreamProvider =
    AutoDisposeStreamProvider<List<Anomaly>>.internal(
  anomaliesStream,
  name: r'anomaliesStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$anomaliesStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AnomaliesStreamRef = AutoDisposeStreamProviderRef<List<Anomaly>>;
String _$cascadeAnomaliesHash() => r'f35c16394a62a167228e1e12d9d71e18fd985a17';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Fetches cascade-connected anomalies for a given anomaly
///
/// Copied from [cascadeAnomalies].
@ProviderFor(cascadeAnomalies)
const cascadeAnomaliesProvider = CascadeAnomaliesFamily();

/// Fetches cascade-connected anomalies for a given anomaly
///
/// Copied from [cascadeAnomalies].
class CascadeAnomaliesFamily extends Family<AsyncValue<List<Anomaly>>> {
  /// Fetches cascade-connected anomalies for a given anomaly
  ///
  /// Copied from [cascadeAnomalies].
  const CascadeAnomaliesFamily();

  /// Fetches cascade-connected anomalies for a given anomaly
  ///
  /// Copied from [cascadeAnomalies].
  CascadeAnomaliesProvider call(
    String anomalyId,
  ) {
    return CascadeAnomaliesProvider(
      anomalyId,
    );
  }

  @override
  CascadeAnomaliesProvider getProviderOverride(
    covariant CascadeAnomaliesProvider provider,
  ) {
    return call(
      provider.anomalyId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'cascadeAnomaliesProvider';
}

/// Fetches cascade-connected anomalies for a given anomaly
///
/// Copied from [cascadeAnomalies].
class CascadeAnomaliesProvider
    extends AutoDisposeFutureProvider<List<Anomaly>> {
  /// Fetches cascade-connected anomalies for a given anomaly
  ///
  /// Copied from [cascadeAnomalies].
  CascadeAnomaliesProvider(
    String anomalyId,
  ) : this._internal(
          (ref) => cascadeAnomalies(
            ref as CascadeAnomaliesRef,
            anomalyId,
          ),
          from: cascadeAnomaliesProvider,
          name: r'cascadeAnomaliesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$cascadeAnomaliesHash,
          dependencies: CascadeAnomaliesFamily._dependencies,
          allTransitiveDependencies:
              CascadeAnomaliesFamily._allTransitiveDependencies,
          anomalyId: anomalyId,
        );

  CascadeAnomaliesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.anomalyId,
  }) : super.internal();

  final String anomalyId;

  @override
  Override overrideWith(
    FutureOr<List<Anomaly>> Function(CascadeAnomaliesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CascadeAnomaliesProvider._internal(
        (ref) => create(ref as CascadeAnomaliesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        anomalyId: anomalyId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Anomaly>> createElement() {
    return _CascadeAnomaliesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CascadeAnomaliesProvider && other.anomalyId == anomalyId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, anomalyId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CascadeAnomaliesRef on AutoDisposeFutureProviderRef<List<Anomaly>> {
  /// The parameter `anomalyId` of this provider.
  String get anomalyId;
}

class _CascadeAnomaliesProviderElement
    extends AutoDisposeFutureProviderElement<List<Anomaly>>
    with CascadeAnomaliesRef {
  _CascadeAnomaliesProviderElement(super.provider);

  @override
  String get anomalyId => (origin as CascadeAnomaliesProvider).anomalyId;
}

String _$anomalyControllerHash() => r'ae09870dee9982a10e7e96264a3aa7e96450c45d';

/// Controller for anomaly actions (purge, stabilize)
///
/// Copied from [AnomalyController].
@ProviderFor(AnomalyController)
final anomalyControllerProvider =
    AutoDisposeNotifierProvider<AnomalyController, AsyncValue<void>>.internal(
  AnomalyController.new,
  name: r'anomalyControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$anomalyControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AnomalyController = AutoDisposeNotifier<AsyncValue<void>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
