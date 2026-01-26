// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_handler.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Global error handler for the application
///
/// Usage:
/// ```dart
/// try {
///   await someOperation();
/// } catch (e) {
///   ref.read(errorHandlerProvider).handle(
///     AuthException('Login failed', e),
///     context: context,
///   );
/// }
/// ```

@ProviderFor(ErrorHandler)
final errorHandlerProvider = ErrorHandlerProvider._();

/// Global error handler for the application
///
/// Usage:
/// ```dart
/// try {
///   await someOperation();
/// } catch (e) {
///   ref.read(errorHandlerProvider).handle(
///     AuthException('Login failed', e),
///     context: context,
///   );
/// }
/// ```
final class ErrorHandlerProvider extends $NotifierProvider<ErrorHandler, void> {
  /// Global error handler for the application
  ///
  /// Usage:
  /// ```dart
  /// try {
  ///   await someOperation();
  /// } catch (e) {
  ///   ref.read(errorHandlerProvider).handle(
  ///     AuthException('Login failed', e),
  ///     context: context,
  ///   );
  /// }
  /// ```
  ErrorHandlerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'errorHandlerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$errorHandlerHash();

  @$internal
  @override
  ErrorHandler create() => ErrorHandler();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$errorHandlerHash() => r'574345871362832e27b15d51244c2c7210f6ca17';

/// Global error handler for the application
///
/// Usage:
/// ```dart
/// try {
///   await someOperation();
/// } catch (e) {
///   ref.read(errorHandlerProvider).handle(
///     AuthException('Login failed', e),
///     context: context,
///   );
/// }
/// ```

abstract class _$ErrorHandler extends $Notifier<void> {
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
