import 'package:coffee_app/app/router/app_routes.dart';
import 'package:coffee_app/app/theme/app_spacing.dart';
import 'package:coffee_app/features/orders/domain/entities/order.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Post-checkout receipt.
///
/// Takes the [order] directly rather than fetching it: the route is reached
/// straight from a successful placement, and re-fetching would mean showing a
/// spinner for data the app already has.
class OrderConfirmationScreen extends StatelessWidget {
  const OrderConfirmationScreen({required this.order, super.key});

  final Order order;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              const Spacer(),
              Icon(
                Icons.check_circle_rounded,
                size: 88,
                color: theme.colorScheme.tertiary,
                semanticLabel: 'Order confirmed',
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                "You're all set",
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Show this code at the counter',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              _PickupCode(code: order.pickupCode),
              const SizedBox(height: AppSpacing.lg),
              Text(
                '${order.itemSummary} · ${order.totals.total.formatted}',
                style: theme.textTheme.titleMedium,
              ),
              const Spacer(),
              FilledButton(
                onPressed: () => context.goNamed(AppRoutes.orderHistory),
                child: const Text('Track my order'),
              ),
              const SizedBox(height: AppSpacing.sm),
              OutlinedButton(
                onPressed: () => context.goNamed(AppRoutes.menu),
                child: const Text('Back to menu'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PickupCode extends StatelessWidget {
  const _PickupCode({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: scheme.secondaryContainer,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Text(
        code,
        style: Theme.of(context).textTheme.displaySmall?.copyWith(
          color: scheme.onSecondaryContainer,
          fontWeight: FontWeight.w700,
          letterSpacing: 4,
        ),
      ),
    );
  }
}
