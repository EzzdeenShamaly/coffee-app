# Skill: feature-trace

**Invocation:** `/feature-trace "[screen/flow name]"`

---

## Overview

`feature-trace` answers "how does this screen/flow actually work today" by
tracing the real widget tree, bloc wiring, and repository calls behind it —
from route entry to data source — rather than guessing from file names. In this
app the trace is: route → `BlocProvider` created there → screen widget → state
variants it renders → events it dispatches → the handlers those events run →
repositories those handlers call → the data source underneath, plus any
navigation the flow triggers.

**Memory references:** `memory-bank/architecture.md`.

**Guard rules:** none — read-only tracing.

---

## Steps

**Step 0 — Locate the entry point.** Find the route (`go_router` `GoRoute` in
`lib/app/router/app_router.dart`) or the widget that starts the flow. If the
request names a screen, Glob for its file directly; if it names a user-facing
flow ("checkout"), start from the route table and follow forward.

**Step 1 — Note what the route provides.** Read the route's `builder`. Which
bloc does it create, which repository does it read from `context.read<...>()`,
and does it dispatch a seed event immediately (`..add(const XRequested())`)?
This is also where you learn the bloc's **scope** — route-scoped, or one of the
app-wide blocs in `CoffeeApp`.

**Step 2 — Trace the widget tree.** Read the screen widget. List:
- every bloc it reads (`BlocBuilder`, `BlocSelector`, `context.watch`)
- every event it dispatches, and from which control
- every `BlocListener` and the side effect it performs (navigation, snackbar)
- every navigation call (`context.go`/`push`/`pop`) and where each leads

**Step 3 — Enumerate the state variants and what each renders.** The sealed
state hierarchy *is* the screen's contract. List each variant and the UI it
produces — including which variant handles empty data. A variant with no branch
in the screen's `switch` is a bug, not a gap in the trace.

**Step 4 — Trace each event handler to its repository call(s).** For each
`on<Event>` handler: which repository methods it calls, in what order, which
states it emits along the way, and what it emits on failure (which
`AppException` subclasses it catches and what message reaches the UI).

**Step 5 — Trace the repository to its data source.** Which implementation is
bound in `CoffeeApp`, the endpoint or in-memory store behind it, and how errors
are mapped onto `AppException`.

**Step 6 — Produce the trace report.**

```markdown
## Feature Trace — Checkout Flow

**Entry:** `GoRoute('/checkout')` → `CheckoutScreen`
(`lib/features/checkout/presentation/screens/checkout_screen.dart`)

**Route provides:** `CheckoutBloc(repository: context.read<CheckoutRepository>())`,
seeded with `CheckoutStarted(items, totals)` read from the app-wide `CartBloc`.
Route-scoped, so backing out discards a half-filled form.

**Widget → events:**
- Pickup/payment `RadioGroup`s dispatch `CheckoutPickupOptionSelected` /
  `CheckoutPaymentMethodSelected`
- The note field dispatches `CheckoutNoteChanged`
- "Place order" dispatches `CheckoutSubmitted`
- `BlocListener` on `CheckoutSuccess` dispatches `CartCleared` to `CartBloc`
  and navigates to `/order-confirmation/:orderId` with the order as `extra`

**State variants rendered:**
- `CheckoutInitial` → spinner
- `CheckoutFormReady` → the form; `isSubmitting` swaps the button to a spinner,
  `submissionError` renders an inline error banner above the summary
- `CheckoutSuccess` → spinner (terminal; the listener is navigating away)

**Events → repository:**
- `CheckoutSubmitted` → guards re-entry on `isSubmitting`, emits
  `isSubmitting: true`, calls
  `CheckoutRepository.placeOrder(items, totals, paymentMethod, pickupOption, note)`
  → `CheckoutSuccess(order)`; on `AppException` returns to the form with
  `submissionError` and every selection intact

**Repository → data source:**
- `FakeCheckoutRepository` → writes into the shared `InMemoryOrderStore`
  (the same instance `FakeOrderRepository` reads, which is why a placed order
  appears in history)

**Files touched by this flow (8):** [list]
```

---

## Example

Request: `/feature-trace "checkout"` — produces the report above, giving the
caller everything needed before making a change (`/impact-analysis` next)
without re-deriving it from scratch.
