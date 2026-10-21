import 'package:flutter/material.dart';

/// Template: estrutura de uma tela de formulário (AppBar + corpo rolável).
class FormTemplate extends StatelessWidget {
  const FormTemplate({
    super.key,
    required this.title,
    required this.body,
    this.actions = const [],
  });

  final String title;
  final Widget body;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: actions,
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            child: body,
          ),
        ),
      ),
    );
  }
}

