import 'package:flutter/material.dart';

import '../../globxpay_auth_sdk_platform_interface.dart';
import '../../registration_data.dart';
import '../../utils/dialogs.dart';
import '../../widget/otp_body.dart';
import '../../widget/waiting_screen.dart';

class FtlVerifyPhoneScreen extends StatefulWidget {
  const FtlVerifyPhoneScreen({super.key});

  @override
  State<FtlVerifyPhoneScreen> createState() => _FtlVerifyPhoneScreenState();
}

class _FtlVerifyPhoneScreenState extends State<FtlVerifyPhoneScreen> {
  late TextEditingController otpController;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    otpController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  void _setLoading(bool isLoading) {
    if (!mounted) return;
    setState(() {
      _isLoading = isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: SafeArea(
            child: Form(
              key: _formKey,
              child: OTPBody(
                isLoading: _isLoading,
                showLoading: false,
                otpController: otpController,
                phoneText: RegistrationData.getPhoneNumber().replaceFirst(
                  '00',
                  '+',
                ),
                onResendOTP: () {
                  GlobxpayAuthSdkPlatform.instance.firstTimeLogin(
                    phoneNumber: RegistrationData.getPhoneNumber(),
                    stepId: 1,
                    isResendOTP: true,
                    onSuccess: (_) {
                      otpController.clear();
                    },
                    onError: (error) {
                      Dialogs.errorDialog(context, message: error);
                    },
                    onLoading: _setLoading,
                  );
                },
                onSubmitted: (_) {
                  if (_formKey.currentState!.validate()) {
                    GlobxpayAuthSdkPlatform.instance.firstTimeLogin(
                      phoneNumber: RegistrationData.getPhoneNumber(),
                      stepId: 2,
                      otp: otpController.text.trim(),
                      onSuccess: (_) {
                        GlobxpayAuthSdkPlatform
                            .instance
                            .firstTimeLoginPageController
                            .jumpToPage(2);
                      },
                      onError: (error) {
                        Dialogs.errorDialog(context, message: error);
                      },
                      onLoading: _setLoading,
                    );
                  }
                },
                onWrongMobileNumber: () {
                  GlobxpayAuthSdkPlatform.instance.firstTimeLoginPageController
                      .jumpToPage(0);
                },
              ),
            ),
          ),
        ),
        Visibility(visible: _isLoading, child: const WaitingScreen()),
      ],
    );
  }
}
