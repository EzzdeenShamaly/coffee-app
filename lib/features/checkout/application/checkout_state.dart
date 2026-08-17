import 'package:coffee_app/features/cart/domain/entities/cart_item.dart';
import 'package:coffee_app/features/cart/domain/entities/cart_totals.dart';
import 'package:coffee_app/features/checkout/domain/entities/payment_method.dart';
import 'package:coffee_app/features/orders/domain/entities/order.dart';
import 'package:equatable/equatable.dart';

sealed class CheckoutState extends Equatable {
  const CheckoutState();

  @override
  List<Object?> get props => const [];
}

final class CheckoutInitial extends CheckoutState {
  const CheckoutInitial();
}

/// The form, ready to edit.
///
/// [submissionError] holds a failed attempt's message so the customer keeps
/// their selections instead of being sent back to a blank form — the most
/// important reason this is one variant with a nullable error rather than a
/// separate failure variant that would have to duplicate every field.
final class CheckoutFormReady extends CheckoutState {
  const CheckoutFormReady({
    required this.items,
    required this.totals,
    this.paymentMethod = PaymentMethod.applePay,
    this.pickupOption = PickupOption.asap,
    this.note = '',
    this.isSubmitting = false,
    this.submissionError,
  });

  final List<CartItem> items;
  final CartTotals totals;
  final PaymentMethod paymentMethod;
  final PickupOption pickupOption;
  final String note;

  /// Drives the button spinner. The form stays visible and readable throughout.
  final bool isSubmitting;

  /// Non-null after a failed submit. Cleared on the next submit attempt.
  final String? submissionError;

  bool get canSubmit => items.isNotEmpty && !isSubmitting;

  CheckoutFormReady copyWith({
    PaymentMethod? paymentMethod,
    PickupOption? pickupOption,
    String? note,
    bool? isSubmitting,
    String? submissionError,
    bool clearError = false,
  }) {
    return CheckoutFormReady(
      items: items,
      totals: totals,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      pickupOption: pickupOption ?? this.pickupOption,
      note: note ?? this.note,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submissionError: clearError
          ? null
          : (submissionError ?? this.submissionError),
    );
  }

  @override
  List<Object?> get props => [
    items,
    totals,
    paymentMethod,
    pickupOption,
    note,
    isSubmitting,
    submissionError,
  ];
}

/// Terminal success. The screen's `BlocListener` watches for this and navigates
/// to the confirmation route — navigation never happens in a `builder`.
final class CheckoutSuccess extends CheckoutState {
  const CheckoutSuccess(this.order);

  final Order order;

  @override
  List<Object?> get props => [order];
}
