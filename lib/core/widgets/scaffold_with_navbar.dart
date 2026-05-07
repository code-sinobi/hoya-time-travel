import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

/// Scaffold with 5-tab bottom navigation bar for the main app shell
class ScaffoldWithNavBar extends ConsumerWidget {
  const ScaffoldWithNavBar({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: child,
      bottomNavigationBar: _MythicNavBar(
        selectedIndex: _calculateSelectedIndex(context),
        onTap: (index) => _onItemTapped(index, context),
      ),
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/portal')) return 0;
    if (location.startsWith('/library')) return 1;
    if (location.startsWith('/community')) return 2;
    if (location.startsWith('/rifts')) return 3;
    if (location.startsWith('/profile')) return 4;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/portal');
      case 1:
        context.go('/library');
      case 2:
        context.go('/community');
      case 3:
        context.go('/rifts');
      case 4:
        context.go('/profile');
    }
  }
}

class _MythicNavBar extends StatelessWidget {
  const _MythicNavBar({required this.selectedIndex, required this.onTap});
  final int selectedIndex;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 12,
        bottom: 20,
      ), // 12px top padding as requested
      decoration: BoxDecoration(
        color: const Color(
          0xFF0A0A0F,
        ).withValues(alpha: 0.8), // Frosted glass bg base
        border: const Border(
          top: BorderSide(
            color: Color(0x33D4A574),
          ), // Bronze 20% opacity
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ClipRect(
        // BackdropFilter for blur effect
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavBarItem(
                icon: Icons.auto_stories_outlined,
                filledIcon: Icons
                    .auto_stories, // Material icons usually don't have perfect filled/outlined pairs for everything
                label: 'PORTAL',
                isSelected: selectedIndex == 0,
                onTap: () => onTap(0),
              ),
              _NavBarItem(
                icon: Icons.grid_view_outlined,
                filledIcon: Icons.grid_view,
                label: 'ARCHIVES',
                isSelected: selectedIndex == 1,
                onTap: () => onTap(1),
              ),
              _NavBarItem(
                icon: Icons.groups_outlined,
                filledIcon: Icons.groups,
                label: 'LORE',
                isSelected: selectedIndex == 2,
                onTap: () => onTap(2),
              ),
              _NavBarItem(
                icon: Icons.bolt_outlined,
                filledIcon: Icons.bolt,
                label: 'ANOMALIES',
                isSelected: selectedIndex == 3,
                onTap: () => onTap(3),
              ),
              _NavBarItem(
                icon: Icons.person_outline,
                filledIcon: Icons.person,
                label: 'ID',
                isSelected: selectedIndex == 4,
                onTap: () => onTap(4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  const _NavBarItem({
    required this.icon,
    required this.filledIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });
  final IconData icon;
  final IconData filledIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const bronze = Color(0xFFD4A574);
    final inactiveColor = const Color(0xFF6B6B6B).withValues(alpha: 0.6);

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: isSelected
                  ? BoxDecoration(
                      color: bronze.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20), // Pill shape
                      border: Border.all(color: bronze.withValues(alpha: 0.3)),
                      boxShadow: [
                        BoxShadow(
                          color: bronze.withValues(alpha: 0.15),
                          blurRadius: 15,
                          spreadRadius: 1,
                        ),
                      ],
                    )
                  : null,
              child: Icon(
                isSelected ? filledIcon : icon,
                color: isSelected ? bronze : inactiveColor,
                size: 24,
              ).animate(target: isSelected ? 1 : 0).scale(
                    begin: const Offset(1, 1),
                    end: const Offset(1.1, 1.1),
                    duration: 200.ms,
                  ),
            ),
            if (isSelected)
              // Active state handled by pill background
              const SizedBox(height: 4),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.orbitron(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? bronze : inactiveColor,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
