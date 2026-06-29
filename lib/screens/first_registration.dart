import 'dart:async';
import 'dart:developer';
import 'package:globxpay_auth_sdk/utils/dialogs.dart';
import 'package:globxpay_auth_sdk/utils/phone_number_lengths.dart';

import '../api/network.dart';
import '../constants/app_assets.dart';
import '../constants/app_colors.dart';
import '../globxpay_auth_sdk_platform_interface.dart';
import '../image_builder.dart';
import '../init_sdk_model.dart';
import '../language_manager.dart';
import '../registration_data.dart';
import '../utils/recaptcha.dart';
import '../widget/button.dart';
import '../widget/text_phone_field.dart';
import '../widget/waiting_screen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class FirstRegistrationScreen extends StatefulWidget {
  const FirstRegistrationScreen({super.key});

  @override
  State<FirstRegistrationScreen> createState() =>
      _FirstRegistrationScreenState();
}

class _FirstRegistrationScreenState extends State<FirstRegistrationScreen> {
  late TextEditingController phoneNumberController;
  final _formKey = GlobalKey<FormState>();
  String countryCode = '';
  Completer<bool> completerRecaptcha = Completer<bool>();
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

  void _callRegisterStepOne() {
    GlobxpayAuthSdkPlatform.instance.registerStepOne(
      phoneNumber: '$countryCode${phoneNumberController.text}',
      onSuccess: (userId) {
        log('Register step one successful, userId: $userId');
        // Save userId to registration data
        RegistrationData.setPhoneNumber(
          '$countryCode${phoneNumberController.text.trim()}'.replaceFirst(
            '+',
            '00',
          ),
        );

        // Navigate to next page
        GlobxpayAuthSdkPlatform.instance.registrationPageController.jumpToPage(
          1,
        );
      },
      onError: (error) {
        log('Register step one failed: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              LanguageManager.getText('errorOccurredPleaseTryAgainLater'),
            ),
          ),
        );
      },
      onLoading: (isLoading) {
        setState(() {
          _isLoading = isLoading;
        });
      },
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
                          Stack(
                            children: [
                              ImageBuilder(
                                image: AppAssets.globXLogoSVG,
                                package: 'globxpay_auth_sdk',
                                fit: BoxFit.fill,
                              ),
                            ],
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
                          //SizedBox(height: 5.h),
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
                                    onSubmitted: (p0) {
                                      onEnterMobileNumber();
                                    },
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

  void onEnterMobileNumber() async {
    FocusScope.of(context).requestFocus(FocusNode());
    log('Start register');
    if (_formKey.currentState!.validate()) {
      log('Start register 1');
      if (phoneNumberController.text.trim().isNotEmpty) {
        log('Start register 2');

        RegistrationData.setPhoneNumber(
          '$countryCode${phoneNumberController.text.trim()}'.replaceFirst(
            '+',
            '00',
          ),
        );

        // Show recaptcha with callbacks
        await Recaptcha().showRecaptcha(
          context,
          onSuccess: () {
            completerRecaptcha.complete(true);
            // Call register step one after successful recaptcha

            GlobxpayAuthSdkPlatform.instance.getOtpMethodLookup(
              onSuccess: (list) {
            
                // _callRegisterStepOne();
                Dialogs.showChannelSelectionDialog(
                  context,
                  channels:list,
                  onChannelSelected: (selectedChannel) {
                    // Handle the selected channel here
                    log(
                      'Selected channel: ${selectedChannel.englishDisplayName ?? selectedChannel.arabicDisplayName}',
                    );
                    // Store the selected channel method in the cubit
                    GlobxpayAuthSdkPlatform.instance.selectedChannelMethod =
                        (LanguageManager.currentLanguage == 'ar'
                            ? selectedChannel.arabicDisplayName
                            : selectedChannel.englishDisplayName) ??
                        selectedChannel.englishDisplayName ??
                        selectedChannel.arabicDisplayName ??
                        'SMS';
                    // You can store the selected channel or proceed with the registration
                    GlobxpayAuthSdkPlatform.instance.codeMethod = int.parse(
                      selectedChannel.code ?? '0',
                    );

                    _callRegisterStepOne();
                  },
                );
              },

              onLoading: (isLoading) {
                setState(() {
                  _isLoading = isLoading;
                });
              },
              onError: (String error, int? errorCode) {
                log('Get OTP method lookup failed: $error');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      LanguageManager.getText(
                        'errorOccurredPleaseTryAgainLater',
                      ),
                    ),
                  ),
                );
              },
            );
          },
          onError: (error) {
            // Error is already shown in the recaptcha handler
            log('Recaptcha validation failed: $error');
          },
          onLoading: (isLoading) {
            if (mounted) {
              setState(() {
                _isRecaptchaLoading = isLoading;
              });
            }
          },
        );
      }
    }
  }
}
