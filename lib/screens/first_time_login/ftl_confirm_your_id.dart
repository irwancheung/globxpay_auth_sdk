import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../constants/app_assets.dart';
import '../../constants/app_colors.dart';
import '../../globxpay_auth_sdk_platform_interface.dart';
import '../../image_builder.dart';
import '../../language_manager.dart';
import '../../registration_data.dart';
import '../../utils/dialogs.dart';

class FtlConfirmYourIdScreen extends StatefulWidget {
  const FtlConfirmYourIdScreen({super.key});

  @override
  State<FtlConfirmYourIdScreen> createState() => _FtlConfirmYourIdScreenState();
}

class _FtlConfirmYourIdScreenState extends State<FtlConfirmYourIdScreen> {
  late TextEditingController documentNumberController;
  late TextEditingController placeOfBirthController;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      GlobxpayAuthSdkPlatform.instance.changeLoading(
        false,
        onLoading: (_) {
          if (mounted) setState(() {});
        },
      );
    });
    documentNumberController = TextEditingController(
      text: RegistrationData.getdocIdNumber(),
    );
    placeOfBirthController = TextEditingController(
      text: RegistrationData.getPlaceOfBirth(),
    );
    super.initState();
  }

  @override
  void dispose() {
    documentNumberController.dispose();
    placeOfBirthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final documentType =
        GlobxpayAuthSdkPlatform.instance.registrationDocumentType;
    final isPassport = documentType?.id == 3;

    return Scaffold(
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.h, vertical: 2.h),
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
                  children: [
                    SizedBox(height: 2.h),
                    _buildPlaceOfBirth(),
                    SizedBox(height: 1.h),
                    _buildDocumentNumber(),
                    const SizedBox(height: 10),
                    if (!isPassport) ...[
                      Text(
                        LanguageManager.getText('nationalNumber'),
                        style: _labelStyle(),
                      ),
                      Text(
                        RegistrationData.getnationalNumber(),
                        style: _labelStyle(),
                      ),
                      Divider(
                        color: AppColors.primary,
                        height: 4.h,
                        thickness: 1,
                      ),
                    ],
                    Text(
                      LanguageManager.getText('idExpiry'),
                      style: _labelStyle(),
                    ),
                    Text(RegistrationData.getidExpiery(), style: _labelStyle()),
                    Divider(
                      color: AppColors.primary,
                      height: 4.h,
                      thickness: 1,
                    ),
                    _buildDocumentImages(isPassport: isPassport),
                    SizedBox(height: 1.5.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildActionButton(
                          text: LanguageManager.getText('back'),
                          onPressed: () {
                            GlobxpayAuthSdkPlatform
                                .instance
                                .firstTimeLoginPageController
                                .jumpToPage(3);
                          },
                        ),
                        _buildActionButton(
                          text: LanguageManager.getText('confirm'),
                          onPressed: () {
                            if (placeOfBirthController.text.trim().isEmpty) {
                              Dialogs.errorDialog(
                                context,
                                barrierDismissible: true,
                                message: LanguageManager.getText(
                                  'PalaceOfBirth',
                                ),
                              );
                              return;
                            }

                            RegistrationData.setdocIdNumber(
                              documentNumberController.text.trim(),
                            );
                            RegistrationData.setPlaceOfBirth(
                              placeOfBirthController.text.trim(),
                            );
                            GlobxpayAuthSdkPlatform
                                .instance
                                .firstTimeLoginPageController
                                .jumpToPage(6);
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 5.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle _labelStyle() {
    return TextStyle(
      fontWeight: FontWeight.w300,
      color: AppColors.black,
      fontSize: 12.0.sp,
    );
  }

  Widget _buildDocumentNumber() {
    return Visibility(
      visible:
          GlobxpayAuthSdkPlatform.instance.registrationDocumentType?.id != 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(LanguageManager.getText('docIdNumber'), style: _labelStyle()),
          TextField(
            onTapOutside: (_) => FocusScope.of(context).unfocus(),
            controller: documentNumberController,
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.name,
            style: _labelStyle(),
            decoration: _underlineDecoration(),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceOfBirth() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(LanguageManager.getText('palceOfBirth'), style: _labelStyle()),
        TextField(
          onTapOutside: (_) => FocusScope.of(context).unfocus(),
          controller: placeOfBirthController,
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.name,
          style: _labelStyle(),
          decoration: _underlineDecoration(),
        ),
      ],
    );
  }

  InputDecoration _underlineDecoration() {
    return InputDecoration(
      contentPadding: EdgeInsets.zero,
      border: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.primary),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.primary),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.primary),
      ),
    );
  }

  Widget _buildDocumentImages({required bool isPassport}) {
    return Column(
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
          visible: !isPassport,
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
    );
  }

  Widget _buildActionButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return Material(
      elevation: 1.0,
      borderRadius: BorderRadius.circular(1.2.h),
      color: AppColors.primary,
      child: MaterialButton(
        height: 6.5.h,
        minWidth: 40.w,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(color: AppColors.textGreyDark),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
