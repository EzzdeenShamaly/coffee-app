import 'package:coffee_app/features/profile/domain/entities/user_profile.dart';
import 'package:equatable/equatable.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => const [];
}

final class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

final class ProfileLoadInProgress extends ProfileState {
  const ProfileLoadInProgress();
}

final class ProfileLoadSuccess extends ProfileState {
  const ProfileLoadSuccess(this.profile);

  final UserProfile profile;

  @override
  List<Object?> get props => [profile];
}

final class ProfileLoadFailure extends ProfileState {
  const ProfileLoadFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
