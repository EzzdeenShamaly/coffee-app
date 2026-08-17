# Skill: flutter-screen-gen

**Invocation:** `/flutter-screen-gen [screen name/description]`

---

## Overview

`flutter-screen-gen` generates a full screen: the screen widget itself, the
`Bloc` backing its state, and the `go_router` route registration wiring it in
— in one pass, so the screen is reachable and functional immediately rather
than left as an orphaned widget.

> **Adapted from the upstream Riverpod version.** This app uses `flutter_bloc`
> — see the note in `02-flutter-state-guard.mdc`.

**Memory references:** `memory-bank/architecture.md`,
`memory-bank/techContext.md`, `memory-bank/domainRules.md`

**Guard rules:** `01-flutter-architecture-guard.mdc`,
`02-flutter-state-guard.mdc`, `04-flutter-test-guard.mdc`.

**Depends on:** `flutter-bloc-gen` (Step 2), `flutter-route-gen` (Step 4) —
this skill orchestrates both rather than duplicating their logic.

---

## Steps

**Step 0 — Find the pattern.** Run `pattern-scout` for the nearest existing
screen in the same feature area (or the closest structural analog) to match
folder layout, bloc wiring, the `switch`-over-sealed-state shape, and
`AppBar`/scaffold conventions already established.

**Step 1 — Confirm scope with the user (planning-rigor applies).** If the
screen has non-trivial state or navigation implications, run the elicitation
pass from `05-planning-rigor.mdc` before generating (event list, whether data
is fetched on entry vs passed in, error-handling shape).

**Step 2 — Generate the backing bloc.** Delegate to `flutter-bloc-gen`'s
pattern: sealed events, sealed state variants, and a `Bloc` that owns the
screen's data and the operations the screen triggers.

**Step 3 — Generate the screen widget.** The screen is a `StatelessWidget`
that reads state with `BlocBuilder` and dispatches with `context.read`:

```dart
class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order History')),
      body: BlocBuilder<OrderHistoryBloc, OrderHistoryState>(
        builder: (context, state) {
          return switch (state) {
            OrderHistoryInitial() ||
            OrderHistoryLoadInProgress() => const AppLoadingIndicator(),
            OrderHistoryLoadFailure(:final message) => AppErrorView(
                message: message,
                onRetry: () => context
                    .read<OrderHistoryBloc>()
                    .add(const OrderHistoryRequested()),
              ),
            OrderHistoryLoadSuccess(:final orders) when orders.isEmpty =>
              const AppEmptyView(message: 'No orders yet.'),
            OrderHistoryLoadSuccess(:final orders) => ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, i) => OrderTile(order: orders[i]),
              ),
          };
        },
      ),
    );
  }
}
```

Every screen handles all state variants explicitly — in-progress, failure with
retry, and success including the empty-collection case. A screen that only
handles the happy path is incomplete. Use an exhaustive `switch` with **no
`default` branch**, so adding a state variant later is a compile error rather
than a silently blank screen.

**Step 4 — Register the route.** Delegate to `flutter-route-gen`'s pattern to
add the `GoRoute` entry, including path parameters and the `redirect`/guard
logic if the screen requires auth. Provide the screen's bloc in the route's
`builder` so its lifetime is the route's:

```dart
GoRoute(
  path: 'orders',
  name: AppRoutes.orderHistory,
  builder: (context, state) => BlocProvider(
    create: (context) => OrderHistoryBloc(
      repository: context.read<OrderRepository>(),
    )..add(const OrderHistoryRequested()),
    child: const OrderHistoryScreen(),
  ),
),
```

**Step 5 — Side effects go in a `BlocListener`.** Navigation after a
successful submit, snackbars, and dialogs belong in `listener:`, never in
`builder:` — a `builder:` that navigates fires on every rebuild. Use
`BlocConsumer` if the screen needs both.

**Step 6 — Generate tests.** Widget tests per `04-flutter-test-guard.mdc`
covering in-progress, failure+retry, empty, and populated states — not just
the happy path. Pin an exact state with `MockBloc` where the test is about
rendering.

**Step 7 — Update memory-bank.** Note the new screen and its route in
`memory-bank/activeContext.md` per the always-on `00-memory-think` rule.

---

## Example

Request: "Generate an order history screen."

Output: `lib/features/orders/presentation/screens/order_history_screen.dart`,
bloc + event + state in `lib/features/orders/application/`, a `GoRoute` added
to the router config, and
`test/features/orders/presentation/order_history_screen_test.dart` covering
all four state variants.
