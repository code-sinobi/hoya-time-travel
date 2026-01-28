import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'shared_preferences_provider.g.dart';

/// Provider for SharedPreferences
///
/// Must be overridden in main() with actual instance:
/// ```dart
/// final prefs = await SharedPreferences.getInstance();
/// ProviderScope(
///   overrides: [
///     sharedPreferencesProvider.overrideWithValue(prefs),
///   ],
/// )
/// ```
@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(Ref ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider must be overridden in main()',
  );
}
