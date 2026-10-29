import '../models/category.dart';
import '../models/expense.dart';

/// Realistic demo expenses for a college student, spread over the last 6 weeks.
class SampleData {
  SampleData._();

  static List<Expense> build(DateTime now) {
    const items = <(String, double, ExpenseCategory, int, String)>[
      ('Canteen lunch', 120, ExpenseCategory.food, 0, 'Veg meals'),
      ('Metro card recharge', 300, ExpenseCategory.travel, 0, ''),
      ('Flutter course', 499, ExpenseCategory.education, 1, 'Online course'),
      ('Movie night', 350, ExpenseCategory.entertainment, 1, 'With friends'),
      ('Mobile recharge', 299, ExpenseCategory.bills, 2, '28 days plan'),
      ('Groceries', 860, ExpenseCategory.shopping, 2, 'Weekly groceries'),
      ('Auto to college', 80, ExpenseCategory.travel, 3, ''),
      ('Tea & snacks', 60, ExpenseCategory.food, 3, ''),
      ('Pharmacy', 240, ExpenseCategory.health, 4, 'Cold medicine'),
      ('Notebook & pens', 150, ExpenseCategory.education, 5, ''),
      ('Pizza', 420, ExpenseCategory.food, 6, 'Birthday treat'),
      ('Bus pass', 600, ExpenseCategory.travel, 7, 'Monthly pass'),
      ('T-shirt', 699, ExpenseCategory.shopping, 9, ''),
      ('Electricity share', 650, ExpenseCategory.bills, 10, 'Hostel room'),
      ('Biryani', 280, ExpenseCategory.food, 11, ''),
      ('Gym fee', 500, ExpenseCategory.health, 13, ''),
      ('Cricket match ticket', 400, ExpenseCategory.entertainment, 16, ''),
      ('Internet bill', 590, ExpenseCategory.bills, 20, 'Wi-Fi'),
      ('Textbook', 780, ExpenseCategory.education, 24, 'Data structures'),
      ('Train ticket home', 455, ExpenseCategory.travel, 30, ''),
      ('Shoes', 1499, ExpenseCategory.shopping, 35, ''),
      ('Dinner outing', 520, ExpenseCategory.food, 40, ''),
    ];
    return [
      for (var i = 0; i < items.length; i++)
        Expense(
          id: 'sample-$i',
          title: items[i].$1,
          amount: items[i].$2,
          category: items[i].$3,
          date: DateTime(
            now.year,
            now.month,
            now.day,
            12,
          ).subtract(Duration(days: items[i].$4)),
          note: items[i].$5,
        ),
    ];
  }
}
