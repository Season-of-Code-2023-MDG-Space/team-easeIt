import 'dart:js_util';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../utils/app_theme.dart';
import 'bloc/login_bloc.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const id = 'login';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightpurple,
      appBar: AppBar(
        title: Text(
          'Login Screen',
          style: AppTheme.h2.copyWith(color: AppTheme.lightGreen),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            TextFormField(
              initialValue: 'Email',
            ),
            TextFormField(
              initialValue: 'Password',
              obscureText: true,
            ),
            TextButton(
                onPressed: () {
                  context.read<LoginBloc>().add(LoginEvent());
                },
                child: Text('Login')),
            Row(children: [
              Text("Didn't have account?"),
              TextButton(
                onPressed: () => Get.toNamed('sign-up'),
                child: Text('Sign Up here'),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
