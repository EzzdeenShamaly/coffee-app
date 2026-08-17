import 'package:bloc/bloc.dart';
import 'package:coffee_app/core/error/app_exception.dart';
import 'package:coffee_app/features/auth/application/auth_event.dart';
import 'package:coffee_app/features/auth/application/auth_state.dart';
import 'package:coffee_app/features/auth/domain/repositories/auth_repository.dart';

/// Owns the app-wide session.
///
/// This is one of only two blocs provided above `MaterialApp.router` — the
/// router's `redirect` guard reads its state, so its lifetime has to be the
/// app's (`02-flutter-state-guard.mdc`).
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required this._repository}) : super(const AuthInitial()) {
    on<AuthStarted>(_onStarted);
    on<AuthSignInRequested>(_onSignInRequested);
    on<AuthSignUpRequested>(_onSignUpRequested);
    on<AuthSignOutRequested>(_onSignOutRequested);
  }

  final AuthRepository _repository;

  Future<void> _onStarted(AuthStarted event, Emitter<AuthState> emit) async {
    emit(const AuthInProgress(isStartupCheck: true));
    try {
      final user = await _repository.currentUser();
      if (isClosed) return;
      emit(user == null ? const AuthUnauthenticated() : AuthAuthenticated(user));
    } on AppException {
      // A failed session restore is not a sign-in error to show the user —
      // it just means they start at the sign-in screen.
      if (isClosed) return;
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onSignInRequested(
    AuthSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthInProgress());
    try {
      final user = await _repository.signIn(
        email: event.email,
        password: event.password,
      );
      if (isClosed) return;
      emit(AuthAuthenticated(user));
    } on AppException catch (e) {
      if (isClosed) return;
      emit(AuthFailure(e.message));
    }
  }

  Future<void> _onSignUpRequested(
    AuthSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthInProgress());
    try {
      final user = await _repository.signUp(
        fullName: event.fullName,
        email: event.email,
        password: event.password,
      );
      if (isClosed) return;
      emit(AuthAuthenticated(user));
    } on AppException catch (e) {
      if (isClosed) return;
      emit(AuthFailure(e.message));
    }
  }

  Future<void> _onSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    // Sign-out always lands on unauthenticated, even if clearing storage
    // throws — leaving the user signed in on a failed sign-out is the worse
    // outcome.
    try {
      await _repository.signOut();
    } on AppException {
      // Intentionally swallowed; see above.
    }
    if (isClosed) return;
    emit(const AuthUnauthenticated());
  }
}
