import 'package:flutter/material.dart';

import '../models/category.dart';
import '../state/expense_controller.dart';
import '../utils/currency.dart';
import '../widgets/empty_state.dart';
import '../widgets/expense_tile.dart';
import 'add_expense_screen.dart';

/// Expenses tab: search, filter by category, swipe to delete (with undo), tap to edit.
class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key, required this.controller});

  final ExpenseController controller;

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  String _query = '';
  ExpenseCategory? _filter;

  Future<void> _delete(String id) async {
    final removed = await widget.controller.remove(id);
    if (!mounted || removed == null) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Deleted "${removed.title}"'),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () => widget.controller.add(removed),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final items = widget.controller.search(_query, category: _filter);
        final total = items.fold<double>(0, (s, e) => s + e.amount);
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'All expenses',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    key: const Key('search-field'),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search_rounded),
                      hintText: 'Search title or note',
                    ),
                    onChanged: (v) => setState(() => _query = v),
                  ),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: const Text('All'),
                            selected: _filter == null,
                            onSelected: (_) => setState(() => _filter = null),
                          ),
                        ),
                        for (final c in ExpenseCategory.values)
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              avatar: Icon(c.icon, size: 18, color: c.color),
                              label: Text(c.label),
                              selected: _filter == c,
                              onSelected: (_) => setState(
                                () => _filter = _filter == c ? null : c,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${items.length} entries • ${Currency.format(total)}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            Expanded(
              child: items.isEmpty
                  ? const Center(
                      child: EmptyState(message: 'No matching expenses'),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
                      itemCount: items.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 8),
                      itemBuilder: (context, i) {
                        final e = items[i];
                        return Dismissible(
                          key: ValueKey(e.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            decoration: BoxDecoration(
                              color: Colors.red.shade400,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: const Icon(
                              Icons.delete_rounded,
                              color: Colors.white,
                            ),
                          ),
                          onDismissed: (_) => _delete(e.id),
                          child: ExpenseTile(
                            expense: e,
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => AddExpenseScreen(
                                  controller: widget.controller,
                                  existing: e,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}
