part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

class GetUserDataEvent extends HomeEvent {
  const GetUserDataEvent();

  @override
  List<Object?> get props => [];
}

class Logout extends HomeEvent {
  const Logout();

  @override
  List<Object?> get props => [];
}

class PDFPickEvent extends HomeEvent {
  const PDFPickEvent({required this.textToFind});
  final String textToFind;
  @override
  List<Object?> get props => [];
}
