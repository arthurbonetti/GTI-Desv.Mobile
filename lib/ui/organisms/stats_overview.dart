import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../molecules/molecules.dart';

/// Organismo: painel de resumo com progresso e estatísticas.
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
    return Row(
      children: [
        Expanded(
          child: StatTile(
            label: 'Pendentes',
            value: pending,
            icon: Icons.pending_actions_rounded,
            color: AppColors.secondary,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: StatTile(
            label: 'Concluídas',
            value: completed,
            icon: Icons.task_alt_rounded,
            color: AppColors.success,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: StatTile(
            label: 'Atrasadas',
            value: overdue,
            icon: Icons.warning_amber_rounded,
            color: AppColors.danger,
          ),
        ),
      ],
    );
  }
}

