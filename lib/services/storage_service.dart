import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/expense.dart';

/// Persists expenses and settings on the device using shared_preferences
/// (localStorage on the web, NSUserDefaults on iOS, SharedPreferences on Android).
class StorageService {
  StorageService._(this._prefs);

  static const _expensesKey = 'expenses_v1';
  static const _budgetKey = 'monthly_budget';
  static const _darkKey = 'dark_mode';

  final SharedPreferences _prefs;

  static Future<StorageService> create() async =>
      StorageService._(await SharedPreferences.getInstance());

  List<Expense> loadExpenses() {
    final raw = _prefs.getString(_expensesKey);
    if (raw == null || raw.isEmpty) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => Expense.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveExpenses(List<Expense> expenses) => _prefs.setString(
    _expensesKey,
    jsonEncode(expenses.map((e) => e.toJson()).toList()),
  );

  double loadBudget() => _prefs.getDouble(_budgetKey) ?? 15000;

  Future<void> saveBudget(double value) => _prefs.setDouble(_budgetKey, value);

  bool loadDarkMode() => _prefs.getBool(_darkKey) ?? false;

  Future<void> saveDarkMode(bool value) => _prefs.setBool(_darkKey, value);

  Future<void> clearAll() => _prefs.clear();
}
