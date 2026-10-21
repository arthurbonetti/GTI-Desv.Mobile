import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Template: estrutura (layout) da tela inicial, sem regras de negócio.
/// Recebe as "slots" já montadas pela página.
class HomeTemplate extends StatelessWidget {
  const HomeTemplate({
    super.key,
    required this.title,
    this.subtitle,
    required this.stats,
    required this.search,
    this.filters,
    required this.content,
    required this.onAdd,
    this.actions = const [],
    this.resultsHeader,
  });

  final String title;
  final String? subtitle;
  final Widget stats;
  final Widget search;
  final Widget? filters;

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
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 8, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (subtitle != null && subtitle!.isNotEmpty) ...[
                              Text(
                                subtitle!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 2),
                            ],
                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ...actions,
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: stats,
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                  child: search,
                ),
              ),
              if (filters != null) SliverToBoxAdapter(child: filters!),
              if (resultsHeader != null)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
                    child: resultsHeader,
                  ),
                ),
              content,
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: onAdd,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Nova tarefa'),
      ),
    );
  }
}

