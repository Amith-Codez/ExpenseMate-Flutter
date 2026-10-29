import 'package:flutter/material.dart';

import '../models/category.dart';
import '../utils/currency.dart';
import 'category_avatar.dart';

/// List of categories with a coloured share bar, used on the Insights screen.
class CategoryBreakdown extends StatelessWidget {
  const CategoryBreakdown({super.key, required this.totals});

  final Map<ExpenseCategory, double> totals;

  @override
  Widget build(BuildContext context) {
    final sum = totals.values.fold<double>(0, (a, b) => a + b);
    return Column(
      children: [
        for (final entry in totals.entries)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                CategoryAvatar(category: entry.key, size: 38),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              entry.key.label,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Text(
                            Currency.format(entry.value, decimals: false),
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: sum == 0 ? 0 : entry.value / sum,
                          minHeight: 8,
                          color: entry.key.color,
                          backgroundColor: entry.key.color.withValues(
                            alpha: 0.12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 42,
                  child: Text(
                    '${sum == 0 ? 0 : (entry.value / sum * 100).round()}%',
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
