// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'openrouter_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// OpenRouter API Service
/// Uses the OpenRouter unified API for AI model access
/// Default model: GLM 4.5 Air (free)

@ProviderFor(openRouterService)
final openRouterServiceProvider = OpenRouterServiceProvider._();

/// OpenRouter API Service
/// Uses the OpenRouter unified API for AI model access
/// Default model: GLM 4.5 Air (free)

final class OpenRouterServiceProvider
    extends
        $FunctionalProvider<
          OpenRouterService,
          OpenRouterService,
          OpenRouterService
        >
    with $Provider<OpenRouterService> {
  /// OpenRouter API Service
  /// Uses the OpenRouter unified API for AI model access
  /// Default model: GLM 4.5 Air (free)
  OpenRouterServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'openRouterServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$openRouterServiceHash();

  @$internal
  @override
  $ProviderElement<OpenRouterService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  OpenRouterService create(Ref ref) {
    return openRouterService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OpenRouterService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OpenRouterService>(value),
    );
  }
}

String _$openRouterServiceHash() => r'7824096e03b63695be3c98fcdc435aac8d943e65';
