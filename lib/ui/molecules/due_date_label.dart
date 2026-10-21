import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/date_utils.dart';

/// Molécula: ícone + texto indicando a data de vencimento.
class DueDateLabel extends StatelessWidget {
  const DueDateLabel({
    super.key,
    required this.date,
    this.isCompleted = false,
  });

  final DateTime date;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    final diff = AppDateUtils.daysFromToday(date);
    Color color = AppColors.textSecondary;
    if (!isCompleted) {
      if (diff < 0) {
        color = AppColors.danger;
      } else if (diff <= 1) {
        color = AppColors.priorityMedium;
      }
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          diff < 0 && !isCompleted
              ? Icons.warning_amber_rounded
              : Icons.event_rounded,
          size: 14,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(
          AppDateUtils.relativeLabel(date),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
      ],
    );
  }
}

