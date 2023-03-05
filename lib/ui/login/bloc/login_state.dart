part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();
}

class LoginInitial extends LoginState {
  @override
  List<Object> get props => [];
}

class LogInSuccess extends LoginState {
  const LogInSuccess(
    this.result,
  );
  final String result;

  @override
  List<Object?> get props => [result];
}

class LogInError extends LoginState {
  const LogInError(this.error);
  final String error;

  @override
  List<Object?> get props => [error];
}

class LogInLoading extends LoginState {
  const LogInLoading();

  @override
  List<Object?> get props => [];
}
