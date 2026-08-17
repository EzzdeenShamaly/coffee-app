import 'package:coffee_app/app/router/app_routes.dart';
import 'package:coffee_app/app/theme/app_spacing.dart';
import 'package:coffee_app/app/widgets/app_shell.dart';
import 'package:coffee_app/features/menu/application/menu_bloc.dart';
import 'package:coffee_app/features/menu/application/menu_event.dart';
import 'package:coffee_app/features/menu/application/menu_state.dart';
import 'package:coffee_app/features/menu/presentation/widgets/category_filter_bar.dart';
import 'package:coffee_app/features/menu/presentation/widgets/drink_card.dart';
import 'package:coffee_app/shared/widgets/app_empty_view.dart';
import 'package:coffee_app/shared/widgets/app_error_view.dart';
import 'package:coffee_app/shared/widgets/app_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// The menu — the app's home screen.
class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order coffee'),
        titleTextStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        actions: [
          CartAppBarButton(
            onPressed: () => context.pushNamed(AppRoutes.cart),
          ),
        ],
      ),
      body: BlocBuilder<MenuBloc, MenuState>(
        builder: (context, state) {
          // Exhaustive switch with no `default`: adding a state variant becomes
          // a compile error, not a blank screen.
          return switch (state) {
            MenuInitial() || MenuLoadInProgress() => const AppLoadingIndicator(),
            MenuLoadFailure(:final message) => AppErrorView(
              message: message,
              onRetry: () =>
                  context.read<MenuBloc>().add(const MenuRequested()),
            ),
            MenuLoadSuccess() => _MenuList(state: state),
          };
        },
      ),
    );
  }
}

class _MenuList extends StatelessWidget {
  const _MenuList({required this.state});

  final MenuLoadSuccess state;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CategoryFilterBar(
          categories: state.availableCategories,
          selected: state.selectedCategory,
          onSelected: (category) =>
              context.read<MenuBloc>().add(MenuCategorySelected(category)),
        ),
        const SizedBox(height: AppSpacing.sm),
        Expanded(
          child: state.isEmpty
              ? const AppEmptyView(
                  message: 'Nothing in this category right now.',
                )
              // .builder rather than a Column in a ScrollView: only visible rows
              // are built (`/flutter-performance-audit`).
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    0,
                    AppSpacing.md,
                    AppSpacing.xl,
                  ),
                  itemCount: state.visibleDrinks.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final drink = state.visibleDrinks[index];
                    return DrinkCard(
                      drink: drink,
                      onTap: () => context.goNamed(
                        AppRoutes.product,
                        pathParameters: {AppRoutes.productParamId: drink.id},
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
