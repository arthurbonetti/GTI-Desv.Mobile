import 'package:flutter/material.dart';

import '../../controllers/task_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/task.dart';
import '../molecules/molecules.dart';

/// Organismo: painel de filtros (status, categoria e prioridade).
class FilterPanel extends StatelessWidget {
  const FilterPanel({
    super.key,
    required this.status,
    required this.category,
    required this.priority,
    required this.onStatusChanged,
    required this.onCategoryChanged,
    required this.onPriorityChanged,
  });

  final TaskStatusFilter status;
  final TaskCategory? category;
  final TaskPriority? priority;
  final ValueChanged<TaskStatusFilter> onStatusChanged;
  final ValueChanged<TaskCategory?> onCategoryChanged;
  final ValueChanged<TaskPriority?> onPriorityChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ChipFilterRow<TaskStatusFilter>(
          selected: status,
          onSelected: (v) => onStatusChanged(v ?? TaskStatusFilter.todas),
          options: TaskStatusFilter.values
              .map((s) => ChipOption<TaskStatusFilter>(value: s, label: s.label))
              .toList(),
        ),
        const SizedBox(height: 10),
        ChipFilterRow<TaskCategory>(
          selected: category,
          // Tocar novamente no chip ativo remove o filtro.
          onSelected: (v) => onCategoryChanged(v == category ? null : v),
          options: [
            const ChipOption<TaskCategory>(
              value: null,
              label: 'Todas categorias',
              icon: Icons.apps_rounded,
              color: AppColors.textPrimary,
            ),
            ...TaskCategory.values.map(
              (c) => ChipOption<TaskCategory>(
                value: c,
                label: c.label,
                icon: c.icon,
                color: c.color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ChipFilterRow<TaskPriority>(
          selected: priority,
          onSelected: (v) => onPriorityChanged(v == priority ? null : v),
          options: [
            const ChipOption<TaskPriority>(
              value: null,
              label: 'Todas prioridades',
              icon: Icons.flag_outlined,
              color: AppColors.textPrimary,
            ),
            ...TaskPriority.values.map(
              (p) => ChipOption<TaskPriority>(
                value: p,
                label: p.label,
                icon: Icons.flag_rounded,
                color: p.color,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

