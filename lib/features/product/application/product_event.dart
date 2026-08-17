import 'package:coffee_app/features/product/domain/entities/drink_options.dart';
import 'package:equatable/equatable.dart';

sealed class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => const [];
}

/// Load the drink being configured. Carries the id because the product screen
/// is reachable by deep link, where the menu may never have loaded.
final class ProductRequested extends ProductEvent {
  const ProductRequested(this.drinkId);

  final String drinkId;

  @override
  List<Object?> get props => [drinkId];
}

final class ProductSizeSelected extends ProductEvent {
  const ProductSizeSelected(this.size);

  final DrinkSize size;

  @override
  List<Object?> get props => [size];
}

final class ProductMilkSelected extends ProductEvent {
  const ProductMilkSelected(this.milk);

  final MilkOption milk;

  @override
  List<Object?> get props => [milk];
}

/// Adds or removes one extra — the UI sends the extra that was tapped and the
/// bloc decides which way to flip it.
final class ProductExtraToggled extends ProductEvent {
  const ProductExtraToggled(this.extra);

  final DrinkExtra extra;

  @override
  List<Object?> get props => [extra];
}

final class ProductQuantityChanged extends ProductEvent {
  const ProductQuantityChanged(this.quantity);

  final int quantity;

  @override
  List<Object?> get props => [quantity];
}
