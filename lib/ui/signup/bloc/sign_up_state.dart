part of 'sign_up_bloc.dart';

class SignUpState extends Equatable {
  const SignUpState();

  @override
  List<Object> get props => [];
}

class InitialState extends SignUpState {
  const InitialState();
}

class Loading extends SignUpState {
  const Loading();
}

class Success extends SignUpState {
  const Success(this.result);
  final String result;

  @override
  List<Object> get props => [result];
}

class Error extends SignUpState {
  const Error(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}

class PictureLoading extends SignUpState {
  const PictureLoading();
}

class PickProfilePictureState extends SignUpState {
  const PickProfilePictureState(this.imageUrl);
  final String imageUrl;

  @override
  List<Object> get props => [imageUrl];
}

class ProfileLoaded extends SignUpState {
  const ProfileLoaded({required this.user});
  final User user;
}
