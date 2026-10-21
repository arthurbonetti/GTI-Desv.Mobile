import 'package:flutter/material.dart';

import '../../controllers/task_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/task.dart';
import '../templates/templates.dart';
import '../organisms/organisms.dart';

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
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir tarefa'),
        content: Text('Deseja realmente excluir "${task!.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    final removed = await controller.deleteTask(task!.id);
    navigator.pop();
    if (removed != null) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: const Text('Tarefa excluída'),
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Desfazer',
              onPressed: () => controller.restoreTask(removed),
            ),
            onVisible: () {
              Future.delayed(const Duration(seconds: 5), () {
                messenger.hideCurrentSnackBar();
              });
            },
          ),
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

