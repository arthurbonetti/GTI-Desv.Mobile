import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Molécula: cabeçalho com contagem de resultados, ordenação atual e limpar filtros.
class ResultsHeader extends StatelessWidget {
  const ResultsHeader({
    super.key,
    required this.count,
    required this.sortLabel,
    required this.hasActiveFilters,
    required this.onClearFilters,
  });

  final int count;
  final String sortLabel;
  final bool hasActiveFilters;
  final VoidCallback onClearFilters;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$count ${count == 1 ? 'tarefa' : 'tarefas'}',
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.1,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.surfaceMuted,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            'Ordem: $sortLabel',
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        const Spacer(),
        if (hasActiveFilters)
          TextButton.icon(
            onPressed: onClearFilters,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.danger,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            icon: const Icon(Icons.close_rounded, size: 15),
            label: const Text(
              'Limpar filtros',
              style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
            ),
          ),
      ],
    );
  }
}
