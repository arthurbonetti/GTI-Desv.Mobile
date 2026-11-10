import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../molecules/molecules.dart';

/// Organismo: painel unificado de métricas em estilo grade técnica (Swiss Grid).
class StatsOverview extends StatelessWidget {
  const StatsOverview({
    super.key,
    required this.total,
    required this.pending,
    required this.completed,
    required this.overdue,
    required this.progress,
  });

  final int total;
  final int pending;
  final int completed;
  final int overdue;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: StatTile(
                label: 'Pendentes',
                value: pending,
                icon: Icons.pending_actions_rounded,
                color: AppColors.primary,
              ),
            ),
            const VerticalDivider(width: 1, thickness: 1, color: AppColors.border),
            Expanded(
              child: StatTile(
                label: 'Concluídas',
                value: completed,
                icon: Icons.task_alt_rounded,
                color: AppColors.success,
              ),
            ),
            const VerticalDivider(width: 1, thickness: 1, color: AppColors.border),
            Expanded(
              child: StatTile(
                label: 'Atrasadas',
                value: overdue,
                icon: Icons.warning_amber_rounded,
                color: AppColors.danger,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
