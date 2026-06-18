import 'dart:ui';

final class InitSdkModel {
  final GlobXLanguage language;
  final Color? primaryColor;
   InitSdkModel({
    this.language = GlobXLanguage.en,
    this.primaryColor,

  });
}

enum GlobXLanguage { en, ar }
