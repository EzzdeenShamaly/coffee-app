import 'package:bloc/bloc.dart';
import 'package:coffee_app/core/error/app_exception.dart';
import 'package:coffee_app/features/checkout/application/checkout_event.dart';
import 'package:coffee_app/features/checkout/application/checkout_state.dart';
import 'package:coffee_app/features/checkout/domain/repositories/checkout_repository.dart';

/// Owns the checkout form and the order-placing call.
///
/// Route-scoped: leaving checkout and coming back should start a fresh form,
/// not resurrect a half-filled one with a stale error on it.
class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  CheckoutBloc({required this._repository}) : super(const CheckoutInitial()) {
    on<CheckoutStarted>(_onStarted);
    on<CheckoutPaymentMethodSelected>(_onPaymentMethodSelected);
    on<CheckoutPickupOptionSelected>(_onPickupOptionSelected);
    on<CheckoutNoteChanged>(_onNoteChanged);
    on<CheckoutSubmitted>(_onSubmitted);
  }

  final CheckoutRepository _repository;

  void _onStarted(CheckoutStarted event, Emitter<CheckoutState> emit) {
    emit(CheckoutFormReady(items: event.items, totals: event.totals));
  }

  void _onPaymentMethodSelected(
    CheckoutPaymentMethodSelected event,
    Emitter<CheckoutState> emit,
  ) {
    final current = state;
    if (current is! CheckoutFormReady) return;
    emit(current.copyWith(paymentMethod: event.paymentMethod));
  }

  void _onPickupOptionSelected(
    CheckoutPickupOptionSelected event,
    Emitter<CheckoutState> emit,
  ) {
    final current = state;
    if (current is! CheckoutFormReady) return;
    emit(current.copyWith(pickupOption: event.pickupOption));
  }

  void _onNoteChanged(CheckoutNoteChanged event, Emitter<CheckoutState> emit) {
    final current = state;
    if (current is! CheckoutFormReady) return;
    emit(current.copyWith(note: event.note));
  }

  Future<void> _onSubmitted(
    CheckoutSubmitted event,
    Emitter<CheckoutState> emit,
  ) async {
    final current = state;
    if (current is! CheckoutFormReady) return;

    // Guards a double-tap on "place order" — without this, two taps place two
    // orders and charge twice.
    if (current.isSubmitting) return;

    emit(current.copyWith(isSubmitting: true, clearError: true));

    try {
      final order = await _repository.placeOrder(
        items: current.items,
        totals: current.totals,
        paymentMethod: current.paymentMethod,
        pickupOption: current.pickupOption,
        note: current.note.trim().isEmpty ? null : current.note.trim(),
      );
      if (isClosed) return;
      emit(CheckoutSuccess(order));
    } on AppException catch (e) {
      if (isClosed) return;
      // Back to the form with everything the customer entered intact.
      emit(current.copyWith(isSubmitting: false, submissionError: e.message));
    }
  }
}
