import 'package:coffee_app/core/money/money.dart';
import 'package:coffee_app/features/menu/domain/entities/drink.dart';
import 'package:coffee_app/features/product/domain/entities/drink_configuration.dart';
import 'package:coffee_app/features/product/domain/usecases/calculate_drink_price.dart';
import 'package:equatable/equatable.dart';

sealed class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => const [];
}

final class ProductInitial extends ProductState {
  const ProductInitial();
}

final class ProductLoadInProgress extends ProductState {
  const ProductLoadInProgress();
}

/// The drink loaded and is being configured.
///
/// Prices are getters that delegate to [CalculateDrinkPrice] rather than stored
/// fields, so they can never drift out of sync with the configuration.
final class ProductLoadSuccess extends ProductState {
  const ProductLoadSuccess({
    required this.drink,
    this.configuration = const DrinkConfiguration(),
    this.quantity = 1,
  });

  final Drink drink;
  final DrinkConfiguration configuration;
  final int quantity;

  static const _calculatePrice = CalculateDrinkPrice();

  /// Price for a single unit as configured.
  Money get unitPrice =>
      _calculatePrice(drink: drink, configuration: configuration);

  /// Price for [quantity] units — what the add-to-cart button shows.
  Money get totalPrice => _calculatePrice(
    drink: drink,
    configuration: configuration,
    quantity: quantity,
  );

  /// A sold-out drink can be viewed but not ordered.
  bool get canAddToCart => drink.isAvailable;

  /// Pastries have no size or milk to choose.
  bool get showsCustomisation => drink.category.isCustomisable;

  ProductLoadSuccess copyWith({
    DrinkConfiguration? configuration,
    int? quantity,
  }) {
    return ProductLoadSuccess(
      drink: drink,
      configuration: configuration ?? this.configuration,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [drink, configuration, quantity];
}

final class ProductLoadFailure extends ProductState {
  const ProductLoadFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
