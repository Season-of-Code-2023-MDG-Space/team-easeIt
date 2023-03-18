part of 'starting_info_bloc.dart';

class StartingInfoState extends Equatable {
  const StartingInfoState(this.page);
  final int page;
  @override
  List<Object> get props => [page];
}
