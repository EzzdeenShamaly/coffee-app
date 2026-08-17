import 'package:coffee_app/core/error/app_exception.dart';
import 'package:coffee_app/features/orders/data/in_memory_order_store.dart';
import 'package:coffee_app/features/orders/domain/entities/order.dart';
import 'package:coffee_app/features/orders/domain/repositories/order_repository.dart';

/// Reads orders from the shared [InMemoryOrderStore].
class FakeOrderRepository implements OrderRepository {
  const FakeOrderRepository({required this._store});

  final InMemoryOrderStore _store;

  static const _latency = Duration(milliseconds: 450);

  @override
  Future<List<Order>> fetchOrders() async {
    await Future<void>.delayed(_latency);
    return _store.orders;
  }

  @override
  Future<Order> fetchOrder(String id) async {
    await Future<void>.delayed(_latency);
    final order = _store.findById(id);
    if (order == null) {
      throw const NotFoundException('That order could not be found.');
    }
    return order;
  }
}
