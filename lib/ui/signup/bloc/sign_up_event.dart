part of 'sign_up_bloc.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object?> get props => [];
}

class Submit extends SignUpEvent {
  const Submit({
    required this.name,
    required this.phoneNumber,
    required this.dob,
    required this.address,
    this.profileImage,
  });
  final String name;
  final String phoneNumber;
  final String dob;
  final Map<String, dynamic> address;
  final String? profileImage;

  @override
  List<Object?> get props => [name, phoneNumber, dob, address, profileImage];
}

class PickProfilePictureEvent extends SignUpEvent {
  const PickProfilePictureEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfileData extends SignUpEvent {
  const LoadProfileData();

  @override
  List<Object?> get props => [];
}
