import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/task.dart';

/// Apresentação visual de [TaskCategory] (ícone e cor), mantida na camada de UI.
extension TaskCategoryVisuals on TaskCategory {
  IconData get icon {
    switch (this) {
      case TaskCategory.trabalho:
        return Icons.work_outline_rounded;
      case TaskCategory.estudo:
        return Icons.school_outlined;
      case TaskCategory.pessoal:
        return Icons.person_outline_rounded;
      case TaskCategory.saude:
        return Icons.favorite_border_rounded;
      case TaskCategory.financas:
        return Icons.account_balance_wallet_outlined;
      case TaskCategory.outros:
        return Icons.label_outline_rounded;
    }
  }

  Color get color {
    switch (this) {
      case TaskCategory.trabalho:
        return AppColors.categoryWork;
      case TaskCategory.estudo:
        return AppColors.categoryStudy;
      case TaskCategory.pessoal:
        return AppColors.categoryPersonal;
      case TaskCategory.saude:
        return AppColors.categoryHealth;
      case TaskCategory.financas:
        return AppColors.categoryFinance;
      case TaskCategory.outros:
        return AppColors.categoryOther;
    }
  }
}

/// Apresentação visual de [TaskPriority] (cores), mantida na camada de UI.
extension TaskPriorityVisuals on TaskPriority {
  Color get color {
    switch (this) {
      case TaskPriority.alta:
        return AppColors.priorityHigh;
      case TaskPriority.media:
        return AppColors.priorityMedium;
      case TaskPriority.baixa:
        return AppColors.priorityLow;
    }
  }

  Color get background {
    switch (this) {
      case TaskPriority.alta:
        return AppColors.priorityHighBg;
      case TaskPriority.media:
        return AppColors.priorityMediumBg;
      case TaskPriority.baixa:
        return AppColors.priorityLowBg;
    }
  }
}
