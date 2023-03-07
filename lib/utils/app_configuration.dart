import 'package:flutter/material.dart';

class AppConfiguration extends InheritedWidget {
  AppConfiguration({Key? key, required Widget child, required this.appTitle})
      : super(key: key, child: child);
  String appTitle;
  static AppConfiguration of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppConfiguration>()!;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}
