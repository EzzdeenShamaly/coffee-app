import 'package:coffee_app/core/error/app_exception.dart';
import 'package:coffee_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:coffee_app/features/profile/domain/entities/user_profile.dart';
import 'package:coffee_app/features/profile/domain/repositories/profile_repository.dart';

/// Builds a profile around whoever is signed in.
///
/// Depends on [AuthRepository]'s interface to resolve the current user, which
/// keeps "who am I" in one place instead of duplicating session logic here.
class FakeProfileRepository implements ProfileRepository {
  const FakeProfileRepository({required this._authRepository});

  final AuthRepository _authRepository;

  static const _latency = Duration(milliseconds: 400);

  @override
  Future<UserProfile> fetchProfile() async {
    await Future<void>.delayed(_latency);

    final user = await _authRepository.currentUser();
    if (user == null) {
      throw const UnauthorizedException('Sign in to see your profile.');
    }

    // Fixed values — a real backend returns the customer's actual balance.
    return UserProfile(
      user: user,
      loyaltyPoints: 240,
      favouriteDrinkId: 'drink-3',
    );
  }
}
