import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/task.dart';
import '../atoms/atoms.dart';
import '../molecules/molecules.dart';
import '../core/task_visuals.dart';

/// Organismo: cartão de tarefa editorial (checkbox tátil + título + metadados),
/// com gesto de arrastar para excluir.
class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onTap,
    required this.onDelete,
  });

  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final completed = task.isCompleted;

    return Dismissible(
      key: ValueKey('task-${task.id}'),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: AppColors.danger,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Excluir',
              style: TextStyle(
                color: AppColors.surface,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.delete_outline_rounded, color: AppColors.surface, size: 19),
          ],
        ),
      ),
      child: Material(
        color: completed ? AppColors.background : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: task.isOverdue
                    ? AppColors.danger.withAlpha(110)
                    : AppColors.border,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(11),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(17.5, 14, 14, 14),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 1),
                          child: TaskCheckbox(
                            value: completed,
                            onChanged: onToggle,
                            semanticLabel: completed
                                ? 'Marcar "${task.title}" como pendente'
                                : 'Marcar "${task.title}" como concluída',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: _buildContent(completed)),
                      ],
                    ),
                  ),
                  // Filete de sinalização lateral com a cor da prioridade.
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    width: 3.5,
                    child: ColoredBox(
                      color: completed ? AppColors.border : task.priority.color,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(bool completed) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 180),
      opacity: completed ? 0.5 : 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            task.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 15.5,
              height: 1.3,
              letterSpacing: -0.2,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              decoration: completed ? TextDecoration.lineThrough : null,
              decorationColor: AppColors.textSecondary,
            ),
          ),
          if (task.description.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              task.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                height: 1.4,
                color: AppColors.textSecondary,
              ),
            ),
          ],
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              CategoryTag(category: task.category),
              PriorityBadge(priority: task.priority),
              if (task.dueDate != null)
                DueDateLabel(date: task.dueDate!, isCompleted: completed),
            ],
          ),
        ],
      ),
    );
  }
}
