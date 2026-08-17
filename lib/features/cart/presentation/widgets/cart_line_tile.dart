import 'package:coffee_app/app/theme/app_spacing.dart';
import 'package:coffee_app/features/cart/domain/entities/cart_item.dart';
import 'package:coffee_app/shared/widgets/quantity_stepper.dart';
import 'package:flutter/material.dart';

/// One cart row: drink, customisation summary, quantity stepper, line total.
class CartLineTile extends StatelessWidget {
  const CartLineTile({
    required this.item,
    required this.onQuantityChanged,
    required this.onRemove,
    super.key,
  });

  final CartItem item;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.drink.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        item.configuration.summary,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onRemove,
                  icon: const Icon(Icons.delete_outline_rounded),
                  // Icon-only destructive action: without this label a screen
                  // reader announces only "button".
                  tooltip: 'Remove ${item.drink.name}',
                  constraints: const BoxConstraints(
                    minWidth: AppSpacing.minTapTarget,
                    minHeight: AppSpacing.minTapTarget,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                QuantityStepper(
                  quantity: item.quantity,
                  itemLabel: item.drink.name,
                  onChanged: onQuantityChanged,
                ),
                Text(
                  item.lineTotal.formatted,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
