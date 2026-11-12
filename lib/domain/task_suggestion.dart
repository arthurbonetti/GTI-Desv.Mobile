import '../data/models/task.dart';
import 'task_query.dart';

/// Resultado da sugestão automática de metadados a partir do título da tarefa.
class TaskSuggestion {
  const TaskSuggestion({this.category, this.priority});

  final TaskCategory? category;
  final TaskPriority? priority;

  static const Map<TaskCategory, List<String>> _categoryKeywords = {
    TaskCategory.trabalho: [
      'reuniao',
      'cliente',
      'relatorio',
      'projeto',
      'email',
      'e-mail',
      'trabalho',
    ],
    TaskCategory.estudo: [
      'estudar',
      'prova',
      'aula',
      'livro',
      'curso',
      'exercicio',
      'faculdade',
      'tcc',
    ],
    TaskCategory.saude: [
      'medico',
      'academia',
      'treino',
      'remedio',
      'consulta',
      'dentista',
      'correr',
      'saude',
    ],
    TaskCategory.financas: [
      'pagar',
      'conta',
      'boleto',
      'fatura',
      'banco',
      'investir',
      'imposto',
    ],
    TaskCategory.pessoal: [
      'comprar',
      'mercado',
      'aniversario',
      'casa',
      'limpar',
      'ligar',
    ],
  };

  static const List<String> _urgentKeywords = [
    'urgente',
    'hoje',
    'importante',
    'agora',
    'asap',
  ];

  /// Infere categoria e prioridade de forma pura e determinística.
  static TaskSuggestion fromTitle(String title) {
    final normalized = normalizeSearchText(title);
    if (normalized.isEmpty) return const TaskSuggestion();

    TaskCategory? suggestedCategory;
    for (final entry in _categoryKeywords.entries) {
      if (entry.value.any(normalized.contains)) {
        suggestedCategory = entry.key;
        break;
      }
    }

    final isUrgent = _urgentKeywords.any(normalized.contains);
    return TaskSuggestion(
      category: suggestedCategory,
      priority: isUrgent ? TaskPriority.alta : null,
    );
  }
}
