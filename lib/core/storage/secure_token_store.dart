import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// The only place an auth token is read from or written to.
///
/// Backed by Keychain on iOS and EncryptedSharedPreferences/Keystore on
/// Android. Tokens must never go through `SharedPreferences` or a plaintext
/// file (`03-flutter-security-guard.mdc`); routing every access through this
/// one class is what makes that reviewable.
///
/// Nothing here logs its values — a `print` of a token in a debug build is
/// still a leaked token.
class SecureTokenStore {
  const SecureTokenStore(this._storage);

  final FlutterSecureStorage _storage;

  static const _accessTokenKey = 'auth.access_token';
  static const _refreshTokenKey = 'auth.refresh_token';

  Future<String?> readAccessToken() => _storage.read(key: _accessTokenKey);

  Future<void> writeAccessToken(String token) =>
      _storage.write(key: _accessTokenKey, value: token);

  Future<String?> readRefreshToken() => _storage.read(key: _refreshTokenKey);

  Future<void> writeRefreshToken(String token) =>
      _storage.write(key: _refreshTokenKey, value: token);

  /// Called on sign-out. Deletes both tokens rather than only the access token,
  /// so a stale refresh token cannot silently restore the session.
  Future<void> clear() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }
}
