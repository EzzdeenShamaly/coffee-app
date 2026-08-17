import 'package:coffee_app/core/money/money.dart';
import 'package:coffee_app/features/cart/domain/entities/cart_item.dart';
import 'package:coffee_app/features/cart/domain/entities/cart_totals.dart';

/// Pure rule turning cart lines into a money summary.
///
/// Tax is applied to the whole subtotal and rounded **once**, which is what
/// guarantees `subtotal + tax == total`. Rounding per line instead can leave a
/// receipt that does not add up — see `memory-bank/domainRules.md`.
class CalculateCartTotals {
  const CalculateCartTotals({this.taxRate = defaultTaxRate});

  /// Placeholder rate. A real deployment reads this per store/jurisdiction
  /// rather than hardcoding it.
  static const defaultTaxRate = 0.0825;

  final double taxRate;

  CartTotals call(List<CartItem> items) {
    if (items.isEmpty) return CartTotals.empty;

    final subtotal = Money.sum(items.map((item) => item.lineTotal));
    final tax = subtotal.percentage(taxRate);

    return CartTotals(
      subtotalCents: subtotal.cents,
      taxCents: tax.cents,
      totalCents: (subtotal + tax).cents,
      itemCount: items.fold(0, (count, item) => count + item.quantity),
    );
  }
}
