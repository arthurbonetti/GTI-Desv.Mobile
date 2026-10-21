import 'package:flutter_test/flutter_test.dart';
import 'package:gerenciador_tarefas_inteligente/controllers/task_controller.dart';
import 'package:gerenciador_tarefas_inteligente/data/models/task.dart';
import 'package:gerenciador_tarefas_inteligente/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

Task _task(
  String id,
  String title, {
  TaskCategory category = TaskCategory.pessoal,
  TaskPriority priority = TaskPriority.media,
  bool completed = false,
  DateTime? due,
}) =>
    Task(
      id: id,
      title: title,
      category: category,
      priority: priority,
      isCompleted: completed,
      createdAt: DateTime(2026, 1, int.parse(id)),
      dueDate: due,
    );

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('Task serializa e desserializa corretamente', () {
    final t = _task('1', 'Estudar',
        category: TaskCategory.estudo, priority: TaskPriority.alta);
    final copy = Task.fromJson(t.toJson());
    expect(copy.title, 'Estudar');
    expect(copy.category, TaskCategory.estudo);
    expect(copy.priority, TaskPriority.alta);
  });

  test('CRUD, filtros e persistência', () async {
    final c = TaskController();
    await c.load();
    await c.addTask(_task('1', 'Relatório', category: TaskCategory.trabalho));
    await c.addTask(_task('2', 'Prova', priority: TaskPriority.alta));
    await c.addTask(_task('3', 'Mercado', priority: TaskPriority.baixa));

    // Ordenação inteligente: alta prioridade primeiro.
    expect(c.filteredTasks.first.title, 'Prova');

    await c.toggleCompleted('2');
    expect(c.completedCount, 1);
    expect(c.filteredTasks.last.title, 'Prova');

    c.setStatusFilter(TaskStatusFilter.pendentes);
    expect(c.filteredTasks.length, 2);

    c.setCategoryFilter(TaskCategory.trabalho);
    expect(c.filteredTasks.single.title, 'Relatório');

    c.clearFilters();
    c.setQuery('merc');
    expect(c.filteredTasks.single.title, 'Mercado');

    await c.deleteTask('3');
    expect(c.totalCount, 2);

    // Persistência: um novo controller carrega os mesmos dados.
    final c2 = TaskController();
    await c2.load();
    expect(c2.totalCount, 2);
  });

  testWidgets('Home exibe estado vazio', (tester) async {
    await tester.pumpWidget(const GerenciadorTarefasApp());
    await tester.pumpAndSettle();
    expect(find.text('Minhas Tarefas'), findsOneWidget);
    expect(find.text('Nenhuma tarefa ainda'), findsOneWidget);
  });
}

