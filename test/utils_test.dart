import 'package:expense_mate/utils/currency.dart';
import 'package:expense_mate/utils/date_utils.dart';
import 'package:expense_mate/utils/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Currency', () {
    test('uses Indian digit grouping', () {
      expect(Currency.format(1234567.5), '₹12,34,567.50');
      expect(Currency.format(999, decimals: false), '₹999');
      expect(Currency.format(15000, decimals: false), '₹15,000');
    });
    test('compact labels', () {
      expect(Currency.compact(1500), '₹1.5K');
      expect(Currency.compact(250000), '₹2.5L');
    });
  });

  group('Dates', () {
    test('relative labels', () {
      final now = DateTime(2026, 10, 21, 10);
      expect(DateUtilsX.relative(DateTime(2026, 10, 21), now: now), 'Today');
      expect(
        DateUtilsX.relative(DateTime(2026, 10, 20), now: now),
        'Yesterday',
      );
      expect(
        DateUtilsX.relative(DateTime(2026, 10, 15), now: now),
        '15 Oct 2026',
      );
    });
  });

  group('Validators', () {
    test('title and amount', () {
      expect(Validators.title(''), isNotNull);
      expect(Validators.title('Bus pass'), isNull);
      expect(Validators.amount('abc'), isNotNull);
      expect(Validators.amount('-5'), isNotNull);
      expect(Validators.amount('250'), isNull);
    });
  });
}
