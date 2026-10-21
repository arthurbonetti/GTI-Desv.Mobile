import 'package:flutter/material.dart';

import '../../data/models/task.dart';
import 'task_card.dart';

/// Organismo: lista de tarefas como Sliver (para uso em CustomScrollView).
class TaskSliverList extends StatelessWidget {
  const TaskSliverList({
    super.key,
    required this.tasks,
    required this.onToggle,
    required this.onTap,
    required this.onDelete,
  });

  final List<Task> tasks;
  final ValueChanged<Task> onToggle;
  final ValueChanged<Task> onTap;
  final ValueChanged<Task> onDelete;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final task = tasks[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: TaskCard(
                key: ValueKey(task.id),
                task: task,
                onToggle: () => onToggle(task),
                onTap: () => onTap(task),
                onDelete: () => onDelete(task),
              ),
            );
          },
          childCount: tasks.length,
        ),
      ),
    );
  }
}

