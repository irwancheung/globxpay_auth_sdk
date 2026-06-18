import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../constants/app_colors.dart';

class TextFormFieldWidget extends StatefulWidget {
  const TextFormFieldWidget({
    super.key,
    required this.controller,
    this.obscureText,
    this.textInputAction,
    this.keyboardType,
    this.hintText,
    this.validationMethod,
    this.onSubmitted,
    this.enableColor,
    this.borderSideColor,
    this.textAlign,
    this.focusNode,
    this.onChange,
    this.inputFormatters,
    this.textColor,
    this.autofocus,
    this.suffixIcon,
    this.suffixIconConstraints,
    this.filled,
    this.fillColor,
    this.contentPadding,
    this.enabled,
    this.prefix,
    this.onTap,
    this.maxLength,
    this.fontSize = 10.0,
    this.cursorColor,
    this.readOnly = false,
  });

  final TextEditingController controller;
  final bool? obscureText;
  final bool? autofocus;
  final bool? enabled;
  final bool readOnly;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? hintText;
  final String? Function(String?)? validationMethod;
  final Function(String)? onSubmitted;
  final Color? enableColor;
  final Color? textColor;
  final Color? borderSideColor;
  final Function(String)? onChange;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffixIcon;
  final Widget? prefix;
  final TextAlign? textAlign;
  final FocusNode? focusNode;
  final BoxConstraints? suffixIconConstraints;
  final bool? filled;
  final Color? fillColor;
  final EdgeInsetsGeometry? contentPadding;
  final int? maxLength;
  final Function()? onTap;
  final double fontSize;
  final Color? cursorColor;

  @override
  State<TextFormFieldWidget> createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState extends State<TextFormFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: widget.enabled,
      maxLength: widget.maxLength,
      focusNode: widget.focusNode,
      readOnly: widget.readOnly,
      textAlign: widget.textAlign ?? TextAlign.start,
      obscureText: widget.obscureText ?? false,
      onTap: widget.onTap,
      cursorColor: widget.cursorColor ?? AppColors.primary,
      style: TextStyle(
          color: widget.textColor ?? AppColors.white,
          fontSize: widget.fontSize.sp),
      controller: widget.controller,
      autofocus: widget.autofocus ?? false,
      keyboardType: widget.keyboardType ?? TextInputType.name,
      textInputAction: widget.textInputAction,
      decoration: InputDecoration(
        filled: widget.filled,
        fillColor: widget.fillColor,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(1.2.h),
          borderSide: BorderSide(
            color: widget.borderSideColor ??
               AppColors.primary),
          ),
        
        contentPadding: widget.contentPadding ??
            EdgeInsets.symmetric(
              vertical: 2.h,
              horizontal: 2.h,
            ),
        hintText: widget.hintText ?? "",
        suffixIcon: widget.suffixIcon,
        prefix: widget.prefix,
        suffixIconConstraints: widget.suffixIconConstraints,
        hintStyle: const TextStyle(color: AppColors.textGreyDark),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: widget.enableColor ?? AppColors.white,
          ),
          borderRadius: BorderRadius.all(Radius.circular(1.2.h)),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color.fromARGB(255, 212, 69, 58)),
          borderRadius: BorderRadius.all(Radius.circular(1.2.h)),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: widget.enableColor ?? AppColors.white),
          borderRadius: BorderRadius.all(Radius.circular(1.2.h)),
        ),
        disabledBorder: widget.enabled != null
            ? OutlineInputBorder(
                borderSide:
                    BorderSide(color: widget.enableColor ?? AppColors.white),
                borderRadius: BorderRadius.all(Radius.circular(1.2.h)),
              )
            : null,
      ),
      onTapOutside: (_) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      validator: (String? val) {
        if (widget.validationMethod != null) {
          return widget.validationMethod!(val);
        }
        setState(() {});
        return null;
      },
      inputFormatters: widget.inputFormatters,
      onFieldSubmitted: (value) {
        if (widget.onSubmitted != null) {
          widget.onSubmitted!(value);
        }
      },
      onChanged: (value) =>
          widget.onChange == null ? () {} : widget.onChange!(value),
    );
  }
}
