sealed class GlopXPayAppFunctions {

  static RegExp get specialCharacters => RegExp(r'[!@#$%^&*(),.?":{}|<>_]');
  static RegExp get passwordCharacters =>
      RegExp(r'[a-zA-Z0-9_!@#$%^&*(),.?":{}|<>]');
  static final String specialCharsOnly = specialCharacters.pattern.replaceAll(
    RegExp(r'[\[\]]'),
    '',
  );

}
