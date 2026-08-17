import 'package:coffee_app/core/error/app_exception.dart';
import 'package:coffee_app/core/storage/secure_token_store.dart';
import 'package:coffee_app/features/auth/data/repositories/fake_auth_repository.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late MockSecureStorage storage;
  late FakeAuthRepository repository;

  setUp(() {
    storage = MockSecureStorage();
    repository = FakeAuthRepository(tokenStore: SecureTokenStore(storage));

    when(
      () => storage.write(key: any(named: 'key'), value: any(named: 'value')),
    ).thenAnswer((_) async {});
    when(() => storage.read(key: any(named: 'key'))).thenAnswer((_) async => null);
    when(() => storage.delete(key: any(named: 'key'))).thenAnswer((_) async {});
  });

  group('FakeAuthRepository sign-in', () {
    test('returns the account and stores a session on valid credentials', () async {
      final user = await repository.signIn(
        email: 'sam@example.com',
        password: 'coffee123',
      );

      expect(user.email, 'sam@example.com');
      // The session marker must land in secure storage, not anywhere else.
      verify(
        () => storage.write(key: 'auth.access_token', value: any(named: 'value')),
      ).called(1);
    });

    test('is case- and whitespace-insensitive about the email', () async {
      final user = await repository.signIn(
        email: '  SAM@Example.com  ',
        password: 'coffee123',
      );

      expect(user.id, 'user-1');
    });

    test('throws UnauthorizedException on a wrong password', () {
      expect(
        () => repository.signIn(
          email: 'sam@example.com',
          password: 'not-the-password',
        ),
        throwsA(isA<UnauthorizedException>()),
      );
    });

    test('throws UnauthorizedException for an unknown account', () {
      // Same exception as a wrong password on purpose — telling an attacker
      // which emails exist is an account-enumeration leak.
      expect(
        () => repository.signIn(
          email: 'nobody@example.com',
          password: 'coffee123',
        ),
        throwsA(isA<UnauthorizedException>()),
      );
    });

    test('throws ValidationException on a malformed email', () {
      expect(
        () => repository.signIn(email: 'not-an-email', password: 'coffee123'),
        throwsA(isA<ValidationException>()),
      );
    });
  });

  group('FakeAuthRepository sign-up', () {
    test('creates and signs in a new account', () async {
      final user = await repository.signUp(
        fullName: 'Ada Lovelace',
        email: 'ada@example.com',
        password: 'longenough',
      );

      expect(user.fullName, 'Ada Lovelace');
      expect(user.email, 'ada@example.com');
      expect(await repository.currentUser(), user);
    });

    test('rejects a duplicate email', () {
      expect(
        () => repository.signUp(
          fullName: 'Someone Else',
          email: 'sam@example.com',
          password: 'longenough',
        ),
        throwsA(isA<ValidationException>()),
      );
    });

    test('rejects a password under eight characters', () {
      expect(
        () => repository.signUp(
          fullName: 'Ada Lovelace',
          email: 'ada@example.com',
          password: 'short',
        ),
        throwsA(isA<ValidationException>()),
      );
    });

    test('rejects a blank name', () {
      expect(
        () => repository.signUp(
          fullName: '   ',
          email: 'ada@example.com',
          password: 'longenough',
        ),
        throwsA(isA<ValidationException>()),
      );
    });
  });

  group('FakeAuthRepository session handling', () {
    test('returns null when there is no stored token', () async {
      expect(await repository.currentUser(), isNull);
    });

    test('restores a session from a stored token', () async {
      when(() => storage.read(key: 'auth.access_token'))
          .thenAnswer((_) async => 'dev-session-user-1');

      expect(await repository.currentUser(), isNotNull);
    });

    test('clears both token keys on sign out', () async {
      await repository.signOut();

      // Leaving a refresh token behind would let a stale session be restored.
      verify(() => storage.delete(key: 'auth.access_token')).called(1);
      verify(() => storage.delete(key: 'auth.refresh_token')).called(1);
    });
  });

  group('FakeAuthRepository storage-failure mapping', () {
    test('maps a PlatformException on read to an AppException', () async {
      when(() => storage.read(key: any(named: 'key'))).thenThrow(
        PlatformException(code: 'Keychain locked'),
      );

      // The application layer catches AppException only, so a raw
      // PlatformException escaping here would become an unhandled bloc error.
      await expectLater(
        repository.currentUser(),
        throwsA(isA<AppException>()),
      );
    });

    test('maps a PlatformException on write to an AppException', () async {
      when(
        () => storage.write(key: any(named: 'key'), value: any(named: 'value')),
      ).thenThrow(PlatformException(code: 'Keystore unavailable'));

      await expectLater(
        repository.signIn(email: 'sam@example.com', password: 'coffee123'),
        throwsA(isA<AppException>()),
      );
    });

    test('maps a PlatformException on sign-out to an AppException', () async {
      when(() => storage.delete(key: any(named: 'key')))
          .thenThrow(PlatformException(code: 'Keychain locked'));

      await expectLater(repository.signOut(), throwsA(isA<AppException>()));
    });
  });
}
