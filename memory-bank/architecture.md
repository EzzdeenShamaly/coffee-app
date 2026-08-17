# Architecture

**Tier 2 — standards, not a snapshot.** These are decisions. Skills and rules
read this as ground truth to check generated code against. Change it
deliberately, in a conversation — not as a side effect of a refactor.

Every decision below was made explicitly at project scaffold (2026-08-08).

## Folder convention: feature-first

```
lib/
  app/               composition root, router, theme, shell chrome
  core/              cross-cutting primitives with no feature knowledge
  features/
    <feature>/
      presentation/   screens/, widgets/
      application/    <feature>_bloc.dart, _event.dart, _state.dart
      domain/         entities/, repositories/ (interfaces), usecases/
      data/           repositories/ (implementations)
  shared/            cross-feature widgets and utilities
```

**Why feature-first over layered:** a coffee app has clean seams (menu, cart,
orders, auth). Each feature stays self-contained and deletable. Layered would
have put all seven features' screens in one flat `presentation/` pile with
boundaries existing only by naming convention.

The seven features are: `auth`, `menu`, `product`, `cart`, `checkout`, `orders`,
`profile`.

**`core/` vs `shared/`:** `core/` holds primitives that know nothing about any
feature (`AppException`, `Money`, `SecureTokenStore`). `shared/` holds widgets
used by more than one feature (`AppErrorView`, `QuantityStepper`). If it imports
a feature, it belongs in neither.

## Dependency direction

One-way, always: **presentation → application → domain → (domain interface) ←
data**.

- A widget never constructs a repository or calls one directly. It dispatches an
  event.
- A repository implementation never imports a widget.
- A bloc depends on the **abstract** repository interface, injected via
  constructor.

**Cross-feature rule:** a feature may depend on another feature's **domain
interface**, and nothing else. `ProductBloc` takes `MenuRepository` because "one
drink" is a read of the menu, not a separate resource — that is allowed.
`FakeProfileRepository` takes `AuthRepository` to resolve the current user —
also allowed. Importing another feature's widgets, blocs, or `data/`
implementations is not.

## State management: event-driven Bloc

`flutter_bloc`, **`Bloc` everywhere, no `Cubit`.** The reason is traceability:
every state transition has a named event, so what the user actually did is a
first-class testable value and shows up in `onTransition` logging. A `Cubit`'s
method call leaves no such record.

Events and states are **sealed hierarchies extending `Equatable`**. Sealed gives
exhaustive `switch` in the UI — adding a state variant becomes a compile error
rather than a silently blank screen. `Equatable` makes `bloc_test`'s `expect:`
compare by value.

**Bloc scope — exactly two blocs are app-wide**, provided in
`lib/app/coffee_app.dart`:

| Bloc | Why app-wide |
|---|---|
| `AuthBloc` | The router's `redirect` guard reads its state |
| `CartBloc` | Three separate readers: nav badge, cart screen, checkout |

Everything else is created in its route's `builder` and dies with the route, so
leaving a flow discards its state. **Do not add a third app-wide bloc without
revisiting this table.**

Full conventions — emit discipline, `BlocListener` for side effects,
`BlocSelector` for narrow rebuilds, `setState` boundaries — live in
`.cursor/rules/02-flutter-state-guard.mdc`.

## Business rules live in `domain/usecases/`

A bloc **orchestrates**: it calls repositories, sequences work, and maps results
to states. A pure calculation is a use-case class with a `call` method:

- `CalculateDrinkPrice` — base + size + milk + extras, × quantity
- `CalculateCartTotals` — subtotal, tax, total, unit count

This keeps pricing testable without a bloc, and reusable by the product screen,
the cart, and checkout without any of them duplicating it. A `fold` over prices
inside a widget's `build()` is a layering violation.

## Error handling: one hierarchy

`lib/core/error/app_exception.dart` is the **only** failure hierarchy:
`NetworkException`, `NotFoundException`, `UnauthorizedException`,
`ValidationException`, `UnexpectedException`.

Repositories map everything onto these — HTTP errors, and equally
`PlatformException` from secure storage. Blocs catch `on AppException` and emit a
failure state carrying a **display-ready** `message`. Widgets render that message
without formatting it.

**Do not add per-resource exception families** (`OrderNotFoundException`,
`CartNetworkException`). Seven features × three exception classes is duplication
that buys nothing, and it breaks the single `on AppException` catch.

## Entities carry their own JSON — no DTO layer

Domain entities are `freezed` classes with `fromJson`/`toJson` and
`@JsonKey(name:)` for snake_case wire fields. There is deliberately **no**
separate DTO + mapper layer.

**The trade-off, stated honestly:** a strict reading of layered architecture
wants the domain ignorant of serialization. We accepted the coupling because it
halves the file count and eliminates a mapper per entity that would, today, be a
field-for-field copy. If the API shape ever diverges meaningfully from the domain
shape — a field the UI must not see, one entity assembled from two endpoints —
introduce DTOs **for that entity only**, and record it here.

## Money is integer cents

`lib/core/money/money.dart`. Prices are `int` minor units, never `double` —
`0.1 + 0.2 != 0.3` in binary floating point, and a cart that sums doubles drifts.
Entities store `...PriceCents` fields (exact JSON round-trip) and expose a
`Money` getter for arithmetic. Formatting happens only at the edge.

Tax is applied to the whole subtotal and rounded **once**, which is what
guarantees `subtotal + tax == total`. See `domainRules.md`.

## Navigation

`go_router`. Router in `lib/app/router/app_router.dart`, path and name constants
in `app_routes.dart`. **Navigate by name**, never a literal path string.

- `StatefulShellRoute.indexedStack`, three branches (menu, orders, profile),
  each keeping its own stack.
- Product detail nests **under** the menu branch, so backing out returns to the
  menu and the nav bar stays visible.
- Cart and checkout sit **above** the shell — full-screen, no bottom nav, because
  they are a linear flow you complete or abandon.
- Blocs are provided in the route's `builder`, which is what makes route scope
  and bloc lifetime the same thing.

**Auth guard:** one top-level `redirect` (`AppRouter._guard`) reading
`AuthBloc.state`. Routes are protected **by default** — a new route needs no
guard code. Only paths in `AppRoutes.unauthenticatedPaths` are open. The guard
returns `null` while `isResolving` so the startup session check doesn't flash
sign-in at a signed-in user.

## Composition root

`lib/app/coffee_app.dart` is **the only file that names a concrete repository
implementation.** Everything else depends on the interface. Swapping
`FakeMenuRepository` for an API-backed one is a one-line change there.

Repositories and blocs are built in `initState`, not `build()` — rebuilding them
would discard the session and reset navigation.

## Divergence from the upstream platform

This repo carries a copy of `flutter-platform`, which ships **Riverpod**
guidance. It was deliberately rewritten for BLoC:

| Changed | What |
|---|---|
| `02-flutter-state-guard.mdc` | Rewritten: Bloc/sealed events/emit discipline/`BlocProvider` scoping |
| `04-flutter-test-guard.mdc` | Rewritten: `bloc_test`, `MockBloc`, `registerFallbackValue` |
| `flutter-provider-gen` | **Renamed** to `flutter-bloc-gen` and rewritten |
| `flutter-screen-gen`, `flutter-test-gen`, `feature-trace` | Rewritten for BLoC |
| `flutter-repository-gen`, `flutter-route-gen`, `flutter-performance-audit`, `flutter-architecture-audit`, `flutter-dependency-audit`, `repo-discovery`, `context-sync`, `production-readiness-review`, `flutter-widget-gen`, `flutter-model-gen` | Riverpod examples and steps replaced |
| `01-`, `00-`, `05-`, `10-` rules | Riverpod examples replaced |
| `flutter-auditor`, `pattern-scout`, `repo-cartographer` subagents | Checks restated for BLoC |
| `AGENTS.md`, `CLAUDE.md`, `START-HERE.md`, `skill-catalog.md` | Updated |

**Do not "restore" Riverpod guidance** from the upstream `flutter-platform` copy
at `e:\repo\flutter-platform` — that folder is intentionally left as a pristine
Riverpod template for other projects.
