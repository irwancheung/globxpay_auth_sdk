import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:sizer/sizer.dart';

import '../constants/app_colors.dart';
import '../language_manager.dart';

class CustomPhoneField extends StatelessWidget {
  const CustomPhoneField({
    super.key,
    this.textInputAction,
    this.focusNode,
    required this.controller,
    this.onChanged,
    this.hintText,
    this.onCountryChanged,
    this.readOnly,
    this.textColor,
    this.boarderColor,
    this.onSubmitted,
    this.onTap,
    this.fillColor,
  });

  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final TextEditingController controller;
  final ValueChanged<PhoneNumber>? onChanged;
  final String? hintText;
  final ValueChanged<Country>? onCountryChanged;
  final bool? readOnly;
  final Color? textColor;
  final Color? boarderColor;
  final Color? fillColor;
  final Function(String)? onSubmitted;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: IntlPhoneField(
        keyboardType: TextInputType.phone,
        onTap: onTap,
        controller: controller,
        focusNode: focusNode,
        style: TextStyle(color: textColor),
        textInputAction: textInputAction,
        onSubmitted: onSubmitted,
        readOnly: readOnly ?? false,
        validator: (phone) {
          try {
            if (phone?.number.isEmpty == true) {
              return 'Phone Number is Required';
            }
          } catch (e) {
            log('Not Match');
            return 'Not Match';
          }
          return null;
        },
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'\d'))],
        initialCountryCode: 'JO',
        countries: countries.where((element) => element.code != 'TW').toList(),
        invalidNumberMessage: '',
        onChanged: onChanged,
        onCountryChanged: onCountryChanged,
        autofocus: false,
        decoration: InputDecoration(
          filled: fillColor == null ? false : true,
          fillColor: fillColor,
          enabled: true,
          contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          counterStyle: TextStyle(color: textColor),
          floatingLabelStyle: TextStyle(color: textColor),
          //suffixStyle: ,
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: boarderColor ?? Colors.grey),
            borderRadius: BorderRadius.circular(1.2.h),
          ),
          focusColor: boarderColor ?? Colors.grey,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(1.2.h),
            borderSide: BorderSide(color: boarderColor ?? AppColors.primary),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(1.2.h),
            borderSide: BorderSide(color: boarderColor ?? AppColors.primary),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(1.2.h),
            borderSide: BorderSide(color: boarderColor ?? Colors.red),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(1.2.h),
            borderSide: BorderSide(color: AppColors.primary),
          ),
          hintText: hintText,
          hintStyle: const TextStyle(
            fontSize: 14,
            color: AppColors.textGreyDark,
          ),
        ),
        languageCode: LanguageManager.currentLanguage.toString(),
        dropdownTextStyle: TextStyle(color: textColor),
        textAlign: TextAlign.left,
        textAlignVertical: TextAlignVertical.center,
        dropdownIcon: Icon(
          Icons.arrow_drop_down,
          color: textColor ?? Theme.of(context).iconTheme.color,
        ),
      ),
    );
  }
}
