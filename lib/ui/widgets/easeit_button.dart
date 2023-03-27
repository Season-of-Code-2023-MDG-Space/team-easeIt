import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/app_theme.dart';

class EaseItButton extends StatelessWidget {
  const EaseItButton({
    required this.onPressed,
    required this.buttonText,
    this.textStyle,
    this.padding,
    Key? key,
  }) : super(key: key);
  final VoidCallback onPressed;
  final String buttonText;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: padding ??
            EdgeInsets.only(top: 8.h, bottom: 8.h, right: 35.h, left: 8.w),
        child: MaterialButton(
          height: 45.h,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
          onPressed: onPressed,
          textColor: AppTheme.blue,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          color: AppTheme.blue,
          child: Text(
            buttonText,
            style: textStyle ?? AppTheme.h4.copyWith(color: AppTheme.white),
          ),
        ),
      ),
    );
  }
}
