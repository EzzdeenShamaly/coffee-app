import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_user.freezed.dart';
part 'app_user.g.dart';

/// The signed-in account.
///
/// Deliberately minimal — this is identity only. Loyalty points and
/// preferences live on the profile feature's `UserProfile`, so the auth slice
/// does not become a dumping ground for every user-shaped field.
@freezed
abstract class AppUser with _$AppUser {
  const factory AppUser({
    required String id,
    required String email,
    @JsonKey(name: 'full_name') required String fullName,
  }) = _AppUser;

  const AppUser._();

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);

  /// First letter of the name, for the profile avatar.
  String get initial =>
      fullName.trim().isEmpty ? '?' : fullName.trim()[0].toUpperCase();
}
