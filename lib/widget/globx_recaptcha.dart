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

  // @override
  // void initState() {
  //   WidgetsBinding.instance.addPostFrameCallback((_) async {
  //     //await _localhostServer.start();
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   });
  //   super.initState();
  // }

  // @override
  // void dispose() {
  //   //_localhostServer.close();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InAppWebView(
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
          ),
          onWebViewCreated: (controller) {},
          onLoadStop: (controller, url) {
            setState(() {
              _isLoading = false;
            });
          },
          onLoadStart: (controller, url) {
            setState(() {
              _isLoading = true;
            });
          },
          onConsoleMessage: (controller, consoleMessage) {
            log("[GlobX Recaptcha] consoleMessage ${consoleMessage.message}");
            if (consoleMessage.messageLevel == ConsoleMessageLevel.LOG &&
                // Verifying if the string is a token or not.
                consoleMessage.message.length > 70) {
              String token = consoleMessage.message;
              if (token.contains('verify')) {
                token = token.substring(7);
              }
              widget.onVerifiedSuccessfully?.call(token);
            }
          },
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
