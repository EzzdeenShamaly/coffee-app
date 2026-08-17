import 'package:coffee_app/features/auth/domain/entities/app_user.dart';

/// Authentication seam.
///
/// The application layer depends only on this interface; the concrete
/// implementation is bound once via `RepositoryProvider` in `CoffeeApp`
/// (`01-flutter-architecture-guard.mdc`).
///
/// Every method throws an [AppException] subclass on failure rather than
/// returning a nullable or a result wrapper — blocs catch and map to a failure
/// state.
abstract class AuthRepository {
  /// The already-signed-in user, or null on a cold start with no session.
  ///
  /// Throws nothing for "not signed in" — that is a null, not a failure.
  Future<AppUser?> currentUser();

  /// Throws [ValidationException] for malformed input and
  /// [UnauthorizedException] for rejected credentials.
  Future<AppUser> signIn({required String email, required String password});

  /// Throws [ValidationException] if the email is taken or the password is too
  /// weak.
  Future<AppUser> signUp({
    required String fullName,
    required String email,
    required String password,
  });

  /// Clears the local session. Must succeed even if the network is down —
  /// a user who taps sign out should never stay signed in.
  Future<void> signOut();
}
