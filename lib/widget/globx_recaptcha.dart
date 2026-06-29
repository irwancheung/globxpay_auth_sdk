import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:globxpay_auth_sdk/constants/app_colors.dart';

//InAppLocalhostServer _localhostServer = InAppLocalhostServer();

class GlobXRecaptcha extends StatefulWidget {
  final String apiKey;

  final ValueChanged<String>? onVerifiedSuccessfully;

  const GlobXRecaptcha({
    super.key,
    required this.apiKey,
    this.onVerifiedSuccessfully,
  });

  @override
  State<StatefulWidget> createState() => _GlobXRecaptchaState();
}

class _GlobXRecaptchaState extends State<GlobXRecaptcha> {
  bool _isLoading = true;
  InAppWebViewController? _controller;

  @override
  void initState() {
    super.initState();
    log("[GlobX Recaptcha] Initializing ReCAPTCHA widget");
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AbsorbPointer(
          absorbing: _isLoading,
          child: InAppWebView(
            initialUrlRequest: URLRequest(
              url: WebUri.uri(
                Uri.parse(
                  "https://recaptcha-flutter-plugin.firebaseapp.com/?api_key=${widget.apiKey}",
                ),
              ),
            ),
            initialSettings: InAppWebViewSettings(
              javaScriptEnabled: true,
              transparentBackground: true,
              domStorageEnabled: true,
              supportZoom: true,
            ),
            onWebViewCreated: (controller) {
              _controller = controller;
              log("[GlobX Recaptcha] WebView created");
            },
            onLoadStop: (controller, url) {
              log("[GlobX Recaptcha] onLoadStop: $url");
              if (mounted) {
                setState(() {
                  _isLoading = false;
                });
              }
            },
            onLoadStart: (controller, url) {
              log("[GlobX Recaptcha] onLoadStart: $url");
              if (mounted) {
                setState(() {
                  _isLoading = true;
                });
              }
            },
            onConsoleMessage: (controller, consoleMessage) {
              log("[GlobX Recaptcha] consoleMessage: [${consoleMessage.messageLevel}] ${consoleMessage.message}");
              
              final message = consoleMessage.message;
              // Check for token - usually a long string. 
              // ReCAPTCHA v2 tokens are typically > 300 chars, but > 70 is a safe start.
              if (message.length > 70) {
                log("[GlobX Recaptcha] Potential token received, length: ${message.length}");
                String token = message;
                if (token.contains('verify')) {
                  token = token.substring(7);
                  log("[GlobX Recaptcha] Token stripped of 'verify' prefix");
                }
                widget.onVerifiedSuccessfully?.call(token);
              }
            },
            onReceivedError: (controller, request, error) {
              log("[GlobX Recaptcha] Error: ${error.description}");
            },
            onReceivedHttpError: (controller, request, errorResponse) {
              log("[GlobX Recaptcha] HTTP Error: ${errorResponse.statusCode}");
            },
          ),
        ),
        if (_isLoading)
          Center(
            child: Theme(
                data: Theme.of(context).copyWith(
                  progressIndicatorTheme: ProgressIndicatorThemeData(
                    color: AppColors.primary,
                  ),
                ),
                child: const CircularProgressIndicator.adaptive()),
          ),
      ],
    );
  }
}

// Future<bool> verifyRecaptchaV2Token({
//   required String token,
//   required String apiSecret,
// }) async {
//   String url = "https://www.google.com/recaptcha/api/siteverify";
//   http.Response response = await http.post(Uri.parse(url), body: {
//     "secret": apiSecret,
//     "response": token,
//   });
//
//   if (response.statusCode == 200) {
//     dynamic json = jsonDecode(response.body);
//     if (json['success']) {
//       return true;
//     } else {
//       log("[flutter_easy_recaptcha_v2] Error while verifying recaptcha token: ${json['error-codes'].toString()}");
//       return false;
//     }
//   }
//   log("[flutter_easy_recaptcha_v2] Error while verifying recaptcha token");
//   return false;
// }
