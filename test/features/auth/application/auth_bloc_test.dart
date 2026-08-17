import 'package:bloc_test/bloc_test.dart';
import 'package:coffee_app/core/error/app_exception.dart';
import 'package:coffee_app/features/auth/application/auth_bloc.dart';
import 'package:coffee_app/features/auth/application/auth_event.dart';
import 'package:coffee_app/features/auth/application/auth_state.dart';
import 'package:coffee_app/features/auth/domain/entities/app_user.dart';
import 'package:coffee_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  const user = AppUser(
    id: 'user-1',
    email: 'sam@example.com',
    fullName: 'Sam Rivera',
  );

  late MockAuthRepository repository;

  setUp(() => repository = MockAuthRepository());

  group('AuthBloc startup', () {
    blocTest<AuthBloc, AuthState>(
      'restores an existing session',
      setUp: () =>
          when(() => repository.currentUser()).thenAnswer((_) async => user),
      build: () => AuthBloc(repository: repository),
      act: (bloc) => bloc.add(const AuthStarted()),
      expect: () => const [
        AuthInProgress(isStartupCheck: true),
        AuthAuthenticated(user),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'lands unauthenticated when there is no session',
      setUp: () =>
          when(() => repository.currentUser()).thenAnswer((_) async => null),
      build: () => AuthBloc(repository: repository),
      act: (bloc) => bloc.add(const AuthStarted()),
      expect: () => const [
        AuthInProgress(isStartupCheck: true),
        AuthUnauthenticated(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'treats a failed session restore as unauthenticated, not as an error',
      setUp: () => when(() => repository.currentUser())
          .thenThrow(const NetworkException()),
      build: () => AuthBloc(repository: repository),
      act: (bloc) => bloc.add(const AuthStarted()),
      // A cold-start network blip should not show the customer a scary error;
      // it just means they start at sign-in.
      expect: () => const [
        AuthInProgress(isStartupCheck: true),
        AuthUnauthenticated(),
      ],
    );
  });

  group('AuthBloc sign-in', () {
    blocTest<AuthBloc, AuthState>(
      'emits [inProgress, authenticated] on valid credentials',
      setUp: () => when(
        () => repository.signIn(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => user),
      build: () => AuthBloc(repository: repository),
      act: (bloc) => bloc.add(
        const AuthSignInRequested(
          email: 'sam@example.com',
          password: 'coffee123',
        ),
      ),
      expect: () => const [AuthInProgress(), AuthAuthenticated(user)],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [inProgress, failure] on rejected credentials',
      setUp: () => when(
        () => repository.signIn(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(const UnauthorizedException('Incorrect email or password.')),
      build: () => AuthBloc(repository: repository),
      act: (bloc) => bloc.add(
        const AuthSignInRequested(email: 'sam@example.com', password: 'wrong'),
      ),
      expect: () => const [
        AuthInProgress(),
        AuthFailure('Incorrect email or password.'),
      ],
    );
  });

  group('AuthBloc sign-out', () {
    blocTest<AuthBloc, AuthState>(
      'ends unauthenticated on a clean sign-out',
      setUp: () => when(() => repository.signOut()).thenAnswer((_) async {}),
      build: () => AuthBloc(repository: repository),
      seed: () => const AuthAuthenticated(user),
      act: (bloc) => bloc.add(const AuthSignOutRequested()),
      expect: () => const [AuthUnauthenticated()],
    );

    blocTest<AuthBloc, AuthState>(
      'still ends unauthenticated when clearing storage throws',
      setUp: () => when(() => repository.signOut())
          .thenThrow(const UnexpectedException()),
      build: () => AuthBloc(repository: repository),
      seed: () => const AuthAuthenticated(user),
      // Leaving someone signed in because cleanup failed is the worse outcome.
      act: (bloc) => bloc.add(const AuthSignOutRequested()),
      expect: () => const [AuthUnauthenticated()],
    );
  });

  group('AuthState route-guard contract', () {
    test('only AuthAuthenticated reports isAuthenticated', () {
      expect(const AuthAuthenticated(user).isAuthenticated, isTrue);
      expect(const AuthInitial().isAuthenticated, isFalse);
      expect(const AuthUnauthenticated().isAuthenticated, isFalse);
      expect(const AuthFailure('x').isAuthenticated, isFalse);
      expect(const AuthInProgress().isAuthenticated, isFalse);
    });

    test('only the startup check reports isResolving', () {
      // The router shows a splash while resolving; a user-initiated sign-in must
      // not, or the form disappears mid-tap.
      expect(const AuthInitial().isResolving, isTrue);
      expect(const AuthInProgress(isStartupCheck: true).isResolving, isTrue);
      expect(const AuthInProgress().isResolving, isFalse);
      expect(const AuthUnauthenticated().isResolving, isFalse);
    });
  });

  group('AuthEvent redaction', () {
    test('does not print the password in toString', () {
      const event = AuthSignInRequested(
        email: 'sam@example.com',
        password: 'coffee123',
      );

      // Bloc observers and crash reporters print events; a credential must never
      // reach a log (`03-flutter-security-guard.mdc`).
      expect(event.toString(), contains('sam@example.com'));
      expect(event.toString(), isNot(contains('coffee123')));
    });

    test('still compares by password so tests can assert equality', () {
      expect(
        const AuthSignInRequested(email: 'a@b.c', password: 'one'),
        isNot(const AuthSignInRequested(email: 'a@b.c', password: 'two')),
      );
    });
  });
}
