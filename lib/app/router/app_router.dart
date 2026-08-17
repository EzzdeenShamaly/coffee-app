import 'package:coffee_app/app/router/app_routes.dart';
import 'package:coffee_app/app/router/go_router_refresh_stream.dart';
import 'package:coffee_app/app/widgets/app_shell.dart';
import 'package:coffee_app/features/auth/application/auth_bloc.dart';
import 'package:coffee_app/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:coffee_app/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:coffee_app/features/cart/application/cart_bloc.dart';
import 'package:coffee_app/features/cart/application/cart_state.dart';
import 'package:coffee_app/features/cart/presentation/screens/cart_screen.dart';
import 'package:coffee_app/features/checkout/application/checkout_bloc.dart';
import 'package:coffee_app/features/checkout/application/checkout_event.dart';
import 'package:coffee_app/features/checkout/domain/repositories/checkout_repository.dart';
import 'package:coffee_app/features/checkout/presentation/screens/checkout_screen.dart';
import 'package:coffee_app/features/menu/application/menu_bloc.dart';
import 'package:coffee_app/features/menu/application/menu_event.dart';
import 'package:coffee_app/features/menu/domain/repositories/menu_repository.dart';
import 'package:coffee_app/features/menu/presentation/screens/menu_screen.dart';
import 'package:coffee_app/features/orders/application/order_history_bloc.dart';
import 'package:coffee_app/features/orders/application/order_history_event.dart';
import 'package:coffee_app/features/orders/domain/entities/order.dart';
import 'package:coffee_app/features/orders/domain/repositories/order_repository.dart';
import 'package:coffee_app/features/orders/presentation/screens/order_confirmation_screen.dart';
import 'package:coffee_app/features/orders/presentation/screens/order_history_screen.dart';
import 'package:coffee_app/features/product/application/product_bloc.dart';
import 'package:coffee_app/features/product/application/product_event.dart';
import 'package:coffee_app/features/product/presentation/screens/product_detail_screen.dart';
import 'package:coffee_app/features/profile/application/profile_bloc.dart';
import 'package:coffee_app/features/profile/application/profile_event.dart';
import 'package:coffee_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:coffee_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// The app's route table.
///
/// Every feature bloc is created here, in its route's `builder`, so its lifetime
/// is the route's — leaving a screen disposes its bloc and the next visit starts
/// clean. Only `AuthBloc` and `CartBloc` live above this, in `CoffeeApp`
/// (`02-flutter-state-guard.mdc`).
class AppRouter {
  AppRouter({required this._authBloc});

  final AuthBloc _authBloc;

  late final GoRouter router = GoRouter(
    initialLocation: AppRoutes.menuPath,
    // Re-runs `redirect` when auth changes, so a sign-out immediately bounces
    // the customer off a protected screen instead of leaving them on it.
    refreshListenable: GoRouterRefreshStream(_authBloc.stream),
    redirect: _guard,
    routes: [
      GoRoute(
        path: AppRoutes.signInPath,
        name: AppRoutes.signIn,
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: AppRoutes.signUpPath,
        name: AppRoutes.signUp,
        builder: (context, state) => const SignUpScreen(),
      ),

      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.menuPath,
                name: AppRoutes.menu,
                builder: (context, state) => BlocProvider(
                  create: (context) =>
                      MenuBloc(repository: context.read<MenuRepository>())
                        ..add(const MenuRequested()),
                  child: const MenuScreen(),
                ),
                routes: [
                  // Nested, so backing out of a drink returns to the menu and
                  // the bottom nav stays visible.
                  GoRoute(
                    path: AppRoutes.productPath,
                    name: AppRoutes.product,
                    builder: (context, state) {
                      final drinkId =
                          state.pathParameters[AppRoutes.productParamId]!;
                      return BlocProvider(
                        create: (context) => ProductBloc(
                          repository: context.read<MenuRepository>(),
                        )..add(ProductRequested(drinkId)),
                        child: ProductDetailScreen(drinkId: drinkId),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.orderHistoryPath,
                name: AppRoutes.orderHistory,
                builder: (context, state) => BlocProvider(
                  create: (context) => OrderHistoryBloc(
                    repository: context.read<OrderRepository>(),
                  )..add(const OrderHistoryRequested()),
                  child: const OrderHistoryScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profilePath,
                name: AppRoutes.profile,
                builder: (context, state) => BlocProvider(
                  create: (context) =>
                      ProfileBloc(repository: context.read<ProfileRepository>())
                        ..add(const ProfileRequested()),
                  child: const ProfileScreen(),
                ),
              ),
            ],
          ),
        ],
      ),

      // Cart and checkout sit above the shell: full-screen, no bottom nav,
      // because they are a linear flow the customer either completes or backs
      // out of.
      GoRoute(
        path: AppRoutes.cartPath,
        name: AppRoutes.cart,
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        path: AppRoutes.checkoutPath,
        name: AppRoutes.checkout,
        builder: (context, state) => BlocProvider(
          create: (context) {
            final bloc = CheckoutBloc(
              repository: context.read<CheckoutRepository>(),
            );
            // Seed with the cart snapshot the customer is confirming, so the
            // placed order matches exactly what was on screen.
            final cartState = context.read<CartBloc>().state;
            if (cartState is CartLoadSuccess) {
              bloc.add(
                CheckoutStarted(
                  items: cartState.items,
                  totals: cartState.totals,
                ),
              );
            }
            return bloc;
          },
          child: const CheckoutScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.orderConfirmationPath,
        name: AppRoutes.orderConfirmation,
        // The order arrives as `extra` straight from a successful placement.
        // A cold deep link has no order to show, so send the customer to their
        // history rather than rendering an empty receipt.
        redirect: (context, state) =>
            state.extra is Order ? null : AppRoutes.orderHistoryPath,
        builder: (context, state) =>
            OrderConfirmationScreen(order: state.extra! as Order),
      ),
    ],
  );

  /// Auth guard.
  ///
  /// Returns null (allow) while the startup session check is still resolving —
  /// `CoffeeApp` shows a splash for that window, and redirecting mid-check would
  /// flash the sign-in screen at a customer who is already signed in.
  String? _guard(BuildContext context, GoRouterState state) {
    final auth = _authBloc.state;
    if (auth.isResolving) return null;

    final onAuthRoute = AppRoutes.unauthenticatedPaths.contains(
      state.matchedLocation,
    );

    if (!auth.isAuthenticated) {
      return onAuthRoute ? null : AppRoutes.signInPath;
    }
    // Already signed in — no reason to sit on sign-in or sign-up.
    return onAuthRoute ? AppRoutes.menuPath : null;
  }
}
