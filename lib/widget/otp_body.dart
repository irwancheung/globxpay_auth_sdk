import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:globxpay_auth_sdk/widget/text_form_field_widget.dart';
import 'package:globxpay_auth_sdk/widget/waiting_screen.dart';
import 'package:sizer/sizer.dart';

import '../constants/app_colors.dart';
import '../language_manager.dart';
import '../registration_data.dart';
import '../utils/dialogs.dart';
import 'button.dart';

class OTPBody extends StatefulWidget {
  const OTPBody({
    super.key,
    required this.onSubmitted,
    required this.otpController,
    required this.isLoading,
    required this.onWrongMobileNumber,
    required this.onResendOTP,
    this.inAppLogin = false,
    this.showLoading = true,
    this.showResendOTP = true,
    this.phoneText,
  });

  final Function(String) onSubmitted;
  final Function() onWrongMobileNumber;
  final Function() onResendOTP;
  final TextEditingController otpController;
  final bool isLoading;
  final bool inAppLogin;
  final String? phoneText;
  final bool showLoading;
  final bool showResendOTP;

  @override
  State<OTPBody> createState() => _OTPBodyState();
}

class _OTPBodyState extends State<OTPBody> {
  late Timer _timer;
  int _remainingSeconds = 90;

  @override
  void initState() {
    super.initState();
    if (widget.showResendOTP) {
      _startTimer();
    }
  }

  @override
  void dispose() {
    if (widget.showResendOTP) {
      _timer.cancel();
    }
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds == 0) {
        _timer.cancel();
      } else {
        setState(() {
          _remainingSeconds--;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: 16.h),
              Text(
                LanguageManager.getText('verifyMobileNumber'),
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 16.0.sp,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Cairo',
                ),
              ),
              SizedBox(height: 4.h),
              Visibility(
                visible: !widget.inAppLogin,
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: LanguageManager.getText(
                          'verificationCodeWillBeSentViaSMS',
                        ),
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 13.0.sp,
                          fontWeight: FontWeight.w200,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: widget.inAppLogin,
                child: Text(
                  LanguageManager.getText('verificationCodeWillBeSentViaSMS'),
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 14.0.sp,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ),
              Directionality(
                textDirection: TextDirection.ltr,
                child: Center(
                  child: Text(
                    widget.phoneText ?? RegistrationData.getPhoneNumber(),
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 14.0.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 4.h),
              Visibility(
                visible: !widget.inAppLogin,
                child: InkWell(
                  onTap: widget.onWrongMobileNumber,
                  child: Container(
                    width: 50.w,
                    padding: const EdgeInsets.only(bottom: 5),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: AppColors.primary,
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        LanguageManager.getText('wrongMobileNumber'),
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 13.5.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                LanguageManager.getText('enterVerificationCode'),
                style: TextStyle(
                  color: AppColors.textGreyDark,
                  fontSize: 14.0.sp,
                ),
              ),
              SizedBox(height: 2.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.5.h),
                child: TextFormFieldWidget(
                  textAlign: TextAlign.center,
                  fontSize: 15.sp,
                  autofocus: true,
                  controller: widget.otpController,
                  textColor: AppColors.textGreyDark,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  validationMethod: (p0) {
                    if (p0!.isEmpty) {
                      return LanguageManager.getText('otpRequired');
                    }
                    return null;
                  },
                  enableColor: AppColors.primary,
                  onSubmitted: widget.onSubmitted,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(
                        r'^[0-9]{0,6}$',
                      ), // Allows only English digits (0-9) up to 6 digits
                    ),
                  ],
                ),
              ),
              SizedBox(height: 2.h),
              Visibility(
                visible: widget.showResendOTP,
                child: _remainingSeconds > 0
                    ? Text(
                        "${LanguageManager.getText('resendVerificationCode')} ${LanguageManager.getText('in')} $_remainingSeconds ${LanguageManager.getText('seconds')}",
                        style: TextStyle(
                          color: AppColors.textGreyDark,
                          fontSize: 14.0.sp,
                        ),
                      )
                    : InkWell(
                        onTap: () {
                          widget.onResendOTP();
                          setState(() {
                            _remainingSeconds = 90;
                          });
                          _startTimer();
                        },
                        child: Text(
                          LanguageManager.getText('resendVerificationCode'),
                          style: TextStyle(
                            color: AppColors.textGreyDark,
                            fontSize: 14.0.sp,
                          ),
                        ),
                      ),
              ),
              SizedBox(height: 4.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.5.h),
                child: CustomButton(
                  text: LanguageManager.getText('verify'),
                  onPressed: () {
                    if (widget.otpController.text.trim().isEmpty) {
                      Dialogs.animatedSnackBar(
                        context,
                        message: LanguageManager.getText(
                          'verificationCodeIsRequired',
                        ),
                      );
                      return;
                    }

                    if (_remainingSeconds == 0) {
                      Dialogs.errorDialog(
                        context,
                        message: LanguageManager.getText('otpIsExpired'),
                      );
                      return;
                    }

                    widget.onSubmitted(
                      widget.phoneText ?? RegistrationData.getPhoneNumber(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        Visibility(
          visible: widget.isLoading && widget.showLoading,
          child: const WaitingScreen(),
        ),
      ],
    );
  }
}
