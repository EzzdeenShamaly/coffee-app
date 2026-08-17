# Skill: flutter-route-gen

**Invocation:** `/flutter-route-gen [route path/screen]`

---

## Overview

`flutter-route-gen` registers a new route in the app's `go_router`
configuration — path, name, builder, any path/query parameters, and an
auth guard via `redirect` if the route requires it. Used standalone for a
route added to an existing screen, or as Step 4 of `flutter-screen-gen`.

**Memory references:** `memory-bank/architecture.md` (router file
location, guard convention).

**Guard rules:** `01-flutter-architecture-guard.mdc`.

---

## Steps

**Step 0 — Confirm `go_router` is the routing package in use.** Check
`pubspec.yaml`. If the repo uses `Navigator` 1.0/2.0 directly or another
package, follow that existing convention instead — do not introduce
`go_router` to a repo that doesn't already use it.

**Step 1 — Find the router configuration file** (commonly
`lib/router/app_router.dart` or `lib/routing/router.dart` — confirm via
Glob rather than assuming the path).

**Step 2 — Add the route.**

```dart
GoRoute(
  path: '/orders/:orderId',
  name: 'orderDetail',
  builder: (context, state) {
    final orderId = state.pathParameters['orderId']!;
    return OrderDetailScreen(orderId: orderId);
  },
),
```

- Path parameters are extracted via `state.pathParameters`, never parsed
  by hand from the raw path string.
- Use `name:` and navigate with `context.goNamed(...)`/`pushNamed(...)`
  rather than hardcoded path strings scattered across the codebase — this
  is what keeps a later path change a one-line edit.

**Step 3 — Add an auth/eligibility guard if required.** If the screen
requires authentication, use the router's existing `redirect` mechanism
(a top-level `redirect` checking auth state, or a per-route guard if the
repo already has that pattern) — do not add a second, inconsistent
ad-hoc check inside the screen's `initState`/`build`.

This app already has that guard: `AppRouter._guard` reads `AuthBloc.state` and
`AppRoutes.unauthenticatedPaths`. A new protected route needs **no new code** —
it is protected by default, because the guard redirects anything not in that
set. Only add a path to `unauthenticatedPaths` if the screen must be reachable
without a session.

```dart
String? _guard(BuildContext context, GoRouterState state) {
  final auth = _authBloc.state;
  // Still restoring the stored session — CoffeeApp shows a splash for this
  // window, and redirecting now would flash sign-in at a signed-in customer.
  if (auth.isResolving) return null;

  final onAuthRoute =
      AppRoutes.unauthenticatedPaths.contains(state.matchedLocation);

  if (!auth.isAuthenticated) return onAuthRoute ? null : AppRoutes.signInPath;
  return onAuthRoute ? AppRoutes.menuPath : null;
}
```

The router re-runs this on auth changes via
`refreshListenable: GoRouterRefreshStream(_authBloc.stream)` — a bloc is a
stream, not a `Listenable`, so that adapter is what makes a sign-out bounce the
customer off a protected screen immediately.

**Step 3b — Provide the screen's bloc in the route's `builder`.** A new route
that needs state creates its bloc there, reading the repository from
`context.read<XRepository>()`, so the bloc's lifetime is the route's:

```dart
GoRoute(
  path: AppRoutes.orderHistoryPath,
  name: AppRoutes.orderHistory,
  builder: (context, state) => BlocProvider(
    create: (context) =>
        OrderHistoryBloc(repository: context.read<OrderRepository>())
          ..add(const OrderHistoryRequested()),
    child: const OrderHistoryScreen(),
  ),
),
```

**Step 4 — Nested routes / shell routes.** If the new screen belongs under
a bottom-nav or tab shell, add it as a child of the existing
`ShellRoute`/`StatefulShellRoute` rather than as a top-level route that
would escape the shell's persistent UI.

**Step 5 — Generate a navigation test.** A test asserting that navigating
to the route's path (or calling `goNamed`) renders the expected screen, and
— if a guard was added — that an unauthenticated navigation redirects
correctly.

---

## Example

Request: "Add a route for the order detail screen at /orders/:orderId,
requires login."

Output: `GoRoute` added to the existing router config under the appropriate
`StatefulShellBranch`, path and name constants added to `AppRoutes`, the
screen's bloc provided in the route's `builder`, protection inherited from
`AppRouter._guard` (no new guard code), and a routing test asserting an
unauthenticated navigation redirects to `/sign-in`.
