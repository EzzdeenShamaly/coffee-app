import 'package:coffee_app/core/money/money.dart';
import 'package:coffee_app/features/menu/domain/entities/drink.dart';
import 'package:coffee_app/features/product/domain/entities/drink_configuration.dart';
import 'package:coffee_app/features/product/domain/usecases/calculate_drink_price.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart_item.freezed.dart';
part 'cart_item.g.dart';

/// One line in the cart: a drink, how it was customised, and how many.
///
/// The line stores no price. [unitPrice] and [lineTotal] recompute from
/// [CalculateDrinkPrice], so a menu price change can never leave a stale
/// number in the cart.
@freezed
abstract class CartItem with _$CartItem {
  const factory CartItem({
    required String id,
    required Drink drink,
    required DrinkConfiguration configuration,
    @Default(1) int quantity,
  }) = _CartItem;

  const CartItem._();

  factory CartItem.fromJson(Map<String, dynamic> json) =>
      _$CartItemFromJson(json);

  static const _calculatePrice = CalculateDrinkPrice();

  Money get unitPrice =>
      _calculatePrice(drink: drink, configuration: configuration);

  Money get lineTotal => _calculatePrice(
    drink: drink,
    configuration: configuration,
    quantity: quantity,
  );

  /// True when [other] is the same drink customised the same way — the test
  /// `CartRepository.addItem` uses to merge into an existing line instead of
  /// appending a duplicate row.
  bool isSameLineAs({
    required Drink otherDrink,
    required DrinkConfiguration otherConfiguration,
  }) {
    return drink.id == otherDrink.id && configuration == otherConfiguration;
  }
}
