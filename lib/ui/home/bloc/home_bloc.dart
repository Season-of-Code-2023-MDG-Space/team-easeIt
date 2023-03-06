import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../../../domain/models/user_model.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../domain/repositories/user_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final UserRepository userRepository;
  final AuthRepository authRepository;
  HomeBloc({required this.userRepository, required this.authRepository})
      : super(HomeInitial()) {
    on<HomeEvent>((event, emit) {
      on<GetUserDataEvent>((event, emit) async {
        emit(const Loading());
        try {
          final result = await userRepository.getUserDetails();
          emit(Success(result));
        } catch (e) {
          emit(Error(e.toString()));
        }
      });
      on<Logout>((event, emit) async {
        emit(const Loading());
        try {
          await authRepository.signOutFromGoogle();
          emit(const LogoutSuccess());
        } on firebase_auth.FirebaseAuthException catch (e) {
          emit(Error(e.toString()));
        }
      });
    });
  }
}
