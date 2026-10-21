import 'package:flutter/material.dart';

import '../atoms/atoms.dart';

/// Opção genérica para [ChipFilterRow].
class ChipOption<T> {
  const ChipOption({
    required this.value,
    required this.label,
    this.icon,
    this.color,
  });

  final T? value;
  final String label;
  final IconData? icon;
  final Color? color;
}

/// Molécula: linha horizontal rolável de chips de filtro.
class ChipFilterRow<T> extends StatelessWidget {
  const ChipFilterRow({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  final List<ChipOption<T>> options;
  final T? selected;
  final ValueChanged<T?> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(
          scrollbars: false,
          overscroll: false,
        ),
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          clipBehavior: Clip.none,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: options.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (_, i) {
            final o = options[i];
            final color = o.color;
            return color == null
                ? AppChoiceChip(
                    label: o.label,
                    icon: o.icon,
                    selected: o.value == selected,
                    onTap: () => onSelected(o.value),
                  )
                : AppChoiceChip(
                    label: o.label,
                    icon: o.icon,
                    color: color,
                    selected: o.value == selected,
                    onTap: () => onSelected(o.value),
                  );
          },
        ),
      ),
    );
  }
}

