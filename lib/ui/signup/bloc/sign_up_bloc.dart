import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

import '../../../domain/models/user_model.dart';
import '../../../domain/repositories/user_repository.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc({required this.userRepository}) : super(const InitialState()) {
    on<Submit>((event, emit) async {
      emit(const Loading());
      try {
        final result = await userRepository.saveUserDetails(
          event.name,
          event.phoneNumber,
          event.dob,
          event.address,
          event.profileImage,
        );
        emit(Success(result));
      } catch (e) {
        if (e is FirebaseException) {
          emit(Error(e.message!));
        }
      }
    });
    on<PickProfilePictureEvent>((event, emit) async {
      try {
        final XFile? image =
            await _picker.pickImage(source: ImageSource.gallery);
        if (image != null) {
          emit(const PictureLoading());
          final result = await userRepository.uploadPic(image);
          emit(PickProfilePictureState(result));
        } else {
          emit(const PickProfilePictureState(
              'https://www.clipartkey.com/view/ohiRbb_user-staff-man-profile-person-icon-circle-png/'));
        }
      } catch (e) {
        if (e is FirebaseException) {
          emit(Error(e.message!));
        }
      }
    });
    on<LoadProfileData>((event, emit) async {
      try {
        emit(const Loading());
        final User user = await userRepository.getUserDetails();
        emit(ProfileLoaded(user: user));
      } catch (e) {
        print(e);
      }
    });
  }
  final UserRepository userRepository;
  final ImagePicker _picker = ImagePicker();
}
