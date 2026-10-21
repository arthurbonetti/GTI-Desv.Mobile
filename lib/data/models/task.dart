import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/date_utils.dart';

enum TaskCategory { trabalho, estudo, pessoal, saude, financas, outros }

extension TaskCategoryX on TaskCategory {
  String get label {
    switch (this) {
      case TaskCategory.trabalho:
        return 'Trabalho';
      case TaskCategory.estudo:
        return 'Estudo';
      case TaskCategory.pessoal:
        return 'Pessoal';
      case TaskCategory.saude:
        return 'Saúde';
      case TaskCategory.financas:
        return 'Finanças';
      case TaskCategory.outros:
        return 'Outros';
    }
  }

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

enum TaskPriority { alta, media, baixa }

extension TaskPriorityX on TaskPriority {
  String get label {
    switch (this) {
      case TaskPriority.alta:
        return 'Alta';
      case TaskPriority.media:
        return 'Média';
      case TaskPriority.baixa:
        return 'Baixa';
    }
  }

  /// Peso usado na ordenação (maior = mais importante).
  int get weight {
    switch (this) {
      case TaskPriority.alta:
        return 3;
      case TaskPriority.media:
        return 2;
      case TaskPriority.baixa:
        return 1;
    }
  }

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

class Task {
  final String id;
  final String title;
  final String description;
  final TaskCategory category;
  final TaskPriority priority;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime? dueDate;
  final DateTime? completedAt;

  const Task({
    required this.id,
    required this.title,
    this.description = '',
    this.category = TaskCategory.pessoal,
    this.priority = TaskPriority.media,
    this.isCompleted = false,
    required this.createdAt,
    this.dueDate,
    this.completedAt,
  });

  bool get isOverdue =>
      !isCompleted &&
      dueDate != null &&
      AppDateUtils.daysFromToday(dueDate!) < 0;

  Task copyWith({
    String? title,
    String? description,
    TaskCategory? category,
    TaskPriority? priority,
    bool? isCompleted,
    DateTime? dueDate,
    bool clearDueDate = false,
    DateTime? completedAt,
    bool clearCompletedAt = false,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt,
      dueDate: clearDueDate ? null : (dueDate ?? this.dueDate),
      completedAt:
          clearCompletedAt ? null : (completedAt ?? this.completedAt),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'category': category.name,
        'priority': priority.name,
        'isCompleted': isCompleted,
        'createdAt': createdAt.toIso8601String(),
        'dueDate': dueDate?.toIso8601String(),
        'completedAt': completedAt?.toIso8601String(),
      };

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      title: json['title'] as String,
      description: (json['description'] as String?) ?? '',
      category: TaskCategory.values.firstWhere(
        (c) => c.name == json['category'],
        orElse: () => TaskCategory.outros,
      ),
      priority: TaskPriority.values.firstWhere(
        (p) => p.name == json['priority'],
        orElse: () => TaskPriority.media,
      ),
      isCompleted: (json['isCompleted'] as bool?) ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'] as String)
          : null,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
    );
  }
}

