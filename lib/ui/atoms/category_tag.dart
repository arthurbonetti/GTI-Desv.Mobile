import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/task.dart';

/// Átomo: etiqueta editorial que indica a categoria da tarefa.
class CategoryTag extends StatelessWidget {
  const CategoryTag({super.key, required this.category});

  final TaskCategory category;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.border, width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(category.icon, size: 12, color: category.color),
          const SizedBox(width: 4),
          Text(
            category.label,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.1,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
