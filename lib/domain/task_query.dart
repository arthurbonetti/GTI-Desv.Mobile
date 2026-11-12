import '../data/models/task.dart';

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

/// Critérios imutáveis de busca, filtro e ordenação de tarefas.
///
/// Regra de negócio pura (sem Flutter): fácil de testar isoladamente.
class TaskQuery {
  const TaskQuery({
    this.text = '',
    this.status = TaskStatusFilter.todas,
    this.category,
    this.priority,
    this.sort = TaskSort.inteligente,
  });

  final String text;
  final TaskStatusFilter status;
  final TaskCategory? category;
  final TaskPriority? priority;
  final TaskSort sort;

  /// Indica se há busca ou filtros ativos.
  bool get hasActiveFilters => text.trim().isNotEmpty || hasFacetFilters;

  /// Indica se há filtros do painel (status, categoria ou prioridade) ativos.
  bool get hasFacetFilters =>
      status != TaskStatusFilter.todas ||
      category != null ||
      priority != null;

  TaskQuery copyWith({
    String? text,
    TaskStatusFilter? status,
    TaskCategory? category,
    bool clearCategory = false,
    TaskPriority? priority,
    bool clearPriority = false,
    TaskSort? sort,
  }) {
    return TaskQuery(
      text: text ?? this.text,
      status: status ?? this.status,
      category: clearCategory ? null : (category ?? this.category),
      priority: clearPriority ? null : (priority ?? this.priority),
      sort: sort ?? this.sort,
    );
  }

  /// Mantém apenas a ordenação, descartando busca e filtros.
  TaskQuery withoutFilters() => TaskQuery(sort: sort);

  List<Task> apply(Iterable<Task> tasks) {
    return tasks.where(_matches).toList()..sort(_compare);
  }

  bool _matches(Task task) {
    return _matchesStatus(task) &&
        (category == null || task.category == category) &&
        (priority == null || task.priority == priority) &&
        _matchesText(task);
  }

  bool _matchesStatus(Task task) {
    switch (status) {
      case TaskStatusFilter.todas:
        return true;
      case TaskStatusFilter.pendentes:
        return !task.isCompleted;
      case TaskStatusFilter.concluidas:
        return task.isCompleted;
    }
  }

  bool _matchesText(Task task) {
    final needle = normalizeSearchText(text);
    if (needle.isEmpty) return true;
    return normalizeSearchText(task.title).contains(needle) ||
        normalizeSearchText(task.description).contains(needle) ||
        normalizeSearchText(task.category.label).contains(needle);
  }

  int _compare(Task a, Task b) {
    switch (sort) {
      case TaskSort.inteligente:
        return _compareSmart(a, b);
      case TaskSort.prioridade:
        return _compareByPriorityThenRecent(a, b);
      case TaskSort.vencimento:
        return _compareDueDate(a, b);
      case TaskSort.recentes:
        return b.createdAt.compareTo(a.createdAt);
      case TaskSort.alfabetica:
        return normalizeSearchText(a.title)
            .compareTo(normalizeSearchText(b.title));
    }
  }

  /// Pendentes primeiro, depois atrasadas, prioridade, vencimento mais
  /// próximo e, por fim, mais recentes.
  int _compareSmart(Task a, Task b) {
    if (a.isCompleted != b.isCompleted) return a.isCompleted ? 1 : -1;
    if (a.isOverdue != b.isOverdue) return a.isOverdue ? -1 : 1;
    final byPriority = b.priority.weight.compareTo(a.priority.weight);
    if (byPriority != 0) return byPriority;
    final byDueDate = _compareDueDate(a, b);
    if (byDueDate != 0) return byDueDate;
    return b.createdAt.compareTo(a.createdAt);
  }

  int _compareByPriorityThenRecent(Task a, Task b) {
    final byPriority = b.priority.weight.compareTo(a.priority.weight);
    return byPriority != 0 ? byPriority : b.createdAt.compareTo(a.createdAt);
  }

  int _compareDueDate(Task a, Task b) {
    final aDue = a.dueDate;
    final bDue = b.dueDate;
    if (aDue == null && bDue == null) return 0;
    if (aDue == null) return 1;
    if (bDue == null) return -1;
    return aDue.compareTo(bDue);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TaskQuery &&
        other.text == text &&
        other.status == status &&
        other.category == category &&
        other.priority == priority &&
        other.sort == sort;
  }

  @override
  int get hashCode => Object.hash(text, status, category, priority, sort);
}

/// Remove espaços extras, converte para minúsculas e normaliza acentos comuns
/// do português para buscas e ordenação alfabética consistentes.
String normalizeSearchText(String input) {
  const accents = 'áàâãäéèêëíìîïóòôõöúùûüçñ';
  const plain = 'aaaaaeeeeiiiiooooouuuucn';
  final lower = input.trim().toLowerCase();
  final buffer = StringBuffer();
  for (var i = 0; i < lower.length; i++) {
    final ch = lower[i];
    final idx = accents.indexOf(ch);
    buffer.write(idx >= 0 ? plain[idx] : ch);
  }
  return buffer.toString();
}
