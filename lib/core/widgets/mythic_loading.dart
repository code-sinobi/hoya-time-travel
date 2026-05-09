import 'package:flutter/material.dart';
import '../theme/era_theme.dart' hide MythicColors;
import '../theme/mythic_colors.dart';

/// A unified loading indicator that adapts to the current EraTheme.
class MythicLoading extends StatelessWidget {
  const MythicLoading({
    super.key,
    this.size = 24.0,
    this.color,
    this.strokeWidth = 2.0,
  });

  final double size;
  final Color? color;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    final eraTheme = Theme.of(context).extension<EraTheme>();
    final indicatorColor =
        color ?? eraTheme?.primaryColor ?? MythicColors.bronze;

    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        color: indicatorColor,
        strokeWidth: strokeWidth,
      ),
    );
  }
}
