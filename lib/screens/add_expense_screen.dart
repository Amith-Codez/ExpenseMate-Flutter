import 'package:flutter/material.dart';

import '../models/category.dart';
import '../models/expense.dart';
import '../state/expense_controller.dart';
import '../utils/date_utils.dart';
import '../utils/validators.dart';

/// Form to add a new expense or edit an existing one.
class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key, required this.controller, this.existing});

  final ExpenseController controller;
  final Expense? existing;

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title = TextEditingController(
    text: widget.existing?.title,
  );
  late final TextEditingController _amount = TextEditingController(
    text: widget.existing == null
        ? ''
        : widget.existing!.amount.toStringAsFixed(0),
  );
  late final TextEditingController _note = TextEditingController(
    text: widget.existing?.note,
  );
  late ExpenseCategory _category =
      widget.existing?.category ?? ExpenseCategory.food;
  late DateTime _date = widget.existing?.date ?? DateTime.now();

  bool get _editing => widget.existing != null;

  @override
  void dispose() {
    _title.dispose();
    _amount.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final expense = Expense(
      id:
          widget.existing?.id ??
          DateTime.now().microsecondsSinceEpoch.toString(),
      title: _title.text.trim(),
      amount: double.parse(_amount.text.trim()),
      category: _category,
      date: _date,
      note: _note.text.trim(),
    );
    if (_editing) {
      await widget.controller.update(expense);
    } else {
      await widget.controller.add(expense);
    }
    if (!mounted) return;
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_editing ? 'Expense updated' : 'Expense added')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_editing ? 'Edit expense' : 'Add expense')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              key: const Key('title-field'),
              controller: _title,
              decoration: const InputDecoration(
                labelText: 'Title',
                prefixIcon: Icon(Icons.edit_rounded),
              ),
              validator: Validators.title,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 12),
            TextFormField(
              key: const Key('amount-field'),
              controller: _amount,
              decoration: const InputDecoration(
                labelText: 'Amount (₹)',
                prefixIcon: Icon(Icons.currency_rupee_rounded),
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: Validators.amount,
            ),
            const SizedBox(height: 16),
            const Text(
              'Category',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final c in ExpenseCategory.values)
                  ChoiceChip(
                    avatar: Icon(c.icon, size: 18, color: c.color),
                    label: Text(c.label),
                    selected: _category == c,
                    onSelected: (_) => setState(() => _category = c),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            // Own Material so the background moves with the tile when the form re-lays out.
            Material(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(14),
              clipBehavior: Clip.antiAlias,
              child: ListTile(
                leading: const Icon(Icons.calendar_month_rounded),
                title: const Text('Date'),
                subtitle: Text(DateUtilsX.format(_date)),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: _pickDate,
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _note,
              decoration: const InputDecoration(
                labelText: 'Note (optional)',
                prefixIcon: Icon(Icons.notes_rounded),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              key: const Key('save-button'),
              onPressed: _save,
              icon: const Icon(Icons.check_rounded),
              label: Text(_editing ? 'Update expense' : 'Save expense'),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(54),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
