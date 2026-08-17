# Skill: repo-discovery

**Invocation:** `/repo-discovery`

**Category:** Housekeeping — runs silently, no announcement.

---

## Overview

`repo-discovery` scans a Flutter repository and builds the structural map
this platform reasons from: `pubspec.yaml` dependencies, `lib/` folder
structure, which state-management package and shape are in use (`Bloc` vs
`Cubit`), the router package, and the testing setup. Writes
`.cursor/cache/repo-map.json` — the machine-owned structural layer
`context-sync` reads to populate the memory-bank's Tier 1 files.

**Memory references:** none read — this skill produces the evidence other
skills and `context-sync` read.

**Guard rules:** none — read-only scan. Never hand-edit
`.cursor/cache/repo-map.json`; only this skill writes it.

---

## Steps

**Step 1 — Read `pubspec.yaml`.** Extract: Flutter/Dart SDK constraint,
every `dependencies`/`dev_dependencies` entry and version, and flag the
presence of the packages this platform has conventions for:
`flutter_bloc`/`bloc`, `bloc_test`, `equatable`, `go_router`,
`freezed`/`json_serializable`, `build_runner` (codegen signal),
`flutter_secure_storage`, `dio`/`http`, `mocktail`/`mockito`,
`integration_test`, `flutter_localizations`/`intl`.

**Step 2 — Map `lib/` structure.** Use `readdirSync(dir, {withFileTypes:
true})`-style directory listing (not per-entry `stat`, which is slow on
mounted/network filesystems) to determine: feature-first
(`lib/features/<name>/...`) vs layered (`lib/presentation|domain|data/...`)
at the top level, and the depth/consistency of that pattern across
existing features.

**Step 3 — Detect state-management convention in use.** Grep for
`extends Bloc<` / `extends Cubit<` / `BlocProvider` / `BlocBuilder` /
`BlocListener` / `setState` usage counts to determine which pattern actually
dominates today — a repo can have `flutter_bloc` in `pubspec.yaml` while most
screens still use `setState`, which matters more than the dependency listing
alone. Also note whether events/states extend `Equatable` and whether state
hierarchies are `sealed`, since that determines whether exhaustive `switch` and
`bloc_test`'s `expect:` comparisons work.

**Step 4 — Detect routing convention.** Find the router configuration file
and note whether routes are flat, nested under a `ShellRoute`, and whether
any route has a `redirect` guard already.

**Step 5 — Detect test setup.** Note whether `test/` mirrors `lib/`'s
structure, whether bloc tests use `bloc_test`'s `blocTest` and widget tests
provide their bloc explicitly (or whether tests let a real repository-backed
bloc run — a finding for `flutter-architecture-audit` to pick up later), and
whether `integration_test/` exists.

**Step 6 — Write `.cursor/cache/repo-map.json`.**

```json
{
  "generatedAt": "2026-08-08T00:00:00Z",
  "sdkConstraint": ">=3.3.0 <4.0.0",
  "stateManagement": { "package": "flutter_bloc", "shape": "Bloc", "sealedStates": true, "equatable": true },
  "routing": { "package": "go_router", "shellRoutes": true },
  "layout": "feature-first",
  "features": ["auth", "cart", "checkout", "menu", "orders", "product", "profile"],
  "testing": { "blocTestUsed": true, "integrationTestPresent": false },
  "dependenciesOfInterest": { "freezed": "3.2.5", "flutter_secure_storage": "11.0.0" }
}
```

**Step 7 — Report freshness on future runs.** If `repo-map.json` already
exists, compare `generatedAt` against `pubspec.yaml`'s mtime — if
`pubspec.yaml` changed more recently, note the map is stale and re-scan
rather than trusting it silently.

---

## Example

Request: "Scan this repo before we start." → Silent run, writes
`.cursor/cache/repo-map.json`, then hands off to `/context-sync` to
populate the human-readable memory-bank from it.
