import 'package:coffee_app/app/theme/app_spacing.dart';
import 'package:coffee_app/features/cart/application/cart_bloc.dart';
import 'package:coffee_app/features/cart/application/cart_event.dart';
import 'package:coffee_app/features/product/application/product_bloc.dart';
import 'package:coffee_app/features/product/application/product_event.dart';
import 'package:coffee_app/features/product/application/product_state.dart';
import 'package:coffee_app/features/product/domain/entities/drink_options.dart';
import 'package:coffee_app/shared/widgets/app_error_view.dart';
import 'package:coffee_app/shared/widgets/app_loading_indicator.dart';
import 'package:coffee_app/shared/widgets/quantity_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Drink customisation and add-to-cart.
class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({required this.drinkId, super.key});

  final String drinkId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          return switch (state) {
            ProductInitial() ||
            ProductLoadInProgress() => const AppLoadingIndicator(),
            ProductLoadFailure(:final message) => AppErrorView(
              message: message,
              onRetry: () =>
                  context.read<ProductBloc>().add(ProductRequested(drinkId)),
            ),
            ProductLoadSuccess() => _ProductForm(state: state),
          };
        },
      ),
    );
  }
}

class _ProductForm extends StatelessWidget {
  const _ProductForm({required this.state});

  final ProductLoadSuccess state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final drink = state.drink;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              Text(drink.name, style: theme.textTheme.headlineSmall),
              const SizedBox(height: AppSpacing.sm),
              Text(
                drink.description,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              if (state.showsCustomisation) ...[
                _SectionLabel('Size'),
                _OptionWrap(
                  children: [
                    for (final size in DrinkSize.values)
                      _OptionChip(
                        label: size.label,
                        priceDeltaCents: size.priceDeltaCents,
                        isSelected: state.configuration.size == size,
                        onTap: () => context.read<ProductBloc>().add(
                          ProductSizeSelected(size),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),

                _SectionLabel('Milk'),
                _OptionWrap(
                  children: [
                    for (final milk in MilkOption.values)
                      _OptionChip(
                        label: milk.label,
                        priceDeltaCents: milk.priceDeltaCents,
                        isSelected: state.configuration.milk == milk,
                        onTap: () => context.read<ProductBloc>().add(
                          ProductMilkSelected(milk),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),

                _SectionLabel('Extras'),
                _OptionWrap(
                  children: [
                    for (final extra in DrinkExtra.values)
                      _OptionChip(
                        label: extra.label,
                        priceDeltaCents: extra.priceDeltaCents,
                        isSelected: state.configuration.extras.contains(extra),
                        onTap: () => context.read<ProductBloc>().add(
                          ProductExtraToggled(extra),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
              ],

              _SectionLabel('Quantity'),
              const SizedBox(height: AppSpacing.sm),
              QuantityStepper(
                quantity: state.quantity,
                itemLabel: drink.name,
                onChanged: (quantity) => context.read<ProductBloc>().add(
                  ProductQuantityChanged(quantity),
                ),
              ),
            ],
          ),
        ),
        _AddToCartBar(state: state),
      ],
    );
  }
}

/// The sticky bottom bar: total price plus the add-to-cart action.
class _AddToCartBar extends StatelessWidget {
  const _AddToCartBar({required this.state});

  final ProductLoadSuccess state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Total', style: theme.textTheme.labelMedium),
                Text(
                  state.totalPrice.formatted,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: FilledButton(
                onPressed: state.canAddToCart
                    ? () => _addToCart(context)
                    : null,
                child: Text(state.canAddToCart ? 'Add to cart' : 'Sold out'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Dispatches to `CartBloc` — the cart write is the cart's job, not
  /// `ProductBloc`'s — then leaves the screen. Navigation lives in the callback
  /// rather than a `builder`, which would fire on every rebuild.
  void _addToCart(BuildContext context) {
    context.read<CartBloc>().add(
      CartItemAdded(
        drink: state.drink,
        configuration: state.configuration,
        quantity: state.quantity,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${state.drink.name} added to your cart'),
        duration: const Duration(seconds: 2),
      ),
    );

    context.pop();
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _OptionWrap extends StatelessWidget {
  const _OptionWrap({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: children,
      ),
    );
  }
}

/// A selectable option showing its surcharge, e.g. "Oat milk +$0.70".
class _OptionChip extends StatelessWidget {
  const _OptionChip({
    required this.label,
    required this.priceDeltaCents,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final int priceDeltaCents;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final suffix = priceDeltaCents == 0
        ? ''
        : ' +\$${(priceDeltaCents / 100).toStringAsFixed(2)}';

    return FilterChip(
      label: Text('$label$suffix'),
      selected: isSelected,
      onSelected: (_) => onTap(),
    );
  }
}
