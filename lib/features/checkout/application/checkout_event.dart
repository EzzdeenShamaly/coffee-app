import 'package:coffee_app/features/cart/domain/entities/cart_item.dart';
import 'package:coffee_app/features/cart/domain/entities/cart_totals.dart';
import 'package:coffee_app/features/checkout/domain/entities/payment_method.dart';
import 'package:equatable/equatable.dart';

sealed class CheckoutEvent extends Equatable {
  const CheckoutEvent();

  @override
  List<Object?> get props => const [];
}

/// Seeds checkout with the cart snapshot the customer is confirming.
///
/// Passing the snapshot in (rather than having checkout read the cart) is what
/// makes the placed order match exactly what was on screen.
final class CheckoutStarted extends CheckoutEvent {
  const CheckoutStarted({required this.items, required this.totals});

  final List<CartItem> items;
  final CartTotals totals;

  @override
  List<Object?> get props => [items, totals];
}

final class CheckoutPaymentMethodSelected extends CheckoutEvent {
  const CheckoutPaymentMethodSelected(this.paymentMethod);

  final PaymentMethod paymentMethod;

  @override
  List<Object?> get props => [paymentMethod];
}

final class CheckoutPickupOptionSelected extends CheckoutEvent {
  const CheckoutPickupOptionSelected(this.pickupOption);

  final PickupOption pickupOption;

  @override
  List<Object?> get props => [pickupOption];
}

final class CheckoutNoteChanged extends CheckoutEvent {
  const CheckoutNoteChanged(this.note);

  final String note;

  @override
  List<Object?> get props => [note];
}

/// "Place order" tapped.
final class CheckoutSubmitted extends CheckoutEvent {
  const CheckoutSubmitted();
}
