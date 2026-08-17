# Security Standards

**Tier 2 — standards, not a snapshot.** Read by
`.cursor/rules/03-flutter-security-guard.mdc` and the `mobile-security-auditor`
subagent. Standard mobile hygiene for a consumer coffee-ordering app — not a
regulated-industry compliance framework.

## Secrets

**No secrets exist in this repo today, and none may be added to source.** There
is no API key, no client secret, and no backend URL — every repository is an
in-memory fake.

When a real backend arrives:

- Build-time configuration goes through `--dart-define` /
  `--dart-define-from-file`, or a git-ignored `local.properties` (Android) /
  `.xcconfig` (iOS). **Never** a checked-in `ApiKeys` class with a literal
  string.
- `.gitignore` already excludes `.env`; `.claude/settings.json` additionally
  denies reading `.env`, `*.jks`, `*.keystore`, and `GoogleService-Info.plist`,
  and `guard-write.mjs` blocks writing secret-bearing files and hardcoded
  credential patterns.
- If a secret is ever found already committed, **flag it explicitly** — do not
  silently relocate it to another committed file.

## Token and session storage

**`flutter_secure_storage` only, accessed solely through
`lib/core/storage/secure_token_store.dart`.** Keychain on iOS,
EncryptedSharedPreferences/Keystore on Android. Routing every token access
through one class is what makes this reviewable in a diff.

- **`SharedPreferences` is not in this project at all.** If it is ever added, it
  is for genuinely non-sensitive local state only (theme preference,
  onboarding-seen flag) — never a token, never PII.
- Sign-out deletes **both** the access and refresh token keys. Leaving a refresh
  token behind would let a stale session be silently restored.
- **Secure storage failures must be mapped, not propagated.** A locked Keychain
  or missing plugin registration arrives as `PlatformException`, and blocs catch
  only `AppException` — an unmapped throw becomes an unhandled bloc error instead
  of a UI failure state. `FakeAuthRepository` maps all three paths (read, write,
  clear) and has regression tests for each. Any new secure-storage caller must do
  the same.

## Logging and credential redaction

**No credential, token, or full PII payload may reach a log.**

`AuthSignInRequested` and `AuthSignUpRequested` override `toString()` to render
the password as `•••`, because bloc observers, `onTransition` logging, and crash
reporters print events. There is a test asserting the password does not appear in
`toString()`.

The events still include the password in `props` so equality works in tests —
value equality and log safety are separate concerns, and both are needed.

**Any new event carrying a credential must redact it the same way.**

## Payment data

**The app never sees payment instrument data.** `PaymentMethod` is an enum of
labels (`applePay`, `googlePay`, `cardOnFile`, `payAtCounter`). There is no card
number, expiry, CVV, or payment token anywhere in the codebase.

When real payments arrive, hand off to the platform payment sheet (Apple Pay /
Google Pay) or a PCI-compliant SDK, and let the app see only an opaque result.
**Do not add a card-entry form to this app** — that changes its compliance
posture entirely and is a decision for the team, not a generator.

## Network

**No HTTP client is present yet** (`dio`/`http` are both absent from
`pubspec.yaml`), so there is nothing to pin today.

When one is added:

- Create **one** configured client instance and route every repository through
  it. A second, separately-configured client is how auth headers and TLS
  settings silently diverge.
- Certificate pinning is **not** currently adopted. This standard does not
  require adding it unilaterally — flag it as a recommendation per
  `10-evidence-and-dependency-guard.mdc` rather than pulling in a pinning
  package unasked. If it is adopted, every new call goes through the pinned
  client.
- HTTPS only. No `http://` endpoints, and no
  `badCertificateCallback` returning true — that disables the protection
  entirely and must never be committed, not even "temporarily for local dev".

## Platform channels and deep links

**No custom `MethodChannel`/`EventChannel` exists in this app.** If one is added,
validate arguments before invoking (native code is a different trust boundary)
and treat return values as untrusted input.

**Deep links:** routing is `go_router`'s own path parsing only; no custom URL
scheme handler is registered. If deep linking is added, validate the scheme and
host before acting on a link — arriving through the app's own registered scheme
does not make a URL trustworthy. Note `OrderConfirmationScreen` already refuses
to render on a cold deep link with no order attached, redirecting to history
instead.

## Permissions

**The app currently requests no runtime permissions** — no camera, location,
notifications, or contacts. `flutter_secure_storage` needs none.

Every permission added later must have:
- A genuine feature that fails without it
- An accurate iOS `Info.plist` usage-description string
- A matching Play Data Safety declaration

`/production-readiness-review` checks these against the store checklist, and a
permission requested with no corresponding feature is a store-review rejection
risk as well as a privacy problem.

## Known gaps

- **No crash reporting.** Nothing is wired. Beyond being a readiness blocker,
  note that when Crashlytics or Sentry is added, its scrubbing configuration must
  keep the redaction guarantees above — a crash reporter that logs bloc events
  verbatim would undo the password redaction.
- **No certificate pinning** (nothing to pin yet).
- **No jailbreak/root detection, no obfuscation.** Appropriate for a coffee app;
  revisit only if stored-value balances or payment credentials ever live
  on-device.
