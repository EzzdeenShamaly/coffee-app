import 'package:coffee_app/features/cart/domain/entities/cart_item.dart';
import 'package:coffee_app/features/cart/domain/entities/cart_totals.dart';
import 'package:coffee_app/features/checkout/domain/entities/payment_method.dart';
import 'package:coffee_app/features/orders/domain/entities/order.dart';

/// The order-placing seam.
///
/// Takes the cart snapshot rather than reading the cart itself, so placing an
/// order is a pure function of what the customer confirmed on the checkout
/// screen — not of whatever the cart happens to hold by the time the request
/// lands.
abstract class CheckoutRepository {
  /// Places the order and returns it as stored.
  ///
  /// Throws [ValidationException] for an empty cart, [NetworkException] when
  /// unreachable, and [UnauthorizedException] if the session expired mid-flow.
  Future<Order> placeOrder({
    required List<CartItem> items,
    required CartTotals totals,
    required PaymentMethod paymentMethod,
    required PickupOption pickupOption,
    String? note,
  });
}
