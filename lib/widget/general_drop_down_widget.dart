import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';
import '../../data/kyc_data_holder_models.dart';
import '../constants/app_assets.dart';
import '../constants/app_colors.dart';
import '../language_manager.dart';

class GeneralDropDownWidget extends StatefulWidget {
  GeneralDropDownWidget({
    required this.controller,
    required this.kycQuestion,
    this.text,
    this.hint,
    this.width,
    this.validationMethod,
    super.key,
  });

  final TextEditingController controller;
  final KycQuestionModel kycQuestion;
  final String? hint;
  String? text;
  final double? width;
  final String? Function(String?)? validationMethod;

  @override
  State<GeneralDropDownWidget> createState() => _GeneralDropDownWidgetState();
}

class _GeneralDropDownWidgetState extends State<GeneralDropDownWidget> {
  dynamic textVal;
  List<DropdownMenuItem> items = [];
  bool showTextField = false;
  TextEditingController otherController = TextEditingController();

  @override
  void initState() {
    super.initState();

    for (var i in widget.kycQuestion.options) {
      items.add(DropdownMenuItem(value: i.id, child: Text(i.nameEn)));
    }

    if (widget.text?.isEmpty ?? true) {
      textVal = null;
    } else {
      try {
        textVal = widget.kycQuestion.options
            .firstWhere((element) => element.nameEn == widget.text)
            .id;
        _checkForMarried();
      } catch (e) {
        log(e.toString());
      }
    }

    widget.controller.text = textVal.toString();
  }

  void _checkForMarried() {
    if (widget.kycQuestion.nameEn == "Marital status" &&
        widget.text == "Married") {
      setState(() {
        showTextField = true;
      });
    } else {
      setState(() {
        showTextField = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 6.5.h,
          width: widget.width ?? 100.w,
          padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.4.h),
          decoration: BoxDecoration(
            color: AppColors.inputBackground,
            border: Border.all(color: AppColors.textGrey, width: 1),
            borderRadius: BorderRadius.circular(1.2.h),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              icon: Padding(
                padding: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 1.h),
                child: SvgPicture.asset(
                  AppAssets.dropDownIconSVG,
                  package: 'globxpay_auth_sdk',
                ),
              ),
              isExpanded: true,
              value: textVal,
              hint: Padding(
                padding: EdgeInsets.symmetric(horizontal: 1.h),
                child: Text(
                  widget.hint ?? '',
                  style: TextStyle(
                    fontSize: 10.5.sp,
                    color: AppColors.textGreyDark,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              elevation: 1,
              borderRadius: BorderRadius.circular(1.2.h),
              items: items,
              itemHeight: 8.5.h,
              onChanged: (val) {
                widget.controller.text = val.toString();
                setState(() {
                  textVal = val!;
                  widget.text = widget.kycQuestion.options
                      .firstWhere((element) => element.id == val)
                      .nameEn;
                  _checkForMarried();
                });
              },
            ),
          ),
        ),
        if (showTextField)
          Column(
            children: [
              SizedBox(height: 3.h),
              SizedBox(
                child: TextFormField(
                  obscureText: false,
                  style: TextStyle(color: AppColors.black),
                  keyboardType: TextInputType.name,
                  controller: otherController,
                  cursorColor: AppColors.primary,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.textGrey,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(1.2.h),
                      borderSide: const BorderSide(color: AppColors.textGrey),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 2.5.h,
                      horizontal: 2.h,
                    ),
                    hintStyle: const TextStyle(color: AppColors.textGreyDark),
                    hintText: LanguageManager.getText('nameHusbandWife'),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: AppColors.white),
                      borderRadius: BorderRadius.all(Radius.circular(1.2.h)),
                    ),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.white),
                    ),
                  ),
                  validator: (value) {
                    if (widget.validationMethod != null) {
                      return widget.validationMethod!(value);
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
      ],
    );
  }
}
