import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../atoms/atoms.dart';

/// Molécula: campo de busca (AppTextField + ícone + botão limpar).
class SearchField extends StatefulWidget {
  const SearchField({
    super.key,
    required this.onChanged,
    this.initialValue = '',
    this.hint = 'Buscar tarefas...',
  });

  final ValueChanged<String> onChanged;
  final String initialValue;
  final String hint;

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.initialValue);

  @override
  void didUpdateWidget(covariant SearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sincroniza quando os filtros são limpos externamente.
    if (widget.initialValue != _controller.text &&
        widget.initialValue.isEmpty) {
      _controller.clear();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _clear() {
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
      onChanged: (value) {
        widget.onChanged(value);
        setState(() {});
      },
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

