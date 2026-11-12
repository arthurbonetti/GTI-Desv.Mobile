import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/task.dart';

/// Contrato de acesso às tarefas, permitindo trocar a fonte de dados.
abstract class TaskRepository {
  Future<List<Task>> loadTasks();
  Future<void> saveTasks(List<Task> tasks);
}

/// Persistência local das tarefas (SharedPreferences).
class LocalTaskRepository implements TaskRepository {
  static const String _storageKey = 'gti_tasks_v1';

  @override
  Future<List<Task>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return [];
      final tasks = <Task>[];
      for (final item in decoded) {
        if (item is Map<String, dynamic>) {
          try {
            tasks.add(Task.fromJson(item));
          } catch (e) {
            debugPrint('Ignorando tarefa inválida no armazenamento local: $e');
          }
        }
      }
      return tasks;
    } catch (e) {
      debugPrint('Erro ao decodificar tarefas do armazenamento local: $e');
      return [];
    }
  }

  @override
  Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(tasks.map((t) => t.toJson()).toList());
    await prefs.setString(_storageKey, encoded);
  }
}
