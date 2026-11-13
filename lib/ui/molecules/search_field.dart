import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../atoms/atoms.dart';

/// Molécula: campo de busca (AppTextField + ícone + botão limpar com debounce).
class SearchField extends StatefulWidget {
  const SearchField({
    super.key,
    required this.onChanged,
    this.initialValue = '',
    this.hint = 'Buscar tarefas...',
    this.debounceDuration = const Duration(milliseconds: 220),
  });

  final ValueChanged<String> onChanged;
  final String initialValue;
  final String hint;
  final Duration debounceDuration;

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.initialValue);
  Timer? _debounce;

  @override
  void didUpdateWidget(covariant SearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sincroniza apenas quando os filtros são limpos externamente.
    if (oldWidget.initialValue != widget.initialValue &&
        widget.initialValue.isEmpty &&
        _controller.text.isNotEmpty) {
      _debounce?.cancel();
      _controller.clear();
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    setState(() {});
    _debounce?.cancel();
    _debounce = Timer(widget.debounceDuration, () {
      widget.onChanged(value);
    });
  }

  void _clear() {
    _debounce?.cancel();
    _controller.clear();
    widget.onChanged('');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: _controller,
      hint: widget.hint,
      prefixIcon: Icons.search_rounded,
      textInputAction: TextInputAction.search,
      onChanged: _onChanged,
      suffix: _controller.text.isEmpty
          ? null
          : IconButton(
              icon: const Icon(Icons.close_rounded,
                  color: AppColors.textSecondary),
              onPressed: _clear,
            ),
    );
  }
}

