import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/app_theme.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);
  static const id = 'sign-up';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightpurple,
      appBar: AppBar(
        title: Text(
          'Sign Up',
          style: AppTheme.h2.copyWith(color: AppTheme.lightGreen),
        ),
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
            TextButton(onPressed: null, child: Text('Login')),
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
