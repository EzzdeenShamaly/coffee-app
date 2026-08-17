// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => _UserProfile(
  user: AppUser.fromJson(json['user'] as Map<String, dynamic>),
  loyaltyPoints: (json['loyalty_points'] as num?)?.toInt() ?? 0,
  favouriteDrinkId: json['favourite_drink_id'] as String?,
);

Map<String, dynamic> _$UserProfileToJson(_UserProfile instance) =>
    <String, dynamic>{
      'user': instance.user,
      'loyalty_points': instance.loyaltyPoints,
      'favourite_drink_id': instance.favouriteDrinkId,
    };
