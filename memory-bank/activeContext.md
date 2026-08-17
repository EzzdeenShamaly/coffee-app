# Active Context

**Last Updated:** 2026-08-08

What's being worked on right now, updated after every significant task per
`00-memory-think.mdc`. This file is meant to be touched constantly — don't be
precious about overwriting the previous entry.

## Current focus

Project scaffold is complete and green: 7 feature slices, `flutter analyze`
clean, 91 tests passing. Nothing is mid-flight.

## Last change

Scaffolded the whole app from scratch, and adapted the copied
`flutter-platform` config from Riverpod to BLoC.

**App** — feature-first `lib/` with `app/`, `core/`, `shared/`, and 7 features
(auth, menu, product, cart, checkout, orders, profile). Event-driven `Bloc`
everywhere with sealed `Equatable` events and state variants. `go_router` with a
single top-level auth guard and a three-branch bottom-nav shell. All
repositories are in-memory fakes bound in `lib/app/coffee_app.dart`.

**Platform** — rewrote `02-flutter-state-guard.mdc` and
`04-flutter-test-guard.mdc` for BLoC, renamed `flutter-provider-gen` →
`flutter-bloc-gen` (shims regenerated via `sync-skills.mjs`), rewrote
`flutter-screen-gen` / `flutter-test-gen` / `feature-trace`, and swept Riverpod
language out of the auditors, subagents, and docs.

**One real defect found and fixed along the way:** `FakeAuthRepository` let
`flutter_secure_storage`'s `PlatformException` escape, but `AuthBloc` catches
only `AppException` — a locked Keychain would have become an unhandled bloc
error instead of a sign-in failure. Now mapped, with three regression tests.

## Next step

Pick one from `progress.md` § Not Started. The two highest-value:

1. **Backfill widget tests** for the six screens that have none
   (`ProductDetailScreen`, `CheckoutScreen`, `OrderHistoryScreen`,
   `ProfileScreen`, sign-in, sign-up) via `/flutter-test-gen`. Cheapest way to
   raise confidence, and needs no new dependencies.
2. **Decide the backend story.** Every repository is a fake; going real needs an
   HTTP client added to `pubspec.yaml`, which requires explicit sign-off under
   `10-evidence-and-dependency-guard.mdc`.

Before shipping anything to a store, `/production-readiness-review` will fail on
missing crash reporting — worth knowing now rather than at submission.

## Open questions for the team

- **Tax rate.** `CalculateCartTotals.defaultTaxRate` is a placeholder `0.0825`.
  Real deployments need this per store/jurisdiction, not hardcoded.
- **Cart persistence semantics.** If the cart is persisted across restarts, what
  happens to a saved line whose drink left the menu or changed price? Unanswered,
  which is why the cart is session-only today.
