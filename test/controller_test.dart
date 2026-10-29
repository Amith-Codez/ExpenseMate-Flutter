import 'package:expense_mate/models/category.dart';
import 'package:expense_mate/models/expense.dart';
import 'package:expense_mate/services/storage_service.dart';
import 'package:expense_mate/state/expense_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late ExpenseController controller;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    controller = ExpenseController(await StorageService.create());
    await controller.load();
  });

  Expense make(String id, double amount, ExpenseCategory c) => Expense(
    id: id,
    title: 'Item $id',
    amount: amount,
    category: c,
    date: DateTime.now(),
  );

  test('add, update and remove expenses', () async {
    await controller.add(make('a', 100, ExpenseCategory.food));
    await controller.add(make('b', 300, ExpenseCategory.travel));
    expect(controller.expenses.length, 2);
    expect(controller.spentThisMonth, 400);

    await controller.update(make('a', 150, ExpenseCategory.food));
    expect(controller.spentThisMonth, 450);

    await controller.remove('b');
    expect(controller.expenses.length, 1);
  });

  test('category totals are sorted from highest to lowest', () async {
    await controller.add(make('a', 100, ExpenseCategory.food));
    await controller.add(make('b', 500, ExpenseCategory.shopping));
    await controller.add(make('c', 50, ExpenseCategory.food));
    final totals = controller.categoryTotals(DateTime.now());
    expect(totals.keys.first, ExpenseCategory.shopping);
    expect(totals[ExpenseCategory.food], 150);
  });

  test('data is persisted and reloaded', () async {
    await controller.add(make('a', 99, ExpenseCategory.bills));
    await controller.setBudget(8000);
    final reloaded = ExpenseController(await StorageService.create());
    await reloaded.load();
    expect(reloaded.expenses.single.amount, 99);
    expect(reloaded.monthlyBudget, 8000);
  });

  test('search filters by text and category', () async {
    await controller.loadSampleData();
    expect(controller.search('pizza').length, 1);
    expect(
      controller
          .search('', category: ExpenseCategory.travel)
          .every((e) => e.category == ExpenseCategory.travel),
      isTrue,
    );
  });
}
