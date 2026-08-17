import 'package:coffee_app/features/auth/domain/entities/app_user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

/// Account details beyond identity.
///
/// Separate from [AppUser] on purpose: auth owns *who you are*, this owns *what
/// the shop knows about you*. Merging them would put loyalty points behind the
/// auth repository, which has no business fetching them.
@freezed
abstract class UserProfile with _$UserProfile {
  const factory UserProfile({
    required AppUser user,
    @JsonKey(name: 'loyalty_points') @Default(0) int loyaltyPoints,
    @JsonKey(name: 'favourite_drink_id') String? favouriteDrinkId,
  }) = _UserProfile;

  const UserProfile._();

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);

  /// Points needed for the next free drink.
  static const pointsPerReward = 100;

  int get pointsToNextReward =>
      pointsPerReward - (loyaltyPoints % pointsPerReward);

  /// How many free drinks are currently available to redeem.
  int get availableRewards => loyaltyPoints ~/ pointsPerReward;

  /// 0.0–1.0 progress toward the next reward, for the profile progress bar.
  double get rewardProgress =>
      (loyaltyPoints % pointsPerReward) / pointsPerReward;
}
