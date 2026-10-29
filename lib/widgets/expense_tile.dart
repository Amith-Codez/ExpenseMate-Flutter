import 'package:flutter/material.dart';

import '../models/expense.dart';
import '../utils/currency.dart';
import '../utils/date_utils.dart';
import 'category_avatar.dart';

/// One row in the expense lists.
class ExpenseTile extends StatelessWidget {
  const ExpenseTile({super.key, required this.expense, this.onTap});

  final Expense expense;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        leading: CategoryAvatar(category: expense.category),
        title: Text(
          expense.title,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Text(
          '${expense.category.label} • ${DateUtilsX.relative(expense.date)}',
        ),
        trailing: Text(
          '-${Currency.format(expense.amount)}',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: theme.colorScheme.error,
          ),
        ),
      ),
    );
  }
}
