import 'package:flutter/material.dart';
import '../../../core/theme/era_theme.dart';
import 'package:google_fonts/google_fonts.dart';

class AstralMapNode extends StatefulWidget {
  final Map<String, dynamic> data;
  final VoidCallback onTap;
  final bool isLocked;

  const AstralMapNode({
    super.key,
    required this.data,
    required this.onTap,
    this.isLocked = false,
  });

  @override
  State<AstralMapNode> createState() => _AstralMapNodeState();
}

class _AstralMapNodeState extends State<AstralMapNode>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: false); // One way ripple?

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 2.0,
    ).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeOut));

    _opacityAnimation = Tween<double>(
      begin: 0.8,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Stylistic choices
    final bool isRift = widget.data['isRift'] == true;
    final Color nodeColor = isRift
        ? MythicColors.ochreRed
        : MythicColors.bronze;

    return GestureDetector(
      onTap: widget.onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Pulse Ring (Ink Ripple)
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: nodeColor.withValues(
                        alpha: _opacityAnimation.value * 0.5,
                      ),
                      width: 1,
                    ),
                  ),
                ),
              );
            },
          ),

          // Outer Ring (Static)
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: nodeColor.withValues(alpha: 0.8),
                width: 1.5,
              ),
            ),
          ),

          // Core Node
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: nodeColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: nodeColor.withValues(alpha: 0.6),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),

          // Label (if not locked)
          if (!widget.isLocked)
            Positioned(
              top: 30,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E2C).withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: nodeColor.withValues(alpha: 0.3)),
                ),
                child: Text(
                  widget.data['name']?.toUpperCase() ?? 'UNKNOWN',
                  style: GoogleFonts.cinzel(
                    color: MythicColors.parchment,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
