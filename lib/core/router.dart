import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../features/admin/presentation/admin_dashboard_screen.dart';
import '../features/auth/auth_screen.dart';
import '../features/auth/profile_screen.dart';
import '../features/auth/services/auth_service.dart';
import '../features/auth/services/profile_service.dart';
import '../features/chronicler/presentation/chronicler_dashboard_screen.dart';
import '../features/chronicler/presentation/chronicler_onboarding_screen.dart';
import '../features/chronicler/presentation/node_editor_screen.dart';
import '../features/chronicler/presentation/story_graph_screen.dart';
import '../features/community/presentation/community_screen.dart';
import '../features/library/presentation/library_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/onboarding/providers/onboarding_provider.dart';
import '../features/portal/portal_screen.dart';
import '../features/rifts/rifts_screen.dart';
import '../features/splash/splash_screen.dart';
import '../features/story/story_intro_screen.dart';
import '../features/story/story_screen.dart';
import 'router/routes.dart';
import 'utils/logger.dart';
import 'widgets/scaffold_with_navbar.dart';

part 'router.g.dart';

@riverpod
GoRouter router(Ref ref) {
  final notifier = ref.watch(routerRefreshNotifierProvider.notifier);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: notifier,
    redirect: (context, state) {
      final hasCompletedOnboarding = ref.read(onboardingNotifierProvider);
      final isLoggedIn = ref.read(authServiceProvider).currentUser != null;
      final currentPath = state.uri.path;

      AppLogger.debug(
        'ROUTER: path=$currentPath, onboarding=$hasCompletedOnboarding, loggedIn=$isLoggedIn',
      );

      // Allow splash screen to show initially
      if (currentPath == AppRoutes.splash) return null;

      // Redirect to onboarding if not completed
      if (!hasCompletedOnboarding) {
        // Prevent redirect loop - if already at onboarding, stay there
        if (currentPath == AppRoutes.onboarding) return null;
        return AppRoutes.onboarding;
      }

      // If finished onboarding but not logged in, go to Auth
      if (hasCompletedOnboarding && !isLoggedIn) {
        // Prevent redirect loop - if already at auth, stay there
        if (currentPath == AppRoutes.auth) return null;
        return AppRoutes.auth;
      }

      // If logged in and trying to access auth/onboarding/splash, go to Portal
      if (isLoggedIn &&
          (currentPath == AppRoutes.auth ||
              currentPath == AppRoutes.onboarding ||
              currentPath == AppRoutes.splash)) {
        // Prevent redirect loop - if already at portal, stay there
        if (currentPath == AppRoutes.portal) return null;
        return AppRoutes.portal;
      }

      final profile = ref.read(userProfileProvider).valueOrNull;

      // Admin route guard
      if (currentPath.startsWith('/admin')) {
        if (profile == null || profile.role != 'admin') {
          AppLogger.warning('Unauthorized access attempt to /admin');
          return AppRoutes.portal;
        }
      }

      // Chronicler route guard
      if (currentPath.startsWith('/chronicler')) {
        if (profile == null ||
            (profile.role != 'admin' && profile.role != 'chronicler')) {
          AppLogger.warning('Unauthorized access attempt to /chronicler');
          return AppRoutes.portal;
        }
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
            path: AppRoutes.community,
            builder: (context, state) => const CommunityScreen(),
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
        routes: [
          GoRoute(
            path: 'intro',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return StoryIntroScreen(storyId: id);
            },
          ),
        ],
      ),

      GoRoute(
        path: '/admin',
        builder: (context, state) => const AdminDashboardScreen(),
      ),

      GoRoute(
        path: '/chronicler',
        builder: (context, state) => const ChroniclerDashboardScreen(),
        routes: [
          GoRoute(
            path: 'onboarding',
            builder: (context, state) => const ChroniclerOnboardingScreen(),
          ),
          GoRoute(
            path: 'story/:storyId',
            builder: (context, state) {
              final storyId = state.pathParameters['storyId']!;
              final storyTitle =
                  state.uri.queryParameters['title'] ?? 'Story Graph';
              return StoryGraphScreen(storyId: storyId, storyTitle: storyTitle);
            },
            routes: [
              GoRoute(
                path: 'node/:nodeId',
                builder: (context, state) {
                  final storyId = state.pathParameters['storyId']!;
                  final nodeId = state.pathParameters['nodeId']!;
                  return NodeEditorScreen(storyId: storyId, nodeId: nodeId);
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

/// A notifier that combines auth and onboarding state to trigger router refreshes
@riverpod
class RouterRefreshNotifier extends _$RouterRefreshNotifier
    implements Listenable {
  VoidCallback? _listener;

  @override
  void build() {
    // Watch auth changes
    ref.listen(authStateChangesProvider, (_, __) {
      _listener?.call();
    });
    // Watch onboarding changes
    ref.listen(onboardingNotifierProvider, (_, __) {
      _listener?.call();
    });
  }

  @override
  void addListener(VoidCallback listener) {
    _listener = listener;
  }

  @override
  void removeListener(VoidCallback listener) {
    if (_listener == listener) {
      _listener = null;
    }
  }
}
