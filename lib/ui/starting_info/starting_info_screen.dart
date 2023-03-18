import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../data/services/local/storage_service.dart';
import '../../utils/app_theme.dart';
import 'bloc/starting_info_bloc.dart';

class StartingInfoScreen extends StatelessWidget {
  const StartingInfoScreen({Key? key}) : super(key: key);
  static const String id = 'starting-info';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StartingInfoBloc(),
      child: Scaffold(
        backgroundColor: AppTheme.lightBlue,
        body: SafeArea(child: StartingInfoScreenBody()),
      ),
    );
  }
}

class StartingInfoScreenBody extends StatelessWidget {
  StartingInfoScreenBody({Key? key}) : super(key: key);
  final PageController pageController = PageController();
  final storageService = StorageService();
  static const int numPages = 3;
  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 6.w),
      height: 7.62.h,
      width: 7.62.h,
      decoration: BoxDecoration(
        color: isActive ? AppTheme.blue : AppTheme.lightBlue,
        border: Border.all(color: AppTheme.greyNew),
        borderRadius: BorderRadius.all(Radius.circular(2.28.r)),
      ),
    );
  }

  List<Widget> _buildPageIndicator(int page) {
    final list = <Widget>[];
    for (var i = 0; i < numPages; i++) {
      list.add(i == page ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  bool isLastPage = false;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StartingInfoBloc, StartingInfoState>(
      listener: (context, state) {
        if (state.page == numPages - 1) {
          Scaffold.of(context).showBottomSheet(
            (context) {
              return Padding(
                padding: EdgeInsets.only(right: 20.h),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 40.h),
                    child: Container(
                      height: 45.h,
                      width: 130.w,
                      decoration: BoxDecoration(
                          color: AppTheme.blue,
                          borderRadius: BorderRadius.circular(16.r)),
                      child: GestureDetector(
                        onTap: () {
                          StorageService.instance.isFirstTime = false;
                          Get.offAllNamed('login');
                        },
                        child: Center(
                          child: Text(
                            'Get Started',
                            style: AppTheme.h4.copyWith(
                              color: AppTheme.lightBlue,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
            backgroundColor: Colors.transparent,
            enableDrag: false,
          );
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: PageView(
                    onPageChanged: (int page) {
                      context
                          .read<StartingInfoBloc>()
                          .add(StartingInfoPageChange(page: page));
                    },
                    physics: state.page == numPages - 1
                        ? const NeverScrollableScrollPhysics()
                        : const ClampingScrollPhysics(),
                    controller: pageController,
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 110.h),
                            child: SvgPicture.asset('assets/images/1.svg'),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 110.h, left: 35.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Ease your PDF &\nImage Text Search',
                                  style: AppTheme.h1.copyWith(
                                    color: AppTheme.greyNew,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20.h, left: 35.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Search by Photos\nSearch Text in super-fast way.',
                                  style: AppTheme.h4.copyWith(
                                    color: AppTheme.greyNew,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 110.h),
                            child: SvgPicture.asset('assets/images/2.svg'),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 110.h, left: 35.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Find Solutions\nOnline',
                                  style: AppTheme.h1.copyWith(
                                    color: AppTheme.greyNew,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20.h, left: 35.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Haven't found result in PDF/Image?\nDon't worry, find it on Google and Youtube.",
                                  style: AppTheme.h4.copyWith(
                                    color: AppTheme.greyNew,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 110.h),
                            child: SvgPicture.asset('assets/images/3.svg'),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 110.h, left: 35.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Forgot What you've\nSearched?",
                                  style: AppTheme.h1.copyWith(
                                    color: AppTheme.greyNew,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20.h, left: 35.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'EaseIt maintains search history\nAccess all your results anytime.',
                                  style: AppTheme.h4.copyWith(
                                    color: AppTheme.greyNew,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 50.h, bottom: 50.h, left: 35.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: _buildPageIndicator(state.page),
                  ),
                ),
              ],
            ),
            state.page == numPages - 1
                ? Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      color: AppTheme.blue,
                      height: double.infinity,
                      width: 10,
                    ),
                  )
                : CustomPaint(
                    painter: CustomShape(),
                    child: SizedBox(
                      height: double.infinity,
                      width: double.infinity,
                      child: Align(
                        alignment: const FractionalOffset(0.95, 0.715),
                        child: Container(
                          decoration: BoxDecoration(
                            border:
                                Border.all(width: 1, color: AppTheme.lightBlue),
                            color: AppTheme.blue,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                              icon: SvgPicture.asset(
                                  'assets/icons/new-arrow-1.svg'),
                              onPressed: () {
                                pageController.animateToPage(
                                  state.page + 1,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                );
                              }),
                        ),
                      ),
                    ),
                  ),
            state.page == numPages - 1
                ? const SizedBox()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 15.h, right: 15.h),
                        child: TextButton(
                          onPressed: () {
                            StorageService.instance.isFirstTime = false;
                            Get.offAllNamed('login');
                          },
                          child: Text(
                            'Skip',
                            style: AppTheme.h4.copyWith(
                              color: AppTheme.blue,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
            // Align(
            //   alignment: Alignment.centerRight,
            //   child: Container(
            //     color: AppTheme.blue,
            //     width: 10.h,
            //     height: double.infinity,
            //   ),
            // ),
          ],
        );
      },
    );
  }
}

class CustomShape extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final path = Path();
    paint.color = AppTheme.blue;
    paint.strokeWidth = 5;
    paint.style = PaintingStyle.fill;
    path.moveTo(size.width - 10, 0);
    path.lineTo(size.width - 10, size.height * 0.6);
    path.quadraticBezierTo(size.width - 15, size.height * 0.6125,
        size.width - 25, size.height * 0.625);
    path.quadraticBezierTo(size.width * 0.675, size.height * 0.7,
        size.width - 25, size.height * 0.775);
    path.quadraticBezierTo(size.width - 15, size.height * 0.785,
        size.width - 10, size.height * 0.8);
    path.lineTo(size.width - 10, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.lineTo(size.width - 10, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
