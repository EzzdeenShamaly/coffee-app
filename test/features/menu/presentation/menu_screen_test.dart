import 'package:bloc_test/bloc_test.dart';
import 'package:coffee_app/features/cart/application/cart_bloc.dart';
import 'package:coffee_app/features/cart/application/cart_event.dart';
import 'package:coffee_app/features/cart/application/cart_state.dart';
import 'package:coffee_app/features/cart/domain/entities/cart_totals.dart';
import 'package:coffee_app/features/menu/application/menu_bloc.dart';
import 'package:coffee_app/features/menu/application/menu_event.dart';
import 'package:coffee_app/features/menu/application/menu_state.dart';
import 'package:coffee_app/features/menu/domain/entities/drink.dart';
import 'package:coffee_app/features/menu/domain/entities/drink_category.dart';
import 'package:coffee_app/features/menu/presentation/screens/menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockMenuBloc extends MockBloc<MenuEvent, MenuState> implements MenuBloc {}

class MockCartBloc extends MockBloc<CartEvent, CartState> implements CartBloc {}

void main() {
  const latte = Drink(
    id: 'drink-3',
    name: 'Caramel Latte',
    description: 'Espresso, steamed milk, house caramel.',
    basePriceCents: 480,
    category: DrinkCategory.espresso,
  );
  const croissant = Drink(
    id: 'drink-7',
    name: 'Butter Croissant',
    description: 'Baked this morning.',
    basePriceCents: 390,
    category: DrinkCategory.pastry,
    isAvailable: false,
  );

  late MockMenuBloc menuBloc;
  late MockCartBloc cartBloc;

  setUpAll(() => registerFallbackValue(const MenuRequested()));

  setUp(() {
    menuBloc = MockMenuBloc();
    cartBloc = MockCartBloc();
    // The AppBar's cart badge reads this on every build.
    when(() => cartBloc.state).thenReturn(
      const CartLoadSuccess(items: [], totals: CartTotals.empty),
    );
  });

  /// Pumps MenuScreen with both blocs provided and the menu pinned to [state].
  Future<void> pumpMenu(WidgetTester tester, MenuState state) async {
    when(() => menuBloc.state).thenReturn(state);

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<MenuBloc>.value(value: menuBloc),
          BlocProvider<CartBloc>.value(value: cartBloc),
        ],
        child: const MaterialApp(home: MenuScreen()),
      ),
    );
  }

  group('MenuScreen', () {
    testWidgets('shows a spinner while the menu is loading', (tester) async {
      await pumpMenu(tester, const MenuLoadInProgress());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Caramel Latte'), findsNothing);
    });

    testWidgets('renders a card per drink once loaded', (tester) async {
      await pumpMenu(
        tester,
        const MenuLoadSuccess(allDrinks: [latte, croissant]),
      );

      expect(find.text('Caramel Latte'), findsOneWidget);
      expect(find.text('Butter Croissant'), findsOneWidget);
      expect(find.text(r'$4.80'), findsOneWidget);
    });

    testWidgets('marks an unavailable drink as sold out', (tester) async {
      await pumpMenu(
        tester,
        const MenuLoadSuccess(allDrinks: [latte, croissant]),
      );

      expect(find.text('Sold out'), findsOneWidget);
    });

    testWidgets('offers a chip per available category plus All', (tester) async {
      await pumpMenu(
        tester,
        const MenuLoadSuccess(allDrinks: [latte, croissant]),
      );

      expect(find.text('All'), findsOneWidget);
      expect(find.text('Espresso'), findsOneWidget);
      expect(find.text('Pastry'), findsOneWidget);
      // No chip for a category with nothing in it.
      expect(find.text('Tea'), findsNothing);
    });

    testWidgets('dispatches MenuCategorySelected when a chip is tapped', (
      tester,
    ) async {
      await pumpMenu(
        tester,
        const MenuLoadSuccess(allDrinks: [latte, croissant]),
      );

      await tester.tap(find.text('Pastry'));
      await tester.pump();

      // The chip's job is to dispatch, so the dispatch is the behaviour.
      verify(
        () => menuBloc.add(const MenuCategorySelected(DrinkCategory.pastry)),
      ).called(1);
    });

    testWidgets('shows the empty view when a filter matches nothing', (
      tester,
    ) async {
      await pumpMenu(
        tester,
        const MenuLoadSuccess(
          allDrinks: [latte],
          selectedCategory: DrinkCategory.tea,
        ),
      );

      expect(find.text('Nothing in this category right now.'), findsOneWidget);
      expect(find.text('Caramel Latte'), findsNothing);
    });

    testWidgets('shows the message and a working retry on failure', (
      tester,
    ) async {
      await pumpMenu(tester, const MenuLoadFailure('No internet connection.'));

      expect(find.text('No internet connection.'), findsOneWidget);

      await tester.tap(find.text('Try again'));
      await tester.pump();

      verify(() => menuBloc.add(const MenuRequested())).called(1);
    });

    testWidgets('hides the cart badge when the cart is empty', (tester) async {
      await pumpMenu(tester, const MenuLoadSuccess(allDrinks: [latte]));

      final badge = tester.widget<Badge>(find.byType(Badge));
      expect(badge.isLabelVisible, isFalse);
    });

    testWidgets('shows the cart count once the cart has items', (tester) async {
      when(() => cartBloc.state).thenReturn(
        const CartLoadSuccess(
          items: [],
          totals: CartTotals(
            subtotalCents: 960,
            taxCents: 96,
            totalCents: 1056,
            itemCount: 2,
          ),
        ),
      );

      await pumpMenu(tester, const MenuLoadSuccess(allDrinks: [latte]));

      final badge = tester.widget<Badge>(find.byType(Badge));
      expect(badge.isLabelVisible, isTrue);
      expect(find.text('2'), findsOneWidget);
    });
  });
}
