import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../data/services/local/storage_service.dart';
import '../../domain/repositories/user_repository.dart';
import '../../utils/app_theme.dart';
import '../widgets/easeit_button.dart';
import '../widgets/text_input.dart';
import 'bloc/sign_up_bloc.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({required this.phoneNumber, Key? key}) : super(key: key);
  static const String id = 'sign-up';
  final String phoneNumber;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SignUpBloc(userRepository: context.read<UserRepository>()),
      child: Scaffold(
        backgroundColor: AppTheme.lightBlue,
        body: SignUpBody(phoneNumber: phoneNumber),
      ),
    );
  }
}

// ignore: must_be_immutable
class SignUpBody extends StatelessWidget {
  SignUpBody({required this.phoneNumber, Key? key}) : super(key: key);
  final String phoneNumber;
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _dobcontroller = TextEditingController();
  String? genderValue;
  final Map<String, TextEditingController> _addresscontroller = {
    'pinCode': TextEditingController(),
    'name': TextEditingController(),
    'city': TextEditingController(),
    'state': TextEditingController(),
  };
  String url =
      'https://www.clipartkey.com/view/ohiRbb_user-staff-man-profile-person-icon-circle-png/';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignUpBloc, SignUpState>(listener: (context, state) {
      if (state is Success) {
        StorageService.instance.isUserRegistered = true;
        Get.offAllNamed('home');
      }
      if (state is Error) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(state.error)));
      }
    }, builder: (context, state) {
      if (state is Loading) {
        return const Center(child: CircularProgressIndicator());
      }

      return Form(
        key: _formkey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 50.h),
              Stack(
                children: [
                  BlocBuilder<SignUpBloc, SignUpState>(
                    builder: (context, state) {
                      if (state is PickProfilePictureState) {
                        url = state.imageUrl;
                        return SizedBox(
                          height: 100.h,
                          width: 100.w,
                          child: CachedNetworkImage(
                            imageUrl: url,
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(50.r),
                                ),
                                border: Border.all(
                                  color: AppTheme.blue,
                                  width: 4.w,
                                ),
                              ),
                            ),
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(
                              color: AppTheme.blue,
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        );
                      } else if (state is PictureLoading) {
                        return SizedBox(
                          height: 100.h,
                          width: 100.w,
                          child: const Center(
                              child: CircularProgressIndicator(
                            color: AppTheme.blue,
                          )),
                        );
                      } else {
                        return Container(
                          height: 100.h,
                          width: 100.w,
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                              image:
                                  AssetImage('assets/images/placeholder.png'),
                              fit: BoxFit.contain,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(50.r),
                            ),
                            border: Border.all(
                              color: AppTheme.blue,
                              width: 4.w,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  Positioned(
                    bottom: 5.h,
                    right: 0,
                    child: CircleAvatar(
                      radius: 14.r,
                      backgroundColor: AppTheme.blue,
                      child: IconButton(
                        padding: const EdgeInsets.all(2),
                        iconSize: 18.w,
                        icon: const Icon(
                          Icons.camera_alt_outlined,
                          color: AppTheme.white,
                        ),
                        onPressed: () async {
                          context.read<SignUpBloc>().add(
                                const PickProfilePictureEvent(),
                              );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 30.h, left: 48.w, right: 48.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: TextInput(
                        controller: _namecontroller,
                        hintText: 'Enter your full name',
                        labelText: 'Name',
                        fillColor: AppTheme.lightGrey,
                        validator: (value) {
                          if (value.toString().isEmpty) {
                            return 'Please Enter Your Full Name';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: TextInput(
                        controller: _dobcontroller,
                        hintText: 'dd/mm/yyyy',
                        labelText: 'Date of Birth',
                        suffix: IconButton(
                            iconSize: 20.w,
                            padding: EdgeInsets.only(bottom: 10.h),
                            icon: SvgPicture.asset(
                                'assets/icons/new-date-picker.svg'),
                            //updated the lastDate property, Changed the color of DatePicker.
                            onPressed: () {
                              showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1950, 1),
                                lastDate: DateTime(2030, 12),
                                builder: (_, child) {
                                  return Theme(
                                    data: Theme.of(_).copyWith(
                                      colorScheme: const ColorScheme.light(
                                        primary: AppTheme.blue,
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              ).then((pickedDate) {
                                if (pickedDate != null) {
                                  _dobcontroller
                                    ..text = DateFormat('dd/MM/yyyy')
                                        .format(pickedDate)
                                    ..selection = TextSelection.fromPosition(
                                        TextPosition(
                                            offset: _dobcontroller.text.length,
                                            affinity: TextAffinity.upstream));
                                }
                              });
                            }),
                        validator: (value) {
                          if (value.toString().isEmpty) {
                            return 'Please enter a Date of Birth';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5.h, bottom: 5.h),
                      child: SizedBox(
                        width: 280.w,
                        child: DropdownButtonFormField(
                          isExpanded: true,
                          icon: SvgPicture.asset(
                              'assets/icons/arrow-down-new.svg'),
                          elevation: 10,
                          dropdownColor: AppTheme.lightBlue,
                          borderRadius: BorderRadius.circular(10),
                          value: genderValue,
                          focusColor: AppTheme.blue,
                          hint: const Text('Gender'),
                          style: AppTheme.h4.copyWith(color: AppTheme.greyNew),
                          items: const <DropdownMenuItem<String>>[
                            DropdownMenuItem(
                                value: 'Male', child: Text('Male')),
                            DropdownMenuItem(
                                value: 'Female', child: Text('Female')),
                          ],
                          onChanged: (value) {
                            genderValue = value;
                          },
                          decoration: InputDecoration(
                            labelText: 'Gender',
                            labelStyle: AppTheme.h3.copyWith(
                                color: AppTheme.greyNew,
                                fontWeight: FontWeight.w400),
                            // focusColor: AppTheme.blue,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: AppTheme.blue,
                                width: 2,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: AppTheme.lightGrey,
                                width: 2,
                              ),
                              gapPadding: 5,
                            ),
                          ),
                        ),
                      ),
                    ),
                    TextInput(
                      controller: _addresscontroller['pinCode'],
                      hintText: 'Pincode',
                      fillColor: AppTheme.lightGrey,
                      keyboard: TextInputType.number,
                      validator: (value) {
                        if (value.toString().isEmpty) {
                          return 'Please Enter Pincode';
                        } else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(height: 20.h),
                    TextInput(
                      controller: _addresscontroller['name'],
                      hintText: 'House No., Building Name',
                      fillColor: AppTheme.lightGrey,
                      validator: (value) {
                        if (value.toString().isEmpty) {
                          return 'Please enter address';
                        } else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 125.w,
                          child: TextInput(
                            controller: _addresscontroller['city'],
                            hintText: 'City',
                            fillColor: AppTheme.lightGrey,
                            validator: (value) {
                              if (value.toString().isEmpty) {
                                return 'Please enter city';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        SizedBox(width: 14.w),
                        SizedBox(
                          width: 125.w,
                          child: TextInput(
                            controller: _addresscontroller['state'],
                            hintText: 'State',
                            fillColor: AppTheme.lightGrey,
                            validator: (value) {
                              if (value.toString().isEmpty) {
                                return 'Please enter state';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30.h),
                    EaseItButton(
                        padding:
                            EdgeInsets.only(top: 8.h, bottom: 8.h, left: 8.w),
                        onPressed: () {
                          if (_formkey.currentState!.validate()) {
                            context.read<SignUpBloc>().add(Submit(
                                  name: _namecontroller.text,
                                  phoneNumber: '+91$phoneNumber',
                                  dob: _dobcontroller.text,
                                  address: {
                                    'pinCode':
                                        _addresscontroller['pinCode']!.text,
                                    'name': _addresscontroller['name']!.text,
                                    'city': _addresscontroller['city']!.text,
                                    'state': _addresscontroller['state']!.text,
                                  },
                                  profileImage: url,
                                ));
                          }
                        },
                        buttonText: 'Done'),
                    SizedBox(height: 14.h),
                    Center(
                      child: Text(
                        'By creating account, you agree to our Term and conditions and\nPrivacy Policy.',
                        style: AppTheme.h4.copyWith(
                          fontSize: 8.sp,
                          color: AppTheme.greyNew,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
