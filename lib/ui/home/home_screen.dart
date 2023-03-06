import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../data/services/local/storage_service.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/user_repository.dart';
import '../../utils/app_theme.dart';
import 'bloc/home_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const id = 'home';
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(
          userRepository: context.read<UserRepository>(),
          authRepository: context.read<AuthRepository>())
        ..add(const GetUserDataEvent()),
      child: Scaffold(
        backgroundColor: AppTheme.lightBlue,
        appBar: AppBar(
          elevation: 2,
          backgroundColor: AppTheme.lightBlue,
          leading: Padding(
            padding: EdgeInsets.all(5.h),
            child: CircleAvatar(
              backgroundColor: AppTheme.blue,
              radius: 20.h,
            ),
          ),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'Hello UserName!',
                style: AppTheme.h4,
              ),
              Text(
                'Have a Great Day!',
                style: AppTheme.h4,
              ),
            ],
          ),
          actions: [
            Builder(builder: (blocContext) {
              return IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Builder(
                          builder: (context) => AlertDialog(
                                title: const Text('Do you want to exit?'),
                                actions: <Widget>[
                                  Builder(
                                    builder: (context) => TextButton(
                                      child: const Text('Yes'),
                                      onPressed: () {
                                        blocContext
                                            .read<HomeBloc>()
                                            .add(const Logout());
                                      },
                                    ),
                                  ),
                                  TextButton(
                                    child: const Text('Cancel'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ));
                    },
                  );
                },
                icon: const Icon(
                  Icons.logout_outlined,
                  color: AppTheme.blue,
                ),
              );
            }),
          ],
        ),
        body: HomeBody(),
        floatingActionButton: Padding(
          padding: EdgeInsets.all(10.h),
          child: FloatingActionButton(
            elevation: 3,
            backgroundColor: AppTheme.blue,
            onPressed: () {},
            child: const Icon(Icons.add, color: AppTheme.lightBlue),
          ),
        ),
      ),
    );
  }
}

class HomeBody extends StatefulWidget {
  const HomeBody({Key? key}) : super(key: key);

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is Success) {
          return const SingleChildScrollView();
        } else if (state is Error) {
          return Center(
              child: Text('Something Went Wrong!',
                  style: AppTheme.h2.copyWith(color: Colors.red)));
        }
        return const Center(child: CircularProgressIndicator());
      },
      listener: (context, state) {
        if (state is LogoutSuccess) {
          StorageService.instance.isLoggedIn = false;
          Get.offAllNamed('login');
        }
      },
    );
  }
}
