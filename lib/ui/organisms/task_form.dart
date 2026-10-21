import 'package:flutter/material.dart';

import '../../data/models/task.dart';
import '../atoms/atoms.dart';
import '../molecules/molecules.dart';

/// Organismo: formulário completo de criação/edição de tarefa.
class TaskForm extends StatefulWidget {
  const TaskForm({
    super.key,
    this.initialTask,
    required this.onSubmit,
  });

  final Task? initialTask;
  final ValueChanged<Task> onSubmit;

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late TaskCategory _category;
  late TaskPriority _priority;
  DateTime? _dueDate;
  bool _categoryTouched = false;
  bool _priorityTouched = false;

  bool get _isEditing => widget.initialTask != null;

  @override
  void initState() {
    super.initState();
    final t = widget.initialTask;
    _titleController = TextEditingController(text: t?.title ?? '');
    _descriptionController = TextEditingController(text: t?.description ?? '');
    _category = t?.category ?? TaskCategory.pessoal;
    _priority = t?.priority ?? TaskPriority.media;
    _dueDate = t?.dueDate;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  /// Sugestão "inteligente" de categoria/prioridade a partir do título,
  /// aplicada apenas na criação de novas tarefas.
  void _onTitleChanged(String value) {
    if (_isEditing) return;
    final text = value.toLowerCase();
    TaskCategory? suggestedCategory;
    const keywords = <TaskCategory, List<String>>{
      TaskCategory.trabalho: ['reunião', 'reuniao', 'cliente', 'relatório', 'relatorio', 'projeto', 'email', 'e-mail', 'trabalho'],
      TaskCategory.estudo: ['estudar', 'prova', 'aula', 'livro', 'curso', 'exercício', 'exercicio', 'faculdade', 'tcc'],
      TaskCategory.saude: ['médico', 'medico', 'academia', 'treino', 'remédio', 'remedio', 'consulta', 'dentista', 'correr'],
      TaskCategory.financas: ['pagar', 'conta', 'boleto', 'fatura', 'banco', 'investir', 'imposto'],
      TaskCategory.pessoal: ['comprar', 'mercado', 'aniversário', 'aniversario', 'casa', 'limpar', 'ligar'],
    };
    for (final entry in keywords.entries) {
      if (entry.value.any(text.contains)) {
        suggestedCategory = entry.key;
        break;
      }
    }
    final urgent = ['urgente', 'hoje', 'importante', 'agora', 'asap']
        .any(text.contains);

    final suggested = suggestedCategory;
    setState(() {
      // Só sugere se o usuário ainda não escolheu manualmente.
      if (!_categoryTouched && suggested != null) {
        _category = suggested;
      }
      if (!_priorityTouched && urgent) _priority = TaskPriority.alta;
    });
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    final initial = widget.initialTask;

    final task = initial == null
        ? Task(
            id: DateTime.now().microsecondsSinceEpoch.toString(),
            title: title,
            description: description,
            category: _category,
            priority: _priority,
            createdAt: DateTime.now(),
            dueDate: _dueDate,
          )
        : initial.copyWith(
            title: title,
            description: description,
            category: _category,
            priority: _priority,
            dueDate: _dueDate,
            clearDueDate: _dueDate == null,
          );

    widget.onSubmit(task);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel('Título'),
          AppTextField(
            controller: _titleController,
            hint: 'Ex.: Estudar para a prova de Flutter',
            prefixIcon: Icons.title_rounded,
            autofocus: !_isEditing,
            maxLength: 80,
            textInputAction: TextInputAction.next,
            onChanged: _onTitleChanged,
            validator: (v) {
              if (v == null || v.trim().isEmpty) {
                return 'Informe um título para a tarefa';
              }
              if (v.trim().length < 3) {
                return 'O título deve ter pelo menos 3 caracteres';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          const SectionLabel('Descrição'),
          AppTextField(
            controller: _descriptionController,
            hint: 'Detalhes da tarefa (opcional)',
            maxLines: 4,
            maxLength: 500,
          ),
          const SizedBox(height: 20),
          CategorySelector(
            selected: _category,
            onChanged: (c) => setState(() {
              _category = c;
              _categoryTouched = true;
            }),
          ),
          const SizedBox(height: 20),
          PrioritySelector(
            selected: _priority,
            onChanged: (p) => setState(() {
              _priority = p;
              _priorityTouched = true;
            }),
          ),
          const SizedBox(height: 20),
          DatePickerField(
            date: _dueDate,
            onChanged: (d) => setState(() => _dueDate = d),
          ),
          const SizedBox(height: 32),
          AppButton(
            label: _isEditing ? 'Salvar alterações' : 'Criar tarefa',
            icon: _isEditing ? Icons.save_rounded : Icons.add_rounded,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
