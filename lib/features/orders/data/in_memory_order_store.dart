import 'package:coffee_app/features/orders/domain/entities/order.dart';

/// Shared in-memory order table.
///
/// Both `FakeCheckoutRepository` (which writes) and `FakeOrderRepository`
/// (which reads) hold the *same* instance, so an order placed at checkout shows
/// up in history immediately. Without a shared store the two fakes would
/// disagree and the flow would look broken for reasons that have nothing to do
/// with the app's logic.
///
/// Registered once in `CoffeeApp`. A real backend makes this class unnecessary.
class InMemoryOrderStore {
  final List<Order> _orders = [];

  int _nextId = 1;

  /// Most recent first, matching `OrderRepository.fetchOrders`' contract.
  List<Order> get orders => List.unmodifiable(_orders.reversed);

  Order? findById(String id) {
    final match = _orders.where((order) => order.id == id);
    return match.isEmpty ? null : match.first;
  }

  /// Returns the id assigned to the newly stored order.
  String add(Order Function(String id, String pickupCode) build) {
    final id = 'order-${_nextId++}';
    // Two letters plus two digits is enough to be readable at a counter and
    // unambiguous across the handful of orders open at once.
    final pickupCode = 'C${id.hashCode.abs() % 90 + 10}';
    _orders.add(build(id, pickupCode));
    return id;
  }
}
