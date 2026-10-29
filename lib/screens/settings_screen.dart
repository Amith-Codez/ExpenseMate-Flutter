import 'package:flutter/material.dart';

import '../state/expense_controller.dart';
import '../utils/currency.dart';

/// Settings tab: monthly budget, dark mode, demo data and reset.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.controller});

  final ExpenseController controller;

  Future<void> _editBudget(BuildContext context) async {
    final field = TextEditingController(
      text: controller.monthlyBudget.toStringAsFixed(0),
    );
    final value = await showDialog<double>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Monthly budget'),
        content: TextField(
          controller: field,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(prefixText: '₹ '),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, double.tryParse(field.text)),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (value != null && value > 0) await controller.setBudget(value);
  }

  Future<void> _confirmClear(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete all expenses?'),
        content: const Text(
          'This removes every saved expense from this device.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok == true) await controller.clearAll();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) => ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: [
          const Text(
            'Settings',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.account_balance_wallet_rounded),
                  title: const Text('Monthly budget'),
                  subtitle: Text(
                    Currency.format(controller.monthlyBudget, decimals: false),
                  ),
                  trailing: const Icon(Icons.edit_rounded),
                  onTap: () => _editBudget(context),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.dark_mode_rounded),
                  title: const Text('Dark mode'),
                  value: controller.darkMode,
                  onChanged: controller.setDarkMode,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.auto_awesome_rounded),
                  title: const Text('Load demo data'),
                  subtitle: const Text(
                    'Fill the app with sample student expenses',
                  ),
                  onTap: controller.loadSampleData,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(
                    Icons.delete_forever_rounded,
                    color: Colors.red,
                  ),
                  title: const Text('Clear all data'),
                  onTap: () => _confirmClear(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              'ExpenseMate v1.0.0 · Made with Flutter',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
