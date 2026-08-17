import 'package:coffee_app/features/menu/domain/entities/drink.dart';
import 'package:coffee_app/features/menu/domain/entities/drink_category.dart';
import 'package:equatable/equatable.dart';

sealed class MenuState extends Equatable {
  const MenuState();

  @override
  List<Object?> get props => const [];
}

final class MenuInitial extends MenuState {
  const MenuInitial();
}

final class MenuLoadInProgress extends MenuState {
  const MenuLoadInProgress();
}

/// The menu loaded. Holds the full list plus the active filter, and exposes
/// [visibleDrinks] as the derived view the screen renders.
///
/// Keeping the unfiltered list here is what lets a category tap re-filter
/// without a refetch.
final class MenuLoadSuccess extends MenuState {
  const MenuLoadSuccess({required this.allDrinks, this.selectedCategory});

  final List<Drink> allDrinks;
  final DrinkCategory? selectedCategory;

  /// Categories that actually have items, in menu order — so the filter bar
  /// never offers a chip that yields an empty list.
  List<DrinkCategory> get availableCategories {
    final seen = <DrinkCategory>[];
    for (final drink in allDrinks) {
      if (!seen.contains(drink.category)) seen.add(drink.category);
    }
    return seen;
  }

  List<Drink> get visibleDrinks => selectedCategory == null
      ? allDrinks
      : allDrinks.where((d) => d.category == selectedCategory).toList();

  bool get isEmpty => visibleDrinks.isEmpty;

  @override
  List<Object?> get props => [allDrinks, selectedCategory];
}

final class MenuLoadFailure extends MenuState {
  const MenuLoadFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
