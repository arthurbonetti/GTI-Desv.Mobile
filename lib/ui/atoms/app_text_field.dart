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

/// Compõe teclas mortas (`´`, `` ` ``, `~`, `^`, `¨`, `¸` e variantes Unicode
/// como `ˆ`, `˜`, `ˋ` e marcas combinantes) com a letra seguinte quando o
/// sistema/IME (ex.: Linux Wayland sem GTK_IM_MODULE) insere o acento
/// literalmente antes ou depois da letra.
class DeadKeyInputFormatter extends TextInputFormatter {
  static const Map<String, String> _acuteMap = {
    'a': 'á',
    'e': 'é',
    'i': 'í',
    'o': 'ó',
    'u': 'ú',
    'y': 'ý',
    'c': 'ç',
    'A': 'Á',
    'E': 'É',
    'I': 'Í',
    'O': 'Ó',
    'U': 'Ú',
    'Y': 'Ý',
    'C': 'Ç',
  };

  static const Map<String, String> _graveMap = {
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
  };

  static const Map<String, String> _tildeMap = {
    'a': 'ã',
    'o': 'õ',
    'n': 'ñ',
    'A': 'Ã',
    'O': 'Õ',
    'N': 'Ñ',
  };

  static const Map<String, String> _circumflexMap = {
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
  };

  static const Map<String, String> _diaeresisMap = {
    'a': 'ä',
    'e': 'ë',
    'i': 'ï',
    'o': 'ö',
    'u': 'ü',
    'y': 'ÿ',
    'A': 'Ä',
    'E': 'Ë',
    'I': 'Ï',
    'O': 'Ö',
    'U': 'Ü',
    'Y': 'Ÿ',
  };

  static const Map<String, String> _cedillaMap = {
    'c': 'ç',
    'C': 'Ç',
  };

  static const Map<String, Map<String, String>> _combinations = {
    '´': _acuteMap,
    '\u02CA': _acuteMap,
    '\u02B9': _acuteMap,
    '\u0301': _acuteMap,
    '`': _graveMap,
    '\u02CB': _graveMap,
    '\u0300': _graveMap,
    '~': _tildeMap,
    '\u02DC': _tildeMap,
    '\u0303': _tildeMap,
    '^': _circumflexMap,
    '\u02C6': _circumflexMap,
    '\u0302': _circumflexMap,
    '¨': _diaeresisMap,
    '\u0308': _diaeresisMap,
    '¸': _cedillaMap,
    '\u0327': _cedillaMap,
  };

  static const Set<String> _combiningMarks = {
    '\u0300',
    '\u0301',
    '\u0302',
    '\u0303',
    '\u0308',
    '\u0327',
  };

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (!oldValue.selection.isCollapsed || !newValue.selection.isCollapsed) {
      return newValue;
    }
    final cursor = newValue.selection.baseOffset;
    if (newValue.text.length != oldValue.text.length + 1 ||
        cursor != oldValue.selection.baseOffset + 1 ||
        cursor < 2) {
      return newValue;
    }

    final first = newValue.text[cursor - 2];
    final second = newValue.text[cursor - 1];

    // Caso padrão: tecla morta digitada antes da letra (ex.: ´ + a → á, ˆ + e → ê).
    // Caso alternativo (NFD): letra seguida de marca combinante (ex.: a + \u0301 → á).
    var combined = _combinations[first]?[second];
    if (combined == null && _combiningMarks.contains(second)) {
      combined = _combinations[second]?[first];
    }
    if (combined == null) return newValue;

    final updated = newValue.text.replaceRange(cursor - 2, cursor, combined);
    return newValue.copyWith(
      text: updated,
      selection: TextSelection.collapsed(offset: cursor - 1),
      composing: TextRange.empty,
    );
  }
}

