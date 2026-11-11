import 'package:flutter/material.dart';

/// Largura máxima de conteúdo legível em telas grandes (tablet/desktop).
const double kMaxContentWidth = 720;

/// Centraliza o [child] limitando sua largura a [maxWidth], evitando que o
/// conteúdo se estique em janelas largas.
class ContentConstraint extends StatelessWidget {
  const ContentConstraint({
    super.key,
    required this.child,
    this.maxWidth = kMaxContentWidth,
  });

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
