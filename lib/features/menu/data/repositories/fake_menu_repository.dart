import 'package:coffee_app/core/error/app_exception.dart';
import 'package:coffee_app/features/menu/domain/entities/drink.dart';
import 'package:coffee_app/features/menu/domain/entities/drink_category.dart';
import 'package:coffee_app/features/menu/domain/repositories/menu_repository.dart';

/// Hardcoded menu for development.
///
/// Replace with an API-backed implementation by changing the binding in
/// `CoffeeApp`; the interface, blocs, and screens do not change
/// (`/flutter-repository-gen`).
class FakeMenuRepository implements MenuRepository {
  const FakeMenuRepository();

  static const _latency = Duration(milliseconds: 500);

  /// One deliberately unavailable item (`drink-7`) so the sold-out path is
  /// reachable without editing code.
  static const _menu = <Drink>[
    Drink(
      id: 'drink-1',
      name: 'Espresso',
      description: 'Two ristretto shots, thick crema.',
      basePriceCents: 280,
      category: DrinkCategory.espresso,
    ),
    Drink(
      id: 'drink-2',
      name: 'Flat White',
      description: 'Double shot with velvety steamed milk.',
      basePriceCents: 420,
      category: DrinkCategory.espresso,
    ),
    Drink(
      id: 'drink-3',
      name: 'Caramel Latte',
      description: 'Espresso, steamed milk, house caramel.',
      basePriceCents: 480,
      category: DrinkCategory.espresso,
    ),
    Drink(
      id: 'drink-4',
      name: 'Filter Brew',
      description: 'Single-origin, rotating weekly.',
      basePriceCents: 340,
      category: DrinkCategory.brewed,
    ),
    Drink(
      id: 'drink-5',
      name: 'Nitro Cold Brew',
      description: 'Sixteen-hour steep, poured on nitrogen.',
      basePriceCents: 520,
      category: DrinkCategory.coldBrew,
    ),
    Drink(
      id: 'drink-6',
      name: 'Jasmine Green Tea',
      description: 'Loose leaf, three-minute steep.',
      basePriceCents: 320,
      category: DrinkCategory.tea,
    ),
    Drink(
      id: 'drink-7',
      name: 'Butter Croissant',
      description: 'Baked this morning. Usually gone by ten.',
      basePriceCents: 390,
      category: DrinkCategory.pastry,
      isAvailable: false,
    ),
    Drink(
      id: 'drink-8',
      name: 'Almond Danish',
      description: 'Flaked almonds, frangipane centre.',
      basePriceCents: 410,
      category: DrinkCategory.pastry,
    ),
  ];

  @override
  Future<List<Drink>> fetchMenu() async {
    await Future<void>.delayed(_latency);
    return _menu;
  }

  @override
  Future<Drink> fetchDrink(String id) async {
    await Future<void>.delayed(_latency);
    final match = _menu.where((drink) => drink.id == id);
    if (match.isEmpty) {
      throw const NotFoundException('That drink is no longer on the menu.');
    }
    return match.first;
  }
}
