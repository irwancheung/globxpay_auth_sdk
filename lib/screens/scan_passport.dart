import '../constants/app_assets.dart';
import '../constants/app_colors.dart';
import '../globxpay_auth_sdk_platform_interface.dart';
import '../image_builder.dart';
import '../language_manager.dart';
import '../widget/button.dart';
import '../widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ScanPassportScreen extends StatefulWidget {
  const ScanPassportScreen({super.key, required this.resumeJourney});

  final Future<void> Function() resumeJourney;

  @override
  State<ScanPassportScreen> createState() => _ScanPassportScreenState();
}

class _ScanPassportScreenState extends State<ScanPassportScreen> {
  @override
  void initState() {
    super.initState();
    GlobxpayAuthSdkPlatform.instance.isCompleteSummary = false;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: GlobxpayAuthSdkPlatform.instance.sdkLoading,
      builder: (context, sdkLoading, child) {
        return Stack(
          children: [
            Scaffold(
              body: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(height: 8.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4.h),
                              child: ImageBuilder(
                                image: AppAssets.firstStepRegisterSVG,
                                package: 'globxpay_auth_sdk',
                                fit: BoxFit.fill,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(LanguageManager.getText('ScanYourPassport')),
                            SizedBox(height: 2.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4.5.h),
                              child: ImageBuilder(
                                image: AppAssets.passport,
                                package: 'globxpay_auth_sdk',
                                fit: BoxFit.contain,
                              ),
                            ),
                            SizedBox(height: 3.h),
                            Center(
                              child: Text(
                                '\t${LanguageManager.getText('PositionPassportFrame')}',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    sdkLoading
                        ? Center(
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                progressIndicatorTheme:
                                    const ProgressIndicatorThemeData(
                                      color: AppColors.primary,
                                    ),
                              ),
                              child: const CircularProgressIndicator.adaptive(),
                            ),
                          )
                        : Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.5.h),
                            child: CustomButton(
                              text: LanguageManager.getText('scan'),
                              onPressed: () async {
                                try {
                                  await widget.resumeJourney();
                                } catch (e) {
                                  // Handled inside
                                }
                              },
                            ),
                          ),
                    SizedBox(height: 5.h),
                  ],
                ),
              ),
            ),
            if (sdkLoading) const LoaderWidget(),
          ],
        );
      },
    );
  }
}
