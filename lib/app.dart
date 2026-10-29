import 'package:flutter/material.dart';

import 'screens/home_shell.dart';
import 'state/expense_controller.dart';
import 'theme/app_theme.dart';

/// Root widget: wires the theme (light / dark) to the controller.
class ExpenseMateApp extends StatelessWidget {
  const ExpenseMateApp({super.key, required this.controller});

  final ExpenseController controller;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) => MaterialApp(
        title: 'ExpenseMate',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: controller.darkMode ? ThemeMode.dark : ThemeMode.light,
        home: HomeShell(controller: controller),
      ),
    );
  }
}
