import 'package:flutter/material.dart';

import '../state/expense_controller.dart';
import '../utils/currency.dart';
import '../utils/date_utils.dart';
import '../widgets/bar_chart.dart';
import '../widgets/category_breakdown.dart';
import '../widgets/empty_state.dart';
import '../widgets/section_header.dart';

/// Insights tab: last-7-days chart, category breakdown and month comparison.
class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key, required this.controller});

  final ExpenseController controller;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final now = DateTime.now();
        final daily = controller.dailyTotals();
        final totals = controller.categoryTotals(now);
        final lastMonth = DateTime(now.year, now.month - 1, 1);
        final thisTotal = controller.totalFor(now);
        final lastTotal = controller.totalFor(lastMonth);
        final change = lastTotal == 0
            ? 0.0
            : (thisTotal - lastTotal) / lastTotal * 100;
        final scheme = Theme.of(context).colorScheme;
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
          children: [
            const Text(
              'Insights',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
            ),
            const SectionHeader(title: 'Last 7 days'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SimpleBarChart(
                  values: daily.map((e) => e.value).toList(),
                  labels: daily.map((e) => DateUtilsX.weekday(e.key)).toList(),
                  color: scheme.primary,
                ),
              ),
            ),
            const SectionHeader(title: 'This month vs last month'),
            Card(
              child: ListTile(
                leading: Icon(
                  change > 0
                      ? Icons.trending_up_rounded
                      : Icons.trending_down_rounded,
                  color: change > 0 ? Colors.red : Colors.green,
                  size: 32,
                ),
                title: Text(
                  '${Currency.format(thisTotal, decimals: false)}  vs  ${Currency.format(lastTotal, decimals: false)}',
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                subtitle: Text(
                  lastTotal == 0
                      ? 'No data for last month yet'
                      : '${change.abs().toStringAsFixed(0)}% ${change > 0 ? 'more' : 'less'} than ${DateUtilsX.monthTitle(lastMonth)}',
                ),
              ),
            ),
            SectionHeader(
              title: 'Where your money goes · ${DateUtilsX.monthTitle(now)}',
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: totals.isEmpty
                    ? const EmptyState(message: 'No spending this month')
                    : CategoryBreakdown(totals: totals),
              ),
            ),
          ],
        );
      },
    );
  }
}
