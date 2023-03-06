import 'package:ease_it/ui/signup/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../utils/app_theme.dart';
import '../../data/services/local/storage_service.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/user_repository.dart';
import '../login/bloc/login_bloc.dart';

const List<String> list = <String>['India', 'UAE', 'USA', 'France'];
const List<String> listCode = <String>['91', '971', '2', '1'];

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const String id = 'login';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(
        authRepository: context.read<AuthRepository>(),
        userRepository: context.read<UserRepository>(),
      ),
      child: const Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppTheme.lightBlue,
        body: LoginBody(),
      ),
    );
  }
}

class LoginBody extends StatefulWidget {
  const LoginBody({Key? key}) : super(key: key);

  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  bool correctOtp = true;
  bool isClickedContinue = false;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  String? dropdownValue;
  int counter = -1;
  Future registerUser(String mobile, BuildContext context) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    _auth.verifyPhoneNumber(
      phoneNumber: '+$mobile',
      timeout: const Duration(seconds: 60),
      verificationCompleted: (AuthCredential authCredential) {
        _auth.signInWithCredential(authCredential).then((UserCredential user) {
          BlocProvider.of<LoginBloc>(context).add(const SignInEvent());
        }).catchError((e) {});
      },
      verificationFailed: (FirebaseAuthException exception) {},
      codeSent: (verificationId, forceResendingToken) {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context1) {
              return AlertDialog(
                title: const Text('Please Enter the OTP'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextFormField(
                      controller: _codeController,
                      maxLines: 1,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (!correctOtp) {
                          return 'Incorrect OTP';
                        } else if (value?.length != 6) {
                          return 'Incorrect 4OTP';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ],
                ),
                actions: <Widget>[
                  MaterialButton(
                      child: const Text('Close'),
                      onPressed: () {
                        setState(() {
                          isClickedContinue = false;
                        });
                        Navigator.of(context).pop();
                      }),
                  MaterialButton(
                    child: const Text('Confirm'),
                    textColor: Colors.white,
                    color: Colors.blue,
                    onPressed: () async {
                      try {
                        final code = _codeController.text.trim();
                        final AuthCredential credential =
                            PhoneAuthProvider.credential(
                                verificationId: verificationId, smsCode: code);

                        final UserCredential result =
                            await _auth.signInWithCredential(credential);

                        final User? user = result.user;

                        if (user != null) {
                          BlocProvider.of<LoginBloc>(context)
                              .add(const SignInEvent());

                          // Navigator.push(context, MaterialPageRoute(
                          //     builder: (context) => HomeScreen(user: user,)
                          // ));
                        } else {
                          setState(() {
                            correctOtp = false;
                          });
                          Navigator.of(context).pop();
                        }
                      } catch (e) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(
                                  'Error',
                                  style: AppTheme.h5
                                      .copyWith(color: AppTheme.blue),
                                ),
                                content: Text(
                                  e.toString(),
                                  style: AppTheme.h5
                                      .copyWith(color: AppTheme.greyNew),
                                ),
                              );
                            });
                      }
                    },
                  ),
                ],
              );
            });
      },
      codeAutoRetrievalTimeout: (verificationId) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) async {
        if (state is SignInSuccess) {
          StorageService.instance.isLoggedIn = true;
          if (state.path == 'home') {
            StorageService.instance.isUserRegistered = true;
            Get.offAllNamed(state.path);
          } else {
            StorageService.instance.isUserRegistered = false;
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (ctx) =>
                        SignUpScreen(phoneNumber: _phoneController.text)));
          }
        }
        if (state is SignInError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
      builder: (context, state) {
        if (state is SignInLoading) {
          return const Center(
              child: CircularProgressIndicator(
            color: AppTheme.blue,
          ));
        }
        if (state is Unauthenticated) {
          return SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 100.h, bottom: 20.h),
                  child: Text(
                    'EaseIt',
                    style: AppTheme.h1.copyWith(
                      fontSize: 28.sp,
                      color: AppTheme.blue,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 46.h),
                  child: Text(
                    'Welcome!',
                    style: AppTheme.h1.copyWith(
                      fontSize: 28.sp,
                      color: AppTheme.greyNew,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Align(
                  child: Padding(
                    padding:
                        EdgeInsets.only(left: 40.w, top: 5.h, bottom: 20.h),
                    child: Text(
                      'LogIn in to your Account',
                      style: AppTheme.h3.copyWith(
                        color: AppTheme.greyNew,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  alignment: Alignment.centerLeft,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5.h, bottom: 5.h),
                  child: SizedBox(
                    width: 280.w,
                    child: DropdownButtonFormField(
                      isExpanded: true,
                      icon: SvgPicture.asset('assets/icons/arrow-down-new.svg'),
                      elevation: 10,
                      dropdownColor: AppTheme.lightBlue,
                      borderRadius: BorderRadius.circular(10),
                      value: dropdownValue,
                      focusColor: AppTheme.blue,
                      hint: const Text('Select a Country'),
                      style: AppTheme.h4.copyWith(color: AppTheme.greyNew),
                      items: const <DropdownMenuItem<String>>[
                        DropdownMenuItem(child: Text('India'), value: 'India'),
                        DropdownMenuItem(child: Text('UAE'), value: 'UAE'),
                        DropdownMenuItem(
                            child: Text('France'), value: 'France'),
                        DropdownMenuItem(child: Text('USA'), value: 'USA'),
                      ],
                      onChanged: (value) {
                        dropdownValue = value as String?;
                      },
                      decoration: InputDecoration(
                        labelText: 'Country',
                        labelStyle: AppTheme.h4.copyWith(
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
                Padding(
                  padding: EdgeInsets.only(top: 5.h, bottom: 5.h),
                  child: SizedBox(
                    width: 280.w,
                    child: TextFormField(
                      maxLines: 1,
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      style: AppTheme.h4.copyWith(
                          color: AppTheme.greyNew, fontWeight: FontWeight.w400),
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        labelStyle: AppTheme.h4.copyWith(
                            color: AppTheme.greyNew,
                            fontWeight: FontWeight.w400),
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
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 8.h, bottom: 8.h, right: 35.h, left: 8.w),
                    child: MaterialButton(
                      height: 45.h,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      onPressed: () {
                        final mobile = _phoneController.text.trim();
                        if (mobile.length == 10 && dropdownValue == 'India') {
                          setState(() {
                            isClickedContinue = true;
                          });
                          registerUser('91$mobile', context);
                        } else if (mobile.length == 9 &&
                            dropdownValue == 'UAE') {
                          setState(() {
                            isClickedContinue = true;
                          });
                          registerUser('971$mobile', context);
                        } else {
                          if (mobile.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please enter mobile number'),
                              ),
                            );
                          } else {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Error'),
                                    content: const Text(
                                      'Wrong Number of digits according to country code',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    actions: <Widget>[
                                      MaterialButton(
                                        child: const Text('Ok'),
                                        textColor: Colors.white,
                                        color: Colors.blue,
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      )
                                    ],
                                  );
                                });
                          }
                        }
                      },
                      textColor: AppTheme.blue,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      color: AppTheme.blue,
                      child: Text(
                        'Continue',
                        style: AppTheme.h4.copyWith(
                            color: isClickedContinue
                                ? AppTheme.greyNew
                                : AppTheme.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }
}
