import 'package:coffee_app/features/cart/domain/entities/cart_item.dart';
import 'package:coffee_app/features/cart/domain/entities/cart_totals.dart';
import 'package:equatable/equatable.dart';

sealed class CartState extends Equatable {
  const CartState();

  /// Drives the nav-bar badge from any state, so the badge widget doesn't need
  /// to know the variant it's looking at.
  int get itemCount => 0;

  @override
  List<Object?> get props => const [];
}

final class CartInitial extends CartState {
  const CartInitial();
}

final class CartLoadInProgress extends CartState {
  const CartLoadInProgress();
}

final class CartLoadSuccess extends CartState {
  const CartLoadSuccess({required this.items, required this.totals});

  final List<CartItem> items;
  final CartTotals totals;

  bool get isEmpty => items.isEmpty;

  /// An empty cart cannot be checked out — the checkout button reads this
  /// rather than re-deriving the rule.
  bool get canCheckout => items.isNotEmpty;

  @override
  int get itemCount => totals.itemCount;

  @override
  List<Object?> get props => [items, totals];
}

/// A cart operation failed.
///
/// Carries the last known [items] and [totals] so a failed quantity bump shows
/// a message over the cart the customer was reading, instead of blanking it.
/// Both are empty when the initial load itself failed — that case does take over
/// the screen, because there is nothing behind it to show.
final class CartLoadFailure extends CartState {
  const CartLoadFailure(
    this.message, {
    this.items = const [],
    this.totals = CartTotals.empty,
  });

  final String message;
  final List<CartItem> items;
  final CartTotals totals;

  /// True when there is still a cart to render behind the error message.
  bool get hasVisibleCart => items.isNotEmpty;

  @override
  int get itemCount => totals.itemCount;

  @override
  List<Object?> get props => [message, items, totals];
}
