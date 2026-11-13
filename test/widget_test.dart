import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gerenciador_tarefas_inteligente/controllers/task_controller.dart';
import 'package:gerenciador_tarefas_inteligente/core/utils/date_utils.dart';
import 'package:gerenciador_tarefas_inteligente/data/models/task.dart';
import 'package:gerenciador_tarefas_inteligente/data/repositories/task_repository.dart';
import 'package:gerenciador_tarefas_inteligente/domain/task_suggestion.dart';
import 'package:gerenciador_tarefas_inteligente/main.dart';
import 'package:gerenciador_tarefas_inteligente/ui/atoms/app_text_field.dart';
import 'package:gerenciador_tarefas_inteligente/ui/core/app_feedback.dart';
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

class _FailingLoadRepository implements TaskRepository {
  @override
  Future<List<Task>> loadTasks() async => throw Exception('Erro de leitura');

  @override
  Future<void> saveTasks(List<Task> tasks) async {}
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('Task serializa, desserializa e compara por valor corretamente', () {
    final t = _task('1', 'Estudar',
        category: TaskCategory.estudo, priority: TaskPriority.alta);
    final copy = Task.fromJson(t.toJson());
    expect(copy, t);
    expect(copy.hashCode, t.hashCode);
  });

  test('CRUD, filtros, busca sem acento e persistência', () async {
    final c = TaskController();
    await c.load();
    await c.addTask(_task('1', 'Reunião com cliente',
        category: TaskCategory.trabalho));
    await c.addTask(_task('2', 'Prova', priority: TaskPriority.alta));
    await c.addTask(_task('3', 'Mercado', priority: TaskPriority.baixa));

    // Ordenação inteligente: alta prioridade primeiro.
    expect(c.filteredTasks.first.title, 'Prova');

    await c.toggleCompleted('2');
    expect(c.completedCount, 1);
    expect(c.filteredTasks.last.title, 'Prova');

    c.setStatusFilter(TaskStatusFilter.pendentes);
    expect(c.hasFacetFilters, isTrue);
    expect(c.filteredTasks.length, 2);

    c.setCategoryFilter(TaskCategory.trabalho);
    expect(c.filteredTasks.single.title, 'Reunião com cliente');

    c.clearFilters();
    c.setQuery('reuniao');
    expect(c.hasActiveFilters, isTrue);
    expect(c.hasFacetFilters, isFalse);
    expect(c.filteredTasks.single.title, 'Reunião com cliente');

    await c.deleteTask('3');
    expect(c.totalCount, 2);

    // Persistência: um novo controller carrega os mesmos dados.
    final c2 = TaskController();
    await c2.load();
    expect(c2.totalCount, 2);
  });

  test('LocalTaskRepository ignora item corrompido sem perder tarefas válidas',
      () async {
    final valid = _task('1', 'Válida');
    SharedPreferences.setMockInitialValues({
      'gti_tasks_v1': jsonEncode([
        valid.toJson(),
        {'id': '2', 'title': 'Quebrada', 'createdAt': 'data-invalida'},
      ]),
    });

    final repo = LocalTaskRepository();
    final loaded = await repo.loadTasks();
    expect(loaded, [valid]);
  });

  test('TaskController.load encerra isLoading mesmo se repositório falhar',
      () async {
    final c = TaskController(repository: _FailingLoadRepository());
    await expectLater(c.load(), throwsException);
    expect(c.isLoading, isFalse);
  });

  test('TaskSuggestion infere categoria e prioridade ignorando acentos', () {
    final s1 = TaskSuggestion.fromTitle('Pagar boleto urgente');
    expect(s1.category, TaskCategory.financas);
    expect(s1.priority, TaskPriority.alta);

    final s2 = TaskSuggestion.fromTitle('Reuniao sobre relatorio');
    expect(s2.category, TaskCategory.trabalho);
    expect(s2.priority, isNull);
  });

  test('AppDateUtils calcula rótulos relativos corretamente', () {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    expect(AppDateUtils.daysFromToday(today), 0);
    expect(AppDateUtils.relativeLabel(today), 'Hoje');
    expect(
      AppDateUtils.relativeLabel(today.add(const Duration(days: 1))),
      'Amanhã',
    );
    expect(
      AppDateUtils.relativeLabel(today.subtract(const Duration(days: 1))),
      'Ontem',
    );
  });

  testWidgets('Home exibe estado vazio', (tester) async {
    await tester.pumpWidget(const GerenciadorTarefasApp());
    await tester.pumpAndSettle();
    expect(find.text('Minhas Tarefas'), findsOneWidget);
    expect(find.text('Nenhuma tarefa ainda'), findsOneWidget);
  });

  testWidgets('SnackBar de exclusão desaparece automaticamente após 5 segundos',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => showUndoDeleteSnackBar(
                ScaffoldMessenger.of(context),
                message: '"Teste" excluída',
                onUndo: () {},
              ),
              child: const Text('Excluir'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Excluir'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('"Teste" excluída'), findsOneWidget);

    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
    expect(find.text('"Teste" excluída'), findsNothing);
  });

  test('DeadKeyInputFormatter compõe acentos em teclas mortas', () {
    final formatter = DeadKeyInputFormatter();

    final withAcute = formatter.formatEditUpdate(
      const TextEditingValue(
        text: '´',
        selection: TextSelection.collapsed(offset: 1),
      ),
      const TextEditingValue(
        text: '´a',
        selection: TextSelection.collapsed(offset: 2),
      ),
    );
    expect(withAcute.text, 'á');
    expect(withAcute.selection.baseOffset, 1);

    final withTilde = formatter.formatEditUpdate(
      const TextEditingValue(
        text: 'computaç~',
        selection: TextSelection.collapsed(offset: 9),
      ),
      const TextEditingValue(
        text: 'computaç~a',
        selection: TextSelection.collapsed(offset: 10),
      ),
    );
    expect(withTilde.text, 'computação'.substring(0, 9));
    expect(withTilde.selection.baseOffset, 9);
  });
}
