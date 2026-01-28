import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/galactic_colors.dart';

class TemporalNavBar extends StatefulWidget {
  const TemporalNavBar({super.key});

  @override
  State<TemporalNavBar> createState() => _TemporalNavBarState();
}

class _TemporalNavBarState extends State<TemporalNavBar>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _portalController;

  @override
  void initState() {
    super.initState();
    _portalController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: GalacticColors.deepNebula.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(
          color: GalacticColors.etherealCyan.withValues(alpha: 0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: GalacticColors.etherealCyan.withValues(alpha: 0.2),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(child: _buildNavItem(0, Icons.home, 'Portal')),
          const SizedBox(width: 16),
          Flexible(child: _buildNavItem(1, Icons.library_books, 'Library')),
          const SizedBox(width: 16),
          // Central Portal Button
          _buildPortalButton(),
          const SizedBox(width: 16),
          Flexible(child: _buildNavItem(2, Icons.explore, 'Rifts')),
          const SizedBox(width: 16),
          Flexible(child: _buildNavItem(3, Icons.person, 'Profile')),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected
                ? GalacticColors.etherealCyan
                : Colors.white.withValues(alpha: 0.7),
            size: 22,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.orbitron(
              fontSize: 10,
              color: isSelected
                  ? GalacticColors.etherealCyan
                  : Colors.white.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPortalButton() {
    return GestureDetector(
      onTap: _activatePortal,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              GalacticColors.etherealCyan.withValues(alpha: 0.8),
              GalacticColors.wormholeBlue,
            ],
          ),
          shape: BoxShape.circle,
          border: Border.all(color: GalacticColors.temporalGold, width: 2),
          boxShadow: [
            BoxShadow(
              color: GalacticColors.etherealCyan.withValues(alpha: 0.5),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: const Icon(
          Icons
              .av_timer, // Changed from hourglass_empty for better sci-fi feel, or stick to av_timer
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);

    // Navigation logic (adjust routes as needed)
    switch (index) {
      case 0:
        context.go('/portal');
        break;
      case 1:
        context.go('/library');
        break;
      case 2:
        context.go('/rifts');
        break;
      case 3:
        context.go('/profile');
        break;
    }

    // Haptic feedback
    HapticFeedback.selectionClick();
  }

  void _activatePortal() {
    // Animate portal opening
    _portalController.reset();
    _portalController.forward();

    // Show portal menu or trigger action
    HapticFeedback.heavyImpact();
    // Implementation of portal menu would go here
  }

  @override
  void dispose() {
    _portalController.dispose();
    super.dispose();
  }
}
