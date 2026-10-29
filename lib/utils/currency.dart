/// Indian-style rupee formatting without extra packages: 1234567.5 -> ₹12,34,567.50
class Currency {
  Currency._();

  static String format(double value, {bool decimals = true}) {
    final negative = value < 0;
    final fixed = value.abs().toStringAsFixed(decimals ? 2 : 0);
    final parts = fixed.split('.');
    final whole = parts[0];
    String grouped;
    if (whole.length <= 3) {
      grouped = whole;
    } else {
      final last3 = whole.substring(whole.length - 3);
      var rest = whole.substring(0, whole.length - 3);
      final groups = <String>[];
      while (rest.length > 2) {
        groups.insert(0, rest.substring(rest.length - 2));
        rest = rest.substring(0, rest.length - 2);
      }
      if (rest.isNotEmpty) groups.insert(0, rest);
      grouped = '${groups.join(',')},$last3';
    }
    final text = decimals ? '$grouped.${parts[1]}' : grouped;
    return '${negative ? '-' : ''}₹$text';
  }

  /// Compact form for chart labels: 1500 -> ₹1.5K
  static String compact(double value) {
    if (value >= 100000) return '₹${(value / 100000).toStringAsFixed(1)}L';
    if (value >= 1000) return '₹${(value / 1000).toStringAsFixed(1)}K';
    return '₹${value.toStringAsFixed(0)}';
  }
}
