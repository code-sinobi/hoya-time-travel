import 'package:flutter/material.dart';

import 'core/utils/design_system_validator.dart';
import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/router.dart';
import 'core/theme/app_theme.dart';
import 'core/providers/shared_preferences_provider.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Try loading from .env file
  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    debugPrint('No .env file found or error retrieving it: $e');
  }

  // Initialize Supabase if config is present
  // Priority: 1. --dart-define (Environment), 2. .env file
  String supabaseUrl = const String.fromEnvironment('SUPABASE_URL');
  String supabaseKey = const String.fromEnvironment('SUPABASE_ANON_KEY');

  if (supabaseUrl.isEmpty) {
    supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
  }
  if (supabaseKey.isEmpty) {
    supabaseKey = dotenv.env['SUPABASE_ANON_KEY'] ?? '';
  }

  if (supabaseUrl.isNotEmpty && supabaseKey.isNotEmpty) {
    await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);
  } else {
    debugPrint('Supabase not initialized: Missing keys');
  }

  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const HoyaApp(),
    ),
  );
}

class HoyaApp extends ConsumerWidget {
  const HoyaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final theme = ref.watch(appThemeProvider);

    return MaterialApp.router(
      title: 'Hoya',
      theme: theme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        // Run Design System Validation in Debug Mode
        assert(() {
          if (child != null) {
            // We need a context to look up theme? No we have `theme` variable.
            // But we need to ensure it runs only once or lazily?
            // Calling it here is fine for now as it just prints warnings.
            DesignSystemValidator.validateTheme(theme);
          }
          return true;
        }());

        // return AccessibilityTools(
        //   checkFontOverflows: true,
        //   minimumTapAreas: MinimumTapAreas.material,
        //   child: child ?? const SizedBox.shrink(),
        // );
        return child ?? const SizedBox.shrink();
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
