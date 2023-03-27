import 'package:flutter/material.dart';

import '../../utils/app_theme.dart';

class TextInput extends StatelessWidget {
  const TextInput({
    required this.hintText,
    this.action = TextInputAction.next,
    this.controller,
    this.labelText,
    this.initialValue = '',
    this.keyboard,
    this.maxLines = 1,
    this.obscureText = false,
    this.onChanged,
    this.validator,
    this.suffix,
    this.isFilled,
    this.fillColor,
    this.onSubmitted,
    this.enable = true,
    Key? key,
  }) : super(key: key);

  final bool obscureText;
  final int maxLines;
  final String initialValue;

  final String hintText;
  final String? labelText;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;

  final String? Function(String?)? validator;
  final TextInputAction action;
  final TextInputType? keyboard;
  final TextEditingController? controller;
  final Widget? suffix;
  final bool? isFilled;
  final Color? fillColor;
  final bool enable;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        hintStyle: AppTheme.h4
            .copyWith(color: AppTheme.lightGrey, fontWeight: FontWeight.w400),
        contentPadding: const EdgeInsets.fromLTRB(5.0, 1.0, 5.0, 1.0),
        labelStyle: AppTheme.h3
            .copyWith(color: AppTheme.greyNew, fontWeight: FontWeight.w400),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: AppTheme.blue,
            width: 2,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: AppTheme.lightGrey,
            width: 2,
          ),
          gapPadding: 5,
        ),
        suffixIcon: suffix,
        errorStyle: const TextStyle(
          color: Colors.red,
          height: 0,
        ),
        prefixIconColor: Colors.blue,
        filled: isFilled,
        fillColor: fillColor,
      ),
      initialValue: controller == null ? initialValue : null,
      keyboardType: keyboard,
      obscureText: obscureText,
      onChanged: onChanged,
      validator: validator,
      textInputAction: action,
      onFieldSubmitted: onSubmitted,
      enabled: enable,
    );
  }
}
