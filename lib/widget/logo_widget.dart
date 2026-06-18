import 'package:flutter/material.dart';
import '../globxpay_auth_sdk_method_channel.dart';
import '../image_builder.dart';

/// A widget that displays the SDK logo from the configured path
///
/// Automatically uses the logo path set during SDK initialization.
/// If no logo is configured, displays a default placeholder.
class LogoWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Color? color;
  final Widget? fallback;

  const LogoWidget({
    super.key,
    this.width,
    this.height,
    this.fit,
    this.color,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    final logoPath = MethodChannelGlobxpayAuthSdk().logoPath;

    // If no logo path is configured, show fallback or empty container
    if (logoPath.isEmpty) {
      return fallback ??
          Container(
            width: width,
            height: height,
            alignment: Alignment.center,
            child: Icon(
              Icons.image,
              size: width != null ? width! * 0.5 : 48,
              color: color ?? Colors.grey,
            ),
          );
    }

    // Use ImageBuilder to load the logo
    return ImageBuilder(
      image: logoPath,
      width: width,
      height: height,
      fit: fit ?? BoxFit.contain,
      color: color,
    );
  }
}
