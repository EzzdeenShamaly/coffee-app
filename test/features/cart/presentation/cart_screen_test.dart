import 'package:bloc_test/bloc_test.dart';
import 'package:coffee_app/features/cart/application/cart_bloc.dart';
import 'package:coffee_app/features/cart/application/cart_event.dart';
import 'package:coffee_app/features/cart/application/cart_state.dart';
import 'package:coffee_app/features/cart/domain/entities/cart_item.dart';
import 'package:coffee_app/features/cart/domain/entities/cart_totals.dart';
import 'package:coffee_app/features/cart/presentation/screens/cart_screen.dart';
import 'package:coffee_app/features/menu/domain/entities/drink.dart';
import 'package:coffee_app/features/menu/domain/entities/drink_category.dart';
import 'package:coffee_app/features/product/domain/entities/drink_configuration.dart';
import 'package:coffee_app/features/product/domain/entities/drink_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCartBloc extends MockBloc<CartEvent, CartState> implements CartBloc {}

void main() {
  const latte = Drink(
    id: 'drink-3',
    name: 'Caramel Latte',
    description: 'Caramel.',
    basePriceCents: 480,
    category: DrinkCategory.espresso,
  );

  const line = CartItem(
    id: 'line-1',
    drink: latte,
    configuration: DrinkConfiguration(
      size: DrinkSize.large,
      milk: MilkOption.oat,
    ),
    quantity: 2,
  );

  // (480 + 110 large + 70 oat) * 2 = 1320
  const totals = CartTotals(
    subtotalCents: 1320,
    taxCents: 132,
    totalCents: 1452,
    itemCount: 2,
  );

  late MockCartBloc cartBloc;

  setUpAll(() => registerFallbackValue(const CartRequested()));

  setUp(() => cartBloc = MockCartBloc());

  Future<void> pumpCart(WidgetTester tester, CartState state) async {
    when(() => cartBloc.state).thenReturn(state);

    await tester.pumpWidget(
      BlocProvider<CartBloc>.value(
        value: cartBloc,
        child: const MaterialApp(home: CartScreen()),
      ),
    );
  }

  group('CartScreen', () {
    testWidgets('shows a spinner while the cart is loading', (tester) async {
      await pumpCart(tester, const CartLoadInProgress());
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows the empty view for an empty cart, not an error', (
      tester,
    ) async {
      await pumpCart(
        tester,
        const CartLoadSuccess(items: [], totals: CartTotals.empty),
      );

      expect(find.text('Your cart is empty.'), findsOneWidget);
      expect(find.text('Browse the menu'), findsOneWidget);
      expect(find.text('Try again'), findsNothing);
    });

    testWidgets('renders the line, its customisation, and the totals', (
      tester,
    ) async {
      await pumpCart(
        tester,
        const CartLoadSuccess(items: [line], totals: totals),
      );

      expect(find.text('Caramel Latte'), findsOneWidget);
      expect(find.text('Large · Oat milk'), findsOneWidget);
      // Twice: once as the line total, once as the subtotal in the summary card.
      expect(find.text(r'$13.20'), findsNWidgets(2));
      expect(find.text(r'$1.32'), findsOneWidget); // tax
      expect(find.text(r'Checkout · $14.52'), findsOneWidget);
    });

    testWidgets('dispatches a quantity change from the stepper', (tester) async {
      await pumpCart(
        tester,
        const CartLoadSuccess(items: [line], totals: totals),
      );

      await tester.tap(find.byTooltip('Increase Caramel Latte quantity'));
      await tester.pump();

      verify(
        () => cartBloc.add(
          const CartItemQuantityChanged(itemId: 'line-1', quantity: 3),
        ),
      ).called(1);
    });

    testWidgets('dispatches a removal from the delete button', (tester) async {
      await pumpCart(
        tester,
        const CartLoadSuccess(items: [line], totals: totals),
      );

      await tester.tap(find.byTooltip('Remove Caramel Latte'));
      await tester.pump();

      verify(() => cartBloc.add(const CartItemRemoved('line-1'))).called(1);
    });

    testWidgets('takes over the screen when the initial load fails', (
      tester,
    ) async {
      await pumpCart(tester, const CartLoadFailure('No internet connection.'));

      expect(find.text('No internet connection.'), findsOneWidget);

      await tester.tap(find.text('Try again'));
      await tester.pump();

      verify(() => cartBloc.add(const CartRequested())).called(1);
    });

    testWidgets('keeps the cart visible when a write fails over a full cart', (
      tester,
    ) async {
      await pumpCart(
        tester,
        const CartLoadFailure(
          'Butter Croissant is sold out.',
          items: [line],
          totals: totals,
        ),
      );

      // The list survives; the message arrives as a snackbar from the listener.
      expect(find.text('Caramel Latte'), findsOneWidget);
      expect(find.text('Try again'), findsNothing);
    });

    testWidgets('disables checkout while a failure is showing', (tester) async {
      await pumpCart(
        tester,
        const CartLoadFailure(
          'Butter Croissant is sold out.',
          items: [line],
          totals: totals,
        ),
      );

      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('enables checkout for a healthy populated cart', (tester) async {
      await pumpCart(
        tester,
        const CartLoadSuccess(items: [line], totals: totals),
      );

      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNotNull);
    });
  });
}
