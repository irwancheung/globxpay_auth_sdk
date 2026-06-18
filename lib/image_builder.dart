import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

/// A versatile image widget that handles multiple image formats and sources
///
/// Supports:
/// - SVG files (.svg)
/// - Network images (http/https)
/// - Asset images
/// - Base64 encoded images
class ImageBuilder extends StatelessWidget {
  final String image;
  final BoxFit? fit;
  final double? width;
  final double? height;
  final Color? color;
  final bool isBase64;
  final String? package;

  const ImageBuilder({
    super.key,
    required this.image,
    this.fit,
    this.width,
    this.height,
    this.color,
    this.isBase64 = false,
    this.package,
  });

  @override
  Widget build(BuildContext context) {
    // Handle base64 encoded images
    if (isBase64) {
      try {
        final String raw = image.contains(',')
            ? image.split(',').last.trim()
            : image.trim();

        final bytes = base64Decode(raw);

        return Image.memory(
          bytes,
          fit: fit ?? BoxFit.cover,
          width: width,
          height: height,
        );
      } catch (_) {
        return _errorPlaceholder();
      }
    }

    // Handle SVG files
    if (image.toLowerCase().endsWith('.svg')) {
      return SvgPicture.asset(
        image,
        package: package,
        fit: fit ?? BoxFit.cover,
        width: width,
        height: height,
        colorFilter: color != null
            ? ColorFilter.mode(color!, BlendMode.srcIn)
            : null,
      );
    }

    // Handle network images
    if (image.startsWith('http://') || image.startsWith('https://')) {
      return Image.network(
        image,
        fit: fit ?? BoxFit.cover,
        width: width,
        height: height,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: width ?? double.infinity,
            height: height ?? 200,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return _errorPlaceholder();
        },
      );
    }

    // Handle asset images
    return Image.asset(
      image,
      package: package,
      fit: fit ?? BoxFit.cover,
      width: width,
      height: height,
      errorBuilder: (context, error, stackTrace) {
        return _errorPlaceholder();
      },
    );
  }

  Widget _errorPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey,
      alignment: Alignment.center,
      child: const Icon(Icons.broken_image, color: Colors.white),
    );
  }
}
