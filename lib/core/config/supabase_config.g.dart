// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supabase_config.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(supabaseConfig)
final supabaseConfigProvider = SupabaseConfigProvider._();

final class SupabaseConfigProvider
    extends $FunctionalProvider<SupabaseConfig, SupabaseConfig, SupabaseConfig>
    with $Provider<SupabaseConfig> {
  SupabaseConfigProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'supabaseConfigProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$supabaseConfigHash();

  @$internal
  @override
  $ProviderElement<SupabaseConfig> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SupabaseConfig create(Ref ref) {
    return supabaseConfig(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SupabaseConfig value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SupabaseConfig>(value),
    );
  }
}

String _$supabaseConfigHash() => r'622593f2ff3cc517cd7cea7492bfd2484d08838d';
