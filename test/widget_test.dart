import 'package:expense_mate/app.dart';
import 'package:expense_mate/services/storage_service.dart';
import 'package:expense_mate/state/expense_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('user can add an expense from the dashboard', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final controller = ExpenseController(await StorageService.create());
    await controller.load();
    await tester.binding.setSurfaceSize(
      const Size(430, 1400),
    ); // phone-like screen
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(ExpenseMateApp(controller: controller));

    expect(find.text('ExpenseMate'), findsOneWidget);
    await tester.tap(find.byKey(const Key('add-expense-fab')));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('title-field')), 'Bus pass');
    await tester.enterText(find.byKey(const Key('amount-field')), '600');
    await tester.tap(find.byKey(const Key('save-button')));
    await tester.pumpAndSettle();

    expect(controller.expenses.single.title, 'Bus pass');
    expect(find.text('Bus pass'), findsOneWidget);
  });

  testWidgets('validation errors are shown for an empty form', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final controller = ExpenseController(await StorageService.create());
    await tester.pumpWidget(ExpenseMateApp(controller: controller));
    await tester.tap(find.byKey(const Key('add-expense-fab')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('save-button')));
    await tester.pump();
    expect(find.text('Please enter a title'), findsOneWidget);
    expect(find.text('Enter a valid amount'), findsOneWidget);
  });
}
