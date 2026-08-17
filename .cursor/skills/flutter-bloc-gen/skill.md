# Skill: flutter-bloc-gen

**Invocation:** `/flutter-bloc-gen [feature name/description]`

---

## Overview

`flutter-bloc-gen` scaffolds a `flutter_bloc` `Bloc` together with its sealed
event and state hierarchies — the state-owning layer between a screen/widget
and a repository. Event-driven `Bloc` is the state-management approach for
this app; `Cubit` is deliberately not used.

> **Renamed from the upstream `flutter-provider-gen`.** `flutter-platform`
> ships a Riverpod generator under that name. This app uses BLoC, so the skill
> was renamed and rewritten. See `memory-bank/architecture.md`.

**Memory references:** `memory-bank/techContext.md` (bloc/test package
versions), `memory-bank/architecture.md` (bloc placement and scoping).

**Guard rules:** `02-flutter-state-guard.mdc` (primary),
`01-flutter-architecture-guard.mdc` (placement).

---

## Steps

**Step 0 — Find the pattern.** Run `pattern-scout` for the nearest existing
`Bloc` in the same or a similar feature to match the event/state naming
scheme (`XxxRequested` / `XxxLoadInProgress` / `XxxLoadSuccess` /
`XxxLoadFailure`), how repository exceptions are mapped to failure states, and
the file layout (`application/xxx_bloc.dart` + `xxx_event.dart` +
`xxx_state.dart`).

**Step 1 — Enumerate the events before writing anything.** The event list
*is* the feature's API. Write it down first: what can the user do, and what
external triggers exist (an initial load, a refresh, a retry)? An event per
user intent — not an event per state field you want to set.

**Step 2 — Enumerate the state variants.** One sealed variant per genuinely
distinct UI shape. The default set for a data-backed feature is
initial / in-progress / success / failure, with the empty case expressed as a
success carrying an empty collection (not a separate `Empty` variant) unless
the empty screen is meaningfully different.

**Step 3 — Generate the event hierarchy** (`application/xxx_event.dart`),
sealed and `Equatable`, per `02-flutter-state-guard.mdc`:

```dart
sealed class CartEvent extends Equatable {
  const CartEvent();
  @override
  List<Object?> get props => const [];
}

final class CartRequested extends CartEvent {
  const CartRequested();
}

final class CartItemAdded extends CartEvent {
  const CartItemAdded(this.item);
  final CartItem item;
  @override
  List<Object?> get props => [item];
}

final class CartItemRemoved extends CartEvent {
  const CartItemRemoved(this.itemId);
  final String itemId;
  @override
  List<Object?> get props => [itemId];
}
```

**Step 4 — Generate the state hierarchy** (`application/xxx_state.dart`),
sealed and `Equatable`, with a display-ready message on the failure variant:

```dart
sealed class CartState extends Equatable {
  const CartState();
  @override
  List<Object?> get props => const [];
}

final class CartInitial extends CartState {
  const CartInitial();
}

final class CartLoadInProgress extends CartState {
  const CartLoadInProgress();
}

final class CartLoadSuccess extends CartState {
  const CartLoadSuccess({required this.items, required this.totals});
  final List<CartItem> items;
  final CartTotals totals;

  bool get isEmpty => items.isEmpty;

  @override
  List<Object?> get props => [items, totals];
}

final class CartLoadFailure extends CartState {
  const CartLoadFailure(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}
```

**Step 5 — Generate the bloc** (`application/xxx_bloc.dart`), registering one
handler per event in the constructor:

```dart
class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc({required CartRepository repository})
      : _repository = repository,
        super(const CartInitial()) {
    on<CartRequested>(_onRequested);
    on<CartItemAdded>(_onItemAdded);
    on<CartItemRemoved>(_onItemRemoved);
  }

  final CartRepository _repository;

  Future<void> _onRequested(CartRequested event, Emitter<CartState> emit) async {
    emit(const CartLoadInProgress());
    await _emitCart(emit);
  }

  Future<void> _onItemAdded(CartItemAdded event, Emitter<CartState> emit) async {
    try {
      await _repository.addItem(event.item);
    } on AppException catch (e) {
      emit(CartLoadFailure(e.message));
      return;
    }
    await _emitCart(emit);
  }

  Future<void> _emitCart(Emitter<CartState> emit) async {
    try {
      final items = await _repository.fetchItems();
      if (isClosed) return;
      emit(CartLoadSuccess(items: items, totals: CalculateCartTotals()(items)));
    } on AppException catch (e) {
      emit(CartLoadFailure(e.message));
    }
  }
}
```

**Step 6 — Catch typed exceptions, never let them escape.** Every repository
call sits inside `try`/`catch` on the app's `AppException` hierarchy and emits
an explicit failure state. An uncaught throw inside a handler becomes an
unhandled bloc error, not UI. Guard post-`await` emits with
`if (isClosed) return;`.

**Step 7 — Depend on the repository interface, not the implementation.** Take
`CartRepository` (abstract) as a constructor parameter; never construct
`FakeCartRepository()` or an API client inside the bloc. This is the seam the
tests fake and `RepositoryProvider` supplies.

**Step 8 — Keep pure business rules out of the bloc.** A bloc orchestrates:
it calls repositories, sequences work, and maps results to states. A pure
calculation (cart totals, drink price for a configuration, loyalty tier)
belongs in `domain/usecases/` and is called from the bloc — see
`01-flutter-architecture-guard.mdc`.

**Step 9 — Generate the test.** A `bloc_test` group per
`04-flutter-test-guard.mdc` asserting the emitted state sequence for **both**
a success and a failure path, with the repository mocked via `mocktail` or
substituted with the feature's `Fake*Repository`.

**Step 10 — Update memory-bank.** Note the new bloc and its events in
`memory-bank/activeContext.md` per the always-on `00-memory-think` rule.

---

## Example

Request: "Generate state management for the shopping cart with add/remove."

Output: `lib/features/cart/application/cart_bloc.dart`,
`cart_event.dart`, `cart_state.dart` (sealed `CartEvent`/`CartState`
hierarchies, handlers for `CartRequested`/`CartItemAdded`/`CartItemRemoved`,
each catching `AppException`), plus
`test/features/cart/application/cart_bloc_test.dart` covering the load
success sequence and a repository-failure sequence.
