import 'package:flutter/material.dart';

import '../../controllers/task_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/task.dart';
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
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('"${removed.title}" excluída'),
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: 'Desfazer',
            onPressed: () => _controller.restoreTask(removed),
          ),
          onVisible: () {
            Future.delayed(const Duration(seconds: 5), () {
              messenger.hideCurrentSnackBar();
            });
          },
        ),
      );
  }

  Future<void> _clearCompleted() async {
    if (_controller.completedCount == 0) {
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
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Limpar concluídas'),
        content: Text(
            'Excluir ${_controller.completedCount} tarefa(s) concluída(s)?'),
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
    if (confirmed == true) await _controller.clearCompleted();
  }

  Widget _buildSortMenu() {
    return PopupMenuButton<TaskSort>(
      tooltip: 'Ordenar',
      icon: const Icon(Icons.sort_rounded),
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
      icon: const Icon(Icons.more_vert_rounded),
      onSelected: (value) {
        if (value == 'clear') _clearCompleted();
      },
      itemBuilder: (_) => const [
        PopupMenuItem(
          value: 'clear',
          child: Row(
            children: [
              Icon(Icons.cleaning_services_outlined, size: 20),
              SizedBox(width: 12),
              Text('Limpar concluídas'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResultsHeader(int count) {
    return Row(
      children: [
        Text(
          '$count tarefa(s)  •  ${_controller.sort.label}',
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const Spacer(),
        if (_controller.hasActiveFilters)
          TextButton.icon(
            onPressed: _controller.clearFilters,
            icon: const Icon(Icons.filter_alt_off_rounded, size: 18),
            label: const Text('Limpar filtros'),
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
                    'Toque em "Nova tarefa" para começar a organizar seu dia.',
                actionLabel: 'Criar tarefa',
                onAction: () => _openForm(),
              )
            : EmptyState(
                icon: Icons.search_off_rounded,
                title: 'Nada encontrado',
                message: 'Nenhuma tarefa corresponde à busca ou aos filtros.',
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
            total: _controller.totalCount,
            pending: _controller.pendingCount,
            completed: _controller.completedCount,
            overdue: _controller.overdueCount,
            progress: _controller.progress,
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
              Stack(
                alignment: Alignment.topRight,
                children: [
                  IconButton.filledTonal(
                    onPressed: _openFilterDialog,
                    tooltip: 'Filtros',
                    icon: const Icon(Icons.tune_rounded),
                    style: IconButton.styleFrom(
                      padding: const EdgeInsets.all(14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  if (_controller.hasActiveFilters)
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          resultsHeader:
              _controller.isLoading ? null : _buildResultsHeader(tasks.length),
          content: _buildContent(tasks),
          onAdd: () => _openForm(),
        );
      },
    );
  }
}

