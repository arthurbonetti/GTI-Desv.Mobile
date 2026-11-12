import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../atoms/content_constraint.dart';

/// Template: estrutura editorial (layout) da tela inicial, sem regras de negócio.
/// Recebe os "slots" já montados pela página.
class HomeTemplate extends StatelessWidget {
  const HomeTemplate({
    super.key,
    required this.title,
    required this.stats,
    required this.search,
    required this.content,
    required this.onAdd,
    this.actions = const [],
    this.resultsHeader,
  });

  final String title;
  final Widget stats;
  final Widget search;

  /// Deve ser um Sliver (ex.: lista de tarefas ou SliverFillRemaining).
  final Widget content;
  final Widget? resultsHeader;
  final VoidCallback onAdd;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: ContentConstraint(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 12, 0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontSize: 26,
                              height: 1.1,
                              letterSpacing: -0.7,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        ...actions,
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                    child: stats,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
                    child: search,
                  ),
                ),
                if (resultsHeader != null)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 14, 20, 6),
                      child: resultsHeader,
                    ),
                  ),
                content,
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: onAdd,
        icon: const Icon(Icons.add_rounded, size: 20),
        label: const Text('Nova tarefa'),
      ),
    );
  }
}
