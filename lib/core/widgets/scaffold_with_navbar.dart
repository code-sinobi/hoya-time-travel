import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/era_theme.dart';
import '../theme/app_theme.dart';

/// Scaffold with 5-tab bottom navigation bar for the main app shell
class ScaffoldWithNavBar extends ConsumerWidget {
  final Widget child;

  const ScaffoldWithNavBar({required this.child, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme =
        Theme.of(context).extension<EraTheme>() ??
        ref.watch(appThemeProvider).extension<EraTheme>()!;
    final textColor = theme.bodyStyle.color ?? Colors.white;

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: theme.surfaceColor,
          boxShadow: [
            BoxShadow(
              color: theme.primaryColor.withValues(alpha: 0.1),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: NavigationBar(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          indicatorColor: theme.primaryColor.withValues(alpha: 0.15),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          height: 70,
          selectedIndex: _calculateSelectedIndex(context),
          onDestinationSelected: (int index) => _onItemTapped(index, context),
          destinations: [
            NavigationDestination(
              icon: Icon(
                Icons.auto_stories_outlined,
                color: textColor.withValues(alpha: 0.5),
              ),
              selectedIcon: Icon(Icons.auto_stories, color: theme.primaryColor),
              label: 'Portal',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.grid_view_outlined,
                color: textColor.withValues(alpha: 0.5),
              ),
              selectedIcon: Icon(Icons.grid_view, color: theme.primaryColor),
              label: 'Library',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.explore_outlined,
                color: textColor.withValues(alpha: 0.5),
              ),
              selectedIcon: Icon(Icons.explore, color: theme.primaryColor),
              label: 'Explore',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.bolt_outlined,
                color: textColor.withValues(alpha: 0.5),
              ),
              selectedIcon: Icon(Icons.bolt, color: theme.primaryColor),
              label: 'Rifts',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.person_outline,
                color: textColor.withValues(alpha: 0.5),
              ),
              selectedIcon: Icon(Icons.person, color: theme.primaryColor),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/portal')) return 0;
    if (location.startsWith('/library')) return 1;
    if (location.startsWith('/explore')) return 2;
    if (location.startsWith('/rifts')) return 3;
    if (location.startsWith('/profile')) return 4;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/portal');
        break;
      case 1:
        context.go('/library');
        break;
      case 2:
        context.go('/explore');
        break;
      case 3:
        context.go('/rifts');
        break;
      case 4:
        context.go('/profile');
        break;
    }
  }
}
