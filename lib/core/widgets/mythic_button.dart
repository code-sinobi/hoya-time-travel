import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/era_theme.dart';

enum MythicButtonStyle { primary, secondary, danger }

class MythicButton extends StatelessWidget {
  const MythicButton({
    required this.label,
    required this.onTap,
    super.key,
    this.style = MythicButtonStyle.primary,
    this.icon,
  });
  final String label;
  final VoidCallback onTap;
  final MythicButtonStyle style;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    Color borderColor;

    switch (style) {
      case MythicButtonStyle.primary:
        backgroundColor = MythicColors.bronze;
        textColor = Colors.black;
        borderColor = MythicColors.bronze;
      case MythicButtonStyle.secondary:
        backgroundColor = Colors.transparent;
        textColor = MythicColors.parchment;
        borderColor = MythicColors.bronze.withValues(alpha: 0.5);
      case MythicButtonStyle.danger:
        backgroundColor = MythicColors.error.withValues(alpha: 0.2);
        textColor = MythicColors.error;
        borderColor = MythicColors.error;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor),
            boxShadow: style == MythicButtonStyle.primary
                ? [
                    BoxShadow(
                      color: MythicColors.bronze.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, color: textColor, size: 20),
                const SizedBox(width: 8),
              ],
              Text(
                label.toUpperCase(),
                style: GoogleFonts.cinzel(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
