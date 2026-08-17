import 'package:coffee_app/features/profile/domain/entities/user_profile.dart';

/// Read access to the signed-in account's shop-side details.
abstract class ProfileRepository {
  /// Throws [UnauthorizedException] when there is no valid session, and
  /// [NetworkException] when unreachable.
  Future<UserProfile> fetchProfile();
}
