import 'package:coffee_app/core/money/money.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Money', () {
    test('formats whole and fractional amounts with two decimals', () {
      expect(const Money(1234).formatted, r'$12.34');
      expect(const Money(500).formatted, r'$5.00');
      // The padLeft on the cents part is what stops this rendering as "$5.5".
      expect(const Money(505).formatted, r'$5.05');
      expect(const Money.zero().formatted, r'$0.00');
    });

    test('formats a negative amount with the sign before the symbol', () {
      expect(const Money(-250).formatted, r'-$2.50');
    });

    test('adds, subtracts, and multiplies by a quantity', () {
      expect(const Money(300) + const Money(250), const Money(550));
      expect(const Money(300) - const Money(250), const Money(50));
      expect(const Money(420) * 3, const Money(1260));
    });

    test('sums an empty iterable to zero rather than throwing', () {
      expect(Money.sum(const []), const Money.zero());
    });

    test('rounds a percentage to the nearest cent', () {
      // 1000 * 0.0825 = 82.5 -> rounds to 83, not truncated to 82.
      expect(const Money(1000).percentage(0.0825), const Money(83));
    });

    test('is value-equal, so states holding it compare correctly', () {
      expect(const Money(999), const Money(999));
      expect(const Money(999) == const Money(998), isFalse);
    });

    test('sorts by amount', () {
      final amounts = [const Money(300), const Money(100), const Money(200)]
        ..sort();
      expect(amounts, [const Money(100), const Money(200), const Money(300)]);
    });
  });
}
