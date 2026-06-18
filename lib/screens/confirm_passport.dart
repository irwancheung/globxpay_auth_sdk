
import '../constants/app_assets.dart';
import '../constants/app_colors.dart';

import '../globxpay_auth_sdk_platform_interface.dart';
import '../image_builder.dart';
import '../language_manager.dart';
import '../models/date_object.dart';
import '../registration_data.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ConfirmPassportScreen extends StatefulWidget {
  const ConfirmPassportScreen({super.key, this.isRegister = true});

  final bool isRegister;

  @override
  State<ConfirmPassportScreen> createState() => _ConfirmPassportScreenState();
}

class _ConfirmPassportScreenState extends State<ConfirmPassportScreen> {
  TextEditingController placeOfBirthController = TextEditingController();
  TextEditingController documentIdNumberController = TextEditingController();
  TextEditingController nationalNumberController = TextEditingController();
  TextEditingController idExpiryController = TextEditingController();

  DateObjectModel dateOfBirth = DateObjectModel();

  @override
  void dispose() {
    placeOfBirthController.dispose();
    documentIdNumberController.dispose();
    nationalNumberController.dispose();
    idExpiryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.5.h),
              child: ImageBuilder(
                image: AppAssets.secondStepRegisterSVG,
                package: 'globxpay_auth_sdk',
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(height: 2.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 2.h),
                  Text(
                    LanguageManager.getText('dateOfBirth'),
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      color: AppColors.black,
                      fontSize: 12.0.sp,
                    ),
                  ),
                  Text(
                    RegistrationData.getdateOfBirth(),
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      color: AppColors.black,
                      fontSize: 12.0.sp,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    LanguageManager.getText('nationalNumber'),
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      color: AppColors.black,
                      fontSize: 12.0.sp,
                    ),
                  ),
                  Text(
                    RegistrationData.getnationalNumber(),
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      color: AppColors.black,
                      fontSize: 12.0.sp,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    LanguageManager.getText('passportExpiryDate'),
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      color: AppColors.black,
                      fontSize: 12.0.sp,
                    ),
                  ),
                  Text(
                    RegistrationData.getidExpiery(),
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      color: AppColors.black,
                      fontSize: 12.0.sp,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(2.h),
                      child:
                          RegistrationData.getpassportImageFront().isNotEmpty ||
                              RegistrationData.getpassportImageFront()
                                  .isNotEmpty
                          ? ImageBuilder(
                              image: RegistrationData.getpassportImageFront(),
                              isBase64: true,
                              height: 25.h,
                              width: 65.w,
                            )
                          : const SizedBox(),
                    ),
                  ),
                  SizedBox(height: 1.5.h),
                  Center(
                    child: Material(
                      elevation: 1.0,
                      borderRadius: BorderRadius.circular(1.2.h),
                      color: AppColors.primary,
                      child: MaterialButton(
                        height: 6.5.h,
                        minWidth: 40.w,
                        padding: const EdgeInsets.fromLTRB(
                          20.0,
                          15.0,
                          20.0,
                          15.0,
                        ),
                        onPressed: () {
                          GlobxpayAuthSdkPlatform.instance.registrationPageController
                              .jumpToPage(10);
                        },
                        child: Text(
                          LanguageManager.getText('confirm'),
                          style: const TextStyle(color: AppColors.textGreyDark),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
