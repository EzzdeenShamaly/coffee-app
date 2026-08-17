import 'package:coffee_app/app/theme/app_spacing.dart';
import 'package:coffee_app/features/menu/domain/entities/drink.dart';
import 'package:flutter/material.dart';

/// A tappable menu row.
///
/// Presentation only — it reports the tap and renders what it's given. No
/// pricing logic here: [Drink.basePrice] already carries it
/// (`01-flutter-architecture-guard.mdc`).
class DrinkCard extends StatelessWidget {
  const DrinkCard({required this.drink, required this.onTap, super.key});

  final Drink drink;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final soldOut = !drink.isAvailable;

    return Card(
      child: InkWell(
        // A sold-out item is still tappable so the customer can read it; the
        // product screen disables adding instead of dead-ending the tap here.
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DrinkAvatar(drink: drink, isDimmed: soldOut),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            drink.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: soldOut
                                  ? theme.colorScheme.onSurfaceVariant
                                  : null,
                            ),
                          ),
                        ),
                        if (soldOut)
                          Padding(
                            padding: const EdgeInsets.only(left: AppSpacing.sm),
                            child: const _SoldOutBadge(),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      drink.description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      drink.basePrice.formatted,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DrinkAvatar extends StatelessWidget {
  const _DrinkAvatar({required this.drink, required this.isDimmed});

  final Drink drink;
  final bool isDimmed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: isDimmed
            ? scheme.surfaceContainerHighest
            : scheme.secondaryContainer,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      alignment: Alignment.center,
      // Decorative only — the drink name is already read out next to it, so
      // labelling this icon would make a screen reader repeat itself.
      child: Icon(
        drink.category.isCustomisable
            ? Icons.local_cafe_rounded
            : Icons.bakery_dining_rounded,
        color: isDimmed ? scheme.onSurfaceVariant : scheme.onSecondaryContainer,
      ),
    );
  }
}

class _SoldOutBadge extends StatelessWidget {
  const _SoldOutBadge();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs / 2,
      ),
      decoration: BoxDecoration(
        color: scheme.errorContainer,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Text(
        'Sold out',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: scheme.onErrorContainer,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
