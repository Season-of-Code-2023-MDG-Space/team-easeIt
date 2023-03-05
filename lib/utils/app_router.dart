import 'package:flutter/material.dart';

import '../ui/home/home_screen.dart';
import '../ui/login/login_screen.dart';
import '../ui/signup/signup_screen.dart';
import 'app_theme.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case LoginScreen.id:
        return MaterialPageRoute<Widget>(
          builder: (BuildContext context) => const LoginScreen(),
        );
      case SignUpScreen.id:
        return MaterialPageRoute<Widget>(
          builder: (BuildContext context) => const SignUpScreen(),
        );
      case HomeScreen.id:
        return MaterialPageRoute<Widget>(
          builder: (BuildContext context) => const HomeScreen(),
        );
      default:
        return MaterialPageRoute<Widget>(
          builder: (_) => const Scaffold(
            backgroundColor: AppTheme.green,
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
    }
  }
}
