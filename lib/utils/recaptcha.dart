import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../api/network.dart';
import '../constants/app_colors.dart';
import '../globxpay_auth_sdk_platform_interface.dart';
import '../widget/globx_recaptcha.dart';

final class Recaptcha {
  /// Singleton class

  Recaptcha._();

  static final Recaptcha _instance = Recaptcha._();

  factory Recaptcha() {
    return _instance;
  }

  Future<void> showRecaptcha(
    BuildContext context, {
    Function()? onSuccess,
    Function(String error)? onError,
  }) async {
    await showModalBottomSheet(
      isDismissible: true,
      backgroundColor: AppColors.white,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return SizedBox(
          height: MediaQuery.sizeOf(context).height - 200,
          child: Container(
            alignment: Alignment.topCenter,
            margin: const EdgeInsets.only(top: 20),
            child: GlobXRecaptcha(
              onVerifiedSuccessfully: (value) async {
                log('Token When Complete:');
                log('------------------');
                log(value);
                log('------------------');

                if (value.isNotEmpty) {
                  // Validate recaptcha token using SDK
                  print(
                    '🔵 About to call recaptchaValidate on platform instance',
                  );
                  print(
                    '🔵 Platform instance type: ${GlobxpayAuthSdkPlatform.instance.runtimeType}',
                  );

                  GlobxpayAuthSdkPlatform.instance.recaptchaValidate(
                    token: value,
                    onSuccess: (isSuccess) {
                      log('✅ RECAPTCHA VERIFIED: $isSuccess');
                      Navigator.pop(context);
                      // Call success callback
                      if (onSuccess != null) {
                        onSuccess();
                      }
                    },
                    onError: (error) {
                      log('❌ RECAPTCHA ERROR: $error');
                      Navigator.pop(context);

                      // Show error to user
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(error)));

                      // Call error callback
                      if (onError != null) {
                        onError(error);
                      }
                    },
                    onLoading: (isLoading) {
                      log('⏳ RECAPTCHA LOADING: $isLoading');
                    },
                  );
                }
              },
              apiKey: Network.config['RECAPTCHA_API_KEY'] ?? '',
            ),
          ),
        );
      },
    );
  }
}
