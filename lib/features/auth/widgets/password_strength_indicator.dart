import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/mythic_colors.dart';

class PasswordStrengthIndicator extends StatelessWidget {
  const PasswordStrengthIndicator({required this.password, super.key});
  final String password;

  @override
  Widget build(BuildContext context) {
    int strength = 0;
    if (password.length >= 8) strength++;
    if (password.contains(RegExp('[A-Z]'))) strength++;
    if (password.contains(RegExp('[0-9]'))) strength++;
    if (password.contains(RegExp('[^a-zA-Z0-9]'))) strength++;

    Color color;
    String text;
    switch (strength) {
      case 0:
      case 1:
        color = MythicColors.error;
        text = 'WEAK';
      case 2:
      case 3:
        color = MythicColors.warning;
        text = 'GOOD';
      case 4:
        color = MythicColors.success;
        text = 'STRONG';
      default:
        color = MythicColors.error;
        text = 'WEAK';
    }
    if (password.isEmpty) {
      color = MythicColors.transparent;
      text = '';
    }

    return Padding(
      padding: const EdgeInsets.only(top: 12.0, bottom: 8.0, left: 4.0),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: List.generate(4, (index) {
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    height: 4,
                    decoration: BoxDecoration(
                      color: password.isEmpty
                          ? MythicColors.white.withValues(alpha: 0.12)
                          : (index <= (strength == 0 ? 0 : strength - 1)
                              ? color
                              : MythicColors.white.withValues(alpha: 0.12)),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          SizedBox(
            width: 50,
            child: Text(
              text,
              style: AppTypography.navLabel.copyWith(
                fontSize: 10,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
