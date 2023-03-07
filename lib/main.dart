import 'package:ease_it/data/services/local/storage_service.dart';
import 'package:ease_it/ui/home/home_screen.dart';
import 'package:ease_it/ui/login/login_screen.dart';
import 'package:ease_it/ui/starting_info/starting_info_screen.dart';
import 'package:ease_it/utils/app_configuration.dart';
import 'package:ease_it/utils/app_router.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/user_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.getInstance();
  await Firebase.initializeApp();
  final appData = AppConfiguration(
    appTitle: 'EaseIt',
    child: const EaseIt(),
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(appData));
}

class EaseIt extends StatefulWidget {
  const EaseIt({super.key});

  @override
  State<EaseIt> createState() => _EaseItState();
}

class _EaseItState extends State<EaseIt> {
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider(create: (ctx) => AuthRepository()),
          RepositoryProvider(create: (ctx) => UserRepository())
        ],
        child: ScreenUtilInit(
          builder: (_, child) {
            return GetMaterialApp(
              title: AppConfiguration.of(context).appTitle,
              debugShowCheckedModeBanner: false,
              onGenerateRoute: AppRouter.generateRoute,
              initialRoute: StorageService.instance.isFirstTime
                  ? StartingInfoScreen.id
                  : StorageService.instance.isLoggedIn
                      ? HomeScreen.id
                      : LoginScreen.id,
              routes: <String, WidgetBuilder>{
                '/': (ctx) => const LoginScreen(),
              },
            );
          },
          designSize: const Size(360, 640),
        ));
  }
}
