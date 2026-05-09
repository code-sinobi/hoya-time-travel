import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/mythic_colors.dart';

class PasswordStrengthIndicator extends StatelessWidget {
  const PasswordStrengthIndicator({required this.password, super.key});
  final String password;

  static final RegExp _upperCasePattern = RegExp('[A-Z]');
  static final RegExp _digitPattern = RegExp('[0-9]');
  static final RegExp _symbolPattern = RegExp('[^a-zA-Z0-9]');

  Color _barColor(int index, String password, int strength, Color color) {
    if (password.isEmpty || index >= strength) {
      return MythicColors.white.withValues(alpha: 0.12);
    }
    return color;
  }

  @override
  Widget build(BuildContext context) {
    int strength = 0;
    if (password.length >= 8) strength++;
    if (password.contains(_upperCasePattern)) strength++;
    if (password.contains(_digitPattern)) strength++;
    if (password.contains(_symbolPattern)) strength++;

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
                      color: _barColor(index, password, strength, color),
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
