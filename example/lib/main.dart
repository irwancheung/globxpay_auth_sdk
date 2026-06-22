import 'package:flutter/material.dart';

import 'package:globxpay_auth_sdk/globxpay_auth_sdk_platform_interface.dart';
import 'package:globxpay_auth_sdk/init_sdk_model.dart';
import 'package:globxpay_auth_sdk/journey_state_manager.dart';
import 'package:globxpay_auth_sdk/screens/sdk_entry.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the SDK
  await GlobxpayAuthSdkPlatform.instance.initializeSdk(
    InitSdkModel(
      language: GlobXLanguage.en,
      primaryColor: Colors.red,
      flowMode: GlobXSdkFlowMode.firstTimeLogin,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => JourneyStateManager()),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Auth SDK Example',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
              useMaterial3: true,
            ),
            home: const SdkEntryScreen(),
          ),
        );
      },
    );
  }
}
