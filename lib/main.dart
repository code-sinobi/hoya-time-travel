import 'dart:ui';

import 'package:accessibility_tools/accessibility_tools.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/providers/shared_preferences_provider.dart';
import 'core/router.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/design_system_validator.dart';
import 'core/utils/logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables from .env file
  await dotenv.load();
  final String supabaseUrl = dotenv.env['SUPABASE_URL'] ??
      const String.fromEnvironment('SUPABASE_URL');
  final String supabaseKey = dotenv.env['SUPABASE_ANON_KEY'] ??
      const String.fromEnvironment('SUPABASE_ANON_KEY');

  if (supabaseUrl.isNotEmpty && supabaseKey.isNotEmpty) {
    await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);
  } else {
    AppLogger.error(
      'Supabase not initialized: Missing SUPABASE_URL or SUPABASE_ANON_KEY',
    );
  }

  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const ChronoApp(),
    ),
  );
}

class ChronoApp extends ConsumerWidget {
  const ChronoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final theme = ref.watch(appThemeProvider);

    return MaterialApp.router(
      title: 'Chrono',
      theme: theme,
      routerConfig: router,
      scrollBehavior: const AppScrollBehavior(),
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        // Run Design System Validation in Debug Mode
        assert(
          () {
            if (child != null) {
              // We need a context to look up theme? No we have `theme` variable.
              // But we need to ensure it runs only once or lazily?
              // Calling it here is fine for now as it just prints warnings.
              DesignSystemValidator.validateTheme(theme);
            }
            return true;
          }(),
          'Background effect parameter bounds check',
        );

        Widget result = child ?? const SizedBox.shrink();
        if (kDebugMode) {
          result = AccessibilityTools(
            checkFontOverflows: true,
            child: result,
          );
        }
        return result;
      },
    );
  }
}

class AppScrollBehavior extends MaterialScrollBehavior {
  const AppScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
