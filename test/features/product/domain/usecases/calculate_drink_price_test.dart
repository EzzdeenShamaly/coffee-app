import 'package:coffee_app/core/money/money.dart';
import 'package:coffee_app/features/menu/domain/entities/drink.dart';
import 'package:coffee_app/features/menu/domain/entities/drink_category.dart';
import 'package:coffee_app/features/product/domain/entities/drink_configuration.dart';
import 'package:coffee_app/features/product/domain/entities/drink_options.dart';
import 'package:coffee_app/features/product/domain/usecases/calculate_drink_price.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const calculate = CalculateDrinkPrice();

  const latte = Drink(
    id: 'drink-3',
    name: 'Caramel Latte',
    description: 'Espresso, steamed milk, house caramel.',
    basePriceCents: 480,
    category: DrinkCategory.espresso,
  );

  const croissant = Drink(
    id: 'drink-7',
    name: 'Butter Croissant',
    description: 'Baked this morning.',
    basePriceCents: 390,
    category: DrinkCategory.pastry,
  );

  group('CalculateDrinkPrice', () {
    test('prices a default configuration at base plus medium size', () {
      // 480 base + 60 medium + 0 whole milk
      expect(
        calculate(drink: latte, configuration: const DrinkConfiguration()),
        const Money(540),
      );
    });

    test('adds the size and milk surcharges', () {
      // 480 + 110 large + 70 oat
      expect(
        calculate(
          drink: latte,
          configuration: const DrinkConfiguration(
            size: DrinkSize.large,
            milk: MilkOption.oat,
          ),
        ),
        const Money(660),
      );
    });

    test('adds every selected extra', () {
      // 480 + 0 small + 0 whole + 90 shot + 50 vanilla
      expect(
        calculate(
          drink: latte,
          configuration: const DrinkConfiguration(
            size: DrinkSize.small,
            extras: [DrinkExtra.extraShot, DrinkExtra.vanillaSyrup],
          ),
        ),
        const Money(620),
      );
    });

    test('multiplies the configured unit price by quantity', () {
      // (480 + 60) * 3
      expect(
        calculate(
          drink: latte,
          configuration: const DrinkConfiguration(),
          quantity: 3,
        ),
        const Money(1620),
      );
    });

    test('charges nothing extra for decaf', () {
      expect(
        calculate(
          drink: latte,
          configuration: const DrinkConfiguration(
            size: DrinkSize.small,
            extras: [DrinkExtra.decaf],
          ),
        ),
        const Money(480),
      );
    });

    test(
      'ignores size and milk for a non-customisable item, pricing at base',
      () {
        // The domain rule: a pastry has no size or milk, so a configuration
        // claiming "large, oat" must not inflate its price.
        expect(
          calculate(
            drink: croissant,
            configuration: const DrinkConfiguration(
              size: DrinkSize.large,
              milk: MilkOption.oat,
              extras: [DrinkExtra.extraShot],
            ),
            quantity: 2,
          ),
          const Money(780),
        );
      },
    );
  });
}
