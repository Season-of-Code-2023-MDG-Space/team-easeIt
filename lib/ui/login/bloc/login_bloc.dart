import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

import '../../../domain/repositories/auth_repository.dart';
import '../../../domain/repositories/user_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({required this.authRepository, required this.userRepository})
      : super(const Unauthenticated()) {
    on<SignInEvent>((event, emit) async {
      emit(const SignInLoading());
      try {
        final result = fb_auth.FirebaseAuth.instance.currentUser.toString();
        final path = await userRepository.getPath();
        emit(SignInSuccess(result.toString(), path));
      } catch (e) {
        print(e);
        if (e is fb_auth.FirebaseAuthException) {
          emit(SignInError(e.message!));
          print(e.message);
          emit(const Unauthenticated());
        }
      }
    });
  }
  final AuthRepository authRepository;
  final UserRepository userRepository;
}
