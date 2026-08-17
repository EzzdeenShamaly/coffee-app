import 'package:coffee_app/app/router/app_routes.dart';
import 'package:coffee_app/app/theme/app_spacing.dart';
import 'package:coffee_app/features/cart/application/cart_bloc.dart';
import 'package:coffee_app/features/cart/application/cart_event.dart';
import 'package:coffee_app/features/cart/application/cart_state.dart';
import 'package:coffee_app/features/cart/domain/entities/cart_item.dart';
import 'package:coffee_app/features/cart/domain/entities/cart_totals.dart';
import 'package:coffee_app/features/cart/presentation/widgets/cart_line_tile.dart';
import 'package:coffee_app/features/cart/presentation/widgets/cart_summary_card.dart';
import 'package:coffee_app/shared/widgets/app_empty_view.dart';
import 'package:coffee_app/shared/widgets/app_error_view.dart';
import 'package:coffee_app/shared/widgets/app_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// The cart, with checkout as its terminal action.
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your cart')),
      // A failed mutation surfaces as a snackbar over the still-visible list
      // rather than replacing it — side effects belong in a listener, never in
      // a builder (`02-flutter-state-guard.mdc`).
      body: BlocConsumer<CartBloc, CartState>(
        listenWhen: (previous, current) => current is CartLoadFailure,
        listener: (context, state) {
          if (state is CartLoadFailure && state.hasVisibleCart) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return switch (state) {
            CartInitial() || CartLoadInProgress() => const AppLoadingIndicator(),
            // A failure with nothing behind it takes over the screen; a failure
            // over a populated cart keeps the cart (the listener above shows the
            // message).
            CartLoadFailure(:final message) when !state.hasVisibleCart =>
              AppErrorView(
                message: message,
                onRetry: () =>
                    context.read<CartBloc>().add(const CartRequested()),
              ),
            CartLoadFailure(:final items, :final totals) => _CartContents(
              items: items,
              totals: totals,
            ),
            CartLoadSuccess() when state.isEmpty => AppEmptyView(
              message: 'Your cart is empty.',
              actionLabel: 'Browse the menu',
              onAction: () => context.goNamed(AppRoutes.menu),
            ),
            CartLoadSuccess(:final items, :final totals) => _CartContents(
              items: items,
              totals: totals,
              canCheckout: state.canCheckout,
            ),
          };
        },
      ),
    );
  }
}

class _CartContents extends StatelessWidget {
  const _CartContents({
    required this.items,
    required this.totals,
    this.canCheckout = false,
  });

  final List<CartItem> items;
  final CartTotals totals;

  /// False while a failure is showing — the customer should resolve the error
  /// before paying, so checkout stays disabled until the next successful read.
  final bool canCheckout;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) {
              final item = items[index];
              return CartLineTile(
                item: item,
                onQuantityChanged: (quantity) => context.read<CartBloc>().add(
                  CartItemQuantityChanged(
                    itemId: item.id,
                    quantity: quantity,
                  ),
                ),
                onRemove: () =>
                    context.read<CartBloc>().add(CartItemRemoved(item.id)),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: CartSummaryCard(totals: totals),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: FilledButton(
              onPressed: canCheckout
                  ? () => context.pushNamed(AppRoutes.checkout)
                  : null,
              child: Text('Checkout · ${totals.total.formatted}'),
            ),
          ),
        ),
      ],
    );
  }
}
