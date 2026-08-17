import 'dart:async';

import 'package:flutter/foundation.dart';

/// Adapts a [Stream] to the [Listenable] that `GoRouter.refreshListenable`
/// expects.
///
/// A bloc is a stream, not a listenable, so this is the bridge that makes the
/// router re-evaluate its `redirect` when auth state changes — without it, a
/// sign-out leaves the user sitting on a protected screen until they navigate.
///
/// Emits on subscription-time changes only; the router reads the current state
/// from the bloc itself inside `redirect`.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (_) => notifyListeners(),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
