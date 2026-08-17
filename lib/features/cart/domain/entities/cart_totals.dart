import 'package:coffee_app/core/money/money.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart_totals.freezed.dart';
part 'cart_totals.g.dart';

/// The money summary for a cart or a placed order.
///
/// Stored in minor units so it JSON round-trips exactly; [Money] getters are
/// the arithmetic-safe view. Computed once by `CalculateCartTotals` and then
/// carried unchanged onto the order, so a receipt always shows the numbers the
/// customer agreed to — not a recomputation against today's prices.
@freezed
abstract class CartTotals with _$CartTotals {
  const factory CartTotals({
    @JsonKey(name: 'subtotal_cents') required int subtotalCents,
    @JsonKey(name: 'tax_cents') required int taxCents,
    @JsonKey(name: 'total_cents') required int totalCents,
    @JsonKey(name: 'item_count') required int itemCount,
  }) = _CartTotals;

  const CartTotals._();

  factory CartTotals.fromJson(Map<String, dynamic> json) =>
      _$CartTotalsFromJson(json);

  static const empty = CartTotals(
    subtotalCents: 0,
    taxCents: 0,
    totalCents: 0,
    itemCount: 0,
  );

  Money get subtotal => Money(subtotalCents);

  Money get tax => Money(taxCents);

  Money get total => Money(totalCents);

  bool get isEmpty => itemCount == 0;
}
