import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Átomo: checkbox circular animado para concluir tarefas.
class TaskCheckbox extends StatelessWidget {
  const TaskCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor = AppColors.success,
    this.borderColor = AppColors.textMuted,
  });

  final bool value;
  final VoidCallback onChanged;
  final Color activeColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      checked: value,
      button: true,
      child: InkResponse(
        onTap: onChanged,
        radius: 22,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: value ? activeColor : Colors.transparent,
            border: Border.all(
              color: value ? activeColor : borderColor,
              width: 2,
            ),
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 150),
            child: value
                ? const Icon(Icons.check_rounded,
                    key: ValueKey('checked'), size: 16, color: Colors.white)
                : const SizedBox.shrink(key: ValueKey('unchecked')),
          ),
        ),
      ),
    );
  }
}

