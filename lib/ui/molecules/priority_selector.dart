import 'package:flutter/material.dart';

import '../../data/models/task.dart';
import '../atoms/atoms.dart';

/// Molécula: seletor de prioridade (rótulo + chips Alta/Média/Baixa).
class PrioritySelector extends StatelessWidget {
  const PrioritySelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final TaskPriority selected;
  final ValueChanged<TaskPriority> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel('Prioridade'),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: TaskPriority.values
              .map(
                (p) => AppChoiceChip(
                  label: p.label,
                  icon: Icons.flag_rounded,
                  color: p.color,
                  selected: p == selected,
                  onTap: () => onChanged(p),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

