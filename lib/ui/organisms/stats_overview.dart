import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../molecules/molecules.dart';

/// Organismo: painel unificado de métricas em estilo grade técnica (Swiss Grid).
class StatsOverview extends StatelessWidget {
  const StatsOverview({
    super.key,
    required this.pending,
    required this.completed,
    required this.overdue,
  });

  final int pending;
  final int completed;
  final int overdue;

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
                color: AppColors.primary,
              ),
            ),
            const VerticalDivider(width: 1, thickness: 1, color: AppColors.border),
            Expanded(
              child: StatTile(
                label: 'Concluídas',
                value: completed,
                color: AppColors.success,
              ),
            ),
            const VerticalDivider(width: 1, thickness: 1, color: AppColors.border),
            Expanded(
              child: StatTile(
                label: 'Atrasadas',
                value: overdue,
                color: AppColors.danger,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
