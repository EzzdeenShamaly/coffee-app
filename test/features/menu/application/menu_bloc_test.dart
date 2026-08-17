import 'package:bloc_test/bloc_test.dart';
import 'package:coffee_app/core/error/app_exception.dart';
import 'package:coffee_app/features/menu/application/menu_bloc.dart';
import 'package:coffee_app/features/menu/application/menu_event.dart';
import 'package:coffee_app/features/menu/application/menu_state.dart';
import 'package:coffee_app/features/menu/domain/entities/drink.dart';
import 'package:coffee_app/features/menu/domain/entities/drink_category.dart';
import 'package:coffee_app/features/menu/domain/repositories/menu_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockMenuRepository extends Mock implements MenuRepository {}

void main() {
  const latte = Drink(
    id: 'drink-3',
    name: 'Caramel Latte',
    description: 'Caramel.',
    basePriceCents: 480,
    category: DrinkCategory.espresso,
  );
  const croissant = Drink(
    id: 'drink-7',
    name: 'Butter Croissant',
    description: 'Buttery.',
    basePriceCents: 390,
    category: DrinkCategory.pastry,
  );

  late MockMenuRepository repository;

  setUp(() => repository = MockMenuRepository());

  group('MenuBloc', () {
    blocTest<MenuBloc, MenuState>(
      'emits [inProgress, success] when the menu loads',
      setUp: () {
        when(() => repository.fetchMenu())
            .thenAnswer((_) async => [latte, croissant]);
      },
      build: () => MenuBloc(repository: repository),
      act: (bloc) => bloc.add(const MenuRequested()),
      expect: () => const [
        MenuLoadInProgress(),
        MenuLoadSuccess(allDrinks: [latte, croissant]),
      ],
    );

    blocTest<MenuBloc, MenuState>(
      'emits [inProgress, failure] with the exception message when offline',
      setUp: () {
        when(() => repository.fetchMenu())
            .thenThrow(const NetworkException('No internet connection.'));
      },
      build: () => MenuBloc(repository: repository),
      act: (bloc) => bloc.add(const MenuRequested()),
      expect: () => const [
        MenuLoadInProgress(),
        MenuLoadFailure('No internet connection.'),
      ],
    );

    blocTest<MenuBloc, MenuState>(
      'filters in place without refetching when a category is selected',
      build: () => MenuBloc(repository: repository),
      seed: () => const MenuLoadSuccess(allDrinks: [latte, croissant]),
      act: (bloc) => bloc.add(const MenuCategorySelected(DrinkCategory.pastry)),
      expect: () => const [
        MenuLoadSuccess(
          allDrinks: [latte, croissant],
          selectedCategory: DrinkCategory.pastry,
        ),
      ],
      verify: (_) {
        // The whole point of holding allDrinks in state: a chip tap must not
        // hit the repository.
        verifyNever(() => repository.fetchMenu());
      },
    );

    blocTest<MenuBloc, MenuState>(
      'ignores a category selection before the menu has loaded',
      build: () => MenuBloc(repository: repository),
      act: (bloc) => bloc.add(const MenuCategorySelected(DrinkCategory.tea)),
      expect: () => const <MenuState>[],
    );

    test('visibleDrinks narrows to the selected category', () {
      const state = MenuLoadSuccess(
        allDrinks: [latte, croissant],
        selectedCategory: DrinkCategory.pastry,
      );

      expect(state.visibleDrinks, const [croissant]);
      expect(state.isEmpty, isFalse);
    });

    test('visibleDrinks returns everything when no category is selected', () {
      const state = MenuLoadSuccess(allDrinks: [latte, croissant]);
      expect(state.visibleDrinks, const [latte, croissant]);
    });

    test('availableCategories lists only categories that have items', () {
      const state = MenuLoadSuccess(allDrinks: [latte, croissant]);
      expect(state.availableCategories, const [
        DrinkCategory.espresso,
        DrinkCategory.pastry,
      ]);
    });
  });
}
