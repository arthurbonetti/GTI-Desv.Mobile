import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Molécula: botão que aciona o painel de filtros e reflete estado ativo.
class FilterButton extends StatelessWidget {
  const FilterButton({
    super.key,
    required this.active,
    required this.onTap,
  });

  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final foreground = active ? AppColors.surface : AppColors.textPrimary;
    return Material(
      color: active ? AppColors.primary : AppColors.surface,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: active ? AppColors.primary : AppColors.border,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.tune_rounded, size: 18, color: foreground),
              const SizedBox(width: 6),
              Text(
                'Filtrar',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.1,
                  color: foreground,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
