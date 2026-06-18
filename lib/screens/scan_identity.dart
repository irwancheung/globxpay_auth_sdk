import '../constants/app_assets.dart';
import '../globxpay_auth_sdk_platform_interface.dart';
import '../image_builder.dart';
import '../language_manager.dart';
import '../widget/button.dart';
import '../widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ScanIdentityScreen extends StatefulWidget {
  const ScanIdentityScreen({super.key, required this.resumeJourney});

  final Future<void> Function() resumeJourney;

  @override
  State<ScanIdentityScreen> createState() => _ScanIdentityScreenState();
}

class _ScanIdentityScreenState extends State<ScanIdentityScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    GlobxpayAuthSdkPlatform.instance.isCompleteSummary = false;
    GlobxpayAuthSdkPlatform.instance.isIdentity = true;
  }

  @override
  Widget build(BuildContext context) {
    // Standardized spacing constants
    const double horizontalPadding = 4.0;
    const double largeSpacing = 4.0;
    const double mediumSpacing = 3.0;
    const double smallSpacing = 2.0;
    const double tinySpacing = 1.0;

    return Stack(
      children: [
        Scaffold(
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 10.h),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Column(
                      children: [
                        SizedBox(height: mediumSpacing.h),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: horizontalPadding.h,
                          ),
                          child: ImageBuilder(
                            image: AppAssets.firstStepRegisterSVG,
                            package: 'globxpay_auth_sdk',
                            fit: BoxFit.fill,
                          ),
                        ),
                        SizedBox(height: smallSpacing.h),
                        Text(LanguageManager.getText('ScanYourID')),
                        SizedBox(height: mediumSpacing.h),
                        Column(
                          children:
                              GlobxpayAuthSdkPlatform
                                  .instance
                                  .registrationDocumentType
                                  ?.images
                                  .map((image) {
                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: horizontalPadding.h,
                                        vertical: tinySpacing.h,
                                      ),
                                      child: ImageBuilder(
                                        image: image,
                                        package: 'globxpay_auth_sdk',
                                        fit: BoxFit.contain,
                                      ),
                                    );
                                  })
                                  .toList() ??
                              [],
                        ),
                        Padding(
                          padding: EdgeInsets.all(mediumSpacing.h),
                          child: Text(
                            LanguageManager.getText(
                              'positionTheFrontSideOfYourIDInTheFrameThenFlipItToScanBackSide',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding.h,
                  ),
                  child: CustomButton(
                    text: LanguageManager.getText('scan'),
                    onPressed: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      try {
                        await widget.resumeJourney();
                      } finally {
                        if (mounted) {
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      }
                    },
                  ),
                ),
                SizedBox(height: largeSpacing.h),
              ],
            ),
          ),
        ),
        if (_isLoading) const LoaderWidget(),
      ],
    );
  }
}
