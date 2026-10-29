import 'package:expense_mate/models/category.dart';
import 'package:expense_mate/models/expense.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Expense survives a JSON round trip', () {
    final e = Expense(
      id: '1',
      title: 'Lunch',
      amount: 120.5,
      category: ExpenseCategory.food,
      date: DateTime(2026, 10, 15),
      note: 'Canteen',
    );
    final back = Expense.fromJson(e.toJson());
    expect(back.title, 'Lunch');
    expect(back.amount, 120.5);
    expect(back.category, ExpenseCategory.food);
    expect(back.date, DateTime(2026, 10, 15));
    expect(back.note, 'Canteen');
  });

  test('Unknown category falls back to Other', () {
    expect(ExpenseCategory.fromName('crypto'), ExpenseCategory.other);
  });
}
