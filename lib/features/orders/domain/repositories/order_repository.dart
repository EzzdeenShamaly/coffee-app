import 'package:coffee_app/features/orders/domain/entities/order.dart';

/// Read access to placed orders.
///
/// Writing happens through `CheckoutRepository.placeOrder` — keeping the write
/// on the checkout seam means the orders feature cannot accidentally create an
/// order that skipped payment.
abstract class OrderRepository {
  /// Most recent first. Throws [NetworkException] when unreachable.
  Future<List<Order>> fetchOrders();

  /// Throws [NotFoundException] for an unknown id.
  Future<Order> fetchOrder(String id);
}
