import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTheme {
  static const Color white = Colors.white,
      greyNew = Color(0xFF262626),
      lightGrey = Color(0xFF97989F),
      blue = Color(0xFF00A2AD),
      lightBlue = Color(0xFFF5F5F5);

  static TextStyle h1 = TextStyle(
        fontSize: 24.sp,
        fontWeight: FontWeight.w500,
        color: blue,
        fontFamily: 'Josefin Sans',
      ),
      h2 = TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.w500,
        color: blue,
        fontFamily: 'Josefin Sans',
      ),
      h3 = TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        color: blue,
        fontFamily: 'Josefin Sans',
      ),
      h4 = TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: blue,
        fontFamily: 'Josefin Sans',
      ),
      h5 = TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        color: blue,
        fontFamily: 'Josefin Sans',
      ),
      h6 = TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
        color: blue,
        fontFamily: 'Josefin Sans',
        fontStyle: FontStyle.italic,
      );

  // static OutlineInputBorder transparentOutlineBorder = OutlineInputBorder(
  //   borderRadius: BorderRadius.circular(8.r),
  //   borderSide: const BorderSide(color: Colors.transparent),
  // );
}
