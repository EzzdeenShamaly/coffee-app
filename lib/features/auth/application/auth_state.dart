import 'package:coffee_app/features/auth/domain/entities/app_user.dart';
import 'package:equatable/equatable.dart';

/// Auth is app-wide state: the router's `redirect` reads it to guard routes, so
/// every variant must answer "is this user allowed in?" via
/// [isAuthenticated].
sealed class AuthState extends Equatable {
  const AuthState();

  /// True only for [AuthAuthenticated]. Used by the router guard, which must
  /// treat "still checking" as not-yet-allowed.
  bool get isAuthenticated => false;

  /// True until the startup session check resolves. The router shows a splash
  /// rather than bouncing the user to sign-in while this holds.
  bool get isResolving => false;

  @override
  List<Object?> get props => const [];
}

/// Before [AuthStarted] has been handled.
final class AuthInitial extends AuthState {
  const AuthInitial();

  @override
  bool get isResolving => true;
}

/// A session check, sign-in, or sign-up is in flight.
final class AuthInProgress extends AuthState {
  const AuthInProgress({this.isStartupCheck = false});

  /// Distinguishes the silent startup restore (show a splash) from a user-
  /// initiated sign-in (show a button spinner).
  final bool isStartupCheck;

  @override
  bool get isResolving => isStartupCheck;

  @override
  List<Object?> get props => [isStartupCheck];
}

final class AuthAuthenticated extends AuthState {
  const AuthAuthenticated(this.user);

  final AppUser user;

  @override
  bool get isAuthenticated => true;

  @override
  List<Object?> get props => [user];
}

final class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// A sign-in or sign-up attempt failed. Still unauthenticated — the router
/// treats this like [AuthUnauthenticated]; the screen shows [message].
final class AuthFailure extends AuthState {
  const AuthFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
