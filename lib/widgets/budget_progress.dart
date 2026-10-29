import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Thin progress bar that turns amber at 75 % and red when the budget is exceeded.
class BudgetProgress extends StatelessWidget {
  const BudgetProgress({super.key, required this.spent, required this.budget});

  final double spent;
  final double budget;

  @override
  Widget build(BuildContext context) {
    final ratio = budget <= 0 ? 0.0 : spent / budget;
    final color = ratio > 1
        ? AppColors.danger
        : ratio > 0.75
        ? AppColors.warning
        : AppColors.success;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: ratio.clamp(0, 1).toDouble(),
            minHeight: 10,
            backgroundColor: Colors.white24,
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '${(ratio * 100).toStringAsFixed(0)}% of monthly budget used',
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }
}
