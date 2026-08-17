import 'package:coffee_app/app/router/app_routes.dart';
import 'package:coffee_app/app/theme/app_spacing.dart';
import 'package:coffee_app/features/cart/application/cart_bloc.dart';
import 'package:coffee_app/features/cart/application/cart_event.dart';
import 'package:coffee_app/features/cart/presentation/widgets/cart_summary_card.dart';
import 'package:coffee_app/features/checkout/application/checkout_bloc.dart';
import 'package:coffee_app/features/checkout/application/checkout_event.dart';
import 'package:coffee_app/features/checkout/application/checkout_state.dart';
import 'package:coffee_app/features/checkout/domain/entities/payment_method.dart';
import 'package:coffee_app/shared/widgets/app_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Payment method, pickup time, and order placement.
class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: BlocConsumer<CheckoutBloc, CheckoutState>(
        listenWhen: (previous, current) => current is CheckoutSuccess,
        listener: (context, state) {
          if (state is! CheckoutSuccess) return;

          // The order is placed, so the cart it came from is spent. Clearing
          // here — in a listener, once — rather than in the bloc keeps the
          // cart's writes owned by CartBloc.
          context.read<CartBloc>().add(const CartCleared());

          context.goNamed(
            AppRoutes.orderConfirmation,
            pathParameters: {
              AppRoutes.orderConfirmationParamId: state.order.id,
            },
            // The receipt renders from this rather than re-fetching what we
            // already have; the route redirects away if it is ever missing.
            extra: state.order,
          );
        },
        builder: (context, state) {
          return switch (state) {
            CheckoutInitial() => const AppLoadingIndicator(),
            // Terminal state: the listener above is already navigating away.
            CheckoutSuccess() => const AppLoadingIndicator(),
            CheckoutFormReady() => _CheckoutForm(state: state),
          };
        },
      ),
    );
  }
}

class _CheckoutForm extends StatelessWidget {
  const _CheckoutForm({required this.state});

  final CheckoutFormReady state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              Text('Pickup time', style: theme.textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              // RadioGroup owns the selection for the subtree; the tiles below
              // carry only their value. (Per-tile groupValue/onChanged were
              // deprecated in favour of this.)
              RadioGroup<PickupOption>(
                groupValue: state.pickupOption,
                onChanged: (value) {
                  if (value == null) return;
                  context.read<CheckoutBloc>().add(
                    CheckoutPickupOptionSelected(value),
                  );
                },
                child: Column(
                  children: [
                    for (final option in PickupOption.values)
                      RadioListTile<PickupOption>(
                        value: option,
                        title: Text(option.label),
                        contentPadding: EdgeInsets.zero,
                      ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg),
              Text('Payment', style: theme.textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              RadioGroup<PaymentMethod>(
                groupValue: state.paymentMethod,
                onChanged: (value) {
                  if (value == null) return;
                  context.read<CheckoutBloc>().add(
                    CheckoutPaymentMethodSelected(value),
                  );
                },
                child: Column(
                  children: [
                    for (final method in PaymentMethod.values)
                      RadioListTile<PaymentMethod>(
                        value: method,
                        title: Text(method.label),
                        contentPadding: EdgeInsets.zero,
                      ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg),
              Text('Note for the barista', style: theme.textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Optional — e.g. extra hot',
                  // Labelled so the field is not anonymous to a screen reader
                  // (`/flutter-accessibility-audit`).
                  labelText: 'Order note',
                ),
                maxLines: 2,
                maxLength: 140,
                onChanged: (value) =>
                    context.read<CheckoutBloc>().add(CheckoutNoteChanged(value)),
              ),

              const SizedBox(height: AppSpacing.md),
              CartSummaryCard(totals: state.totals),

              if (state.submissionError != null) ...[
                const SizedBox(height: AppSpacing.md),
                _SubmissionError(message: state.submissionError!),
              ],
            ],
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: FilledButton(
              onPressed: state.canSubmit
                  ? () => context.read<CheckoutBloc>().add(
                      const CheckoutSubmitted(),
                    )
                  : null,
              child: state.isSubmitting
                  ? const SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        semanticsLabel: 'Placing your order',
                      ),
                    )
                  : Text('Place order · ${state.totals.total.formatted}'),
            ),
          ),
        ),
      ],
    );
  }
}

class _SubmissionError extends StatelessWidget {
  const _SubmissionError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: scheme.errorContainer,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline_rounded, color: scheme.onErrorContainer),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: scheme.onErrorContainer),
            ),
          ),
        ],
      ),
    );
  }
}
