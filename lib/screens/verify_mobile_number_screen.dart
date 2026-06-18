import '../api/network.dart';
import '../globxpay_auth_sdk_platform_interface.dart';
import '../registration_data.dart';
import '../utils/dialogs.dart';
import '../widget/otp_body.dart';
import '../widget/waiting_screen.dart';
import 'package:flutter/material.dart';


class VerifyMobileNumberScreen extends StatefulWidget {
  const VerifyMobileNumberScreen({super.key});

  @override
  State<VerifyMobileNumberScreen> createState() =>
      _VerifyMobileNumberScreenState();
}

class _VerifyMobileNumberScreenState extends State<VerifyMobileNumberScreen> {
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

  void onRegistrationStep2Completed() {
    try {
      Network.mixpanel?.track(
        "Registration Step 2 Completed",
        properties: {
          "timestamp": DateTime.now().toIso8601String(),
          "phone_number": RegistrationData.getPhoneNumber(),
          "completed_step_2": true,
        },
      );
      print(
        "Mixpanel event logged successfully: Registration Step 2 Completed",
      );
    } catch (e, stackTrace) {
      print("Error logging Mixpanel event: $e");
      print("Stack trace: $stackTrace");

      // Log error to Mixpanel
      Network.mixpanel?.track(
        "Error Logging Event in Registration Step 2",
        properties: {
          "phone_number": RegistrationData.getPhoneNumber(),
          "error": e.toString(),
          "stack_trace": stackTrace.toString(),
          "event": "Registration Step 2 Completed",
          "completed_step_2": false,
          "timestamp": DateTime.now().toIso8601String(),
        },
      );
    }
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
              otpController: otpController,
              showLoading: false,
              onResendOTP: () {
                GlobxpayAuthSdkPlatform.instance.registerStepOne(
                  phoneNumber: RegistrationData.getPhoneNumber(),
                  onSuccess: (message) {
                    if (mounted) {
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  },
                  onError: (error) {
                    if (mounted) {
                      setState(() {
                        _isLoading = false;
                      });
                    }
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(error)));
                  },
                  onLoading: (isLoading) {
                    if (mounted) {
                      setState(() {
                        _isLoading = isLoading;
                      });
                    }
                  },
                );
                otpController.clear();
              },
              onSubmitted: (_) {
                if (_formKey.currentState!.validate()) {
                  GlobxpayAuthSdkPlatform.instance.sendCode(
                    stepId: 2,
                    otp: otpController.text.trim(),
                    phoneNumber: RegistrationData.getPhoneNumber(),
                    onSuccess: (String message) {
                      onRegistrationStep2Completed();
                      GlobxpayAuthSdkPlatform.instance.registrationPageController
                          .jumpToPage(2);
                    },
                    onError: (String error) {
                      Dialogs.errorDialog(context, message: error);
                    },
                    onLoading: (bool isLoading) {
                      if (mounted) {
                        setState(() {
                          _isLoading = isLoading;
                        });
                      }
                    },
                  );
                }
              },
              onWrongMobileNumber: () {
                GlobxpayAuthSdkPlatform.instance.registrationPageController.jumpToPage(
                  0,
                );
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
