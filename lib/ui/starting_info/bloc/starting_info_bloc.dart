import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'starting_info_event.dart';
part 'starting_info_state.dart';

class StartingInfoBloc extends Bloc<StartingInfoEvent, StartingInfoState> {
  StartingInfoBloc() : super(const StartingInfoState(0)) {
    on<StartingInfoPageChange>((event, emit) async {
      emit(StartingInfoState(event.page));
    });
  }
}
