import 'package:coffee_app/features/cart/application/cart_bloc.dart';
import 'package:coffee_app/features/cart/application/cart_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// StatefulNavigationShell, passed in by StatefulShellRoute.indexedStack.
import 'package:go_router/go_router.dart';

/// Bottom-navigation chrome around the three main branches.
///
/// Each branch keeps its own navigation stack (`StatefulShellRoute`), so
/// switching tabs and coming back returns to where the customer was.
class AppShell extends StatelessWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        // goBranch (not `go`) is what preserves each tab's stack. Re-tapping the
        // active tab resets that branch to its root, matching platform
        // convention.
        onDestinationSelected: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.local_cafe_outlined),
            selectedIcon: Icon(Icons.local_cafe_rounded),
            label: 'Menu',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long_rounded),
            label: 'Orders',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

/// Cart button with a live item-count badge, for a screen's `AppBar`.
///
/// Uses `BlocSelector` so it rebuilds only when the count changes — a full
/// `BlocBuilder` here would rebuild the badge on every unrelated cart change
/// (`/flutter-performance-audit`).
class CartAppBarButton extends StatelessWidget {
  const CartAppBarButton({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CartBloc, CartState, int>(
      selector: (state) => state.itemCount,
      builder: (context, itemCount) {
        return IconButton(
          onPressed: onPressed,
          tooltip: itemCount == 0
              ? 'Cart, empty'
              : 'Cart, $itemCount item${itemCount == 1 ? '' : 's'}',
          icon: Badge.count(
            count: itemCount,
            isLabelVisible: itemCount > 0,
            child: const Icon(Icons.shopping_bag_outlined),
          ),
        );
      },
    );
  }
}
