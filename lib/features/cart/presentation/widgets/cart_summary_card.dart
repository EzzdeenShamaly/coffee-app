import 'package:coffee_app/app/theme/app_spacing.dart';
import 'package:coffee_app/features/cart/domain/entities/cart_totals.dart';
import 'package:flutter/material.dart';

/// Subtotal / tax / total breakdown.
///
/// Renders the numbers `CalculateCartTotals` produced — it does no arithmetic
/// of its own, so the receipt and this card can never disagree.
class CartSummaryCard extends StatelessWidget {
  const CartSummaryCard({required this.totals, super.key});

  final CartTotals totals;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            _Row(label: 'Subtotal', value: totals.subtotal.formatted),
            const SizedBox(height: AppSpacing.sm),
            _Row(label: 'Tax', value: totals.tax.formatted),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Divider(),
            ),
            _Row(
              label: 'Total',
              value: totals.total.formatted,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value, this.style});

  final String label;
  final String value;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final effective = style ?? Theme.of(context).textTheme.bodyLarge;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: effective),
        Text(value, style: effective),
      ],
    );
  }
}
