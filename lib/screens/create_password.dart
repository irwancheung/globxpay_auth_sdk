import '../constants/app_colors.dart';

import '../globxpay_auth_sdk_platform_interface.dart';
import '../language_manager.dart';
import '../utils/functions.dart';
import '../widget/button.dart';
import '../widget/validation_password.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

class CreatePasswordScreen extends StatefulWidget {
  const CreatePasswordScreen({super.key});

  @override
  State<CreatePasswordScreen> createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  late TextEditingController passwordController;
  late TextEditingController rePasswordController;

  final formKeyPin = GlobalKey<FormState>();
  final formKeyRePin = GlobalKey<FormState>();

  bool hasUppercase = false;
  bool hasDigits = false;
  bool hasLowercase = false;
  bool hasSpecialCharacters = false;
  bool hasMinLength = false;
  bool isMathPassword = false;

  bool obscure = true;
  bool obscureConf = true;

  @override
  void initState() {
    passwordController = TextEditingController();
    rePasswordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    passwordController.dispose();
    rePasswordController.dispose();
    super.dispose();
  }

  void _validatePassword(String password) {
    setState(() {
      hasUppercase = password.contains(RegExp(r'[A-Z]'));
      hasDigits = password.contains(RegExp(r'[0-9]'));
      hasLowercase = password.contains(RegExp(r'[a-z]'));
      hasSpecialCharacters = password.contains(
        GlopXPayAppFunctions.specialCharacters,
      );
      hasMinLength =
          password.trim().length >= 8 && password.toString().length <= 12;
      isMathPassword =
          (passwordController.text.trim() ==
              rePasswordController.text.trim()) &&
          (passwordController.text.trim().isNotEmpty);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 3.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 6.h),
                    Text(
                      LanguageManager.getText('createPassword'),
                      style: TextStyle(
                        color: AppColors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: 15.0.sp,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    TextFormField(
                      onTapOutside: (_) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      maxLength: 12,
                      obscureText: obscure,
                      style: const TextStyle(color: AppColors.black),
                      keyboardType: TextInputType.visiblePassword,
                      controller: passwordController,
                      cursorColor: AppColors.primary,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscure ? Icons.visibility : Icons.visibility_off,
                            color: AppColors.primary,
                          ),
                          iconSize: 2.0.h,
                          onPressed: () {
                            // Update the state i.e. toogle the state of passwordVisible variable
                            setState(() {
                              obscure = !obscure;
                            });
                          },
                        ),
                        filled: true,
                        fillColor: AppColors.inputBackground,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(1.2.h),
                          borderSide: const BorderSide(
                            color: AppColors.textGrey,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 2.h),
                        hintText: LanguageManager.getText('password'),
                        hintStyle: const TextStyle(
                          color: AppColors.textGreyDark,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: AppColors.white),
                          borderRadius: BorderRadius.all(
                            Radius.circular(1.2.h),
                          ),
                        ),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.white),
                        ),
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          GlopXPayAppFunctions.passwordCharacters,
                        ),
                      ],
                      onChanged: _validatePassword,
                    ),
                    SizedBox(height: 2.h),
                    TextFormField(
                      onTapOutside: (_) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      maxLength: 12,
                      obscureText: obscureConf,
                      style: const TextStyle(color: AppColors.black),
                      keyboardType: TextInputType.visiblePassword,
                      controller: rePasswordController,
                      cursorColor: AppColors.primary,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.inputBackground,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(1.2.h),
                          borderSide: const BorderSide(
                            color: AppColors.textGrey,
                          ),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscureConf
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: AppColors.primary,
                          ),
                          iconSize: 2.0.h,
                          onPressed: () {
                            // Update the state i.e. toogle the state of passwordVisible variable
                            setState(() {
                              obscureConf = !obscureConf;
                            });
                          },
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 2.h),
                        hintText: LanguageManager.getText("re-enterPassword"),
                        hintStyle: const TextStyle(
                          color: AppColors.textGreyDark,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: AppColors.white),
                          borderRadius: BorderRadius.all(
                            Radius.circular(1.2.h),
                          ),
                        ),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.white),
                        ),
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          GlopXPayAppFunctions.passwordCharacters,
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          isMathPassword =
                              passwordController.text.trim() == value.trim();
                        });
                      },
                    ),
                    ValidationPasswordWidget(
                      text: LanguageManager.getText('atLeast8Characters'),
                      isValid: hasMinLength,
                    ),
                    ValidationPasswordWidget(
                      text: LanguageManager.getText(
                        'containsAtLeastUppercaseLetter',
                      ),
                      isValid: hasUppercase,
                    ),
                    ValidationPasswordWidget(
                      text: LanguageManager.getText(
                        'containsAtLeastLowercaseLetter',
                      ),
                      isValid: hasLowercase,
                    ),
                    ValidationPasswordWidget(
                      text: LanguageManager.getText('containsAtLeast1digit'),
                      isValid: hasDigits,
                    ),
                    ValidationPasswordWidget(
                      text:
                          "${LanguageManager.getText('ContainsAtLeast1SpecialCharacter')}(${GlopXPayAppFunctions.specialCharsOnly})",
                      isValid: hasSpecialCharacters,
                    ),
                    ValidationPasswordWidget(
                      text: LanguageManager.getText('isMatchedPassword'),
                      isValid: isMathPassword,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 5.w, right: 5.w, bottom: 4.h),
              child: CustomButton(
                text: LanguageManager.getText('confirm'),
                onPressed: () {
                  if (hasUppercase &&
                      hasDigits &&
                      hasLowercase &&
                      hasSpecialCharacters &&
                      hasMinLength &&
                      isMathPassword) {
                    GlobxpayAuthSdkPlatform.instance.password =
                        passwordController.text.trim();

                    GlobxpayAuthSdkPlatform.instance.registrationPageController
                        .jumpToPage(5);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// validator: (value) {
//   if (value!.trim().isEmpty) {
//     return "password is required";
//   } else if (value.trim().length < 8) {
//     return "password must be 8 character";
//   } else if (!RegExp(
//           r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_])[A-Za-z\d\W_]{8,}$')
//       .hasMatch(value.trim())) {
//     return 'password must be complex';
//   }
//   return null;
// },
