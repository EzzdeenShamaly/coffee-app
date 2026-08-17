import 'package:coffee_app/features/cart/domain/entities/cart_item.dart';
import 'package:coffee_app/features/cart/domain/entities/cart_totals.dart';
import 'package:coffee_app/features/cart/domain/usecases/calculate_cart_totals.dart';
import 'package:coffee_app/features/menu/domain/entities/drink.dart';
import 'package:coffee_app/features/menu/domain/entities/drink_category.dart';
import 'package:coffee_app/features/product/domain/entities/drink_configuration.dart';
import 'package:coffee_app/features/product/domain/entities/drink_options.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const calculate = CalculateCartTotals(taxRate: 0.10);

  const latte = Drink(
    id: 'drink-3',
    name: 'Caramel Latte',
    description: 'Caramel.',
    basePriceCents: 480,
    category: DrinkCategory.espresso,
  );

  // A small latte with whole milk carries no surcharges, so its line total is
  // the 480-cent base price exactly — which keeps the arithmetic below readable.
  const smallLatte = CartItem(
    id: 'line-1',
    drink: latte,
    configuration: DrinkConfiguration(size: DrinkSize.small),
  );

  group('CalculateCartTotals', () {
    test('returns the empty totals for an empty cart', () {
      expect(calculate(const []), CartTotals.empty);
      expect(calculate(const []).isEmpty, isTrue);
    });

    test('sums line totals into the subtotal', () {
      final totals = calculate(const [smallLatte]);
      expect(totals.subtotal.cents, 480);
    });

    test('counts units, not lines', () {
      final totals = calculate(const [
        CartItem(
          id: 'line-1',
          drink: latte,
          configuration: DrinkConfiguration(size: DrinkSize.small),
          quantity: 2,
        ),
        smallLatte,
      ]);

      // Two lines, three drinks.
      expect(totals.itemCount, 3);
      expect(totals.subtotal.cents, 1440);
    });

    test('keeps subtotal + tax exactly equal to total', () {
      final totals = calculate(const [
        CartItem(
          id: 'line-1',
          drink: latte,
          configuration: DrinkConfiguration(size: DrinkSize.small),
          quantity: 3,
        ),
      ]);

      // This is the invariant a receipt depends on. Rounding per line instead of
      // once on the subtotal is what breaks it.
      expect(
        totals.subtotal.cents + totals.tax.cents,
        totals.total.cents,
      );
      expect(totals.subtotal.cents, 1440);
      expect(totals.tax.cents, 144);
      expect(totals.total.cents, 1584);
    });

    test('rounds a half-cent of tax up rather than truncating it', () {
      const fiveDollarDrink = Drink(
        id: 'drink-9',
        name: 'Nitro Cold Brew',
        description: 'On nitrogen.',
        basePriceCents: 500,
        category: DrinkCategory.coldBrew,
      );

      const standardRate = CalculateCartTotals(taxRate: 0.0825);
      final totals = standardRate(const [
        CartItem(
          id: 'line-1',
          drink: fiveDollarDrink,
          configuration: DrinkConfiguration(size: DrinkSize.small),
          quantity: 2,
        ),
      ]);

      // Subtotal 1000; 1000 * 0.0825 = 82.5 exactly, which must round to 83.
      // Truncation would give 82 and leave the receipt a cent short.
      expect(totals.subtotal.cents, 1000);
      expect(totals.tax.cents, 83);
      expect(totals.total.cents, 1083);
    });
  });
}
