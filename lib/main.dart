import 'package:flutter/material.dart';

import 'app.dart';
import 'services/storage_service.dart';
import 'state/expense_controller.dart';

/// Entry point of ExpenseMate.
///
/// Loads the saved expenses and settings from local storage before the
/// first frame so the user always sees their own data on launch.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = await StorageService.create();
  final controller = ExpenseController(storage);
  await controller.load();
  runApp(ExpenseMateApp(controller: controller));
}
