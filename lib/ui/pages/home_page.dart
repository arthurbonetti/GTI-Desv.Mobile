import 'package:flutter/material.dart';

import '../../controllers/task_controller.dart';
import '../../data/models/task.dart';
import '../core/app_feedback.dart';
import '../molecules/molecules.dart';
import '../organisms/organisms.dart';
import '../templates/templates.dart';
import 'task_form_page.dart';

/// Página: tela inicial. Instancia o estado real e preenche o [HomeTemplate].
class HomePage extends StatefulWidget {
  const HomePage({super.key, this.controller});

  /// Permite injetar um controller (útil para testes).
  final TaskController? controller;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TaskController _controller =
      widget.controller ?? TaskController();

  @override
  void initState() {
    super.initState();
    _controller.load();
  }

  @override
  void dispose() {
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  void _openFilterDialog() {
    FilterBottomSheet.show(
      context,
      currentStatus: _controller.statusFilter,
      currentCategory: _controller.categoryFilter,
      currentPriority: _controller.priorityFilter,
      onApply: (status, category, priority) {
        _controller.setStatusFilter(status);
        _controller.setCategoryFilter(category);
        _controller.setPriorityFilter(priority);
      },
      onClear: _controller.clearFilters,
    );
  }

  void _openForm([Task? task]) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TaskFormPage(controller: _controller, task: task),
      ),
    );
  }

  Future<void> _delete(Task task) async {
    final messenger = ScaffoldMessenger.of(context);
    final removed = await _controller.deleteTask(task.id);
    if (removed == null) return;
    showUndoDeleteSnackBar(
      messenger,
      message: '"${removed.title}" excluída',
      onUndo: () => _controller.restoreTask(removed),
    );
  }

  Future<void> _clearCompleted() async {
    final completedCount = _controller.completedCount;
    if (completedCount == 0) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Não há tarefas concluídas.'),
            duration: Duration(seconds: 3),
          ),
        );
      return;
    }
    final confirmed = await showConfirmDeleteDialog(
      context,
      title: 'Limpar concluídas',
      message: 'Excluir $completedCount tarefa(s) concluída(s)?',
    );
    if (confirmed) await _controller.clearCompleted();
  }

  Widget _buildSortMenu() {
    return PopupMenuButton<TaskSort>(
      tooltip: 'Ordenar',
      icon: const Icon(Icons.swap_vert_rounded, size: 22),
      initialValue: _controller.sort,
      onSelected: _controller.setSort,
      itemBuilder: (_) => TaskSort.values
          .map(
            (s) => CheckedPopupMenuItem<TaskSort>(
              value: s,
              checked: s == _controller.sort,
              child: Text(s.label),
            ),
          )
          .toList(),
    );
  }

  Widget _buildMoreMenu() {
    return PopupMenuButton<String>(
      tooltip: 'Mais opções',
      icon: const Icon(Icons.more_horiz_rounded, size: 22),
      onSelected: (value) {
        if (value == 'clear') _clearCompleted();
      },
      itemBuilder: (_) => const [
        PopupMenuItem(
          value: 'clear',
          child: Row(
            children: [
              Icon(Icons.cleaning_services_outlined, size: 19),
              SizedBox(width: 10),
              Text('Limpar concluídas'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContent(List<Task> tasks) {
    if (_controller.isLoading) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (tasks.isEmpty) {
      final noTasksAtAll = _controller.totalCount == 0;
      return SliverToBoxAdapter(
        child: noTasksAtAll
            ? EmptyState(
                icon: Icons.checklist_rounded,
                title: 'Nenhuma tarefa ainda',
                message:
                    'Adicione sua primeira tarefa para organizar as prioridades do dia.',
                actionLabel: 'Criar tarefa',
                onAction: () => _openForm(),
              )
            : EmptyState(
                icon: Icons.search_off_rounded,
                title: 'Nada encontrado',
                message: 'Nenhuma tarefa corresponde à busca ou aos filtros ativos.',
                actionLabel: 'Limpar filtros',
                onAction: _controller.clearFilters,
              ),
      );
    }
    return TaskSliverList(
      tasks: tasks,
      onToggle: (t) => _controller.toggleCompleted(t.id),
      onTap: _openForm,
      onDelete: _delete,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        final tasks = _controller.filteredTasks;
        return HomeTemplate(
          title: 'Minhas Tarefas',
          actions: [_buildSortMenu(), _buildMoreMenu()],
          stats: StatsOverview(
            pending: _controller.pendingCount,
            completed: _controller.completedCount,
            overdue: _controller.overdueCount,
          ),
          search: Row(
            children: [
              Expanded(
                child: SearchField(
                  initialValue: _controller.query,
                  onChanged: _controller.setQuery,
                ),
              ),
              const SizedBox(width: 8),
              FilterButton(
                active: _controller.hasFacetFilters,
                onTap: _openFilterDialog,
              ),
            ],
          ),
          resultsHeader: _controller.isLoading
              ? null
              : ResultsHeader(
                  count: tasks.length,
                  sortLabel: _controller.sort.label,
                  hasActiveFilters: _controller.hasActiveFilters,
                  onClearFilters: _controller.clearFilters,
                ),
          content: _buildContent(tasks),
          onAdd: () => _openForm(),
        );
      },
    );
  }
}
