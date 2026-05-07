import 'dart:developer' as dev;
import 'package:flutter/foundation.dart';

/// Simple logging utility for the app
///
/// Usage:
/// ```dart
/// AppLogger.info('User logged in', data: {'userId': user.id});
/// AppLogger.error('Failed to save progress', error: e);
/// ```
class AppLogger {
  static void debug(String message, {Map<String, dynamic>? data}) {
    if (kDebugMode) {
      _log('DEBUG', message, data: data);
    }
  }

  static void info(String message, {Map<String, dynamic>? data}) {
    _log('INFO', message, data: data);
  }

  static void warning(
    String message, {
    Map<String, dynamic>? data,
    Object? error,
  }) {
    _log('WARNING', message, data: data, error: error);
  }

  static void error(
    String message, {
    Map<String, dynamic>? data,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log('ERROR', message, data: data, error: error);
    if (stackTrace != null && kDebugMode) {
      dev.log('Stack trace', name: 'AppLogger', stackTrace: stackTrace);
    }
  }

  static void _log(
    String level,
    String message, {
    Map<String, dynamic>? data,
    Object? error,
  }) {
    final timestamp = DateTime.now().toIso8601String();
    final buffer = StringBuffer();
    buffer.write('[$timestamp] [$level] $message');

    if (data != null && data.isNotEmpty) {
      buffer.write(' | Data: $data');
    }

    if (error != null) {
      buffer.write(' | Error: $error');
    }

    if (kDebugMode) {
      dev.log(buffer.toString(), name: 'AppLogger');
    }
  }
}
