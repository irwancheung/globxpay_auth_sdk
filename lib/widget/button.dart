import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../constants/app_colors.dart';

class CustomButton extends StatelessWidget {
  CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
    this.isLoginPage,
    this.borderRadius,
    this.color,
    this.textColor,
  });

  final String text;
  final Function()? onPressed;
  final double? width;
  bool? isLoginPage;
  final BorderRadius? borderRadius;
  final Color? color;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    Color buttonColor;

    if (color != null) {
      buttonColor = color!;
    } else {
      buttonColor = AppColors.primary;
    }

    return Material(
      elevation: 1.0,
      borderRadius: borderRadius ?? BorderRadius.circular(1.3.h),
      color: buttonColor,
      child: MaterialButton(
        height: 6.h,
        minWidth: width ?? MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            color: textColor ?? AppColors.textGrey,
            fontWeight: FontWeight.w500,
            fontSize: 14.sp,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
