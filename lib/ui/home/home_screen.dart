import 'package:flutter/material.dart';

import '../../utils/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const id = 'home';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightBlue,
      appBar: AppBar(
        title: Text(
          'Home',
          style: AppTheme.h2.copyWith(color: AppTheme.blue),
        ),
      ),
    );
  }
}
