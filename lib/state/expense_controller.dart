import 'package:flutter/foundation.dart';

import '../data/sample_data.dart';
import '../models/category.dart';
import '../models/expense.dart';
import '../services/storage_service.dart';
import '../utils/date_utils.dart';

/// Single source of truth for the app. Screens listen to it and call its methods.
class ExpenseController extends ChangeNotifier {
  ExpenseController(this._storage);

  final StorageService _storage;
  List<Expense> _expenses = [];
  double _budget = 15000;
  bool _darkMode = false;

  List<Expense> get expenses => List.unmodifiable(_expenses);
  double get monthlyBudget => _budget;
  bool get darkMode => _darkMode;

  Future<void> load() async {
    _expenses = _storage.loadExpenses()
      ..sort((a, b) => b.date.compareTo(a.date));
    _budget = _storage.loadBudget();
    _darkMode = _storage.loadDarkMode();
    notifyListeners();
  }

  // ---------------------------------------------------------------- CRUD
  Future<void> add(Expense expense) async {
    _expenses = [expense, ..._expenses]
      ..sort((a, b) => b.date.compareTo(a.date));
    await _persist();
  }

  Future<void> update(Expense expense) async {
    _expenses = [for (final e in _expenses) e.id == expense.id ? expense : e]
      ..sort((a, b) => b.date.compareTo(a.date));
    await _persist();
  }

  Future<Expense?> remove(String id) async {
    final index = _expenses.indexWhere((e) => e.id == id);
    if (index < 0) return null;
    final removed = _expenses[index];
    _expenses = [..._expenses]..removeAt(index);
    await _persist();
    return removed;
  }

  Future<void> loadSampleData() async {
    _expenses = SampleData.build(DateTime.now())
      ..sort((a, b) => b.date.compareTo(a.date));
    await _persist();
  }

  Future<void> clearAll() async {
    _expenses = [];
    await _persist();
  }

  Future<void> setBudget(double value) async {
    _budget = value;
    await _storage.saveBudget(value);
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    _darkMode = value;
    await _storage.saveDarkMode(value);
    notifyListeners();
  }

  // ---------------------------------------------------------------- analytics
  List<Expense> forMonth(DateTime month) =>
      _expenses.where((e) => DateUtilsX.sameMonth(e.date, month)).toList();

  double totalFor(DateTime month) =>
      forMonth(month).fold(0, (sum, e) => sum + e.amount);

  double get spentThisMonth => totalFor(DateTime.now());

  double get budgetUsed =>
      _budget <= 0 ? 0 : (spentThisMonth / _budget).clamp(0, 1.5);

  double get remainingBudget => _budget - spentThisMonth;

  Map<ExpenseCategory, double> categoryTotals(DateTime month) {
    final totals = <ExpenseCategory, double>{};
    for (final e in forMonth(month)) {
      totals[e.category] = (totals[e.category] ?? 0) + e.amount;
    }
    final sorted = totals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return Map.fromEntries(sorted);
  }

  /// Spending for each of the last [days] days, oldest first.
  List<MapEntry<DateTime, double>> dailyTotals({int days = 7}) {
    final today = DateUtilsX.dateOnly(DateTime.now());
    return List.generate(days, (i) {
      final day = today.subtract(Duration(days: days - 1 - i));
      final sum = _expenses
          .where((e) => DateUtilsX.sameDay(e.date, day))
          .fold<double>(0, (s, e) => s + e.amount);
      return MapEntry(day, sum);
    });
  }

  double get averagePerDay {
    final now = DateTime.now();
    return now.day == 0 ? 0 : spentThisMonth / now.day;
  }

  List<Expense> search(String query, {ExpenseCategory? category}) {
    final q = query.trim().toLowerCase();
    return _expenses.where((e) {
      final matchesText =
          q.isEmpty ||
          e.title.toLowerCase().contains(q) ||
          e.note.toLowerCase().contains(q);
      final matchesCategory = category == null || e.category == category;
      return matchesText && matchesCategory;
    }).toList();
  }

  Future<void> _persist() async {
    await _storage.saveExpenses(_expenses);
    notifyListeners();
  }
}
