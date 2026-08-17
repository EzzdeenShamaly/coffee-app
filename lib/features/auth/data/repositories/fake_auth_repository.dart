import 'package:coffee_app/core/error/app_exception.dart';
import 'package:coffee_app/core/storage/secure_token_store.dart';
import 'package:coffee_app/features/auth/domain/entities/app_user.dart';
import 'package:coffee_app/features/auth/domain/repositories/auth_repository.dart';

/// In-memory [AuthRepository] for development.
///
/// Swap for an API-backed implementation by changing the single binding in
/// `CoffeeApp` — nothing in the application or presentation layers references
/// this class (`/flutter-repository-gen` Step 4).
///
/// It does exercise the real [SecureTokenStore], so the secure-storage path is
/// wired and testable from day one rather than bolted on with the real backend.
class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({required this._tokenStore});

  final SecureTokenStore _tokenStore;

  /// Accounts that "exist" in this fake backend, keyed by lowercased email.
  final Map<String, AppUser> _accounts = {
    'sam@example.com': const AppUser(
      id: 'user-1',
      email: 'sam@example.com',
      fullName: 'Sam Rivera',
    ),
  };

  /// The one password this fake accepts, for any known account. Not a secret —
  /// there is no real backend behind it.
  static const _devPassword = 'coffee123';

  static const _latency = Duration(milliseconds: 400);

  AppUser? _signedIn;

  @override
  Future<AppUser?> currentUser() async {
    await Future<void>.delayed(_latency);
    if (_signedIn != null) return _signedIn;

    // A token on disk without an in-memory user means the app restarted.
    // A real implementation would exchange the token for the user here.
    //
    // Secure storage can fail for reasons that have nothing to do with Dart —
    // a locked Keychain, a missing plugin registration — and those arrive as
    // PlatformException. Mapping them here is what keeps the application layer
    // able to catch only AppException.
    final String? token;
    try {
      token = await _tokenStore.readAccessToken();
    } on Exception catch (e) {
      throw UnexpectedException('Could not read the saved session: $e');
    }

    if (token == null) return null;
    return _signedIn = _accounts.values.first;
  }

  @override
  Future<AppUser> signIn({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(_latency);

    final normalised = email.trim().toLowerCase();
    if (normalised.isEmpty || !normalised.contains('@')) {
      throw const ValidationException('Enter a valid email address.');
    }

    final user = _accounts[normalised];
    if (user == null || password != _devPassword) {
      throw const UnauthorizedException('Incorrect email or password.');
    }

    await _issueSession(user);
    return user;
  }

  @override
  Future<AppUser> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(_latency);

    final normalised = email.trim().toLowerCase();
    if (fullName.trim().isEmpty) {
      throw const ValidationException('Enter your name.');
    }
    if (!normalised.contains('@')) {
      throw const ValidationException('Enter a valid email address.');
    }
    if (password.length < 8) {
      throw const ValidationException(
        'Choose a password of at least 8 characters.',
      );
    }
    if (_accounts.containsKey(normalised)) {
      throw const ValidationException('That email is already registered.');
    }

    final user = AppUser(
      id: 'user-${_accounts.length + 1}',
      email: normalised,
      fullName: fullName.trim(),
    );
    _accounts[normalised] = user;

    await _issueSession(user);
    return user;
  }

  @override
  Future<void> signOut() async {
    // Local state clears first and unconditionally: if wiping storage fails, the
    // user must still end up signed out of this session.
    _signedIn = null;
    try {
      await _tokenStore.clear();
    } on Exception catch (e) {
      throw UnexpectedException('Could not clear the saved session: $e');
    }
  }

  /// Stores an opaque session marker through the secure store — never in
  /// `SharedPreferences` (`03-flutter-security-guard.mdc`).
  Future<void> _issueSession(AppUser user) async {
    _signedIn = user;
    try {
      await _tokenStore.writeAccessToken('dev-session-${user.id}');
    } on Exception catch (e) {
      throw UnexpectedException('Could not save your session: $e');
    }
  }
}
