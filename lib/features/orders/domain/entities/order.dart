import 'package:coffee_app/features/cart/domain/entities/cart_item.dart';
import 'package:coffee_app/features/cart/domain/entities/cart_totals.dart';
import 'package:coffee_app/features/orders/domain/entities/order_status.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'order.freezed.dart';
part 'order.g.dart';

/// A placed order.
///
/// Carries a snapshot of the [items] and [totals] as they were at checkout.
/// This is why an order is not a reference to the live cart: a receipt must
/// keep showing what the customer paid even after menu prices move.
@freezed
abstract class Order with _$Order {
  const factory Order({
    required String id,
    required List<CartItem> items,
    required CartTotals totals,
    required OrderStatus status,
    @JsonKey(name: 'placed_at') required DateTime placedAt,
    // Short code the customer shows at the counter.
    @JsonKey(name: 'pickup_code') required String pickupCode,
  }) = _Order;

  const Order._();

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  /// "2 drinks" / "1 drink" — the history row subtitle.
  String get itemSummary =>
      totals.itemCount == 1 ? '1 drink' : '${totals.itemCount} drinks';
}
