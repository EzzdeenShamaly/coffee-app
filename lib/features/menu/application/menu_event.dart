import 'package:coffee_app/features/menu/domain/entities/drink_category.dart';
import 'package:equatable/equatable.dart';

sealed class MenuEvent extends Equatable {
  const MenuEvent();

  @override
  List<Object?> get props => const [];
}

/// Initial load, and the retry action on the failure view.
final class MenuRequested extends MenuEvent {
  const MenuRequested();
}

/// Category chip tapped. A null [category] means "All" and clears the filter.
///
/// Filtering happens in the bloc against the already-loaded menu — no refetch.
final class MenuCategorySelected extends MenuEvent {
  const MenuCategorySelected(this.category);

  final DrinkCategory? category;

  @override
  List<Object?> get props => [category];
}
