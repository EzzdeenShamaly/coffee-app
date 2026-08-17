import 'package:coffee_app/app/router/app_routes.dart';
import 'package:coffee_app/app/theme/app_spacing.dart';
import 'package:coffee_app/features/orders/application/order_history_bloc.dart';
import 'package:coffee_app/features/orders/application/order_history_event.dart';
import 'package:coffee_app/features/orders/application/order_history_state.dart';
import 'package:coffee_app/features/orders/presentation/widgets/order_tile.dart';
import 'package:coffee_app/shared/widgets/app_empty_view.dart';
import 'package:coffee_app/shared/widgets/app_error_view.dart';
import 'package:coffee_app/shared/widgets/app_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Past and in-flight orders.
class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your orders')),
      body: BlocBuilder<OrderHistoryBloc, OrderHistoryState>(
        builder: (context, state) {
          return switch (state) {
            OrderHistoryInitial() ||
            OrderHistoryLoadInProgress() => const AppLoadingIndicator(),
            OrderHistoryLoadFailure(:final message) => AppErrorView(
              message: message,
              onRetry: () => context.read<OrderHistoryBloc>().add(
                const OrderHistoryRequested(),
              ),
            ),
            OrderHistoryLoadSuccess() when state.isEmpty => AppEmptyView(
              icon: Icons.receipt_long_outlined,
              message: "You haven't ordered anything yet.",
              actionLabel: 'Browse the menu',
              onAction: () => context.goNamed(AppRoutes.menu),
            ),
            OrderHistoryLoadSuccess(:final orders) => RefreshIndicator(
              onRefresh: () async => context.read<OrderHistoryBloc>().add(
                const OrderHistoryRequested(),
              ),
              child: ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.md),
                itemCount: orders.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, index) =>
                    OrderTile(order: orders[index]),
              ),
            ),
          };
        },
      ),
    );
  }
}
