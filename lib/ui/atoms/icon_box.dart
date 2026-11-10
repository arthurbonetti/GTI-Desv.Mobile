import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Átomo: ícone dentro de uma moldura técnica sutil.
class IconBox extends StatelessWidget {
  const IconBox({
    super.key,
    required this.icon,
    required this.color,
    this.size = 38,
  });

  final IconData icon;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(size * 0.22),
        border: Border.all(color: AppColors.border),
      ),
      child: Icon(icon, color: color, size: size * 0.48),
    );
  }
}
