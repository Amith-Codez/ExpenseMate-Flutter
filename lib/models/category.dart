import 'package:flutter/material.dart';

/// Spending categories with an icon and a colour used across the UI.
enum ExpenseCategory {
  food('Food', Icons.restaurant_rounded, Color(0xFFF97316)),
  travel('Travel', Icons.directions_bus_rounded, Color(0xFF0EA5E9)),
  shopping('Shopping', Icons.shopping_bag_rounded, Color(0xFFA855F7)),
  bills('Bills', Icons.receipt_long_rounded, Color(0xFFEF4444)),
  education('Education', Icons.school_rounded, Color(0xFF10B981)),
  entertainment('Fun', Icons.movie_rounded, Color(0xFFEAB308)),
  health('Health', Icons.favorite_rounded, Color(0xFFEC4899)),
  other('Other', Icons.category_rounded, Color(0xFF64748B));

  const ExpenseCategory(this.label, this.icon, this.color);

  final String label;
  final IconData icon;
  final Color color;

  /// Safe lookup used when reading saved data (unknown names fall back to [other]).
  static ExpenseCategory fromName(String name) => ExpenseCategory.values
      .firstWhere((c) => c.name == name, orElse: () => ExpenseCategory.other);
}
