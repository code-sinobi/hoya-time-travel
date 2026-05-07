// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_handler.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$errorHandlerHash() => r'574345871362832e27b15d51244c2c7210f6ca17';

/// Global error handler for the application
///
/// Usage:
/// ```dart
/// try {
///   await someOperation();
/// } on Object catch (e) {
///   ref.read(errorHandlerProvider).handle(
///     AuthException('Entry failed', e),
///     context: context,
///   );
/// }
/// ```
///
/// Copied from [ErrorHandler].
@ProviderFor(ErrorHandler)
final errorHandlerProvider =
    AutoDisposeNotifierProvider<ErrorHandler, void>.internal(
  ErrorHandler.new,
  name: r'errorHandlerProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$errorHandlerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ErrorHandler = AutoDisposeNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
