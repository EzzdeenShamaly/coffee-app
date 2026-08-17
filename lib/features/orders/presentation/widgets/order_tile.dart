import 'package:coffee_app/app/theme/app_spacing.dart';
import 'package:coffee_app/features/orders/domain/entities/order.dart';
import 'package:coffee_app/features/orders/domain/entities/order_status.dart';
import 'package:flutter/material.dart';

/// One row in order history.
class OrderTile extends StatelessWidget {
  const OrderTile({required this.order, super.key});

  final Order order;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order ${order.pickupCode}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '${order.itemSummary} · ${_formatDate(order.placedAt)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  order.totals.total.formatted,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                _StatusChip(status: order.status),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Local, single-locale date formatting. Swap for `intl`'s `DateFormat` when
  /// the app localises (`/flutter-l10n-gen`).
  static String _formatDate(DateTime when) {
    final local = when.toLocal();
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '${local.day}/${local.month} at $hour:$minute';
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    // Ready-for-pickup is the one status worth shouting about, so it gets the
    // tertiary (green) container; everything else stays neutral.
    final (background, foreground) = switch (status) {
      OrderStatus.ready => (scheme.tertiaryContainer, scheme.onTertiaryContainer),
      OrderStatus.cancelled => (scheme.errorContainer, scheme.onErrorContainer),
      _ => (scheme.surfaceContainerHighest, scheme.onSurfaceVariant),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Text(
        status.label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: foreground,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
