# Skill: flutter-test-gen

**Invocation:** `/flutter-test-gen [target file/widget/bloc/repository]`

---

## Overview

`flutter-test-gen` scaffolds widget or unit tests for an existing
widget/screen/bloc/repository that doesn't have coverage yet, following
`04-flutter-test-guard.mdc` — `bloc_test` for blocs, a provided bloc over a
faked repository for widget tests, `MockBloc` for pinning an exact render
state. Other `*-gen` skills already generate a test alongside new code; this
skill is for backfilling tests onto existing code, or expanding coverage an
audit flagged as thin.

> **Adapted from the upstream Riverpod version.** This app uses `flutter_bloc`
> — see the note in `02-flutter-state-guard.mdc`.

**Memory references:** `memory-bank/techContext.md` (test package versions).

**Guard rules:** `04-flutter-test-guard.mdc` (primary).

---

## Steps

**Step 0 — Identify what's under test and its dependencies.** Read the target
file. List every bloc/repository/service it depends on — each needs a fake,
mock, or provided instance in the test.

**Step 1 — Bloc under test.** Use `blocTest<XBloc, XState>` with the
repository mocked via `mocktail` (or the feature's `Fake*Repository`). Assert
the **emitted state sequence** for each event — a success path and at least
one failure path per event that can fail. Use `seed:` to start from a specific
state instead of dispatching a chain of setup events.

**Step 2 — Widget under test.** Two shapes, picked by what the test is about:

- **Behavior through real transitions:** provide the real bloc over a faked
  repository (`RepositoryProvider.value` + `BlocProvider(create: ...)`), then
  assert rendered output after `pumpAndSettle()`.
- **Rendering of one exact state:** provide a `MockBloc` with
  `when(() => bloc.state).thenReturn(...)` via `BlocProvider.value`. Use this
  for error and empty views, where driving the real bloc into that state is
  more setup than the assertion is worth.

Cover, for a screen: the populated render, the in-progress state, the failure
state with its retry action, and the empty-collection state if meaningfully
different from populated.

**Step 3 — Repository under test.** For an API-backed repository, mock the
HTTP client and assert the success path maps JSON correctly and at least one
error path maps to the correct typed `AppException` subclass. For an
in-memory/fake repository, test it only where it encodes real behavior worth
pinning (ordering, de-duplication of cart lines) — not its trivial getters.

**Step 4 — Register fallback values.** `mocktail` needs
`registerFallbackValue` in `setUpAll` for any non-primitive type passed to
`when`/`verify` — including bloc event types when verifying dispatches.

**Step 5 — Do not test implementation details.** No asserting on a bloc's
private fields, no asserting `build()` ran a specific number of times, no
verifying a mock was constructed a certain way without also asserting the
resulting behavior. Every assertion must be able to fail for a real reason — a
test that can never fail (asserting on a constant, or on a value the test
itself just set) adds false coverage.

Verifying a dispatched event *is* legitimate when the event is the behavior
under test: a button's job is to dispatch, so
`verify(() => bloc.add(const CartItemRemoved('id-1'))).called(1);` is the
assertion that matters.

**Step 6 — Name tests by behavior, not by method.** `'shows retry button when
fetch fails'`, not `'test build method'` — the test name is the first thing a
failing-CI reader sees.

---

## Example

Request: "This bloc has no tests, add coverage."

Output: `test/features/cart/application/cart_bloc_test.dart` with
`blocTest` cases for `CartRequested` emitting
`[CartLoadInProgress, CartLoadSuccess]`, `CartItemAdded` re-emitting a success
state with the new line included, and a repository throw mapped to
`[CartLoadInProgress, CartLoadFailure]` — using `mocktail`, already present in
`pubspec.yaml`.
