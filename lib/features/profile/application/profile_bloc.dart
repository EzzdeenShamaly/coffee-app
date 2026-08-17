import 'package:bloc/bloc.dart';
import 'package:coffee_app/core/error/app_exception.dart';
import 'package:coffee_app/features/profile/application/profile_event.dart';
import 'package:coffee_app/features/profile/application/profile_state.dart';
import 'package:coffee_app/features/profile/domain/repositories/profile_repository.dart';

/// Owns the profile screen's data.
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({required this._repository}) : super(const ProfileInitial()) {
    on<ProfileRequested>(_onRequested);
  }

  final ProfileRepository _repository;

  Future<void> _onRequested(
    ProfileRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoadInProgress());
    try {
      final profile = await _repository.fetchProfile();
      if (isClosed) return;
      emit(ProfileLoadSuccess(profile));
    } on AppException catch (e) {
      if (isClosed) return;
      emit(ProfileLoadFailure(e.message));
    }
  }
}
