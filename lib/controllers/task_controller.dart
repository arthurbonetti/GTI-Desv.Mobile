import 'package:flutter/foundation.dart';

import '../data/models/task.dart';
import '../data/repositories/task_repository.dart';

enum TaskStatusFilter { todas, pendentes, concluidas }

extension TaskStatusFilterX on TaskStatusFilter {
  String get label {
    switch (this) {
      case TaskStatusFilter.todas:
        return 'Todas';
      case TaskStatusFilter.pendentes:
        return 'Pendentes';
      case TaskStatusFilter.concluidas:
        return 'Concluídas';
    }
  }
}

enum TaskSort { inteligente, prioridade, vencimento, recentes, alfabetica }

extension TaskSortX on TaskSort {
  String get label {
    switch (this) {
      case TaskSort.inteligente:
        return 'Inteligente';
      case TaskSort.prioridade:
        return 'Prioridade';
      case TaskSort.vencimento:
        return 'Vencimento';
      case TaskSort.recentes:
        return 'Mais recentes';
      case TaskSort.alfabetica:
        return 'A-Z';
    }
  }
}

/// Gerencia o estado das tarefas, filtros, busca e ordenação.
class TaskController extends ChangeNotifier {
  TaskController({TaskRepository? repository})
      : _repository = repository ?? TaskRepository();

  final TaskRepository _repository;

  List<Task> _tasks = [];
  bool _isLoading = true;

  String _query = '';
  TaskStatusFilter _statusFilter = TaskStatusFilter.todas;
  TaskCategory? _categoryFilter;
  TaskPriority? _priorityFilter;
  TaskSort _sort = TaskSort.inteligente;

  // ---------- Getters ----------
  bool get isLoading => _isLoading;
  List<Task> get allTasks => List.unmodifiable(_tasks);
  String get query => _query;
  TaskStatusFilter get statusFilter => _statusFilter;
  TaskCategory? get categoryFilter => _categoryFilter;
  TaskPriority? get priorityFilter => _priorityFilter;
  TaskSort get sort => _sort;

  bool get hasActiveFilters =>
      _query.isNotEmpty ||
      _statusFilter != TaskStatusFilter.todas ||
      _categoryFilter != null ||
      _priorityFilter != null;

  int get totalCount => _tasks.length;
  int get completedCount => _tasks.where((t) => t.isCompleted).length;
  int get pendingCount => totalCount - completedCount;
  int get overdueCount => _tasks.where((t) => t.isOverdue).length;
  double get progress => totalCount == 0 ? 0 : completedCount / totalCount;

  List<Task> get filteredTasks {
    final q = _query.trim().toLowerCase();
    final result = _tasks.where((t) {
      if (_statusFilter == TaskStatusFilter.pendentes && t.isCompleted) {
        return false;
      }
      if (_statusFilter == TaskStatusFilter.concluidas && !t.isCompleted) {
        return false;
      }
      if (_categoryFilter != null && t.category != _categoryFilter) {
        return false;
      }
      if (_priorityFilter != null && t.priority != _priorityFilter) {
        return false;
      }
      if (q.isNotEmpty) {
        final inTitle = t.title.toLowerCase().contains(q);
        final inDesc = t.description.toLowerCase().contains(q);
        final inCategory = t.category.label.toLowerCase().contains(q);
        if (!inTitle && !inDesc && !inCategory) return false;
      }
      return true;
    }).toList();

    result.sort(_comparator);
    return result;
  }

  int _comparator(Task a, Task b) {
    switch (_sort) {
      case TaskSort.inteligente:
        return _smartCompare(a, b);
      case TaskSort.prioridade:
        final p = b.priority.weight.compareTo(a.priority.weight);
        return p != 0 ? p : b.createdAt.compareTo(a.createdAt);
      case TaskSort.vencimento:
        return _compareDueDate(a, b);
      case TaskSort.recentes:
        return b.createdAt.compareTo(a.createdAt);
      case TaskSort.alfabetica:
        return a.title.toLowerCase().compareTo(b.title.toLowerCase());
    }
  }

  /// Ordenação "inteligente": pendentes primeiro, depois atrasadas,
  /// prioridade, vencimento mais próximo e, por fim, mais recentes.
  int _smartCompare(Task a, Task b) {
    if (a.isCompleted != b.isCompleted) return a.isCompleted ? 1 : -1;
    if (a.isOverdue != b.isOverdue) return a.isOverdue ? -1 : 1;
    final p = b.priority.weight.compareTo(a.priority.weight);
    if (p != 0) return p;
    final d = _compareDueDate(a, b);
    if (d != 0) return d;
    return b.createdAt.compareTo(a.createdAt);
  }

  int _compareDueDate(Task a, Task b) {
    if (a.dueDate == null && b.dueDate == null) return 0;
    if (a.dueDate == null) return 1;
    if (b.dueDate == null) return -1;
    return a.dueDate!.compareTo(b.dueDate!);
  }

  // ---------- Ações ----------
  Future<void> load() async {
    _isLoading = true;
    notifyListeners();
    _tasks = await _repository.loadTasks();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _persist() async {
    notifyListeners();
    await _repository.saveTasks(_tasks);
  }

  Future<void> addTask(Task task) async {
    _tasks = [..._tasks, task];
    await _persist();
  }

  Future<void> updateTask(Task task) async {
    _tasks = _tasks.map((t) => t.id == task.id ? task : t).toList();
    await _persist();
  }

  Future<Task?> deleteTask(String id) async {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index == -1) return null;
    final removed = _tasks[index];
    _tasks = [..._tasks]..removeAt(index);
    await _persist();
    return removed;
  }

  Future<void> restoreTask(Task task) async {
    if (_tasks.any((t) => t.id == task.id)) return;
    _tasks = [..._tasks, task];
    await _persist();
  }

  Future<void> toggleCompleted(String id) async {
    _tasks = _tasks.map((t) {
      if (t.id != id) return t;
      final completed = !t.isCompleted;
      return t.copyWith(
        isCompleted: completed,
        completedAt: completed ? DateTime.now() : null,
        clearCompletedAt: !completed,
      );
    }).toList();
    await _persist();
  }

  Future<int> clearCompleted() async {
    final count = completedCount;
    _tasks = _tasks.where((t) => !t.isCompleted).toList();
    await _persist();
    return count;
  }

  // ---------- Filtros ----------
  void setQuery(String value) {
    _query = value;
    notifyListeners();
  }

  void setStatusFilter(TaskStatusFilter value) {
    _statusFilter = value;
    notifyListeners();
  }

  void setCategoryFilter(TaskCategory? value) {
    _categoryFilter = value;
    notifyListeners();
  }

  void setPriorityFilter(TaskPriority? value) {
    _priorityFilter = value;
    notifyListeners();
  }

  void setSort(TaskSort value) {
    _sort = value;
    notifyListeners();
  }

  void clearFilters() {
    _query = '';
    _statusFilter = TaskStatusFilter.todas;
    _categoryFilter = null;
    _priorityFilter = null;
    notifyListeners();
  }
}

