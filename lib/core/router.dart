import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/portal/portal_screen.dart';
import '../features/story/story_screen.dart';
import '../features/auth/auth_screen.dart';
import '../features/splash/splash_screen.dart';
import '../features/auth/profile_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/auth/services/auth_service.dart';
import '../features/library/library_screen.dart';
import '../features/explore/explore_screen.dart';
import '../features/rifts/rifts_screen.dart';
import '../features/onboarding/providers/onboarding_provider.dart';
import 'package:hoya_app/features/story/widgets/admin_dashboard.dart';
import 'router/routes.dart';

import 'widgets/scaffold_with_navbar.dart';

part 'router.g.dart';

@riverpod
GoRouter router(Ref ref) {
  final notifier = ref.watch(routerRefreshNotifierProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: notifier,
    redirect: (context, state) {
      final hasCompletedOnboarding = ref.read(onboardingNotifierProvider);
      final isLoggedIn = ref.read(authServiceProvider).currentUser != null;
      final currentPath = state.uri.path;

      debugPrint(
        'ROUTER: path=$currentPath, onboarding=$hasCompletedOnboarding, loggedIn=$isLoggedIn',
      );

      // Allow splash screen to show initially
      if (currentPath == AppRoutes.splash) return null;

      // Redirect to onboarding if not completed
      if (!hasCompletedOnboarding && currentPath != AppRoutes.onboarding) {
        return AppRoutes.onboarding;
      }

      // If finished onboarding but not logged in, go to Auth
      if (hasCompletedOnboarding &&
          !isLoggedIn &&
          currentPath != AppRoutes.auth) {
        return AppRoutes.auth;
      }

      // If logged in and trying to access auth/onboarding/splash, go to Portal
      if (isLoggedIn &&
          (currentPath == AppRoutes.auth ||
              currentPath == AppRoutes.onboarding ||
              currentPath == AppRoutes.splash)) {
        return AppRoutes.portal;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.auth,
        builder: (context, state) => const AuthScreen(),
      ),

      // Main App Shell
      ShellRoute(
        builder: (context, state, child) {
          return ScaffoldWithNavBar(child: child);
        },
        routes: [
          GoRoute(
            path: AppRoutes.portal,
            builder: (context, state) => const PortalScreen(),
          ),
          GoRoute(
            path: AppRoutes.library,
            builder: (context, state) => const LibraryScreen(),
          ),
          GoRoute(
            path: AppRoutes.explore,
            builder: (context, state) => const ExploreScreen(),
          ),
          GoRoute(
            path: AppRoutes.rifts,
            builder: (context, state) => const RiftsScreen(),
          ),
          GoRoute(
            path: AppRoutes.profile,
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),

      // Story Screen (Top Level - hides navbar)
      GoRoute(
        path: '/story/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return StoryScreen(storyId: id);
        },
      ),
      GoRoute(
        path: '/admin',
        builder: (context, state) => const AdminDashboard(),
      ),
    ],
  );
}

/// A notifier that combines auth and onboarding state to trigger router refreshes
class RouterRefreshNotifier extends ChangeNotifier {
  final Ref _ref;

  RouterRefreshNotifier(this._ref) {
    // Watch auth changes
    _ref.listen(authStateChangesProvider, (_, __) {
      notifyListeners();
    });
    // Watch onboarding changes
    _ref.listen(onboardingNotifierProvider, (_, __) {
      notifyListeners();
    });
  }
}

@riverpod
RouterRefreshNotifier routerRefreshNotifier(Ref ref) {
  return RouterRefreshNotifier(ref);
}
