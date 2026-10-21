import 'package:flutter/material.dart';

import '../../data/models/task.dart';
import '../atoms/atoms.dart';

/// Molécula: seletor de categoria (rótulo + grupo de chips).
class CategorySelector extends StatelessWidget {
  const CategorySelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final TaskCategory selected;
  final ValueChanged<TaskCategory> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel('Categoria'),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: TaskCategory.values
              .map(
                (c) => AppChoiceChip(
                  label: c.label,
                  icon: c.icon,
                  color: c.color,
                  selected: c == selected,
                  onTap: () => onChanged(c),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

