import 'package:coffee_app/features/menu/domain/entities/drink.dart';
import 'package:coffee_app/features/menu/domain/entities/drink_category.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Drink', () {
    const latte = Drink(
      id: 'drink-3',
      name: 'Caramel Latte',
      description: 'Espresso, steamed milk, house caramel.',
      basePriceCents: 480,
      category: DrinkCategory.espresso,
      imageUrl: 'https://example.test/latte.png',
    );

    test('round-trips through JSON unchanged', () {
      expect(Drink.fromJson(latte.toJson()), latte);
    });

    test('maps snake_case wire fields onto Dart names', () {
      final json = latte.toJson();

      // The @JsonKey names are the API contract — renaming a Dart field must not
      // silently change what goes over the wire.
      expect(json['base_price_cents'], 480);
      expect(json['image_url'], 'https://example.test/latte.png');
      expect(json['is_available'], isTrue);
      expect(json['category'], 'espresso');
    });

    test('defaults isAvailable to true when absent from JSON', () {
      final drink = Drink.fromJson(const {
        'id': 'drink-1',
        'name': 'Espresso',
        'description': 'Two shots.',
        'base_price_cents': 280,
        'category': 'espresso',
      });

      expect(drink.isAvailable, isTrue);
      expect(drink.imageUrl, isNull);
    });

    test('deserializes the multi-word category wire value', () {
      final drink = Drink.fromJson(const {
        'id': 'drink-5',
        'name': 'Nitro Cold Brew',
        'description': 'On nitrogen.',
        'base_price_cents': 520,
        'category': 'cold_brew',
      });

      expect(drink.category, DrinkCategory.coldBrew);
    });

    test('exposes basePrice as Money derived from cents', () {
      expect(latte.basePrice.cents, 480);
      expect(latte.basePrice.formatted, r'$4.80');
    });

    test('treats a pastry as non-customisable and a drink as customisable', () {
      expect(DrinkCategory.pastry.isCustomisable, isFalse);
      expect(DrinkCategory.espresso.isCustomisable, isTrue);
    });
  });
}
