# Domain Rules

**Tier 2 — standards, not a snapshot.** The rules the app enforces that aren't
obvious from the UI alone. A human decides what this says; skills read it as
ground truth.

Each rule below names where it is enforced, so a change has one home.

## Pricing

**A drink's price is `(base + size delta + milk delta + sum of extras) ×
quantity`.**
Enforced in `CalculateDrinkPrice`
(`lib/features/product/domain/usecases/calculate_drink_price.dart`). Not in a
widget, not in a bloc — the product screen, the cart, and checkout all call the
same use-case, which is why they can never disagree.

**Small is the reference size and costs nothing extra.** The price on the menu is
the small price; medium `+60¢`, large `+110¢`. Deltas live on `DrinkSize`.

**Non-dairy milk carries a surcharge; dairy and "no milk" do not.** Oat and
almond `+70¢`. Deltas live on `MilkOption`.

**Decaf is free.** Swapping to decaf is a preference, not an upsell — it is a
`DrinkExtra` with a zero delta, deliberately.

**A non-customisable item prices at base only.** A pastry has no size or milk, so
even if a `DrinkConfiguration` claims "large, oat milk, extra shot", those deltas
must be ignored. Enforced by the `!drink.category.isCustomisable` early return in
`CalculateDrinkPrice`, driven by `DrinkCategory.isCustomisable`. Without this, a
croissant could be sold as a "large oat croissant".

## Cart

**Tax applies to the whole subtotal and is rounded exactly once.**
`CalculateCartTotals` computes `subtotal`, then `tax = subtotal × rate` rounded
to the nearest cent, then `total = subtotal + tax`. This guarantees the invariant
**`subtotal + tax == total`**. Rounding per line instead produces a receipt that
does not add up — there is a regression test pinning this.

> **Open question for the team:** `CalculateCartTotals.defaultTaxRate` is a
> placeholder `0.0825`. A real deployment must resolve this per store or
> jurisdiction rather than hardcoding one rate.

**The same drink customised the same way is one line, not two.** Adding a latte
that matches an existing line's drink **and** configuration bumps that line's
quantity. Enforced in `InMemoryCartRepository.addItem` via
`CartItem.isSameLineAs`. Two identical rows in a cart is a bug.

**Differently-configured drinks are separate lines**, even for the same drink. A
large oat latte and a small whole-milk latte are two rows.

**A sold-out drink cannot be added.** `InMemoryCartRepository.addItem` throws
`ValidationException` when `!drink.isAvailable`. The product screen also disables
the button, but the repository is the enforcement point — the UI is a courtesy.

**Quantity is always ≥ 1.** Setting a line to zero is not how you remove it;
`updateQuantity` throws `ValidationException` and `removeItem` is the way.
Removing an id that isn't there is a **no-op, not an error** — a double-tap on
delete must not surface a failure.

**An empty cart cannot be checked out.** Enforced twice on purpose:
`CartLoadSuccess.canCheckout` disables the button, and
`FakeCheckoutRepository.placeOrder` throws `ValidationException` on empty items.

**The cart does not survive an app restart.** `InMemoryCartRepository` is
session-scoped.

> **Open question for the team:** persisting the cart means deciding what happens
> to a saved line whose drink has left the menu or changed price. Unanswered,
> which is why the cart is session-only today rather than by oversight.

## Checkout and orders

**An order is a snapshot, not a reference.** `Order` carries its own `items` and
`totals` copied at checkout. A receipt must keep showing what the customer
actually paid even after menu prices move. Never recompute an order's total from
today's prices.

**Checkout is placed from the cart snapshot the customer confirmed**, not from
whatever the cart holds when the request lands. `CheckoutStarted` seeds
`CheckoutBloc` with the items and totals, and `placeOrder` takes them as
arguments.

**A double-tap must not place two orders.** `CheckoutBloc._onSubmitted` returns
early when `isSubmitting` is already true. This is a charge-the-customer-twice
bug, which is why it is guarded in the bloc and not only by disabling the button.

**A failed order placement preserves everything the customer entered.** The bloc
returns to `CheckoutFormReady` with `submissionError` set and payment method,
pickup option, and note intact. Sending them back to a blank form after a network
blip is unacceptable.

**Placing an order clears the cart** — once, from the checkout screen's
`BlocListener` on `CheckoutSuccess`, by dispatching `CartCleared` to `CartBloc`.
The cart's writes stay owned by `CartBloc`.

**Every order gets a short pickup code** the customer shows at the counter,
assigned by `InMemoryOrderStore.add`. Readable at a counter and unambiguous
across the handful of orders open at once.

**Order history is most-recent-first.** `OrderRepository.fetchOrders`' contract;
`InMemoryOrderStore.orders` reverses insertion order to honour it.

**Nothing advances an order's status yet.** `OrderStatus` models the full
lifecycle (placed → preparing → ready → collected, plus cancelled) but a placed
order stays `placed`. Real status transitions need a backend.

## Auth

**A wrong password and an unknown account return the same error.** Both throw
`UnauthorizedException('Incorrect email or password.')`. Telling an attacker
which emails are registered is an account-enumeration leak.

**Emails are normalised** — trimmed and lowercased — before lookup or storage, so
`  SAM@Example.com  ` and `sam@example.com` are the same account.

**Passwords are at least 8 characters** at sign-up
(`FakeAuthRepository.signUp` throws `ValidationException`).

**A failed session restore is not an error to show the user.** If the startup
check throws, `AuthBloc` emits `AuthUnauthenticated` — a cold-start network blip
means the customer starts at sign-in, not that they see a scary dialog.

**Sign-out always succeeds from the user's perspective.** `AuthBloc` emits
`AuthUnauthenticated` even if clearing storage throws. Leaving someone signed in
because cleanup failed is the worse outcome.

## Loyalty

**100 points earns one free drink.** `UserProfile.pointsPerReward`.
`availableRewards`, `pointsToNextReward`, and `rewardProgress` are all derived
from `loyaltyPoints` on the entity — the profile screen only lays them out.

**Nothing awards points yet.** `FakeProfileRepository` returns a fixed 240. Point
accrual on order completion is not implemented.

> **Dev credentials** (fake backend only, no real secret):
> `sam@example.com` / `coffee123`.
