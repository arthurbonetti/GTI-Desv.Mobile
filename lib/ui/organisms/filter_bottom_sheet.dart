import 'package:flutter/material.dart';

import '../../controllers/task_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/task.dart';
import '../atoms/atoms.dart';

/// Organismo / BottomSheet: diálogo modal em pop-up para escolher filtros.
class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({
    super.key,
    required this.initialStatus,
    required this.initialCategory,
    required this.initialPriority,
    required this.onApply,
    required this.onClear,
  });

  final TaskStatusFilter initialStatus;
  final TaskCategory? initialCategory;
  final TaskPriority? initialPriority;
  final void Function(TaskStatusFilter status, TaskCategory? category, TaskPriority? priority) onApply;
  final VoidCallback onClear;

  static Future<void> show(
    BuildContext context, {
    required TaskStatusFilter currentStatus,
    required TaskCategory? currentCategory,
    required TaskPriority? currentPriority,
    required void Function(TaskStatusFilter status, TaskCategory? category, TaskPriority? priority) onApply,
    required VoidCallback onClear,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FilterBottomSheet(
        initialStatus: currentStatus,
        initialCategory: currentCategory,
        initialPriority: currentPriority,
        onApply: onApply,
        onClear: onClear,
      ),
    );
  }

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late TaskStatusFilter _status = widget.initialStatus;
  late TaskCategory? _category = widget.initialCategory;
  late TaskPriority? _priority = widget.initialPriority;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.tune_rounded, color: AppColors.primary, size: 22),
              const SizedBox(width: 8),
              const Text(
                'Filtros',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  setState(() {
                    _status = TaskStatusFilter.todas;
                    _category = null;
                    _priority = null;
                  });
                  widget.onClear();
                  Navigator.pop(context);
                },
                child: const Text('Limpar'),
              ),
            ],
          ),
          const Divider(height: 24),
          const SectionLabel('Status'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: TaskStatusFilter.values.map((s) {
              return AppChoiceChip(
                label: s.label,
                selected: _status == s,
                onTap: () => setState(() => _status = s),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          const SectionLabel('Categoria'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              AppChoiceChip(
                label: 'Todas',
                selected: _category == null,
                onTap: () => setState(() => _category = null),
              ),
              ...TaskCategory.values.map((c) {
                return AppChoiceChip(
                  label: c.label,
                  icon: c.icon,
                  color: c.color,
                  selected: _category == c,
                  onTap: () => setState(() => _category = _category == c ? null : c),
                );
              }),
            ],
          ),
          const SizedBox(height: 16),
          const SectionLabel('Prioridade'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              AppChoiceChip(
                label: 'Todas',
                selected: _priority == null,
                onTap: () => setState(() => _priority = null),
              ),
              ...TaskPriority.values.map((p) {
                return AppChoiceChip(
                  label: p.label,
                  icon: Icons.flag_rounded,
                  color: p.color,
                  selected: _priority == p,
                  onTap: () => setState(() => _priority = _priority == p ? null : p),
                );
              }),
            ],
          ),
          const SizedBox(height: 24),
          AppButton(
            label: 'Aplicar Filtros',
            icon: Icons.check_rounded,
            onPressed: () {
              widget.onApply(_status, _category, _priority);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

