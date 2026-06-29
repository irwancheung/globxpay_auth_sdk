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
    Function(bool isLoading)? onLoading,
  }) async {
    await showModalBottomSheet(
      isDismissible: true,
      backgroundColor: AppColors.white,
      isScrollControlled: true,
      context: context,
      builder: (sheetContext) {
        return SizedBox(
          height: MediaQuery.sizeOf(sheetContext).height - 200,
          child: Container(
            alignment: Alignment.topCenter,
            margin: const EdgeInsets.only(top: 20),
            child: GlobXRecaptcha(
              onVerifiedSuccessfully: (value) async {
                log('🔵 [Recaptcha Utils] Token received from WebView, length: ${value.length}');

                if (value.isNotEmpty) {
                  // Pop the bottom sheet first so the user returns to the registration screen
                  if (Navigator.canPop(sheetContext)) {
                    log('🔵 [Recaptcha Utils] Popping ReCAPTCHA bottom sheet');
                    Navigator.pop(sheetContext);
                  }

                  // Validate recaptcha token using SDK
                  log('🔵 [Recaptcha Utils] Calling recaptchaValidate on platform instance');

                  GlobxpayAuthSdkPlatform.instance.recaptchaValidate(
                    token: value,
                    onSuccess: (isSuccess) {
                      log('✅ [Recaptcha Utils] RECAPTCHA VERIFIED: $isSuccess');
                      // Call success callback
                      if (onSuccess != null) {
                        onSuccess();
                      }
                    },
                    onError: (error) {
                      log('❌ [Recaptcha Utils] RECAPTCHA ERROR: $error');

                      // Show error to user using host context
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(error)));

                      // Call error callback
                      if (onError != null) {
                        onError(error);
                      }
                    },
                    onLoading: (isLoading) {
                      log('⏳ [Recaptcha Utils] RECAPTCHA LOADING: $isLoading');
                      if (onLoading != null) {
                        onLoading(isLoading);
                      }
                    },
                  );
                } else {
                  log('⚠️ [Recaptcha Utils] Received empty token from ReCAPTCHA');
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
