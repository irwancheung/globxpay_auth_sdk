import 'package:globxpay_auth_sdk/globxpay_auth_sdk_platform_interface.dart';
import 'package:globxpay_auth_sdk/widget/button.dart';

import '../api/network.dart';
import '../constants/app_assets.dart';
import '../language_manager.dart';
import 'package:flutter/material.dart';
import '../image_builder.dart';
import 'package:sizer/sizer.dart';

class SuccessfullyCreatedAccountScreen extends StatefulWidget {
  const SuccessfullyCreatedAccountScreen({
    super.key,
    //this.isFirstTimeLogin = false,
  });

  @override
  State<SuccessfullyCreatedAccountScreen> createState() =>
      _SuccessfullyCreatedAccountScreenState();
}

class _SuccessfullyCreatedAccountScreenState
    extends State<SuccessfullyCreatedAccountScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ImageBuilder(
                image: AppAssets.complete_register_stepsSVG,
                package: 'globxpay_auth_sdk',
                fit: BoxFit.fill,
              ),
              Text(
                LanguageManager.getText(
                  'yourGlobXpayAccountIsSuccessfullyCreated',
                ),
                textAlign: TextAlign.center,
              ),

              ImageBuilder(
                image: AppAssets.globXLogoSVG,
                package: 'globxpay_auth_sdk',
                fit: BoxFit.fill,
                height: 25.h,
                width: 20.w,
              ),
              SizedBox(height: 6.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: CustomButton(
                  text: LanguageManager.getText('backToFirstScreen'),
                  onPressed: () {
                    GlobxpayAuthSdkPlatform.instance.registrationPageController
                        .jumpToPage(0);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
