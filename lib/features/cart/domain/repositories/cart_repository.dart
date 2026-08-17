import 'package:coffee_app/features/cart/domain/entities/cart_item.dart';
import 'package:coffee_app/features/menu/domain/entities/drink.dart';
import 'package:coffee_app/features/product/domain/entities/drink_configuration.dart';

/// The cart's storage seam.
///
/// Implementations own line identity and duplicate merging so every caller
/// gets the same behaviour — the bloc never has to decide whether an add is a
/// new row or a quantity bump.
abstract class CartRepository {
  /// Current lines, in the order they were added.
  Future<List<CartItem>> fetchItems();

  /// Adds [quantity] of [drink] as configured.
  ///
  /// Merges into an existing line when the same drink with the same
  /// configuration is already present. Throws [ValidationException] if the
  /// drink is unavailable.
  Future<void> addItem({
    required Drink drink,
    required DrinkConfiguration configuration,
    int quantity = 1,
  });

  /// Throws [NotFoundException] for an unknown [itemId], and
  /// [ValidationException] for a non-positive [quantity] — removing is
  /// [removeItem]'s job, not a quantity of zero.
  Future<void> updateQuantity({
    required String itemId,
    required int quantity,
  });

  /// Removing an id that isn't there is a no-op, not an error — a double-tap on
  /// delete should not surface a failure.
  Future<void> removeItem(String itemId);

  /// Empties the cart. Called after an order is placed successfully.
  Future<void> clear();
}
