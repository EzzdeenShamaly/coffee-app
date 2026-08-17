import 'package:bloc/bloc.dart';
import 'package:coffee_app/core/error/app_exception.dart';
import 'package:coffee_app/features/orders/application/order_history_event.dart';
import 'package:coffee_app/features/orders/application/order_history_state.dart';
import 'package:coffee_app/features/orders/domain/repositories/order_repository.dart';

/// Owns the order-history list.
class OrderHistoryBloc extends Bloc<OrderHistoryEvent, OrderHistoryState> {
  OrderHistoryBloc({required this._repository})
      : super(const OrderHistoryInitial()) {
    on<OrderHistoryRequested>(_onRequested);
  }

  final OrderRepository _repository;

  Future<void> _onRequested(
    OrderHistoryRequested event,
    Emitter<OrderHistoryState> emit,
  ) async {
    // Only show the full-screen spinner on a cold load; a pull-to-refresh keeps
    // the existing list on screen behind the refresh indicator.
    if (state is! OrderHistoryLoadSuccess) {
      emit(const OrderHistoryLoadInProgress());
    }

    try {
      final orders = await _repository.fetchOrders();
      if (isClosed) return;
      emit(OrderHistoryLoadSuccess(orders));
    } on AppException catch (e) {
      if (isClosed) return;
      emit(OrderHistoryLoadFailure(e.message));
    }
  }
}
