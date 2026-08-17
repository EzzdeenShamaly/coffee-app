import 'package:coffee_app/core/error/app_exception.dart';
import 'package:coffee_app/features/cart/domain/entities/cart_item.dart';
import 'package:coffee_app/features/cart/domain/repositories/cart_repository.dart';
import 'package:coffee_app/features/menu/domain/entities/drink.dart';
import 'package:coffee_app/features/product/domain/entities/drink_configuration.dart';

/// Session-scoped cart held in memory.
///
/// The cart does not survive an app restart, which is a deliberate choice for
/// now rather than an oversight — persisting it means deciding what happens
/// when a saved line's drink leaves the menu or changes price. Swapping in a
/// persisted implementation is a one-line binding change in `CoffeeApp`.
class InMemoryCartRepository implements CartRepository {
  final List<CartItem> _items = [];

  /// Monotonic counter for line ids. Not reused after removal, so a stale
  /// widget holding an old id can never address a different line.
  int _nextId = 1;

  @override
  Future<List<CartItem>> fetchItems() async => List.unmodifiable(_items);

  @override
  Future<void> addItem({
    required Drink drink,
    required DrinkConfiguration configuration,
    int quantity = 1,
  }) async {
    if (!drink.isAvailable) {
      throw ValidationException('${drink.name} is sold out.');
    }
    if (quantity < 1) {
      throw const ValidationException('Choose at least one.');
    }

    final index = _items.indexWhere(
      (item) => item.isSameLineAs(
        otherDrink: drink,
        otherConfiguration: configuration,
      ),
    );

    if (index == -1) {
      _items.add(
        CartItem(
          id: 'line-${_nextId++}',
          drink: drink,
          configuration: configuration,
          quantity: quantity,
        ),
      );
      return;
    }

    // Same drink, same customisation — bump the existing line rather than
    // showing the customer two identical rows.
    final existing = _items[index];
    _items[index] = existing.copyWith(quantity: existing.quantity + quantity);
  }

  @override
  Future<void> updateQuantity({
    required String itemId,
    required int quantity,
  }) async {
    if (quantity < 1) {
      throw const ValidationException('Remove the item instead.');
    }

    final index = _items.indexWhere((item) => item.id == itemId);
    if (index == -1) {
      throw const NotFoundException('That item is no longer in your cart.');
    }

    _items[index] = _items[index].copyWith(quantity: quantity);
  }

  @override
  Future<void> removeItem(String itemId) async {
    _items.removeWhere((item) => item.id == itemId);
  }

  @override
  Future<void> clear() async => _items.clear();
}
