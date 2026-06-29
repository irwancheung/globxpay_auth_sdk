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
    log('🔵 [FTL Step 1] Screen initialized');
    super.initState();
  }

  @override
  void dispose() {
    phoneNumberController.dispose();
    log('🔵 [FTL Step 1] Screen disposed');
    super.dispose();
  }

  void _setLoading(bool isLoading) {
    if (!mounted) return;
    log('🔵 [FTL Step 1] Setting main loading: $isLoading');
    setState(() {
      _isLoading = isLoading;
    });
  }

  void _setRecaptchaLoading(bool isLoading) {
    if (!mounted) return;
    log('🔵 [FTL Step 1] Setting ReCAPTCHA loading: $isLoading');
    setState(() {
      _isRecaptchaLoading = isLoading;
    });
  }

  void _callFirstTimeLoginStepOne() {
    log('🔵 [FTL Step 1] Calling firstTimeLogin API');
    GlobxpayAuthSdkPlatform.instance.firstTimeLogin(
      phoneNumber: RegistrationData.getPhoneNumber(),
      stepId: 1,
      onSuccess: (_) {
        log('✅ [FTL Step 1] firstTimeLogin API success');
        GlobxpayAuthSdkPlatform.instance.firstTimeLoginPageController
            .jumpToPage(1);
      },
      onError: (error) {
        log('❌ [FTL Step 1] firstTimeLogin API error: $error');
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
    if (_isLoading || _isRecaptchaLoading) {
      log('⚠️ [FTL Step 1] Click ignored: already loading');
      return;
    }

    log('🔵 [FTL Step 1] "Next" button clicked');
    FocusScope.of(context).requestFocus(FocusNode());
    if (_formKey.currentState!.validate() &&
        phoneNumberController.text.trim().isNotEmpty) {
      final fullPhone = '$countryCode${phoneNumberController.text.trim()}'.replaceFirst(
          '+',
          '00',
        );
      log('🔵 [FTL Step 1] Validated phone: $fullPhone');
      RegistrationData.setPhoneNumber(fullPhone);

      log('🔵 [FTL Step 1] Showing ReCAPTCHA modal');
      await Recaptcha().showRecaptcha(
        context,
        onSuccess: () {
          log('✅ [FTL Step 1] ReCAPTCHA success callback');
          GlobxpayAuthSdkPlatform.instance.getOtpMethodLookup(
            onSuccess: (channels) {
              log('✅ [FTL Step 1] getOtpMethodLookup success, channels: ${channels.length}');
              Dialogs.showChannelSelectionDialog(
                context,
                channels: channels,
                onChannelSelected: (selectedChannel) {
                  log('🔵 [FTL Step 1] Channel selected: ${selectedChannel.englishDisplayName}');
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
              log('❌ [FTL Step 1] getOtpMethodLookup error: $error');
              Dialogs.errorDialog(context, message: error);
            },
            onLoading: _setLoading,
          );
        },
        onError: (error) {
          log('❌ [FTL Step 1] ReCAPTCHA error callback: $error');
          _setRecaptchaLoading(false);
        },
        onLoading: _setRecaptchaLoading,
      );

      // Ensure loading is reset if user closes the modal without completing
      if (_isRecaptchaLoading) {
        log('🔵 [FTL Step 1] ReCAPTCHA modal closed, resetting loading state');
        _setRecaptchaLoading(false);
      }
    } else {
      log('⚠️ [FTL Step 1] Form validation failed');
    }
  }
}
