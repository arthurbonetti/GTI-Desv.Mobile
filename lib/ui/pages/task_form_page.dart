import 'package:flutter/material.dart';

import '../../controllers/task_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/task.dart';
import '../core/app_feedback.dart';
import '../organisms/organisms.dart';
import '../templates/templates.dart';

/// Página: formulário de criação/edição. Conecta o organismo [TaskForm]
/// ao [TaskController].
class TaskFormPage extends StatelessWidget {
  const TaskFormPage({super.key, required this.controller, this.task});

  final TaskController controller;
  final Task? task;

  bool get _isEditing => task != null;

  Future<void> _save(BuildContext context, Task value) async {
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    if (_isEditing) {
      await controller.updateTask(value);
    } else {
      await controller.addTask(value);
    }
    navigator.pop();
    messenger.showSnackBar(
      SnackBar(
        content: Text(_isEditing ? 'Tarefa atualizada!' : 'Tarefa criada!'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final currentTask = task;
    if (currentTask == null) return;

    final confirmed = await showConfirmDeleteDialog(
      context,
      title: 'Excluir tarefa',
      message: 'Deseja realmente excluir "${currentTask.title}"?',
    );
    if (!confirmed) return;

    final removed = await controller.deleteTask(currentTask.id);
    navigator.pop();
    if (removed != null) {
      showUndoDeleteSnackBar(
        messenger,
        message: 'Tarefa excluída',
        onUndo: () => controller.restoreTask(removed),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormTemplate(
      title: _isEditing ? 'Editar tarefa' : 'Nova tarefa',
      actions: [
        if (_isEditing)
          IconButton(
            tooltip: 'Excluir',
            icon: const Icon(Icons.delete_outline_rounded,
                color: AppColors.danger),
            onPressed: () => _confirmDelete(context),
          ),
      ],
      body: TaskForm(
        initialTask: task,
        onSubmit: (value) => _save(context, value),
      ),
    );
  }
}
