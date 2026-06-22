import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../constants/app_assets.dart';
import '../../constants/app_colors.dart';
import '../../globxpay_auth_sdk_platform_interface.dart';
import '../../image_builder.dart';
import '../../init_sdk_model.dart';
import '../../language_manager.dart';
import '../../registration_data.dart';
import '../../utils/dialogs.dart';
import '../../utils/phone_number_lengths.dart';
import '../../utils/recaptcha.dart';
import '../../widget/button.dart';
import '../../widget/text_phone_field.dart';
import '../../widget/waiting_screen.dart';

class FtlFirstStepScreen extends StatefulWidget {
  const FtlFirstStepScreen({super.key});

  @override
  State<FtlFirstStepScreen> createState() => _FtlFirstStepScreenState();
}

class _FtlFirstStepScreenState extends State<FtlFirstStepScreen> {
  late TextEditingController phoneNumberController;
  final _formKey = GlobalKey<FormState>();
  String countryCode = '';
  bool _isLoading = false;
  bool _isRecaptchaLoading = false;

  @override
  void initState() {
    phoneNumberController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    phoneNumberController.dispose();
    super.dispose();
  }

  void _setLoading(bool isLoading) {
    if (!mounted) return;
    setState(() {
      _isLoading = isLoading;
    });
  }

  void _setRecaptchaLoading(bool isLoading) {
    if (!mounted) return;
    setState(() {
      _isRecaptchaLoading = isLoading;
    });
  }

  void _callFirstTimeLoginStepOne() {
    GlobxpayAuthSdkPlatform.instance.firstTimeLogin(
      phoneNumber: RegistrationData.getPhoneNumber(),
      stepId: 1,
      onSuccess: (_) {
        GlobxpayAuthSdkPlatform.instance.firstTimeLoginPageController
            .jumpToPage(1);
      },
      onError: (error) {
        Dialogs.errorDialog(context, message: error);
      },
      onLoading: _setLoading,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: SafeArea(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        children: [
                          SizedBox(height: 4.h),
                          ImageBuilder(
                            image: AppAssets.globXLogoSVG,
                            package: 'globxpay_auth_sdk',
                            fit: BoxFit.fill,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                              vertical: 6.h,
                            ),
                            child: Text(
                              LanguageManager.getText(
                                'registerOnGlobXpayInSimpleStepsAndDiscoverAworldFullOfSavingAndInvestmentOpportunities',
                              ),
                              style: TextStyle(
                                color: AppColors.black,
                                fontWeight: FontWeight.w200,
                                fontSize: 13.5.sp,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.h),
                            child: Column(
                              children: [
                                ImageBuilder(
                                  image: AppAssets.firstStepRegisterSVG,
                                  package: 'globxpay_auth_sdk',
                                  fit: BoxFit.fill,
                                ),
                                SizedBox(height: 8.h),
                                Row(
                                  children: [
                                    Text(
                                      LanguageManager.getText(
                                        'enterMobileNumber',
                                      ),
                                      style: TextStyle(
                                        color: AppColors.textGreyDark,
                                        fontSize: 13.0.sp,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 1.5.h),
                                Form(
                                  key: _formKey,
                                  child: CustomPhoneField(
                                    boarderColor: AppColors.primary,
                                    controller: phoneNumberController,
                                    textColor: AppColors.black,
                                    onSubmitted: (_) => onEnterMobileNumber(),
                                    onChanged: (value) {
                                      countryCode = value.countryCode;
                                      final expectedLength =
                                          PhoneNumberLengths.getPhoneLength(
                                            value.countryISOCode,
                                          );
                                      log(
                                        'country code: $countryCode, expected phone length: $expectedLength',
                                      );
                                    },
                                    onCountryChanged: (value) {
                                      countryCode = '+${value.dialCode}';
                                      final expectedLength =
                                          PhoneNumberLengths.getPhoneLength(
                                            value.code,
                                          );
                                      log(
                                        'country code: $countryCode, expected phone length: $expectedLength',
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Align(
                                  alignment:
                                      LanguageManager.currentLanguage ==
                                          GlobXLanguage.en
                                      ? Alignment.centerLeft
                                      : Alignment.centerRight,
                                  child: Text(
                                    LanguageManager.getText(
                                      'verificationCodeWillBeSentYourPhoneNumber',
                                    ),
                                    style: TextStyle(
                                      color: AppColors.textGreyDark,
                                      fontSize: 13.0.sp,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  LanguageManager.getText('LicensedBy'),
                                  style: TextStyle(fontSize: 11.5.sp),
                                ),
                                ImageBuilder(
                                  image: AppAssets.centralBankPNG,
                                  package: 'globxpay_auth_sdk',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 2.h,
                      left: 5.w,
                      right: 5.w,
                      bottom: 5.h,
                    ),
                    child: CustomButton(
                      text: LanguageManager.getText('next'),
                      onPressed: onEnterMobileNumber,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Visibility(visible: _isLoading, child: const WaitingScreen()),
        Visibility(visible: _isRecaptchaLoading, child: const WaitingScreen()),
      ],
    );
  }

  Future<void> onEnterMobileNumber() async {
    FocusScope.of(context).requestFocus(FocusNode());
    if (_formKey.currentState!.validate() &&
        phoneNumberController.text.trim().isNotEmpty) {
      RegistrationData.setPhoneNumber(
        '$countryCode${phoneNumberController.text.trim()}'.replaceFirst(
          '+',
          '00',
        ),
      );

      await Recaptcha().showRecaptcha(
        context,
        onSuccess: () {
          GlobxpayAuthSdkPlatform.instance.getOtpMethodLookup(
            onSuccess: (channels) {
              Dialogs.showChannelSelectionDialog(
                context,
                channels: channels,
                onChannelSelected: (selectedChannel) {
                  GlobxpayAuthSdkPlatform.instance.selectedChannelMethod =
                      (LanguageManager.currentLanguage == GlobXLanguage.ar
                          ? selectedChannel.arabicDisplayName
                          : selectedChannel.englishDisplayName) ??
                      selectedChannel.englishDisplayName ??
                      selectedChannel.arabicDisplayName ??
                      'SMS';

                  GlobxpayAuthSdkPlatform.instance.codeMethod = int.parse(
                    selectedChannel.code ?? '0',
                  );

                  _callFirstTimeLoginStepOne();
                },
              );
            },
            onError: (error, _) {
              Dialogs.errorDialog(context, message: error);
            },
            onLoading: _setLoading,
          );
        },
        onError: (error) {
          log('Recaptcha validation failed: $error');
        },
        onLoading: _setRecaptchaLoading,
      );
    }
  }
}
