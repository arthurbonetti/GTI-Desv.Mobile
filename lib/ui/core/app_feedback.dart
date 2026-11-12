import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Exibe um diálogo padrão de confirmação para ações destrutivas.
Future<bool> showConfirmDeleteDialog(
  BuildContext context, {
  required String title,
  required String message,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          style: TextButton.styleFrom(foregroundColor: AppColors.danger),
          child: const Text('Excluir'),
        ),
      ],
    ),
  );
  return confirmed ?? false;
}

/// Exibe uma SnackBar de exclusão com ação "Desfazer" padronizada.
void showUndoDeleteSnackBar(
  ScaffoldMessengerState messenger, {
  required String message,
  required VoidCallback onUndo,
}) {
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: 'Desfazer',
          textColor: AppColors.snackBarAction,
          onPressed: onUndo,
        ),
      ),
    );
}
