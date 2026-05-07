/// Centralized route constants for type-safe navigation
///
/// Usage:
/// ```dart
/// context.go(AppRoutes.splash);
/// context.go(AppRoutes.story('ancient_01'));
/// ```
abstract class AppRoutes {
  // First-run flow
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';

  // Auth flow
  static const String auth = '/auth';

  // Main app
  static const String portal = '/portal';
  static const String library = '/library';
  static const String explore = '/explore';
  static const String community = '/community';
  static const String rifts = '/rifts';
  static const String profile = '/profile';

  // Dynamic routes
  static String story(String id) => '/story/$id';
}
