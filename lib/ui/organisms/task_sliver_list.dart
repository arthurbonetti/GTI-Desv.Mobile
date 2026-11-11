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
              child: _FadeSlideIn(
                key: ValueKey(task.id),
                child: TaskCard(
                  task: task,
                  onToggle: () => onToggle(task),
                  onTap: () => onTap(task),
                  onDelete: () => onDelete(task),
                ),
              ),
            );
          },
          childCount: tasks.length,
        ),
      ),
    );
  }
}


/// Entrada suave (fade + leve deslocamento) de um item da lista.
class _FadeSlideIn extends StatelessWidget {
  const _FadeSlideIn({super.key, required this.child});

  final Widget child;

  static const Duration _duration = Duration(milliseconds: 280);
  static const double _slideOffset = 12;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: _duration,
      curve: Curves.easeOutCubic,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, (1 - value) * _slideOffset),
          child: child,
        ),
      ),
      child: child,
    );
  }
}
