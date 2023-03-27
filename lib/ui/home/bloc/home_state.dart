part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();
}

class HomeInitial extends HomeState {
  @override
  List<Object> get props => [];
}

class Loading extends HomeState {
  const Loading();

  @override
  List<Object?> get props => [];
}

class Success extends HomeState {
  const Success(this.user);

  final User user;

  @override
  List<Object> get props => [user];
}

class Error extends HomeState {
  const Error(this.error);

  final String error;

  @override
  List<Object> get props => [error];
}

class LogoutSuccess extends HomeState {
  const LogoutSuccess();

  @override
  List<Object?> get props => [];
}

class ShowResultPDF extends HomeState {
  ShowResultPDF({required this.pdfFile});
  File pdfFile;
  @override
  List<Object?> get props => [pdfFile];
}

class ShowResultImage extends HomeState {
  ShowResultImage({required this.text});
  String text;
  @override
  List<Object?> get props => [text];
}

class ShowResultCamera extends HomeState {
  ShowResultCamera({required this.text});
  String text;
  @override
  List<Object?> get props => [text];
}
