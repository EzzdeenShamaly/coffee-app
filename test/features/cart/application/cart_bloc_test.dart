import 'package:bloc_test/bloc_test.dart';
import 'package:coffee_app/core/error/app_exception.dart';
import 'package:coffee_app/features/cart/application/cart_bloc.dart';
import 'package:coffee_app/features/cart/application/cart_event.dart';
import 'package:coffee_app/features/cart/application/cart_state.dart';
import 'package:coffee_app/features/cart/data/repositories/in_memory_cart_repository.dart';
import 'package:coffee_app/features/cart/domain/entities/cart_item.dart';
import 'package:coffee_app/features/cart/domain/repositories/cart_repository.dart';
import 'package:coffee_app/features/cart/domain/usecases/calculate_cart_totals.dart';
import 'package:coffee_app/features/menu/domain/entities/drink.dart';
import 'package:coffee_app/features/menu/domain/entities/drink_category.dart';
import 'package:coffee_app/features/product/domain/entities/drink_configuration.dart';
import 'package:coffee_app/features/product/domain/entities/drink_options.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCartRepository extends Mock implements CartRepository {}

void main() {
  const latte = Drink(
    id: 'drink-3',
    name: 'Caramel Latte',
    description: 'Caramel.',
    basePriceCents: 480,
    category: DrinkCategory.espresso,
  );
  const soldOut = Drink(
    id: 'drink-7',
    name: 'Butter Croissant',
    description: 'Buttery.',
    basePriceCents: 390,
    category: DrinkCategory.pastry,
    isAvailable: false,
  );

  const smallConfig = DrinkConfiguration(size: DrinkSize.small);
  const calculateTotals = CalculateCartTotals(taxRate: 0.10);

  setUpAll(() {
    registerFallbackValue(latte);
    registerFallbackValue(smallConfig);
  });

  group('CartBloc with a real in-memory repository', () {
    blocTest<CartBloc, CartState>(
      'emits [inProgress, success] with an empty cart on first load',
      build: () => CartBloc(
        repository: InMemoryCartRepository(),
        calculateTotals: calculateTotals,
      ),
      act: (bloc) => bloc.add(const CartRequested()),
      expect: () => [
        const CartLoadInProgress(),
        isA<CartLoadSuccess>()
            .having((s) => s.items, 'items', isEmpty)
            .having((s) => s.isEmpty, 'isEmpty', isTrue)
            .having((s) => s.canCheckout, 'canCheckout', isFalse),
      ],
    );

    blocTest<CartBloc, CartState>(
      'adds a line and emits the recalculated totals',
      build: () => CartBloc(
        repository: InMemoryCartRepository(),
        calculateTotals: calculateTotals,
      ),
      act: (bloc) => bloc.add(
        const CartItemAdded(
          drink: latte,
          configuration: smallConfig,
          quantity: 2,
        ),
      ),
      expect: () => [
        isA<CartLoadSuccess>()
            .having((s) => s.items.length, 'line count', 1)
            .having((s) => s.totals.itemCount, 'unit count', 2)
            .having((s) => s.totals.subtotal.cents, 'subtotal', 960)
            .having((s) => s.totals.tax.cents, 'tax', 96)
            .having((s) => s.canCheckout, 'canCheckout', isTrue),
      ],
    );

    blocTest<CartBloc, CartState>(
      'merges an identical drink+configuration into one line',
      build: () => CartBloc(
        repository: InMemoryCartRepository(),
        calculateTotals: calculateTotals,
      ),
      act: (bloc) => bloc
        ..add(
          const CartItemAdded(drink: latte, configuration: smallConfig),
        )
        ..add(
          const CartItemAdded(drink: latte, configuration: smallConfig),
        ),
      skip: 1,
      expect: () => [
        // One row, quantity two — not two identical rows.
        isA<CartLoadSuccess>()
            .having((s) => s.items.length, 'line count', 1)
            .having((s) => s.items.single.quantity, 'quantity', 2),
      ],
    );

    blocTest<CartBloc, CartState>(
      'keeps differently-configured drinks as separate lines',
      build: () => CartBloc(
        repository: InMemoryCartRepository(),
        calculateTotals: calculateTotals,
      ),
      act: (bloc) => bloc
        ..add(const CartItemAdded(drink: latte, configuration: smallConfig))
        ..add(
          const CartItemAdded(
            drink: latte,
            configuration: DrinkConfiguration(size: DrinkSize.large),
          ),
        ),
      skip: 1,
      expect: () => [
        isA<CartLoadSuccess>().having((s) => s.items.length, 'line count', 2),
      ],
    );

    blocTest<CartBloc, CartState>(
      'emits a failure that preserves the cart when adding a sold-out drink',
      build: () => CartBloc(
        repository: InMemoryCartRepository(),
        calculateTotals: calculateTotals,
      ),
      act: (bloc) => bloc
        ..add(const CartItemAdded(drink: latte, configuration: smallConfig))
        ..add(
          const CartItemAdded(
            drink: soldOut,
            configuration: DrinkConfiguration.none,
          ),
        ),
      skip: 1,
      expect: () => [
        // The existing line survives, so the screen keeps rendering the cart
        // behind the error message.
        isA<CartLoadFailure>()
            .having((s) => s.message, 'message', 'Butter Croissant is sold out.')
            .having((s) => s.items.length, 'preserved lines', 1)
            .having((s) => s.hasVisibleCart, 'hasVisibleCart', isTrue),
      ],
    );

    blocTest<CartBloc, CartState>(
      'removes a line and empties the cart',
      build: () => CartBloc(
        repository: InMemoryCartRepository(),
        calculateTotals: calculateTotals,
      ),
      act: (bloc) async {
        bloc.add(const CartItemAdded(drink: latte, configuration: smallConfig));
        // Wait for the id the repository assigned before removing it.
        final added = await bloc.stream.firstWhere((s) => s is CartLoadSuccess);
        final id = ((added as CartLoadSuccess).items.single).id;
        bloc.add(CartItemRemoved(id));
      },
      skip: 1,
      expect: () => [
        isA<CartLoadSuccess>().having((s) => s.items, 'items', isEmpty),
      ],
    );

    blocTest<CartBloc, CartState>(
      'clears every line on CartCleared',
      build: () => CartBloc(
        repository: InMemoryCartRepository(),
        calculateTotals: calculateTotals,
      ),
      act: (bloc) => bloc
        ..add(const CartItemAdded(drink: latte, configuration: smallConfig))
        ..add(const CartCleared()),
      skip: 1,
      expect: () => [
        isA<CartLoadSuccess>()
            .having((s) => s.items, 'items', isEmpty)
            .having((s) => s.totals.itemCount, 'unit count', 0),
      ],
    );
  });

  group('CartBloc with a failing repository', () {
    late MockCartRepository repository;

    setUp(() => repository = MockCartRepository());

    blocTest<CartBloc, CartState>(
      'emits [inProgress, failure] when the initial read throws',
      setUp: () {
        when(() => repository.fetchItems())
            .thenThrow(const NetworkException('No internet connection.'));
      },
      build: () => CartBloc(repository: repository),
      act: (bloc) => bloc.add(const CartRequested()),
      expect: () => const [
        CartLoadInProgress(),
        // No items to preserve, so this failure takes over the screen.
        CartLoadFailure('No internet connection.'),
      ],
      verify: (_) {
        expect(const CartLoadFailure('x').hasVisibleCart, isFalse);
      },
    );

    blocTest<CartBloc, CartState>(
      'surfaces a NotFoundException from a quantity update',
      setUp: () {
        when(
          () => repository.updateQuantity(
            itemId: any(named: 'itemId'),
            quantity: any(named: 'quantity'),
          ),
        ).thenThrow(const NotFoundException('That item is no longer in your cart.'));
        when(() => repository.fetchItems()).thenAnswer((_) async => <CartItem>[]);
      },
      build: () => CartBloc(repository: repository),
      act: (bloc) => bloc.add(
        const CartItemQuantityChanged(itemId: 'line-99', quantity: 3),
      ),
      expect: () => const [
        CartLoadFailure('That item is no longer in your cart.'),
      ],
    );
  });
}
