import 'package:bloc/bloc.dart';
import 'package:coffee_app/core/error/app_exception.dart';
import 'package:coffee_app/features/menu/application/menu_event.dart';
import 'package:coffee_app/features/menu/application/menu_state.dart';
import 'package:coffee_app/features/menu/domain/repositories/menu_repository.dart';

/// Owns the menu list and its active category filter.
class MenuBloc extends Bloc<MenuEvent, MenuState> {
  MenuBloc({required this._repository}) : super(const MenuInitial()) {
    on<MenuRequested>(_onRequested);
    on<MenuCategorySelected>(_onCategorySelected);
  }

  final MenuRepository _repository;

  Future<void> _onRequested(
    MenuRequested event,
    Emitter<MenuState> emit,
  ) async {
    emit(const MenuLoadInProgress());
    try {
      final drinks = await _repository.fetchMenu();
      if (isClosed) return;
      emit(MenuLoadSuccess(allDrinks: drinks));
    } on AppException catch (e) {
      if (isClosed) return;
      emit(MenuLoadFailure(e.message));
    }
  }

  /// Filtering is a pure state transition — no repository call, so tapping a
  /// chip never shows a spinner.
  void _onCategorySelected(
    MenuCategorySelected event,
    Emitter<MenuState> emit,
  ) {
    final current = state;
    if (current is! MenuLoadSuccess) return;

    emit(
      MenuLoadSuccess(
        allDrinks: current.allDrinks,
        selectedCategory: event.category,
      ),
    );
  }
}
