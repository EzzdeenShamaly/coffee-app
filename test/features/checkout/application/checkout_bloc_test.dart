import 'package:bloc_test/bloc_test.dart';
import 'package:coffee_app/core/error/app_exception.dart';
import 'package:coffee_app/features/cart/domain/entities/cart_item.dart';
import 'package:coffee_app/features/cart/domain/entities/cart_totals.dart';
import 'package:coffee_app/features/checkout/application/checkout_bloc.dart';
import 'package:coffee_app/features/checkout/application/checkout_event.dart';
import 'package:coffee_app/features/checkout/application/checkout_state.dart';
import 'package:coffee_app/features/checkout/domain/entities/payment_method.dart';
import 'package:coffee_app/features/checkout/domain/repositories/checkout_repository.dart';
import 'package:coffee_app/features/menu/domain/entities/drink.dart';
import 'package:coffee_app/features/menu/domain/entities/drink_category.dart';
import 'package:coffee_app/features/orders/domain/entities/order.dart';
import 'package:coffee_app/features/orders/domain/entities/order_status.dart';
import 'package:coffee_app/features/product/domain/entities/drink_configuration.dart';
import 'package:coffee_app/features/product/domain/entities/drink_options.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCheckoutRepository extends Mock implements CheckoutRepository {}

void main() {
  const latte = Drink(
    id: 'drink-3',
    name: 'Caramel Latte',
    description: 'Caramel.',
    basePriceCents: 480,
    category: DrinkCategory.espresso,
  );

  const items = [
    CartItem(
      id: 'line-1',
      drink: latte,
      configuration: DrinkConfiguration(size: DrinkSize.small),
    ),
  ];

  const totals = CartTotals(
    subtotalCents: 480,
    taxCents: 48,
    totalCents: 528,
    itemCount: 1,
  );

  final placedOrder = Order(
    id: 'order-1',
    items: items,
    totals: totals,
    status: OrderStatus.placed,
    placedAt: DateTime.utc(2026, 8, 8, 9, 30),
    pickupCode: 'C42',
  );

  late MockCheckoutRepository repository;

  // mocktail needs a fallback for every non-primitive type passed to
  // `any(named:)` (`04-flutter-test-guard.mdc` Step 4).
  setUpAll(() {
    registerFallbackValue(CartTotals.empty);
    registerFallbackValue(<CartItem>[]);
    registerFallbackValue(PaymentMethod.applePay);
    registerFallbackValue(PickupOption.asap);
  });

  setUp(() => repository = MockCheckoutRepository());

  void stubSuccess() {
    when(
      () => repository.placeOrder(
        items: any(named: 'items'),
        totals: any(named: 'totals'),
        paymentMethod: any(named: 'paymentMethod'),
        pickupOption: any(named: 'pickupOption'),
        note: any(named: 'note'),
      ),
    ).thenAnswer((_) async => placedOrder);
  }

  group('CheckoutBloc', () {
    blocTest<CheckoutBloc, CheckoutState>(
      'seeds the form from the cart snapshot it is started with',
      build: () => CheckoutBloc(repository: repository),
      act: (bloc) =>
          bloc.add(const CheckoutStarted(items: items, totals: totals)),
      expect: () => [
        isA<CheckoutFormReady>()
            .having((s) => s.items, 'items', items)
            .having((s) => s.totals, 'totals', totals)
            .having((s) => s.canSubmit, 'canSubmit', isTrue)
            .having((s) => s.isSubmitting, 'isSubmitting', isFalse),
      ],
    );

    blocTest<CheckoutBloc, CheckoutState>(
      'records the selected payment method and pickup option',
      build: () => CheckoutBloc(repository: repository),
      seed: () => const CheckoutFormReady(items: items, totals: totals),
      act: (bloc) => bloc
        ..add(
          const CheckoutPaymentMethodSelected(PaymentMethod.payAtCounter),
        )
        ..add(
          const CheckoutPickupOptionSelected(PickupOption.inFifteenMinutes),
        ),
      expect: () => [
        isA<CheckoutFormReady>().having(
          (s) => s.paymentMethod,
          'paymentMethod',
          PaymentMethod.payAtCounter,
        ),
        isA<CheckoutFormReady>().having(
          (s) => s.pickupOption,
          'pickupOption',
          PickupOption.inFifteenMinutes,
        ),
      ],
    );

    blocTest<CheckoutBloc, CheckoutState>(
      'emits [submitting, success] and carries the placed order',
      setUp: stubSuccess,
      build: () => CheckoutBloc(repository: repository),
      seed: () => const CheckoutFormReady(items: items, totals: totals),
      act: (bloc) => bloc.add(const CheckoutSubmitted()),
      expect: () => [
        isA<CheckoutFormReady>().having(
          (s) => s.isSubmitting,
          'isSubmitting',
          isTrue,
        ),
        CheckoutSuccess(placedOrder),
      ],
    );

    blocTest<CheckoutBloc, CheckoutState>(
      'returns to the form with the message and the selections intact on failure',
      setUp: () {
        when(
          () => repository.placeOrder(
            items: any(named: 'items'),
            totals: any(named: 'totals'),
            paymentMethod: any(named: 'paymentMethod'),
            pickupOption: any(named: 'pickupOption'),
            note: any(named: 'note'),
          ),
        ).thenThrow(const NetworkException('No internet connection.'));
      },
      build: () => CheckoutBloc(repository: repository),
      seed: () => const CheckoutFormReady(
        items: items,
        totals: totals,
        paymentMethod: PaymentMethod.payAtCounter,
        note: 'extra hot',
      ),
      act: (bloc) => bloc.add(const CheckoutSubmitted()),
      expect: () => [
        isA<CheckoutFormReady>().having(
          (s) => s.isSubmitting,
          'isSubmitting',
          isTrue,
        ),
        // Everything the customer entered survives the failure.
        isA<CheckoutFormReady>()
            .having((s) => s.isSubmitting, 'isSubmitting', isFalse)
            .having(
              (s) => s.submissionError,
              'submissionError',
              'No internet connection.',
            )
            .having(
              (s) => s.paymentMethod,
              'paymentMethod',
              PaymentMethod.payAtCounter,
            )
            .having((s) => s.note, 'note', 'extra hot'),
      ],
    );

    blocTest<CheckoutBloc, CheckoutState>(
      'ignores a second submit while one is already in flight',
      setUp: stubSuccess,
      build: () => CheckoutBloc(repository: repository),
      seed: () => const CheckoutFormReady(
        items: items,
        totals: totals,
        isSubmitting: true,
      ),
      act: (bloc) => bloc.add(const CheckoutSubmitted()),
      expect: () => const <CheckoutState>[],
      verify: (_) {
        // The double-tap guard: two taps must not place two orders.
        verifyNever(
          () => repository.placeOrder(
            items: any(named: 'items'),
            totals: any(named: 'totals'),
            paymentMethod: any(named: 'paymentMethod'),
            pickupOption: any(named: 'pickupOption'),
            note: any(named: 'note'),
          ),
        );
      },
    );

    blocTest<CheckoutBloc, CheckoutState>(
      'sends a blank note as null rather than an empty string',
      setUp: stubSuccess,
      build: () => CheckoutBloc(repository: repository),
      seed: () => const CheckoutFormReady(
        items: items,
        totals: totals,
        note: '   ',
      ),
      act: (bloc) => bloc.add(const CheckoutSubmitted()),
      verify: (_) {
        verify(
          () => repository.placeOrder(
            items: items,
            totals: totals,
            paymentMethod: PaymentMethod.applePay,
            pickupOption: PickupOption.asap,
            note: null,
          ),
        ).called(1);
      },
    );

    blocTest<CheckoutBloc, CheckoutState>(
      'ignores a submit before the form has been started',
      build: () => CheckoutBloc(repository: repository),
      act: (bloc) => bloc.add(const CheckoutSubmitted()),
      expect: () => const <CheckoutState>[],
    );
  });
}
