// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_theme.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CurrentEra)
final currentEraProvider = CurrentEraProvider._();

final class CurrentEraProvider extends $NotifierProvider<CurrentEra, EraType> {
  CurrentEraProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentEraProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentEraHash();

  @$internal
  @override
  CurrentEra create() => CurrentEra();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EraType value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EraType>(value),
    );
  }
}

String _$currentEraHash() => r'510e0b806714b849268256b3ccffe5589eec72c3';

abstract class _$CurrentEra extends $Notifier<EraType> {
  EraType build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<EraType, EraType>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<EraType, EraType>,
              EraType,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(appTheme)
final appThemeProvider = AppThemeProvider._();

final class AppThemeProvider
    extends $FunctionalProvider<ThemeData, ThemeData, ThemeData>
    with $Provider<ThemeData> {
  AppThemeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appThemeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appThemeHash();

  @$internal
  @override
  $ProviderElement<ThemeData> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ThemeData create(Ref ref) {
    return appTheme(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ThemeData value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ThemeData>(value),
    );
  }
}

String _$appThemeHash() => r'a60a3de48f58a1642665181d8703eb49f3538b09';
