import 'dart:developer';


import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../constants/app_assets.dart';
import '../constants/app_colors.dart';
import '../image_builder.dart';
import '../language_manager.dart';
import '../models/get_lookup_details.dart';

class DropdownIdentityTypeTextField extends StatefulWidget {
  const DropdownIdentityTypeTextField({
    required this.controller,
    required this.result,
    this.text,
    this.hint,
    this.width,
    this.validationMethod,
    super.key,
    this.height,
    this.onChanged
  });

  final TextEditingController controller;
  final List<ResultLookupsDetails> result;
  final String? hint;
  final String? text;
  final double? width;
  final double? height;
  final String? Function(String?)? validationMethod;
  final Function(Object?)? onChanged;
  @override
  State<DropdownIdentityTypeTextField> createState() =>
      _DropdownIdentityTypeTextFieldState();
}

class _DropdownIdentityTypeTextFieldState
    extends State<DropdownIdentityTypeTextField> {
  dynamic textVal;
  List<DropdownMenuItem> items = [];

  int index = 0;

  // This shows a CupertinoModalPopup with a reasonable fixed height which hosts CupertinoPicker.

  @override
  void initState() {
    // TODO: implement initState

    for (var i in widget.result) {
      items.add(DropdownMenuItem(
          value: i.id,
          child: Text(
            i.englishDisplayName!,
          )));
    }

    if (widget.text!.isEmpty) {
      textVal = null;
    } else {
      // AppSharedPreferences.lang == "en"
      //     ?
      try {
        textVal = widget.result
            .firstWhere(
              (element) => element.englishDisplayName == widget.text,
            )
            .id;
      } catch (e) {
        log(e.toString());
      }
    }
    widget.controller.text = textVal.toString();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height ?? 8.h,
      width: widget.width ?? 100.w,
      //     padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.4.h),
      decoration: BoxDecoration(
        color: AppColors.textGrey,
        border: Border.all(
          color: AppColors.textGrey,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(1.2.h),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          // decoration: InputDecoration(
          //     enabledBorder: UnderlineInputBorder(
          //         borderSide:
          //             BorderSide(color: AppColors.searchFieldBackground))),
          icon: Padding(
            padding: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 1.h),
            child: ImageBuilder(
              image: AppAssets.dropDownIconSVG,
              package: 'globxpay_auth_sdk',
            ),
          ),
          isExpanded: true,
          value: textVal,
          hint: Padding(
            padding: EdgeInsets.symmetric(horizontal: 1.h),
            child: Text(
              '${widget.hint}',
              style: TextStyle(
                fontSize: 10.5.sp,
                color: AppColors.textGreyDark,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          elevation: 1,
          borderRadius: BorderRadius.circular(1.2.h),

          items: List.generate(
            widget.result.length,
            (i) => DropdownMenuItem(
              value: widget.result[i].id,
              child: LanguageManager.currentLanguage  == 'ar'
                  ? Text('${widget.result[i].arabicDisplayName}')
                  : Text('${widget.result[i].englishDisplayName}'),
            ),
          ),
          itemHeight: 8.5.h,
          // autovalidateMode: AutovalidateMode.onUserInteraction,
          // validator: (value) {
          //   return widget.validationMethod!(value);
          // },
          onChanged: (val) {
            widget.controller.text = val!.toString();
            setState(() {
              textVal = val;
            });
          },
          //style: AppStyles.simpleTextFieldStyle(fontSize: widget.fontSize),
        ),
      ),
    );
  }
}
