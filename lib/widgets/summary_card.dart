import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../utils/currency.dart';
import 'budget_progress.dart';

/// Gradient card on the dashboard: month spending, budget and remaining amount.
class SummaryCard extends StatelessWidget {
  const SummaryCard({
    super.key,
    required this.spent,
    required this.budget,
    required this.monthLabel,
  });

  final double spent;
  final double budget;
  final String monthLabel;

  @override
  Widget build(BuildContext context) {
    final remaining = budget - spent;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [AppColors.gradientStart, AppColors.gradientEnd],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.gradientStart.withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Spent in $monthLabel',
            style: const TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            Currency.format(spent),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),
          BudgetProgress(spent: spent, budget: budget),
          const SizedBox(height: 12),
          Row(
            children: [
              _Pill(
                label: 'Budget',
                value: Currency.format(budget, decimals: false),
              ),
              const SizedBox(width: 10),
              _Pill(
                label: remaining >= 0 ? 'Remaining' : 'Over budget',
                value: Currency.format(remaining.abs(), decimals: false),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.16),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
