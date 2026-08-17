import 'package:equatable/equatable.dart';

/// Intents the auth feature can act on.
sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => const [];
}

/// Dispatched once at startup to restore an existing session.
final class AuthStarted extends AuthEvent {
  const AuthStarted();
}

final class AuthSignInRequested extends AuthEvent {
  const AuthSignInRequested({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];

  /// Password redacted: bloc observers and error reporters print events, and a
  /// credential must never reach a log (`03-flutter-security-guard.mdc`).
  @override
  String toString() => 'AuthSignInRequested(email: $email, password: •••)';
}

final class AuthSignUpRequested extends AuthEvent {
  const AuthSignUpRequested({
    required this.fullName,
    required this.email,
    required this.password,
  });

  final String fullName;
  final String email;
  final String password;

  @override
  List<Object?> get props => [fullName, email, password];

  @override
  String toString() =>
      'AuthSignUpRequested(fullName: $fullName, email: $email, password: •••)';
}

final class AuthSignOutRequested extends AuthEvent {
  const AuthSignOutRequested();
}
