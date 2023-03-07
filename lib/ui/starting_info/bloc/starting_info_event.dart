part of 'starting_info_bloc.dart';

abstract class StartingInfoEvent extends Equatable {
  const StartingInfoEvent();

  @override
  List<Object> get props => [];
}

class StartingInfoPageChange extends StartingInfoEvent {
  const StartingInfoPageChange({
    required this.page,
  });
  final int page;

  @override
  List<Object> get props => [page];
}
