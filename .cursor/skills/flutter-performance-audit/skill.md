# Skill: flutter-performance-audit

**Invocation:** `/flutter-performance-audit [scope]`

---

## Overview

`flutter-performance-audit` scans for the common causes of janky Flutter
UIs: missing `const`, unnecessary widget rebuilds from an over-broad
`BlocBuilder`, `ListView`/`Column` used where `ListView.builder` is needed,
unbounded/unmanaged image caching, and expensive work in `build()`.
Read-only — produces a findings report with concrete fixes.

**Memory references:** none required beyond the target files themselves —
this audit is mechanical, not convention-dependent.

**Guard rules:** `02-flutter-state-guard.mdc` (rebuild scope).

---

## Steps

**Step 1 — Missing `const`.** Grep for widget constructors that could be
`const` but aren't — a `Container`/`Text`/`Icon`/`SizedBox` instantiated
with only literal arguments and no `const` keyword. Flutter's analyzer
(`prefer_const_constructors` lint) catches most of this if enabled; check
`analysis_options.yaml` first and only report what the analyzer isn't
already configured to catch, to avoid duplicate noise.

**Step 2 — Over-broad `BlocBuilder`.** Look for a `BlocBuilder` (or
`context.watch`) where only a single field of a larger state is used in the
returned subtree — this rebuilds the whole subtree on any state change, not just
the field used. Recommend `BlocSelector`, or `buildWhen` when the widget needs
the full state but only on certain transitions:

```dart
// ❌ rebuilds the whole row on any CartState change
BlocBuilder<CartBloc, CartState>(
  builder: (context, state) => Badge.count(count: state.itemCount, ...),
)

// ✓ rebuilds only when the count actually changes
BlocSelector<CartBloc, CartState, int>(
  selector: (state) => state.itemCount,
  builder: (context, itemCount) => Badge.count(count: itemCount, ...),
)
```

Also flag a `BlocBuilder` wrapping an entire `Scaffold` where only the `body`
depends on state — the `AppBar` and `bottomNavigationBar` are being rebuilt for
nothing.

**Step 2b — Side effects in `builder`.** A `builder:` that navigates, shows a
snackbar, or dispatches an event is both a correctness bug and a performance
one: it re-fires on every rebuild. These belong in a `BlocListener`
(`02-flutter-state-guard.mdc`).

**Step 3 — List rendering.** Grep for `ListView(children: [...])` or
`Column(children: list.map(...).toList())` built from a collection whose
length isn't small and fixed (roughly: more than ~20 items, or any
API-fetched/paginated list) — flag as needing `ListView.builder`/
`SliverList.builder` so off-screen items aren't built eagerly.

**Step 4 — Image caching.** Check `Image.network` usage for a
`cacheWidth`/`cacheHeight` hint on images displayed at a much smaller size
than their source resolution (avoids decoding a full-resolution image into
memory just to downscale it for a thumbnail), and check that a caching
package (`cached_network_image`, if already in `pubspec.yaml`) is used
consistently rather than mixed with bare `Image.network` across the app.

**Step 5 — Expensive work in `build()`.** Grep for sorting, filtering, JSON
parsing, or date formatting performed inline inside a `build()` method on
every rebuild rather than memoized in a provider or computed once and
cached — `build()` should be cheap and side-effect-free.

**Step 6 — Report.**

```markdown
## Flutter Performance Audit — [scope]

| Severity | File | Issue | Fix |
|---|---|---|---|
| Medium | lib/features/orders/presentation/order_list.dart:22 | `Column` built from full order list (paginated, avg 40+ items) | Convert to `ListView.builder` |
| Low | lib/features/cart/presentation/cart_item_tile.dart:12 | `Padding`/`Text` with literal args, no `const` | Add `const` |

### Summary
[N] findings. None of these change behavior — verify with
`flutter test`/manual smoke test after applying fixes, per
`09-minimal-changes.mdc` (const/rebuild-scope fixes only, no unrelated
reformatting).
```

---

## Example

Request: "Audit the order list screen for performance issues."

Output: findings scoped to that screen, prioritizing the `ListView.builder`
conversion (biggest jank risk on a long list) over `const` additions
(smaller, but still reported for completeness).
