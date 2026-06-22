import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

dynamic navigateToAndRemoveLastScreens(context, Widget screen) {
  return Navigator.pushAndRemoveUntil(
    context,
    Platform.isIOS
        ? CupertinoPageRoute(
            builder: (context) => screen,
          )
        : MaterialPageRoute(
            builder: (context) => screen,
          ),
    (route) => false,
  );
}

dynamic globXPush(BuildContext context, Widget screen) {
  return Navigator.push(
    context,
    Platform.isIOS
        ? CupertinoPageRoute(
            builder: (context) => screen,
          )
        : MaterialPageRoute(
            builder: (context) => screen,
          ),
  );
}

dynamic globXPushReplacement(BuildContext context, Widget screen) {
  return Navigator.pushReplacement(
    context,
    Platform.isIOS
        ? CupertinoPageRoute(
            builder: (context) => screen,
          )
        : MaterialPageRoute(
            builder: (context) => screen,
          ),
  );
}
