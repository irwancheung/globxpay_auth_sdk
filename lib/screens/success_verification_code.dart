
import '../constants/app_assets.dart';
import '../constants/app_colors.dart';

import '../globxpay_auth_sdk_platform_interface.dart';
import '../image_builder.dart';
import '../language_manager.dart';
import '../widget/button.dart';
import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';


class SuccessVerificationCodeScreen extends StatelessWidget {
  const SuccessVerificationCodeScreen({
    super.key,
    this.isFirstTimeLogin = false,
  });

  final bool isFirstTimeLogin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.h),
                child: ImageBuilder(
                  image: AppAssets.secondStepRegisterSVG,
                  package: 'globxpay_auth_sdk',
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(height: 15.h),
              ImageBuilder(
                image: AppAssets.tickSVG,
                package: 'globxpay_auth_sdk',
                fit: BoxFit.cover,
              ),
              SizedBox(height: 1.5.h),
              Text(
                LanguageManager.getText('yourMobileNumberIsVerified'),
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 15.0.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 10.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.5.h),
                child: CustomButton(
                  text: LanguageManager.getText('next'),
                  onPressed: () {

                    GlobxpayAuthSdkPlatform.instance
                          .registrationPageController
                          .jumpToPage(3);
                    }
                 
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
