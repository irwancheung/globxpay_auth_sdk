import 'package:flutter/material.dart';

import '../globxpay_auth_sdk_platform_interface.dart';
import '../init_sdk_model.dart';
import 'first_time_login/first_time_login_cycle.dart';
import 'registration_cycle.dart';

class SdkEntryScreen extends StatelessWidget {
  const SdkEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    switch (GlobxpayAuthSdkPlatform.instance.flowMode) {
      case GlobXSdkFlowMode.firstTimeLogin:
        return const FirstTimeLoginCycleScreen();
      case GlobXSdkFlowMode.registration:
        return const RegistrationCycleScreen();
    }
  }
}
