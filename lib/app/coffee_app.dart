import 'package:coffee_app/app/router/app_router.dart';
import 'package:coffee_app/app/theme/app_theme.dart';
import 'package:coffee_app/core/storage/secure_token_store.dart';
import 'package:coffee_app/features/auth/application/auth_bloc.dart';
import 'package:coffee_app/features/auth/application/auth_event.dart';
import 'package:coffee_app/features/auth/application/auth_state.dart';
import 'package:coffee_app/features/auth/data/repositories/fake_auth_repository.dart';
import 'package:coffee_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:coffee_app/features/cart/application/cart_bloc.dart';
import 'package:coffee_app/features/cart/application/cart_event.dart';
import 'package:coffee_app/features/cart/data/repositories/in_memory_cart_repository.dart';
import 'package:coffee_app/features/cart/domain/repositories/cart_repository.dart';
import 'package:coffee_app/features/checkout/data/repositories/fake_checkout_repository.dart';
import 'package:coffee_app/features/checkout/domain/repositories/checkout_repository.dart';
import 'package:coffee_app/features/menu/data/repositories/fake_menu_repository.dart';
import 'package:coffee_app/features/menu/domain/repositories/menu_repository.dart';
import 'package:coffee_app/features/orders/data/in_memory_order_store.dart';
import 'package:coffee_app/features/orders/data/repositories/fake_order_repository.dart';
import 'package:coffee_app/features/orders/domain/repositories/order_repository.dart';
import 'package:coffee_app/features/profile/data/repositories/fake_profile_repository.dart';
import 'package:coffee_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Composition root.
///
/// **This is the only file that names a concrete repository implementation.**
/// Every bloc, screen, and use-case depends on the abstract interface, so
/// swapping `FakeMenuRepository` for an API-backed one is a one-line change here
/// and nothing else moves (`01-flutter-architecture-guard.mdc`).
class CoffeeApp extends StatefulWidget {
  const CoffeeApp({super.key});

  @override
  State<CoffeeApp> createState() => _CoffeeAppState();
}

class _CoffeeAppState extends State<CoffeeApp> {
  // Built once in initState, not in build(): a new AuthBloc or router on every
  // rebuild would discard the session and reset navigation.
  late final SecureTokenStore _tokenStore;
  late final AuthRepository _authRepository;
  late final MenuRepository _menuRepository;
  late final CartRepository _cartRepository;
  late final CheckoutRepository _checkoutRepository;
  late final OrderRepository _orderRepository;
  late final ProfileRepository _profileRepository;

  late final AuthBloc _authBloc;
  late final CartBloc _cartBloc;
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();

    _tokenStore = const SecureTokenStore(FlutterSecureStorage());
    _authRepository = FakeAuthRepository(tokenStore: _tokenStore);
    _menuRepository = const FakeMenuRepository();
    _cartRepository = InMemoryCartRepository();

    // One store shared by the writer (checkout) and the reader (orders), so a
    // placed order shows up in history without a backend.
    final orderStore = InMemoryOrderStore();
    _checkoutRepository = FakeCheckoutRepository(store: orderStore);
    _orderRepository = FakeOrderRepository(store: orderStore);

    _profileRepository = FakeProfileRepository(authRepository: _authRepository);

    _authBloc = AuthBloc(repository: _authRepository)..add(const AuthStarted());
    _cartBloc = CartBloc(repository: _cartRepository)
      ..add(const CartRequested());

    _appRouter = AppRouter(authBloc: _authBloc);
  }

  @override
  void dispose() {
    _authBloc.close();
    _cartBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      // Repositories are exposed as their interfaces — a route's `create:` reads
      // `context.read<MenuRepository>()` and never learns the concrete type.
      providers: [
        RepositoryProvider<AuthRepository>.value(value: _authRepository),
        RepositoryProvider<MenuRepository>.value(value: _menuRepository),
        RepositoryProvider<CartRepository>.value(value: _cartRepository),
        RepositoryProvider<CheckoutRepository>.value(
          value: _checkoutRepository,
        ),
        RepositoryProvider<OrderRepository>.value(value: _orderRepository),
        RepositoryProvider<ProfileRepository>.value(value: _profileRepository),
      ],
      child: MultiBlocProvider(
        // The only two app-wide blocs. Everything else is route-scoped.
        providers: [
          BlocProvider<AuthBloc>.value(value: _authBloc),
          BlocProvider<CartBloc>.value(value: _cartBloc),
        ],
        child: BlocBuilder<AuthBloc, AuthState>(
          // Only the startup session check matters here; rebuilding the whole
          // MaterialApp on every auth change would tear down navigation.
          buildWhen: (previous, current) =>
              previous.isResolving != current.isResolving,
          builder: (context, authState) {
            if (authState.isResolving) {
              return const _SplashApp();
            }

            return MaterialApp.router(
              title: 'Coffee',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              routerConfig: _appRouter.router,
            );
          },
        ),
      ),
    );
  }
}

/// Shown while the stored session is being restored, so the customer never sees
/// the sign-in screen flash before landing on the menu.
class _SplashApp extends StatelessWidget {
  const _SplashApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      home: const Scaffold(
        body: Center(
          child: CircularProgressIndicator(semanticsLabel: 'Starting up'),
        ),
      ),
    );
  }
}
