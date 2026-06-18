
import '../constants/app_assets.dart';
import '../constants/app_colors.dart';

import '../image_builder.dart';
import '../language_manager.dart';
import '../registration_data.dart';
import '../utils/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../globxpay_auth_sdk_platform_interface.dart';
import '../registration_data.dart';

class ConfirmYourIdScreen extends StatefulWidget {
  const ConfirmYourIdScreen({super.key, this.isRegister = true});

  final bool isRegister;

  @override
  State<ConfirmYourIdScreen> createState() => _ConfirmYourIdScreenState();
}

class _ConfirmYourIdScreenState extends State<ConfirmYourIdScreen> {
  late TextEditingController documentNumberController;
  late TextEditingController palaceOfBirthController;

  @override
  void initState() {
    GlobxpayAuthSdkPlatform.instance.changeLoading(
      false,
      onLoading: (bool isLoading) {
        if (mounted) {
          setState(() {});
        }
      },
    );
    documentNumberController = TextEditingController(
      text: RegistrationData.getdocIdNumber(),
    );

    palaceOfBirthController = TextEditingController(
      text: RegistrationData.getPlaceOfBirth(),
    );
    super.initState();
  }

  @override
  void dispose() {
    documentNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.h, vertical: 2.h),
              child: ImageBuilder(
                image: AppAssets.secondStepRegisterSVG,
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
                  _buildPalaceOfBirth(),
                  SizedBox(height: 1.h),
                  _buildDocumentNumber(),
                  const SizedBox(height: 10),
                  GlobxpayAuthSdkPlatform.instance.registrationDocumentType?.id == 3
                      ? const SizedBox()
                      : Text(
                          LanguageManager.getText('nationalNumber'),
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            color: AppColors.black,
                            fontSize: 12.0.sp,
                          ),
                        ),
                  GlobxpayAuthSdkPlatform.instance.registrationDocumentType?.id == 3
                      ? const SizedBox()
                      : Text(
                          RegistrationData.getnationalNumber(),
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            color: AppColors.black,
                            fontSize: 12.0.sp,
                          ),
                        ),
                  GlobxpayAuthSdkPlatform.instance.registrationDocumentType?.id == 3
                      ? const SizedBox()
                      : Divider(
                          color: AppColors.primary,
                          height: 4.h,
                          thickness: 1,
                        ),
                  Text(
                    LanguageManager.getText("idExpiry"),
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
                  Divider(color: AppColors.primary, height: 4.h, thickness: 1),
                  Column(
                    children: [
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(2.h),
                          child: RegistrationData.getdocImageFront().isNotEmpty
                              ? ImageBuilder(
                                  image: RegistrationData.getdocImageFront(),
                                  height: 25.h,
                                  width: double.infinity,
                                  fit: BoxFit.fill,
                                  isBase64: true,
                                )
                              : const SizedBox(),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Visibility(
                        visible:
                        GlobxpayAuthSdkPlatform
                                    .instance
                                    .registrationDocumentType
                                    ?.id ==
                                3
                            ? false
                            : true,
                        child: Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(2.h),
                            child: RegistrationData.getdocImageBack().isNotEmpty
                                ? ImageBuilder(
                                    image: RegistrationData.getdocImageBack(),
                                    height: 25.h,
                                    width: double.infinity,
                                    fit: BoxFit.fill,
                                    isBase64: true,
                                  )
                                : const SizedBox(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.5.h),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Material(
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
                              GlobxpayAuthSdkPlatform
                                  .instance
                                  .registrationPageController
                                  .jumpToPage(5);
                            },
                            child: Text(
                              LanguageManager.getText('back'),
                              style: const TextStyle(
                                color: AppColors.textGreyDark,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Material(
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
                              // if (documentNumberController.text.trim().length <
                              //     8) {
                              //   Dialogs.errorDialog(
                              //     context,
                              //     barrierDismissible: true,
                              //     message: LanguageManager.getText('checkedDocumentNumber'),
                              //   );
                              //   return;
                              // }

                              if (palaceOfBirthController.text.trim().isEmpty) {
                                Dialogs.errorDialog(
                                  context,
                                  barrierDismissible: true,
                                  message: LanguageManager.getText(
                                    'PalaceOfBirth',
                                  ),
                                );
                                return;
                              }

                              GlobxpayAuthSdkPlatform
                                  .instance
                                  .registrationPageController
                                  .jumpToPage(10);
                            },
                            child: Text(
                              LanguageManager.getText('confirm'),
                              style: const TextStyle(
                                color: AppColors.textGreyDark,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentNumber() {
    return Visibility(
      visible: GlobxpayAuthSdkPlatform.instance.registrationDocumentType?.id != 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LanguageManager.getText('docIdNumber'),
            style: TextStyle(
              fontWeight: FontWeight.w300,
              color: AppColors.black,
              fontSize: 12.0.sp,
            ),
          ),
          TextField(
            onTapOutside: (_) {
              FocusScope.of(context).unfocus();
            },
            controller: documentNumberController,
            //maxLength: 8,
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.name,
            style: TextStyle(
              fontWeight: FontWeight.w300,
              color: AppColors.black,
              fontSize: 12.0.sp,
            ),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.primary),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.primary),
              ),
              disabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.primary),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPalaceOfBirth() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LanguageManager.getText('palceOfBirth'),
          style: TextStyle(
            fontWeight: FontWeight.w300,
            color: AppColors.black,
            fontSize: 12.0.sp,
          ),
        ),

        TextField(
          onTapOutside: (_) {
            FocusScope.of(context).unfocus();
          },
          controller: palaceOfBirthController,
          //enabled: AppSharedPreferences.docIdNumber.length != 8,
          //maxLength: 8,
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.name,
          style: TextStyle(
            fontWeight: FontWeight.w300,
            color: AppColors.black,
            fontSize: 12.0.sp,
          ),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary),
            ),
            disabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary),
            ),
          ),
        ),
      ],
    );
  }
}
