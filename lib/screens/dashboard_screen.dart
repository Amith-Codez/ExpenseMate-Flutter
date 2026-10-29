import 'package:flutter/material.dart';

import '../state/expense_controller.dart';
import '../utils/currency.dart';
import '../utils/date_utils.dart';
import '../widgets/empty_state.dart';
import '../widgets/expense_tile.dart';
import '../widgets/section_header.dart';
import '../widgets/stat_tile.dart';
import '../widgets/summary_card.dart';
import 'add_expense_screen.dart';

/// Home tab: monthly summary, quick stats and the five most recent expenses.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({
    super.key,
    required this.controller,
    required this.onSeeAll,
  });

  final ExpenseController controller;
  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final now = DateTime.now();
        final recent = controller.expenses.take(5).toList();
        final top = controller.categoryTotals(now);
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
          children: [
            Text(
              'Hello, Amith 👋',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const Text(
              'ExpenseMate',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 16),
            SummaryCard(
              spent: controller.spentThisMonth,
              budget: controller.monthlyBudget,
              monthLabel: DateUtilsX.monthTitle(now),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                StatTile(
                  icon: Icons.today_rounded,
                  label: 'Avg per day',
                  value: Currency.format(
                    controller.averagePerDay,
                    decimals: false,
                  ),
                  color: Colors.teal,
                ),
                const SizedBox(width: 10),
                StatTile(
                  icon: Icons.receipt_rounded,
                  label: 'Entries',
                  value: '${controller.forMonth(now).length}',
                  color: Colors.indigo,
                ),
                const SizedBox(width: 10),
                StatTile(
                  icon: top.isEmpty
                      ? Icons.category_rounded
                      : top.keys.first.icon,
                  label: 'Top category',
                  value: top.isEmpty ? '-' : top.keys.first.label,
                  color: top.isEmpty ? Colors.grey : top.keys.first.color,
                ),
              ],
            ),
            SectionHeader(
              title: 'Recent expenses',
              trailing: TextButton(
                onPressed: onSeeAll,
                child: const Text('See all'),
              ),
            ),
            if (recent.isEmpty)
              EmptyState(
                message: 'No expenses yet.\nTap "Add expense" or load demo data from Settings.',
                action: FilledButton.tonal(
                  onPressed: controller.loadSampleData,
                  child: const Text('Load demo data'),
                ),
              )
            else
              for (final e in recent)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ExpenseTile(
                    expense: e,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => AddExpenseScreen(
                          controller: controller,
                          existing: e,
                        ),
                      ),
                    ),
                  ),
                ),
          ],
        );
      },
    );
  }
}
