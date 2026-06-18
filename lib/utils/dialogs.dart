import 'dart:developer';
import 'dart:io';
import 'package:animated_snack_bar/animated_snack_bar.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:globxpay_auth_sdk/image_builder.dart';
import 'package:globxpay_auth_sdk/models/lookup_list_otp_method.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

import '../constants/app_assets.dart';
import '../constants/app_colors.dart';
import '../language_manager.dart';

class DialogAction {
  final String text;
  final IconData icon;
  final Function() onPressed;
  final bool isDestructive;

  DialogAction({
    required this.text,
    required this.icon,
    required this.onPressed,
    this.isDestructive = false,
  });
}

sealed class Dialogs {
  static Future errorDialog(
    BuildContext context, {
    required String message,
    Function()? onConfirm,
    String? content,
    bool barrierDismissible = false,
  }) {
    return _customDialog(
      title: message,
      content: content != null ? Text(content) : null,
      context: context,
      firstActionEnabled: true,
      barrierDismissible: barrierDismissible,
      firstOnClick:
          onConfirm ??
          () {
            if (Navigator.canPop(context)) {
              Navigator.of(context).pop();
            }
          },
      firstActionTitle: LanguageManager.getText('ok'),
      actionTextColor: AppColors.white,
      titleFontWight: FontWeight.w600,
      isErrorDialog: true,
      icon: Lottie.asset(
        AppAssets.errorLottie,
        package: 'globxpay_auth_sdk',
        animate: true,
        repeat: true,
        reverse: false,
        height: 15.h,
      ),
    );
  }

  static Future successDialog(
    BuildContext context, {
    required String message,
    Function()? onConfirm,
    Function()? onCancelBtnTap,
    String? confirmBtnText,
    String? cancelTitle,
    List<DialogAction>? actions,
  }) {
    List<Widget> actionWidgets = [];

    if (actions != null) {
      for (var action in actions) {
        actionWidgets.add(
          Platform.isIOS
              ? CupertinoDialogAction(
                  isDefaultAction: true,
                  isDestructiveAction: action.isDestructive,
                  textStyle: TextStyle(
                    color: action.isDestructive
                        ? CupertinoColors.systemRed
                        : CupertinoColors.systemBlue,
                  ),
                  onPressed: action.onPressed,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(action.icon, size: 18),
                      SizedBox(width: 4),
                      Text(action.text),
                    ],
                  ),
                )
              : TextButton.icon(
                  icon: Icon(action.icon, size: 18),
                  onPressed: action.onPressed,
                  label: Text(action.text),
                  style: TextButton.styleFrom(
                    foregroundColor: action.isDestructive
                        ? Colors.red
                        : AppColors.primary,
                  ),
                ),
        );
      }
    }

    return _customDialog(
      context: context,
      title: message,
      firstActionEnabled: true,
      firstActionTitle: confirmBtnText ?? LanguageManager.getText('ok'),
      secondActionTitle: cancelTitle,
      secondActionEnabled: cancelTitle != null,
      titleFontWight: FontWeight.w600,
      firstOnClick: () {
        if (onConfirm != null) {
          onConfirm();
        } else if (Navigator.canPop(context)) {
          Navigator.of(context).pop();
        }
      },
      secondOnClick: onCancelBtnTap != null
          ? () {
              onCancelBtnTap();
            }
          : null,
      actions: actionWidgets.isNotEmpty ? actionWidgets : null,
      icon: Lottie.asset(
        AppAssets.successLottie,
        package: 'globxpay_auth_sdk',
        animate: true,
        repeat: true,
        reverse: false,
        height: 15.h,
      ),
    );
  }

  static Future infoDialog(
    BuildContext context, {
    required String message,
    Function()? onConfirm,
    Function()? onCancelBtnTap,
    String? textConfirm,
    String? textCancel,
  }) {
    return _customDialog(
      context: context,
      title: message,
      isErrorDialogSecond: true,
      firstActionEnabled: true,
      secondActionEnabled: true,
      firstActionTitle: textConfirm ?? LanguageManager.getText('ok'),
      secondActionTitle: textCancel ?? LanguageManager.getText('cancel'),
      titleFontWight: FontWeight.w600,
      firstOnClick: () {
        if (onConfirm != null) {
          onConfirm();
        } else if (Navigator.canPop(context)) {
          Navigator.of(context).pop();
        }
      },
      secondOnClick: () {
        if (onCancelBtnTap != null) {
          onCancelBtnTap();
        } else if (Navigator.canPop(context)) {
          Navigator.of(context).pop();
        }
      },
      icon: Lottie.asset(
        AppAssets.infoLottie,
        package: 'globxpay_auth_sdk',
        animate: true,
        repeat: true,
        reverse: false,
        height: 15.h,
      ),
    );
  }

  static void animatedSnackBar(
    BuildContext context, {
    required String message,
  }) {
    return AnimatedSnackBar.material(
      message,
      type: AnimatedSnackBarType.error,
      duration: const Duration(seconds: 4),
      mobilePositionSettings: const MobilePositionSettings(topOnAppearance: 50),
      mobileSnackBarPosition: MobileSnackBarPosition.top,
      desktopSnackBarPosition: DesktopSnackBarPosition.bottomLeft,
    ).show(context);
  }

  static void animatedSnackBarSuccess(
    BuildContext context, {
    required String message,
  }) {
    return AnimatedSnackBar.material(
      message,
      type: AnimatedSnackBarType.success,
      duration: const Duration(seconds: 4),
      mobilePositionSettings: const MobilePositionSettings(topOnAppearance: 50),
      mobileSnackBarPosition: MobileSnackBarPosition.top,
      desktopSnackBarPosition: DesktopSnackBarPosition.bottomLeft,
    ).show(context);
  }

  static Future<void> showChannelSelectionDialog(
    BuildContext context, {
    required List<Result> channels,
    required Function(Result) onChannelSelected,
  }) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            LanguageManager.getText('selectOtpMethod'),
            style: TextStyle(fontSize: 14.0.sp, fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: channels.length,
              itemBuilder: (context, index) {
                final channel = channels[index];
                String? iconAsset;
                if (channel.englishDisplayName?.toLowerCase().contains(
                          'whatsapp',
                        ) ==
                        true ||
                    channel.arabicDisplayName?.toLowerCase().contains(
                          'whatsapp',
                        ) ==
                        true) {
                  iconAsset = AppAssets.whatsapp;
                } else if (channel.englishDisplayName?.toLowerCase().contains(
                          'sms',
                        ) ==
                        true ||
                    channel.arabicDisplayName?.toLowerCase().contains('sms') ==
                        true) {
                  iconAsset = AppAssets.chatingsquare;
                }

                return ListTile(
                  leading: iconAsset != null
                      ? ImageBuilder(
                          image: iconAsset,
                          package: 'globxpay_auth_sdk',
                          fit: BoxFit.fill,
                          width: 30,
                          height: 30,
                        )
                      : null,
                  title: Text(
                    channel.englishDisplayName ??
                        channel.arabicDisplayName ??
                        '',
                    style: TextStyle(fontSize: 15.sp),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    onChannelSelected(channel);
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                LanguageManager.getText('cancel'),
                style: TextStyle(color: AppColors.primary),
              ),
            ),
          ],
        );
      },
    );
  }
}

Future<void> _customDialog({
  required BuildContext context,
  Widget? icon,
  Widget? content,
  String? title,
  Function()? firstOnClick,
  Function()? secondOnClick,
  String? firstActionTitle,
  String? secondActionTitle,
  Color? actionTextColor,
  bool? firstActionEnabled,
  bool? secondActionEnabled,
  FontWeight? titleFontWight,
  bool isErrorDialog = false,
  bool isErrorDialogSecond = false,
  bool barrierDismissible = false,
  List<Widget>? actions,
}) async {
  return showAdaptiveDialog(
    barrierDismissible: barrierDismissible,
    context: context,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog.adaptive(
          title: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (icon != null) SizedBox(child: icon),
              icon != null ? SizedBox(height: 1.h) : const SizedBox.shrink(),
              if (title != null)
                Text(
                  title,
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 12.0.sp,
                    fontWeight: titleFontWight ?? FontWeight.w400,
                    overflow: TextOverflow.visible,
                  ),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
          content: content,
          actions: <Widget>[
            // Custom actions (with icons)
            if (actions != null) ...actions,

            // Standard actions
            if (firstActionTitle != null && firstOnClick != null) ...{
              if (Platform.isIOS) ...{
                CupertinoDialogAction(
                  isDefaultAction: true,
                  isDestructiveAction: isErrorDialog,
                  textStyle: TextStyle(
                    color: isErrorDialog
                        ? CupertinoColors.systemRed
                        : CupertinoColors.systemBlue,
                  ),
                  onPressed: () {
                    if (firstActionEnabled ?? true) {
                      try {
                        firstOnClick();
                      } catch (e) {
                        log(e.toString());
                        Navigator.of(context).pop();
                      }
                    }
                  },
                  child: Text(firstActionTitle),
                ),
              } else ...{
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: isErrorDialog
                        ? Colors.red
                        : AppColors.primary,
                  ),
                  onPressed: () {
                    if (firstActionEnabled ?? true) {
                      try {
                        firstOnClick();
                      } catch (e) {
                        log(e.toString());
                        Navigator.of(context).pop();
                      }
                    }
                  },
                  child: Text(firstActionTitle),
                ),
              },
            },
            if (secondActionTitle != null && secondOnClick != null) ...{
              if (Platform.isIOS) ...{
                CupertinoDialogAction(
                  isDefaultAction: true,
                  isDestructiveAction: isErrorDialogSecond,
                  textStyle: TextStyle(
                    color: isErrorDialogSecond
                        ? CupertinoColors.systemRed
                        : CupertinoColors.systemBlue,
                  ),
                  onPressed: () {
                    if (secondActionEnabled ?? true) {
                      secondOnClick();
                    }
                  },
                  child: Text(secondActionTitle),
                ),
              } else ...{
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: isErrorDialogSecond
                        ? Colors.red
                        : AppColors.primary,
                  ),
                  onPressed: () {
                    if (secondActionEnabled ?? true) {
                      try {
                        secondOnClick();
                      } catch (e) {
                        log(e.toString());
                        Navigator.of(context).pop();
                      }
                    }
                  },
                  child: Text(secondActionTitle),
                ),
              },
            },
          ],
        ),
      );
    },
  );
}
