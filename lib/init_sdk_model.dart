import 'dart:ui';

final class InitSdkModel {
  final GlobXLanguage language;
  final Color? primaryColor;
  final GlobXSdkFlowMode flowMode;

  InitSdkModel({
    this.language = GlobXLanguage.en,
    this.primaryColor,
    this.flowMode = GlobXSdkFlowMode.registration,
  });
}

enum GlobXLanguage { en, ar }

enum GlobXSdkFlowMode { registration, firstTimeLogin }
