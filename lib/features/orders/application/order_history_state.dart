import 'package:coffee_app/features/orders/domain/entities/order.dart';
import 'package:equatable/equatable.dart';

sealed class OrderHistoryState extends Equatable {
  const OrderHistoryState();

  @override
  List<Object?> get props => const [];
}

final class OrderHistoryInitial extends OrderHistoryState {
  const OrderHistoryInitial();
}

final class OrderHistoryLoadInProgress extends OrderHistoryState {
  const OrderHistoryLoadInProgress();
}

final class OrderHistoryLoadSuccess extends OrderHistoryState {
  const OrderHistoryLoadSuccess(this.orders);

  final List<Order> orders;

  bool get isEmpty => orders.isEmpty;

  /// Orders still being prepared, shown pinned above the rest.
  List<Order> get activeOrders =>
      orders.where((order) => order.status.isActive).toList();

  @override
  List<Object?> get props => [orders];
}

final class OrderHistoryLoadFailure extends OrderHistoryState {
  const OrderHistoryLoadFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
