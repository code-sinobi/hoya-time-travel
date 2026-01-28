import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'app_exceptions.dart';
import '../utils/logger.dart';

part 'error_handler.g.dart';

/// Global error handler for the application
///
/// Usage:
/// ```dart
/// try {
///   await someOperation();
/// } catch (e) {
///   ref.read(errorHandlerProvider).handle(
///     AuthException('Entry failed', e),
///     context: context,
///   );
/// }
/// ```
@riverpod
class ErrorHandler extends _$ErrorHandler {
  @override
  void build() {}

  /// Handle an exception with logging and optional user notification
  void handle(
    AppException exception, {
    BuildContext? context,
    bool showSnackBar = true,
  }) {
    // Log the error
    AppLogger.error(
      exception.message,
      error: exception.innerError,
      data: {'exceptionType': exception.runtimeType.toString()},
    );

    // Show user-friendly message if context is provided
    if (context != null && showSnackBar) {
      _showErrorSnackBar(context, exception);
    }
  }

  /// Handle a generic error that hasn't been wrapped in AppException
  void handleGeneric(
    Object error, {
    BuildContext? context,
    String? message,
    bool showSnackBar = true,
  }) {
    final exception = DataException(
      message ?? 'An unexpected error occurred',
      error,
    );
    handle(exception, context: context, showSnackBar: showSnackBar);
  }

  void _showErrorSnackBar(BuildContext context, AppException exception) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_getUserFriendlyMessage(exception)),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  String _getUserFriendlyMessage(AppException exception) {
    return switch (exception) {
      NetworkException() => 'Network error. Please check your connection.',
      AuthException() => exception.message,
      AIException() => 'AI service temporarily unavailable.',
      DataException() => 'Failed to save data. Please try again.',
      ValidationException() => exception.message,
    };
  }
}
