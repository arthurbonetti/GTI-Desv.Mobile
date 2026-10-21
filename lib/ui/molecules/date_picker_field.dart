import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/date_utils.dart';
import '../atoms/atoms.dart';

/// Molécula: campo para escolher a data de vencimento (opcional).
class DatePickerField extends StatelessWidget {
  const DatePickerField({
    super.key,
    required this.date,
    required this.onChanged,
  });

  final DateTime? date;
  final ValueChanged<DateTime?> onChanged;

  Future<void> _pick(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: date ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
      helpText: 'Data de vencimento',
      cancelText: 'Cancelar',
      confirmText: 'OK',
    );
    if (picked != null) onChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel('Vencimento (opcional)'),
        Material(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _pick(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const Icon(Icons.event_rounded,
                      color: AppColors.textSecondary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        date == null
                            ? 'Sem data definida'
                            : '${AppDateUtils.format(date!)}  •  ${AppDateUtils.relativeLabel(date!)}',
                        style: TextStyle(
                          fontSize: 15,
                          color: date == null
                              ? AppColors.textMuted
                              : AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  if (date != null)
                    IconButton(
                      tooltip: 'Remover data',
                      icon: const Icon(Icons.close_rounded,
                          color: AppColors.textSecondary),
                      onPressed: () => onChanged(null),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

