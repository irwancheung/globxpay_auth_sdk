import 'dart:ui';

sealed class AppColors {
  AppColors._();

  // Brand colors - customizable
  static const Color primary = Color(0xff11FFEE);
  static const Color secondary = Color(0xff4CFFF2);
  static const Color accent = Color(0xff5842F4);

  // Standard colors
  static const Color white = Color(0xffFFFFFF);
  static const Color black = Color(0xFF000000);

  // Text colors
  static const Color textGrey = Color(0xff908E8E);
  static const Color textGreyDark = Color(0xff354257);

  // Background colors
  static const Color inputBackground = Color(0xffeaeaea);

  // Border/Divider colors
  static const Color borderGrey = Color(0xffD9D9D9);
}
