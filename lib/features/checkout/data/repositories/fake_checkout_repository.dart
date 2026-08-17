import 'package:coffee_app/core/error/app_exception.dart';
import 'package:coffee_app/features/cart/domain/entities/cart_item.dart';
import 'package:coffee_app/features/cart/domain/entities/cart_totals.dart';
import 'package:coffee_app/features/checkout/domain/entities/payment_method.dart';
import 'package:coffee_app/features/checkout/domain/repositories/checkout_repository.dart';
import 'package:coffee_app/features/orders/data/in_memory_order_store.dart';
import 'package:coffee_app/features/orders/domain/entities/order.dart';
import 'package:coffee_app/features/orders/domain/entities/order_status.dart';

/// Writes orders into the shared [InMemoryOrderStore].
///
/// Holds the same store instance as `FakeOrderRepository`, so a placed order
/// appears in history without a backend.
class FakeCheckoutRepository implements CheckoutRepository {
  const FakeCheckoutRepository({required this._store});

  final InMemoryOrderStore _store;

  static const _latency = Duration(milliseconds: 900);

  @override
  Future<Order> placeOrder({
    required List<CartItem> items,
    required CartTotals totals,
    required PaymentMethod paymentMethod,
    required PickupOption pickupOption,
    String? note,
  }) async {
    if (items.isEmpty) {
      throw const ValidationException('Your cart is empty.');
    }

    await Future<void>.delayed(_latency);

    final id = _store.add(
      (id, pickupCode) => Order(
        id: id,
        items: items,
        totals: totals,
        status: OrderStatus.placed,
        placedAt: DateTime.now(),
        pickupCode: pickupCode,
      ),
    );

    final placed = _store.findById(id);
    if (placed == null) {
      throw const UnexpectedException('The order could not be saved.');
    }
    return placed;
  }
}
