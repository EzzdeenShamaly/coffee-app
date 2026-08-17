# Progress

**Last Updated:** 2026-08-08

Tracks what's Done, In Progress, and Blocked, per feature. `/context-sync`
refreshes this; keep it current after every significant task per
`00-memory-think.mdc`. **Never re-implement something marked Done.**

## Done

- **Project scaffold** — `flutter create` for android+ios, feature-first `lib/`
  layout, `flutter_bloc` + `go_router` + `freezed` toolchain resolved and
  building. `flutter analyze` clean, 91 tests passing.
- **Platform config adapted to BLoC** — the copied `flutter-platform` ships
  Riverpod guidance; `02-flutter-state-guard.mdc`, `04-flutter-test-guard.mdc`,
  `flutter-bloc-gen` (renamed from `flutter-provider-gen`),
  `flutter-screen-gen`, `flutter-test-gen`, the auditors, the subagents, and the
  docs were all rewritten for BLoC. See `architecture.md` § Divergence.
- **`core/`** — `AppException` hierarchy, `Money` (int cents),
  `SecureTokenStore`.
- **`app/`** — composition root (`coffee_app.dart`), router with auth guard and
  three-branch bottom-nav shell, theme (light + dark), `AppShell` +
  `CartAppBarButton`.
- **`shared/widgets/`** — `AppLoadingIndicator`, `AppErrorView`, `AppEmptyView`,
  `QuantityStepper`.
- **auth** — `AppUser`, `AuthRepository` + `FakeAuthRepository` (exercises real
  secure storage, maps `PlatformException` → `AppException`), `AuthBloc`,
  sign-in and sign-up screens. Dev credentials: `sam@example.com` /
  `coffee123`.
- **menu** — `Drink`, `DrinkCategory`, `MenuRepository` +
  `FakeMenuRepository` (8 items, one deliberately sold out), `MenuBloc` with
  in-state category filtering (no refetch on chip tap), `MenuScreen`,
  `DrinkCard`, `CategoryFilterBar`.
- **product** — `DrinkSize`/`MilkOption`/`DrinkExtra`, `DrinkConfiguration`,
  `CalculateDrinkPrice` use-case, `ProductBloc`, `ProductDetailScreen` with
  size/milk/extras/quantity and add-to-cart.
- **cart** — `CartItem`, `CartTotals`, `CalculateCartTotals`,
  `CartRepository` + `InMemoryCartRepository` (merges identical
  drink+configuration into one line), `CartBloc`, `CartScreen`,
  `CartLineTile`, `CartSummaryCard`.
- **checkout** — `PaymentMethod`/`PickupOption`, `CheckoutRepository` +
  `FakeCheckoutRepository`, `CheckoutBloc` (double-submit guard, failure
  preserves the form), `CheckoutScreen`.
- **orders** — `Order`, `OrderStatus`, `InMemoryOrderStore` shared with
  checkout, `OrderRepository` + `FakeOrderRepository`, `OrderHistoryBloc`
  (pull-to-refresh keeps the list on screen), `OrderHistoryScreen`,
  `OrderConfirmationScreen`, `OrderTile`.
- **profile** — `UserProfile` with loyalty derivations, `ProfileRepository` +
  `FakeProfileRepository`, `ProfileBloc`, `ProfileScreen` with sign-out.

## In Progress

_(nothing — the scaffold is complete and green; pick the next item from Not
Started)_

## Not Started

- **Real backend.** Every repository is an in-memory fake. Swapping one is a
  one-line binding change in `coffee_app.dart`, but it needs an HTTP client
  (`dio` or `http`) added to `pubspec.yaml` first — which
  `10-evidence-and-dependency-guard.mdc` requires you to ask about.
- **Crash reporting.** Nothing is wired. This is a hard
  `/production-readiness-review` blocker before shipping.
- **Localization.** All strings are inline English literals; `Money.formatted`
  and `OrderTile._formatDate` are single-locale hand-rolled helpers.
- **Cart persistence.** `InMemoryCartRepository` loses the cart on restart. See
  `domainRules.md` for the open question this raises (a saved line whose drink
  left the menu or changed price).
- **Order status progression.** `OrderStatus` has the full lifecycle
  (placed → preparing → ready → collected) but nothing advances it; a placed
  order stays `placed` forever.
- **Widget-test coverage for four screens.** `MenuScreen` and `CartScreen` have
  full state-variant coverage; `ProductDetailScreen`, `CheckoutScreen`,
  `OrderHistoryScreen`, `ProfileScreen`, and the two auth screens have none.
  `/flutter-test-gen` is the tool for this.
- **`integration_test/`.** No end-to-end sign-in or checkout flow test.

## Blocked

_(nothing blocked)_

## Known deliberate gaps

These are decisions, not bugs — don't "fix" them without a conversation:

- No `Cubit` anywhere, by choice. Event traceability was the explicit reason.
- No DTO+mapper layer; entities carry their own JSON. See `architecture.md`.
- `OrderConfirmationScreen` takes the order via `extra` and redirects to history
  on a cold deep link rather than re-fetching.
