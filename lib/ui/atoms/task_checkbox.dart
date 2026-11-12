import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Átomo: caixa de seleção tátil com cantos chanfrados (estilo caderno técnico).
class TaskCheckbox extends StatelessWidget {
  const TaskCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.semanticLabel,
    this.activeColor = AppColors.primary,
    this.borderColor = AppColors.borderStrong,
  });

  final bool value;
  final VoidCallback onChanged;
  final String? semanticLabel;
  final Color activeColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      checked: value,
      button: true,
      label: semanticLabel,
      child: InkResponse(
        onTap: onChanged,
        radius: 22,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOutCubic,
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: value ? activeColor : AppColors.surface,
            border: Border.all(
              color: value ? activeColor : borderColor,
              width: 1.6,
            ),
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 140),
            child: value
                ? const Icon(
                    Icons.check_rounded,
                    key: ValueKey('checked'),
                    size: 15,
                    color: AppColors.surface,
                  )
                : const SizedBox.shrink(key: ValueKey('unchecked')),
          ),
        ),
      ),
    );
  }
}
