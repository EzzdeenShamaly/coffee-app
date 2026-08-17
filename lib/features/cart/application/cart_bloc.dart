import 'package:bloc/bloc.dart';
import 'package:coffee_app/core/error/app_exception.dart';
import 'package:coffee_app/features/cart/application/cart_event.dart';
import 'package:coffee_app/features/cart/application/cart_state.dart';
import 'package:coffee_app/features/cart/domain/entities/cart_totals.dart';
import 'package:coffee_app/features/cart/domain/repositories/cart_repository.dart';
import 'package:coffee_app/features/cart/domain/usecases/calculate_cart_totals.dart';

/// Owns the cart.
///
/// App-wide (provided above `MaterialApp.router`) because three separate places
/// read it: the nav-bar badge, the cart screen, and checkout. Scoping it to the
/// cart route would reset the cart every time the customer browsed away.
class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc({
    required this._repository,
    this._calculateTotals = const CalculateCartTotals(),
  }) : super(const CartInitial()) {
    on<CartRequested>(_onRequested);
    on<CartItemAdded>(_onItemAdded);
    on<CartItemQuantityChanged>(_onQuantityChanged);
    on<CartItemRemoved>(_onItemRemoved);
    on<CartCleared>(_onCleared);
  }

  final CartRepository _repository;
  final CalculateCartTotals _calculateTotals;

  Future<void> _onRequested(
    CartRequested event,
    Emitter<CartState> emit,
  ) async {
    emit(const CartLoadInProgress());
    await _emitCart(emit);
  }

  Future<void> _onItemAdded(
    CartItemAdded event,
    Emitter<CartState> emit,
  ) async {
    await _mutate(
      emit,
      () => _repository.addItem(
        drink: event.drink,
        configuration: event.configuration,
        quantity: event.quantity,
      ),
    );
  }

  Future<void> _onQuantityChanged(
    CartItemQuantityChanged event,
    Emitter<CartState> emit,
  ) async {
    await _mutate(
      emit,
      () => _repository.updateQuantity(
        itemId: event.itemId,
        quantity: event.quantity,
      ),
    );
  }

  Future<void> _onItemRemoved(
    CartItemRemoved event,
    Emitter<CartState> emit,
  ) async {
    await _mutate(emit, () => _repository.removeItem(event.itemId));
  }

  Future<void> _onCleared(CartCleared event, Emitter<CartState> emit) async {
    await _mutate(emit, _repository.clear);
  }

  /// Runs a write then re-reads the cart.
  ///
  /// Deliberately does **not** emit an in-progress state: mutations are fast and
  /// local, and flashing a spinner over the whole list on every quantity tap is
  /// worse than a brief stale frame. A failed write keeps the current items
  /// visible alongside the message.
  Future<void> _mutate(
    Emitter<CartState> emit,
    Future<void> Function() write,
  ) async {
    try {
      await write();
    } on AppException catch (e) {
      if (isClosed) return;
      final current = state;
      emit(
        CartLoadFailure(
          e.message,
          items: current is CartLoadSuccess ? current.items : const [],
          totals: current is CartLoadSuccess
              ? current.totals
              : CartTotals.empty,
        ),
      );
      return;
    }
    await _emitCart(emit);
  }

  Future<void> _emitCart(Emitter<CartState> emit) async {
    try {
      final items = await _repository.fetchItems();
      if (isClosed) return;
      emit(CartLoadSuccess(items: items, totals: _calculateTotals(items)));
    } on AppException catch (e) {
      if (isClosed) return;
      emit(CartLoadFailure(e.message));
    }
  }
}
