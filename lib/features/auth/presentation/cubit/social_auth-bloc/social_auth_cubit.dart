import 'package:bloc/bloc.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/repos/social_auth_repo.dart';

part 'social_auth_state.dart';

class SocialAuthCubit extends Cubit<SocialAuthState> {
  final SocialAuthRepo _socialAuthRepo;

  SocialAuthCubit({required SocialAuthRepo socialAuthRepo})
      : _socialAuthRepo = socialAuthRepo,
        super(SocialAuthInitial());

  Future<void> signInWithGoogle() async {
    emit(SocialAuthLoading());
    final result = await _socialAuthRepo.signInWithGoogle();

    result.fold(
          (failure) {
        emit(SocialAuthFailure(errorMessage: failure.message));
      },
          (user) {
        emit(SocialAuthSuccess(user: user));
      },
    );
  }
}