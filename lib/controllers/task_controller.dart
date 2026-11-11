import 'package:flutter/foundation.dart';

import '../data/models/task.dart';
import '../data/repositories/task_repository.dart';
import '../domain/task_query.dart';

export '../domain/task_query.dart';

/// Gerencia o estado das tarefas e delega busca/filtro/ordenação a [TaskQuery].
class TaskController extends ChangeNotifier {
  TaskController({TaskRepository? repository})
      : _repository = repository ?? LocalTaskRepository();

  final TaskRepository _repository;

  List<Task> _tasks = [];
  bool _isLoading = true;
  TaskQuery _query = const TaskQuery();

  bool get isLoading => _isLoading;
  List<Task> get allTasks => List.unmodifiable(_tasks);

  String get query => _query.text;
  TaskStatusFilter get statusFilter => _query.status;
  TaskCategory? get categoryFilter => _query.category;
  TaskPriority? get priorityFilter => _query.priority;
  TaskSort get sort => _query.sort;
  bool get hasActiveFilters => _query.hasActiveFilters;

  int get totalCount => _tasks.length;
  int get completedCount => _tasks.where((t) => t.isCompleted).length;
  int get pendingCount => totalCount - completedCount;
  int get overdueCount => _tasks.where((t) => t.isOverdue).length;
  double get progress => totalCount == 0 ? 0 : completedCount / totalCount;

  List<Task> get filteredTasks => _query.apply(_tasks);

  // ---------- Ações ----------
  Future<void> load() async {
    _isLoading = true;
    notifyListeners();
    _tasks = await _repository.loadTasks();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTask(Task task) => _commit([..._tasks, task]);

  Future<void> updateTask(Task task) =>
      _commit(_tasks.map((t) => t.id == task.id ? task : t).toList());

  Future<Task?> deleteTask(String id) async {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index == -1) return null;
    final removed = _tasks[index];
    await _commit([..._tasks]..removeAt(index));
    return removed;
  }

  Future<void> restoreTask(Task task) async {
    if (_tasks.any((t) => t.id == task.id)) return;
    await addTask(task);
  }

  Future<void> toggleCompleted(String id) {
    return _commit(
      _tasks.map((t) => t.id == id ? _toggled(t) : t).toList(),
    );
  }

  Future<int> clearCompleted() async {
    final count = completedCount;
    await _commit(_tasks.where((t) => !t.isCompleted).toList());
    return count;
  }

  Task _toggled(Task task) {
    final completed = !task.isCompleted;
    return task.copyWith(
      isCompleted: completed,
      completedAt: completed ? DateTime.now() : null,
      clearCompletedAt: !completed,
    );
  }

  /// Atualiza o estado em memória (UI imediata) e persiste em seguida.
  Future<void> _commit(List<Task> tasks) async {
    _tasks = tasks;
    notifyListeners();
    await _repository.saveTasks(_tasks);
  }

  // ---------- Filtros ----------
  void setQuery(String value) => _updateQuery(_query.copyWith(text: value));

  void setStatusFilter(TaskStatusFilter value) =>
      _updateQuery(_query.copyWith(status: value));

  void setCategoryFilter(TaskCategory? value) => _updateQuery(
        _query.copyWith(category: value, clearCategory: value == null),
      );

  void setPriorityFilter(TaskPriority? value) => _updateQuery(
        _query.copyWith(priority: value, clearPriority: value == null),
      );

  void setSort(TaskSort value) => _updateQuery(_query.copyWith(sort: value));

  void clearFilters() => _updateQuery(_query.withoutFilters());

  void _updateQuery(TaskQuery value) {
    _query = value;
    notifyListeners();
  }
}
