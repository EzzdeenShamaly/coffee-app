import 'package:equatable/equatable.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => const [];
}

/// Initial load and the retry action.
final class ProfileRequested extends ProfileEvent {
  const ProfileRequested();
}
