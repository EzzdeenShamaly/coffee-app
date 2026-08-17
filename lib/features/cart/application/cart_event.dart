import 'package:coffee_app/features/menu/domain/entities/drink.dart';
import 'package:coffee_app/features/product/domain/entities/drink_configuration.dart';
import 'package:equatable/equatable.dart';

sealed class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => const [];
}

/// Initial load, and the retry action on the failure view.
final class CartRequested extends CartEvent {
  const CartRequested();
}

/// Dispatched by the product screen's add-to-cart button.
final class CartItemAdded extends CartEvent {
  const CartItemAdded({
    required this.drink,
    required this.configuration,
    this.quantity = 1,
  });

  final Drink drink;
  final DrinkConfiguration configuration;
  final int quantity;

  @override
  List<Object?> get props => [drink, configuration, quantity];
}

final class CartItemQuantityChanged extends CartEvent {
  const CartItemQuantityChanged({
    required this.itemId,
    required this.quantity,
  });

  final String itemId;
  final int quantity;

  @override
  List<Object?> get props => [itemId, quantity];
}

final class CartItemRemoved extends CartEvent {
  const CartItemRemoved(this.itemId);

  final String itemId;

  @override
  List<Object?> get props => [itemId];
}

/// Empties the cart. Dispatched after checkout succeeds.
final class CartCleared extends CartEvent {
  const CartCleared();
}
