import 'package:ease_it/ui/widgets/pdf_results.dart';
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
                'Hello !',
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
        body: const HomeBody(),
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
  String textToFind = '';
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is Success || state is HomeInitial) {
          return SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 10.h, bottom: 5.h, right: 10.w, left: 10.w),
                    child: Builder(builder: (newContext) {
                      return GestureDetector(
                        onTap: () async {
                          showDialog(
                              context: context,
                              builder: (ctx) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.r),
                                    side: const BorderSide(
                                        width: 2, color: AppTheme.blue),
                                  ),
                                  backgroundColor: AppTheme.lightBlue,
                                  title: Text(
                                    'Type Text',
                                    style: AppTheme.h3.copyWith(
                                        color: AppTheme.blue,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  elevation: 5,
                                  actions: [
                                    TextFormField(
                                      onChanged: (value) {
                                        textToFind = value;
                                      },
                                      style: AppTheme.h4.copyWith(
                                          color: AppTheme.greyNew,
                                          fontWeight: FontWeight.w300),
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          Get.back();
                                          newContext.read<HomeBloc>().add(
                                              PDFPickEvent(
                                                  textToFind: textToFind));
                                        },
                                        child: Text(
                                          'Search',
                                          style: AppTheme.h3.copyWith(
                                              color: AppTheme.blue,
                                              fontWeight: FontWeight.w500),
                                        )),
                                  ],
                                );
                              });
                        },
                        child: SizedBox(
                          width: double.infinity,
                          child: Card(
                            elevation: 2,
                            color: Colors.pink.withAlpha(70),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.file_copy_outlined,
                                    color: AppTheme.blue, size: 50.w),
                                SizedBox(width: 10.w),
                                Text(
                                  'Search in PDFs',
                                  style: AppTheme.h2
                                      .copyWith(color: AppTheme.blue),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 10.h, bottom: 5.h, right: 10.w, left: 10.w),
                    child: GestureDetector(
                      onTap: () {},
                      child: SizedBox(
                        width: double.infinity,
                        child: Card(
                          elevation: 2,
                          color: Colors.green.withAlpha(70),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.photo_library_outlined,
                                  color: AppTheme.blue, size: 50.w),
                              SizedBox(width: 10.w),
                              Text(
                                'Search in Images',
                                style:
                                    AppTheme.h2.copyWith(color: AppTheme.blue),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 10.h, bottom: 5.h, right: 10.w, left: 10.w),
                    child: GestureDetector(
                      onTap: () {
                        print('PRESSSSSSEDDDD');
                      },
                      child: SizedBox(
                        width: double.infinity,
                        child: Card(
                          elevation: 2,
                          color: Colors.amberAccent.withAlpha(70),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.camera_alt_outlined,
                                  color: AppTheme.blue, size: 50.w),
                              SizedBox(width: 10.w),
                              Text(
                                'Scan Text with Camera',
                                style:
                                    AppTheme.h2.copyWith(color: AppTheme.blue),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else if (state is ShowResultPDF) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => PDFResults(
                        outputFile: state.pdfFile,
                        resultsData: state.resultsData,
                        textSearched: textToFind,
                      ))).then((value) {
            Navigator.pop(context);
            Get.offAndToNamed('home');
          });
        } else if (state is Error) {
          return Center(
              child: Text('Something Went Wrong!',
                  style: AppTheme.h2.copyWith(color: Colors.red)));
        }
        print(state);
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
