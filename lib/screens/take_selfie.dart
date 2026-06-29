import 'dart:developer';
import '../constants/app_assets.dart';
import '../constants/app_colors.dart';
import '../globxpay_auth_sdk_platform_interface.dart';
import '../image_builder.dart';
import '../journey_state_manager.dart';
import '../language_manager.dart';
import '../widget/loader.dart';
import 'package:flutter/material.dart';

import 'package:idwise_flutter_sdk/idwise.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';


class TakeSelfieScreen extends StatefulWidget {
  const TakeSelfieScreen({super.key});

  @override
  State<TakeSelfieScreen> createState() => _TakeSelfieScreenState();
}

class _TakeSelfieScreenState extends State<TakeSelfieScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      GlobxpayAuthSdkPlatform.instance.changeLoading(
        false,
        onLoading: (bool isLoading) {
          if (mounted) {
            setState(() {});
          }
        },
      );
    });
  }

  static const STEP_SELFIE = '20';

  Future<void> _navigateStep(String stepId) async {
    debugPrint('TakeSelfieScreen: Starting take selfie step: $stepId (global loading false)');
    GlobxpayAuthSdkPlatform.instance.changeLoading(
      false,
      onLoading: (bool isLoading) {
        if (mounted) {
          setState(() {});
        }
      },
    );
    IDWiseDynamic.startStep(stepId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.h),
            child: ImageBuilder(
              image: AppAssets.thirdStepRegisterSVG,
              package: 'globxpay_auth_sdk',
              fit: BoxFit.fill,
            ),
          ),
          SizedBox(height: 5.h),
          Text(LanguageManager.getText("letSayGlobXpayPay")),
          SizedBox(height: 3.h),
          ImageBuilder(
            image: AppAssets.scanSelfieCircle,
            package: 'globxpay_auth_sdk',
          ),
          SizedBox(height: 3.h),
          Consumer<JourneyStateManager>(
            builder: (context, store, child) {
              return FractionallySizedBox(
                widthFactor: 0.5,
                child: Material(
                  elevation: 1.0,
                  borderRadius: BorderRadius.circular(1.2.h),
                  color: AppColors.primary,
                  child: MaterialButton(
                    height: 6.5.h,
                    minWidth: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.fromLTRB(
                      20.0,
                      15.0,
                      20.0,
                      15.0,
                    ),
                    onPressed: () {
                      _navigateStep(STEP_SELFIE);
                    },
                    child: Text(
                      LanguageManager.getText('takePicture'),
                      style: const TextStyle(
                        color: AppColors.textGreyDark,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
