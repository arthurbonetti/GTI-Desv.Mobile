import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';

/// Átomo: campo de texto padrão.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.hint,
    this.prefixIcon,
    this.suffix,
    this.maxLines = 1,
    this.validator,
    this.onChanged,
    this.textInputAction,
    this.autofocus = false,
    this.maxLength,
  });

  final TextEditingController? controller;
  final String? hint;
  final IconData? prefixIcon;
  final Widget? suffix;
  final int maxLines;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final TextInputAction? textInputAction;
  final bool autofocus;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      maxLength: maxLength,
      validator: validator,
      onChanged: onChanged,
      autofocus: autofocus,
      textInputAction: textInputAction,
      textCapitalization: TextCapitalization.sentences,
      inputFormatters: [DeadKeyInputFormatter()],
      style: const TextStyle(fontSize: 15, color: AppColors.textPrimary),
      buildCounter: maxLength == null
          ? null
          : (
              context, {
              required currentLength,
              required isFocused,
              required maxLength,
            }) {
              if (maxLength == null || currentLength < (maxLength * 0.85)) {
                return null;
              }
              return Text(
                '$currentLength/$maxLength',
                style: TextStyle(
                  fontSize: 11,
                  color: currentLength >= maxLength
                      ? AppColors.danger
                      : AppColors.textMuted,
                ),
              );
            },
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textMuted),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: AppColors.textSecondary)
            : null,
        suffixIcon: suffix,
      ),
    );
  }
}

/// Compõe teclas mortas (`´`, `` ` ``, `~`, `^`, `¨`) com a vogal seguinte
/// quando o sistema/IME (ex.: Linux Wayland sem GTK_IM_MODULE) envia o acento
/// literalmente antes da letra.
class DeadKeyInputFormatter extends TextInputFormatter {
  static const Map<String, Map<String, String>> _combinations = {
    '´': {
      'a': 'á',
      'e': 'é',
      'i': 'í',
      'o': 'ó',
      'u': 'ú',
      'y': 'ý',
      'A': 'Á',
      'E': 'É',
      'I': 'Í',
      'O': 'Ó',
      'U': 'Ú',
      'Y': 'Ý',
    },
    '\u02CA': {
      'a': 'á',
      'e': 'é',
      'i': 'í',
      'o': 'ó',
      'u': 'ú',
      'A': 'Á',
      'E': 'É',
      'I': 'Í',
      'O': 'Ó',
      'U': 'Ú',
    },
    '`': {
      'a': 'à',
      'e': 'è',
      'i': 'ì',
      'o': 'ò',
      'u': 'ù',
      'A': 'À',
      'E': 'È',
      'I': 'Ì',
      'O': 'Ò',
      'U': 'Ù',
    },
    '~': {
      'a': 'ã',
      'o': 'õ',
      'n': 'ñ',
      'A': 'Ã',
      'O': 'Õ',
      'N': 'Ñ',
    },
    '^': {
      'a': 'â',
      'e': 'ê',
      'i': 'î',
      'o': 'ô',
      'u': 'û',
      'A': 'Â',
      'E': 'Ê',
      'I': 'Î',
      'O': 'Ô',
      'U': 'Û',
    },
    '¨': {
      'a': 'ä',
      'e': 'ë',
      'i': 'ï',
      'o': 'ö',
      'u': 'ü',
      'A': 'Ä',
      'E': 'Ë',
      'I': 'Ï',
      'O': 'Ö',
      'U': 'Ü',
    },
  };

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.composing.isValid && !newValue.composing.isCollapsed) {
      return newValue;
    }
    if (!oldValue.selection.isCollapsed || !newValue.selection.isCollapsed) {
      return newValue;
    }
    final cursor = newValue.selection.baseOffset;
    if (newValue.text.length != oldValue.text.length + 1 ||
        cursor != oldValue.selection.baseOffset + 1 ||
        cursor < 2) {
      return newValue;
    }

    final deadKey = newValue.text[cursor - 2];
    final typed = newValue.text[cursor - 1];
    final combined = _combinations[deadKey]?[typed];
    if (combined == null) return newValue;

    final updated = newValue.text.replaceRange(cursor - 2, cursor, combined);
    return newValue.copyWith(
      text: updated,
      selection: TextSelection.collapsed(offset: cursor - 1),
      composing: TextRange.empty,
    );
  }
}

