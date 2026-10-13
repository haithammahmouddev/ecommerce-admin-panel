part of 'social_auth_cubit.dart';

sealed class SocialAuthState {}

final class SocialAuthInitial extends SocialAuthState {}

final class SocialAuthLoading extends SocialAuthState {}

final class SocialAuthSuccess extends SocialAuthState {
  final UserEntity user;
  SocialAuthSuccess({required this.user});
}

final class SocialAuthFailure extends SocialAuthState {
  final String errorMessage;
  SocialAuthFailure({required this.errorMessage});
}