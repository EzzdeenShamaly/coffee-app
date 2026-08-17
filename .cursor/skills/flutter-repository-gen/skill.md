# Skill: flutter-repository-gen

**Invocation:** `/flutter-repository-gen [resource name/description]`

---

## Overview

`flutter-repository-gen` generates the data layer for a resource: an
abstract repository interface, its concrete implementation backed by an API
client, typed error handling, and the `RepositoryProvider` binding — so the
domain/application layer only ever depends on the interface.

**Memory references:** `memory-bank/architecture.md`, `memory-bank/
techContext.md` (HTTP client: `dio` vs `http`), `memory-bank/domainRules.md`.

**Guard rules:** `01-flutter-architecture-guard.mdc` (data layer stays
below domain/application), `03-flutter-security-guard.mdc` (no secrets, use
the pinned/secure client if one exists).

---

## Steps

**Step 0 — Find the pattern.** Run `pattern-scout` for the nearest existing
repository (same or adjacent resource) to match the HTTP client already in
use, base-URL/interceptor setup, and error-mapping convention.

**Step 1 — Define the abstract interface.**

```dart
abstract class OrderRepository {
  Future<List<Order>> fetchOrders();
  Future<Order> fetchOrder(String id);
  Future<void> cancelOrder(String id);
}
```

**Step 2 — Use the established failure model. Do not invent a new one.**

This app already has one sealed hierarchy in
`lib/core/error/app_exception.dart`: `NetworkException`, `NotFoundException`,
`UnauthorizedException`, `ValidationException`, `UnexpectedException`. Map onto
those rather than adding a per-resource exception family — one hierarchy is what
lets every bloc catch `on AppException` and every widget render
`failure.message` without a formatting step.

```dart
// ✓ map transport/storage failures onto the shared hierarchy
try {
  final response = await _client.get('/orders');
  return (response.data as List)
      .map((json) => Order.fromJson(json as Map<String, dynamic>))
      .toList();
} on DioException catch (e) {
  throw switch (e.response?.statusCode) {
    404 => const NotFoundException('That order could not be found.'),
    401 || 403 => const UnauthorizedException(),
    _ => const NetworkException(),
  };
}
```

`message` must be display-ready and must never contain a stack trace, a URL,
or a token.

**Step 3 — Implement against the existing HTTP client.** Use whichever
client (`dio`, `http`) is already in `pubspec.yaml` — confirm before
generating. Map transport-level failures (timeout, 404, 5xx) to the typed
exceptions from Step 2 rather than letting a raw `DioException`/
`SocketException` propagate to the application layer.

```dart
class ApiOrderRepository implements OrderRepository {
  ApiOrderRepository(this._client);
  final Dio _client;

  @override
  Future<List<Order>> fetchOrders() async {
    try {
      final response = await _client.get('/orders');
      return (response.data as List)
          .map((json) => Order.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw OrderNetworkException(e.message ?? 'Network error');
    }
  }
  // fetchOrder, cancelOrder follow the same shape
}
```

**Step 4 — Bind the implementation to the interface at the composition root.**

All binding happens in `lib/app/coffee_app.dart` — the only file that names a
concrete implementation. Register it under the **interface** type, so
`context.read<OrderRepository>()` never learns which implementation it got:

```dart
MultiRepositoryProvider(
  providers: [
    RepositoryProvider<OrderRepository>.value(value: _orderRepository),
    // ...
  ],
  child: ...,
)
```

This is the seam `flutter-bloc-gen`'s blocs take as a constructor dependency
and that tests replace with a `Mock`/`Fake`.

**Step 4b — Map every foreign exception before it escapes.** A repository must
not leak `DioException`, `SocketException`, `PlatformException`, or
`FormatException` to the application layer — blocs catch `AppException` only, so
anything else becomes an unhandled bloc error rather than a failure state. This
includes storage and platform-channel calls, not just HTTP.

**Step 5 — Never bypass an existing pinned/secured client.** If the repo
already has certificate pinning or auth-header injection wired into a
shared `Dio` instance (`memory-bank/securityStandards.md`,
`03-flutter-security-guard.mdc`), the new repository uses that same
instance — it does not construct a second, unpinned client.

**Step 6 — Generate the test.** A unit test with a mocked HTTP client
(`mocktail`/`mockito`, whichever is already a dev dependency) asserting the
success path and at least one error-mapping path per
`04-flutter-test-guard.mdc`.

---

## Example

Request: "Generate a repository for fetching and cancelling orders."

Output: `lib/features/orders/domain/order_repository.dart` (interface),
`lib/features/orders/data/api_order_repository.dart` (implementation),
the `RepositoryProvider` binding in `lib/app/coffee_app.dart`, and
`test/features/orders/data/api_order_repository_test.dart`.
