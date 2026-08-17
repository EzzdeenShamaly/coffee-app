import 'package:coffee_app/features/menu/domain/entities/drink.dart';

/// Read-only access to the menu.
///
/// Filtering by category is deliberately **not** a repository method: the full
/// menu is small enough to hold in a success state and filter in the bloc, so
/// tapping a category chip costs no round trip.
abstract class MenuRepository {
  /// The whole menu. Throws [NetworkException] when unreachable.
  Future<List<Drink>> fetchMenu();

  /// A single drink, for deep links into the product screen where the menu was
  /// never loaded. Throws [NotFoundException] for an unknown id.
  Future<Drink> fetchDrink(String id);
}
