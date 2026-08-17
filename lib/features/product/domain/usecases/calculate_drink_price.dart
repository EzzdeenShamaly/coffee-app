import 'package:coffee_app/core/money/money.dart';
import 'package:coffee_app/features/menu/domain/entities/drink.dart';
import 'package:coffee_app/features/product/domain/entities/drink_configuration.dart';

/// Pure pricing rule for one configured drink.
///
/// A use-case rather than a method on the bloc or a getter on the widget: the
/// rule is testable in isolation and reused by the product screen, the cart,
/// and checkout without any of them duplicating it
/// (`01-flutter-architecture-guard.mdc`).
///
/// Rule: `(base + size delta + milk delta + extras) × quantity`, except for
/// non-customisable items (pastries), which price at base only — see
/// `memory-bank/domainRules.md`.
class CalculateDrinkPrice {
  const CalculateDrinkPrice();

  Money call({
    required Drink drink,
    required DrinkConfiguration configuration,
    int quantity = 1,
  }) {
    assert(quantity > 0, 'quantity must be positive');

    if (!drink.category.isCustomisable) {
      return drink.basePrice * quantity;
    }

    final extras = Money.sum(
      configuration.extras.map((e) => Money(e.priceDeltaCents)),
    );

    final unit = drink.basePrice +
        Money(configuration.size.priceDeltaCents) +
        Money(configuration.milk.priceDeltaCents) +
        extras;

    return unit * quantity;
  }
}
