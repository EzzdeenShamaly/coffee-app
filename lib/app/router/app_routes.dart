/// Route paths and names in one place.
///
/// Screens navigate by **name** (`context.goNamed(AppRoutes.cart)`) so a path
/// can change without touching call sites. Paths are here too because
/// `go_router` needs them at declaration time.
abstract final class AppRoutes {
  const AppRoutes._();

  // --- Auth (outside the shell: no bottom nav on sign-in) ---
  static const signIn = 'sign-in';
  static const signInPath = '/sign-in';

  static const signUp = 'sign-up';
  static const signUpPath = '/sign-up';

  // --- Shell branches (bottom navigation) ---
  static const menu = 'menu';
  static const menuPath = '/menu';

  static const orderHistory = 'order-history';
  static const orderHistoryPath = '/orders';

  static const profile = 'profile';
  static const profilePath = '/profile';

  // --- Pushed over the shell ---
  static const product = 'product';

  /// Nested under the menu branch so backing out returns to the menu.
  static const productPath = 'drink/:drinkId';
  static const productParamId = 'drinkId';

  static const cart = 'cart';
  static const cartPath = '/cart';

  static const checkout = 'checkout';
  static const checkoutPath = '/checkout';

  static const orderConfirmation = 'order-confirmation';

  /// Deliberately not nested under `/orders` — a sibling path there would sit
  /// ambiguously against the order-history shell branch.
  static const orderConfirmationPath = '/order-confirmation/:orderId';
  static const orderConfirmationParamId = 'orderId';

  /// Routes reachable without a session. Everything else redirects to sign-in.
  static const unauthenticatedPaths = {signInPath, signUpPath};
}
