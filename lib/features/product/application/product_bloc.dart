import 'package:bloc/bloc.dart';
import 'package:coffee_app/core/error/app_exception.dart';
import 'package:coffee_app/features/menu/domain/repositories/menu_repository.dart';
import 'package:coffee_app/features/product/application/product_event.dart';
import 'package:coffee_app/features/product/application/product_state.dart';
import 'package:coffee_app/features/product/domain/entities/drink_configuration.dart';

/// Owns the drink-customisation form for one product.
///
/// Provided at the product route, so backing out and re-entering starts from a
/// clean default configuration rather than the last drink's options
/// (`02-flutter-state-guard.mdc`).
///
/// Note it depends on [MenuRepository] — the product feature has no repository
/// of its own, because "one drink" is a read of the menu, not a separate
/// resource. Reaching across to another feature's *domain interface* is
/// allowed; reaching into its widgets or data implementations is not.
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc({required this._repository}) : super(const ProductInitial()) {
    on<ProductRequested>(_onRequested);
    on<ProductSizeSelected>(_onSizeSelected);
    on<ProductMilkSelected>(_onMilkSelected);
    on<ProductExtraToggled>(_onExtraToggled);
    on<ProductQuantityChanged>(_onQuantityChanged);
  }

  final MenuRepository _repository;

  Future<void> _onRequested(
    ProductRequested event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductLoadInProgress());
    try {
      final drink = await _repository.fetchDrink(event.drinkId);
      if (isClosed) return;
      emit(
        ProductLoadSuccess(
          drink: drink,
          // A pastry gets the no-options configuration so its summary line
          // doesn't claim a size and milk it doesn't have.
          configuration: drink.category.isCustomisable
              ? const DrinkConfiguration()
              : DrinkConfiguration.none,
        ),
      );
    } on AppException catch (e) {
      if (isClosed) return;
      emit(ProductLoadFailure(e.message));
    }
  }

  void _onSizeSelected(ProductSizeSelected event, Emitter<ProductState> emit) {
    final current = state;
    if (current is! ProductLoadSuccess) return;
    emit(
      current.copyWith(
        configuration: current.configuration.copyWith(size: event.size),
      ),
    );
  }

  void _onMilkSelected(ProductMilkSelected event, Emitter<ProductState> emit) {
    final current = state;
    if (current is! ProductLoadSuccess) return;
    emit(
      current.copyWith(
        configuration: current.configuration.copyWith(milk: event.milk),
      ),
    );
  }

  void _onExtraToggled(ProductExtraToggled event, Emitter<ProductState> emit) {
    final current = state;
    if (current is! ProductLoadSuccess) return;

    final extras = [...current.configuration.extras];
    if (!extras.remove(event.extra)) extras.add(event.extra);

    emit(
      current.copyWith(
        configuration: current.configuration.copyWith(extras: extras),
      ),
    );
  }

  void _onQuantityChanged(
    ProductQuantityChanged event,
    Emitter<ProductState> emit,
  ) {
    final current = state;
    if (current is! ProductLoadSuccess) return;
    if (event.quantity < 1) return;
    emit(current.copyWith(quantity: event.quantity));
  }
}
