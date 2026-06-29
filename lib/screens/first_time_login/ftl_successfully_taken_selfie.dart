import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../constants/app_assets.dart';
import '../../constants/app_colors.dart';
import '../../globxpay_auth_sdk_platform_interface.dart';
import '../../image_builder.dart';
import '../../language_manager.dart';
import '../../registration_data.dart';
import '../../utils/dialogs.dart';
import '../../widget/waiting_screen.dart';

class FtlSuccessfullyTakenSelfieScreen extends StatefulWidget {
  const FtlSuccessfullyTakenSelfieScreen({super.key});

  @override
  State<FtlSuccessfullyTakenSelfieScreen> createState() =>
      _FtlSuccessfullyTakenSelfieScreenState();
}

class _FtlSuccessfullyTakenSelfieScreenState
    extends State<FtlSuccessfullyTakenSelfieScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint('FtlSuccessfullyTakenSelfieScreen: Resetting loading on init');
      GlobxpayAuthSdkPlatform.instance.changeLoading(
        false,
        onLoading: (_) {
          if (mounted) setState(() {});
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 5.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.h),
              child: ImageBuilder(
                image: AppAssets.thirdStepRegisterSVG,
                package: 'globxpay_auth_sdk',
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(height: 8.h),
            Text(LanguageManager.getText('yourPhotoWasSuccessfullyTaken')),
            SizedBox(height: 5.h),
            Stack(
              alignment: Alignment.center,
              children: [
                ClipOval(
                  child: ImageBuilder(
                    image: RegistrationData.getselfieImage(),
                    isBase64: true,
                    height: 35.h,
                    width: 35.h,
                    fit: BoxFit.fill,
                  ),
                ),
                Positioned(
                  child: ImageBuilder(
                    image: AppAssets.scanSelfieCircle,
                    package: 'globxpay_auth_sdk',
                    fit: BoxFit.cover,
                    height: 40.h,
                    width: 40.h,
                  ),
                ),
              ],
            ),
            SizedBox(height: 5.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.5.h),
              child: Material(
                elevation: 1.0,
                borderRadius: BorderRadius.circular(1.2.h),
                color: AppColors.primary,
                child: MaterialButton(
                  height: 6.5.h,
                  minWidth: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                  onPressed: _submitIdWiseInfo,
                  child: Text(
                    LanguageManager.getText('next'),
                    style: const TextStyle(color: AppColors.textGreyDark),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitIdWiseInfo() {
    debugPrint('FtlSuccessfullyTakenSelfieScreen: Submitting IDWise info (global loading)');
    GlobxpayAuthSdkPlatform.instance.updateIDWiseInfo(
      onSuccess: () {
        debugPrint('FtlSuccessfullyTakenSelfieScreen: IDWise info update success');
        final model = GlobxpayAuthSdkPlatform.instance.firstTimeLoginModel;
        final requiresKyc = model?.isKycRequired == true;
        GlobxpayAuthSdkPlatform.instance.firstTimeLoginPageController
            .jumpToPage(requiresKyc ? 8 : 9);
      },
      onError: (error) {
        debugPrint('FtlSuccessfullyTakenSelfieScreen: IDWise info update error: $error');
        Dialogs.errorDialog(context, message: error, barrierDismissible: true);
      },
      onLoading: (isLoading) {
        debugPrint('FtlSuccessfullyTakenSelfieScreen: IDWise info update loading: $isLoading (global source)');
        if (mounted) {
          GlobxpayAuthSdkPlatform.instance.changeLoading(
            isLoading,
            onLoading: (_) {
              if (mounted) setState(() {});
            },
          );
        }
      },
    );
  }
}
